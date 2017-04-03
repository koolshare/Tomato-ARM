/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 * Copyright 2011, ASUSTeK Inc.
 * All Rights Reserved.
 * 
 * THIS SOFTWARE IS OFFERED "AS IS", AND ASUS GRANTS NO WARRANTIES OF ANY
 * KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
 * SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <signal.h>
#include <sys/time.h>
#include <unistd.h>
#include <bcmnvram.h>
#include <shared.h>
#include <shutils.h>
#include <wlutils.h>

//#define DEBUG

//#define dbG(fmt, args...) syslog(LOG_DEBUG, fmt, ##args) // redirect console to syslog

#define FAN_NORMAL_PERIOD	5 * 1000	/* microsecond */
#define TEMP_MAX		84.000		/* note: this not degrees */
#define TEMP_3			78.000		/* actual degrees math is */
#define TEMP_2			72.000		/* Celsius: val / 2 + 20, */
#define TEMP_1			66.000		/* 66.000 = 53 C          */
#define TEMP_MIN		60.000		/* 60.000 = 50 C          */
#define TEMP_H			3.000		/* temp delta */

#define max(a,b)  (((a) > (b)) ? (a) : (b))
#define min(a,b)  (((a) < (b)) ? (a) : (b))

static int count = -2;
static int status = -1;
static int duty_cycle = 0;
static int status_old = 0;
static double tempavg_1 = 0.000;
static double tempavg_2 = 0.000;
static double tempavg_max = 0.000;
static struct itimerval itv;
static int count_timer = 0;
static int base = 1;

static void
alarmtimer(unsigned long sec, unsigned long usec)
{
	itv.it_value.tv_sec  = sec;
	itv.it_value.tv_usec = usec;
	itv.it_interval = itv.it_value;
	setitimer(ITIMER_REAL, &itv, NULL);
}

static int
fan_status()
{
	int idx;

	if (!base)
		return 1;
	else if (base == 1)
		return 0;
	else
		idx = count_timer % base;

	if (!idx)
		return 0;
	else
		return 1;
}

static void
phy_tempsense_exit(int sig)
{
	alarmtimer(0, 0);
	led(LED_BRIDGE, LED_OFF);

        remove("/var/run/phy_tempsense.pid");
        exit(0);
}

static int
phy_tempsense_mon()
{
	char buf[WLC_IOCTL_SMLEN];
	char buf2[WLC_IOCTL_SMLEN];
	char w[32];
	int ret, t_min, t_1, t_2, t_3, t_max;
	unsigned int r0 = TEMP_MIN;	// fake val r0, in case interface is down
	unsigned int *ret_int = NULL;
	unsigned int *ret_int2 = NULL;

	strcpy(buf, "phy_tempsense");
	strcpy(buf2, "phy_tempsense");

	if ((ret = wl_ioctl("eth1", WLC_GET_VAR, buf, sizeof(buf))) == 0)
		ret_int = (unsigned int *)buf;
	else {
#ifdef DEBUG
		dbG("phy_tempsense_mon: eth1 return code: %d. Does interface ON?", ret);
#endif
		ret_int = &r0;	// fake val r0
	}

	if ((ret = wl_ioctl("eth2", WLC_GET_VAR, buf2, sizeof(buf2))) == 0)
		ret_int2 = (unsigned int *)buf2;
	else {
#ifdef DEBUG
		dbG("phy_tempsense_mon: eth2 return code: %d. Does interface ON?", ret);
#endif
		ret_int2 = &r0;	// fake val r0
	}

	if (count == -2) {
		count++;
		tempavg_1 = *ret_int;
		tempavg_2 = *ret_int2;
	} else {
		tempavg_1 = (tempavg_1 * 4 + *ret_int) / 5;
		tempavg_2 = (tempavg_2 * 4 + *ret_int2) / 5;
	}
#if 1	// use highest, not average val (better in case only one radio enabled)
	tempavg_max = (((tempavg_1) > (tempavg_2)) ? (tempavg_1) : (tempavg_2));
#else
	tempavg_max = (tempavg_1 + tempavg_2) / 2;
#endif

#ifdef DEBUG
	dbG("phy_tempsense_mon: eth1: %d (%.3f), eth2: %d (%.3f), Max: %.3f\n",
		*ret_int, tempavg_1, *ret_int2, tempavg_2, tempavg_max);
#endif
	duty_cycle = nvram_get_int("fanctrl_dutycycle");
	if ((duty_cycle < 0) || (duty_cycle > 5))
		duty_cycle = 0;
	// allow user redefine values via nvram (all values must be set in that case)
	t_min = (nvram_get_int("fanctrl_t1") ? ((nvram_get_int("fanctrl_t1") - 20) * 2) : TEMP_MIN);
	t_1 = (nvram_get_int("fanctrl_t2") ? ((nvram_get_int("fanctrl_t2") - 20) * 2) : TEMP_1);
	t_2 = (nvram_get_int("fanctrl_t3") ? ((nvram_get_int("fanctrl_t3") - 20) * 2) : TEMP_2);
	t_3 = (nvram_get_int("fanctrl_t4") ? ((nvram_get_int("fanctrl_t4") - 20) * 2) : TEMP_3);
	t_max = (nvram_get_int("fanctrl_t5") ? ((nvram_get_int("fanctrl_t5") - 20) * 2) : TEMP_MAX);
	// some failsafe checks (revert to defaults on wrong / incomplete user settings)
	if ((t_1 <= t_min) || (t_min < 0)) { t_min = TEMP_MIN; t_1 = TEMP_1; }
	if (t_2 <= t_1) t_2 = TEMP_2;
	if (t_3 <= t_2) t_3 = TEMP_3;
	if (t_max <= t_3) t_max = TEMP_MAX;

	if (duty_cycle && (tempavg_max < t_max)) {
		base = duty_cycle;
#ifdef DEBUG
		dbG("phy_tempsense_mon: manual mode, duty_cycle=%d", duty_cycle);
#endif
	} else {
		if (tempavg_max < t_min - TEMP_H)
			base = 1;
		else
		if ((tempavg_max > t_min) && (tempavg_max < t_1 - TEMP_H))
			base = 2;
		else
		if ((tempavg_max > t_1) && (tempavg_max < t_2 - TEMP_H))
			base = 3;
		else
		if ((tempavg_max > t_2) && (tempavg_max < t_3 - TEMP_H))
			base = 4;
		else
		if ((tempavg_max > t_3) && (tempavg_max < t_max - TEMP_H))
			base = 5;
		else
		if (tempavg_max > t_max)
			base = 0;
#ifdef DEBUG
		dbG("phy_tempsense_mon: auto mode (%d), t_min: %d, t_1: %d, t_2: %d, t_3: %d, t_max: %d", base, t_min, t_1, t_2, t_3, t_max);
#endif
	}

	if (!base) {
		nvram_set("fanctrl_dutycycle_ex", "3"); // average, not max rev (5)
	} else {
		sprintf(w, "%d", base - 1);
#ifdef DEBUG
		dbG("phy_tempsense_mon: nvram set fanctrl_dutycycle_ex=%s", w);
#endif
		nvram_set("fanctrl_dutycycle_ex", w);
	}

	return 0;
}

static void
phy_tempsense(int sig)
{
	int count_local = count_timer % 30;

	if (!count_local)
		phy_tempsense_mon();

        status_old = status;
        status = fan_status();
#ifdef DEBUG
	dbG("tempavg: %.3f, fan status: %d\n", tempavg_max, status);
#endif

	if (status != status_old)
	{
#ifdef DEBUG
		dbG("phy_tempsense: %.3f, fan status changed to: %d\n", tempavg_max, status);
#endif
		if (status)
			led(LED_BRIDGE, LED_ON);
		else
			led(LED_BRIDGE, LED_OFF);
	}

	count_timer = (count_timer + 1) % 60;

	alarmtimer(0, FAN_NORMAL_PERIOD);
}

static void
update_dutycycle(int sig)
{
	alarmtimer(0, 0);

	count = -1;
	status = -1;
	count_timer = 0;

	duty_cycle = nvram_get_int("fanctrl_dutycycle");
	if ((duty_cycle < 0) || (duty_cycle > 5))
		duty_cycle = 0;

#ifdef DEBUG
	dbG("\nduty cycle: %d\n", duty_cycle);
#endif

	phy_tempsense(sig);
}

int 
phy_tempsense_main(int argc, char *argv[])
{
	FILE *fp;
	sigset_t sigs_to_catch;
	char w[32];
	int t1,t2,t3,t4,t5;

	/* write pid */
	if ((fp = fopen("/var/run/phy_tempsense.pid", "w")) != NULL)
	{
		fprintf(fp, "%d", getpid());
		fclose(fp);
	}

	/* set the signal handler */
	sigemptyset(&sigs_to_catch);
	sigaddset(&sigs_to_catch, SIGALRM);
	sigaddset(&sigs_to_catch, SIGTERM);
	sigaddset(&sigs_to_catch, SIGUSR1);
	sigprocmask(SIG_UNBLOCK, &sigs_to_catch, NULL);

	signal(SIGALRM, phy_tempsense);
	signal(SIGTERM, phy_tempsense_exit);
	signal(SIGUSR1, update_dutycycle);

	sprintf(w, "%d", base);
	nvram_set("fanctrl_dutycycle_ex", w);

	duty_cycle = nvram_get_int("fanctrl_dutycycle");
	if ((duty_cycle < 0) || (duty_cycle > 4))
		duty_cycle = 0;
	// note user about fan control in syslog
	if (duty_cycle)
		syslog(LOG_INFO,"Use manual mode for fan control, duty_cycle = %d", duty_cycle);
	else {
		t1 = (nvram_get_int("fanctrl_t1") ? nvram_get_int("fanctrl_t1") : TEMP_MIN / 2 + 20);
		t2 = (nvram_get_int("fanctrl_t2") ? nvram_get_int("fanctrl_t2") : TEMP_1 / 2 + 20);
		t3 = (nvram_get_int("fanctrl_t3") ? nvram_get_int("fanctrl_t3") : TEMP_2 / 2 + 20);
		t4 = (nvram_get_int("fanctrl_t4") ? nvram_get_int("fanctrl_t4") : TEMP_3 / 2 + 20);
		t5 = (nvram_get_int("fanctrl_t5") ? nvram_get_int("fanctrl_t5") : TEMP_MAX / 2 + 20);
		if ((t2 <= t1) || (t1 < 20)) { t1 = TEMP_MIN / 2 + 20; t2 = TEMP_1 / 2 + 20; }
		if (t3 <= t2) t3 = TEMP_2 / 2 + 20;
		if (t4 <= t3) t4 = TEMP_3 / 2 + 20;
		if (t5 <= t4) t5 = TEMP_MAX / 2 + 20;
		syslog(LOG_INFO,"Auto mode, used temps: %d %d %d %d %d", t1, t2, t3, t4, t5);
	}
#ifdef DEBUG
	dbG("\nduty cycle: %d\n", duty_cycle);
#endif

	alarmtimer(0, FAN_NORMAL_PERIOD);

	/* Most of time it goes to sleep */
	while (1)
	{
		pause();
	}

	return 0;
}

void
restart_fanctrl()
{
	kill_pidfile_s("/var/run/phy_tempsense.pid", SIGUSR1);	
}

