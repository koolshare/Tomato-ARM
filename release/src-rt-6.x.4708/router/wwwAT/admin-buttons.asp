<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title><% translate("Buttons/LED"); %></title>
<content>

	<script type='text/javascript'>
		//	<% nvram("stealth_mode,stealth_iled,sesx_led,sesx_b0,sesx_b1,sesx_b2,sesx_b3,sesx_script,script_brau,t_model,t_features"); %>

		var ses = features('ses');
		var brau = features('brau');
		var aoss = features('aoss');
		var wham = features('wham');

		function verifyFields(focused, quiet)
		{
			E('_f_stealth_iled').disabled = !E('_f_stealth_mode').checked;
			return 1;
		}

		function save()
		{
			var n;
			var fom;

			fom = E('_fom');
			n = 0;
			if (fom._led0.checked) n |= 1;
			if (fom._led1.checked) n |= 2;
			if (fom._led2.checked) n |= 4;
			if (fom._led3.checked) n |= 8;
			fom.sesx_led.value = n;
			fom.stealth_mode.value = E('_f_stealth_mode').checked ? 1 : 0;
			fom.stealth_iled.value = E('_f_stealth_iled').checked ? 1 : 0;

			form.submit(fom, 1);
		}

		function earlyInit()
		{
			if ((!brau) && (!ses)) {
			//	E('save-button').disabled = 1;	// anyway allow LED control in case No SES
				return;
			}

			E('_f_stealth_iled').disabled = !E('_f_stealth_mode').checked;

			if (brau) E('braudiv').style.display = '';
			E('sesdiv').style.display = '';
			if ((wham) || (aoss) || (brau)) E('leddiv').style.display = '';
		}
	</script>

	<form id="_fom" method="post" action="tomato.cgi">
		<input type="hidden" name="_nextpage" value="/#admin-buttons.asp">
		<input type="hidden" name="sesx_led" value="0">
		<input type="hidden" name="stealth_mode" value="0">
		<input type="hidden" name="stealth_iled" value="0">

		<div class="box" id="sesdiv" style="display:none">
			<div class="heading"><% translate("SES/WPS/AOSS Button"); %></div>
			<div class="content"></div>
			<script type="text/javascript">
				a = [[0,'<% translate("Do Nothing"); %>'],[1,'<% translate("Toggle Wireless"); %>'],[2,'<% translate("Reboot"); %>'],[3,'<% translate("Shutdown"); %>'],
					/* USB-BEGIN */
					[5,'<% translate("Unmount all USB Drives"); %>'],
					/* USB-END */
					[4,'<% translate("Run Custom Script"); %>']];
				$('#sesdiv .content').forms([
					{ title: "<% translate("When Pushed For"); %>..." },
					{ title: '0-2 <% translate("Seconds"); %>', indent: 2, name: 'sesx_b0', type: 'select', options: a, value: nvram.sesx_b0 || 0 },
					{ title: '4-6 <% translate("Seconds"); %>', indent: 2, name: 'sesx_b1', type: 'select', options: a, value: nvram.sesx_b1 || 0 },
					{ title: '8-10 <% translate("Seconds"); %>', indent: 2, name: 'sesx_b2', type: 'select', options: a, value: nvram.sesx_b2 || 0 },
					{ title: '12+ <% translate("Seconds"); %>', indent: 2, name: 'sesx_b3', type: 'select', options: a, value: nvram.sesx_b3 || 0 },
					{ title: '<% translate("Custom Script"); %>', style: 'width: 90%; height: 80px;', indent: 2, name: 'sesx_script', type: 'textarea', value: nvram.sesx_script }
				]);
			</script>
		</div>

		<div class="box" id="braudiv" style="display:none">
			<div class="heading"><% translate("Bridge/Auto Switch"); %></div>
			<div class="content"></div>
			<script type="text/javascript">
				$('#braudiv .content').forms([
					{ title: '<% translate("Custom Script"); %>', style: 'width: 90%; height: 80px;', indent: 2, name: 'script_brau', type: 'textarea', value: nvram.script_brau }
				]);
			</script>

		</div>

		<div class="box" id="stealthdiv" style="">
			<div class="heading"><% translate("Stealth Mode"); %></div>
			<div class="content"></div>
			<script type="text/javascript">
				$('#stealthdiv .content').forms([
					{ title: '<% translate("Disable all LEDs"); %>', name: 'f_stealth_mode', type: 'checkbox', value: (nvram.stealth_mode == 1), suffix: '&nbsp;<small>(<% translate("reboot required to turn off LEDs"); %>)</small>' },
					{ title: '<% translate("Exclude INTERNET LED"); %>', name: 'f_stealth_iled', type: 'checkbox', value: (nvram.stealth_iled == 1) },
				]);
			</script>
		</div>

		<div class="box" id="leddiv" style="display:none">
			<div class="heading"><% translate("Startup LED"); %></div>
			<div class="content"></div>
			<script type="text/javascript">
				$('#leddiv .content').forms([
					{ title: '<% translate("Amber SES"); %>', name: '_led0', type: 'checkbox', value: nvram.sesx_led & 1, hidden: !wham },
					{ title: '<% translate("White SES"); %>', name: '_led1', type: 'checkbox', value: nvram.sesx_led & 2, hidden: !wham },
					{ title: '<% translate("AOSS"); %>', name: '_led2', type: 'checkbox', value: nvram.sesx_led & 4, hidden: !aoss },
					{ title: '<% translate("Bridge"); %>', name: '_led3', type: 'checkbox', value: nvram.sesx_led & 8, hidden: !brau }
				]);
			</script>
		</div>

		<script type="text/javascript">
			if ((!ses) && (!brau)) $('#leddiv').after('<div class="alert alert-warning icon"><% translate("This feature is not supported on this router"); %>.</div>');
		</script>

		<button type="button" value="<% translate("Save"); %>" id="save-button" onclick="save()" class="btn btn-primary"><% translate("Save"); %> <i class="icon-check"></i></button>
		<button type="button" value="<% translate("Cancel"); %>" id="cancel-button" onclick="javascript:reloadPage();" class="btn"><% translate("Cancel"); %> <i class="icon-cancel"></i></button>
		<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
	</form>

	<script type="text/javascript">earlyInit();</script>
</content>
