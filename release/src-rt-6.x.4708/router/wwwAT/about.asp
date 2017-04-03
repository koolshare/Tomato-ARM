<title><% translate("About"); %></title>
<content>
	<div class="fluid-grid x3">
		<div class="box"><div class="heading">Tomato Firmware <% version(1); %></div>
			<div class="content">
				<p>
				<!-- USB-BEGIN -->
				<% translate("USB support integration and GUI"); %>,
				<!-- USB-END -->
				<!-- IPV6-BEGIN -->
				<% translate("IPv6 support"); %>,
				<!-- IPV6-END -->
				<% translate("Linux kernel"); %> <% version(2); %> <% translate("and Broadcom Wireless Driver"); %> <% version(3); %><br>
				<i>Copyright (C) 2013-2014 <% translate("Tomato-ARM Team"); %></i><br>
				<br>
				<b><% translate("Tomato-ARM Team"); %>:</b><br>
				- Micha&#322; Rupental (Shibby)<br>
				- Ofer Chen (roadkill)<br>
				- Vicente Soriano (Victek)
				<!-- / / / -->
			</div>
		</div>

		<div class="box"><div class="heading">"TsyNik" <% translate("features"); %></div>
			<div class="content">
				<a class="btn btn-primary pull-right" href="https://www.paypal.com/cgi-bin/webscr?&amp;cmd=_xclick&amp;business=tsynik@gmail.com&amp;item_name=Tomato ML" target="_blank"><i class="icon-paypal icon-large"></i> <b>Donate</b></a>
				<p>
					- <% translate("Revised Multi-Language support"); %><br />
					- <% translate("Redesigned AT interface"); %><br />
					- <% translate("HFS+ FS r/w integration"); %><br />
					- <% translate("USB audio ready fw (GUI)"); %><br />
					- <% translate("Extended HW support, thanks"); %> <a href="http://xvtx.ru/xwrt/index.htm">XVotrex</a><br />
					&nbsp;&nbsp;<a href="https://bitbucket.org/tsynik/tomato-arm">Source on BitBucket</a>
				</p>
			</div>
		</div>

		<div class="box"><div class="heading">AdvancedTomato</div>
			<div class="content">
				<a class="btn btn-primary pull-right" href="http://advancedtomato.com/donate" target="_blank"><i class="icon-paypal icon-large"></i> <b>Donate</b></a>
				<p>
					- <% translate("Complete interface re-design"); %><br />
					- <% translate("Various color schemes"); %><br />
					- <% translate("AdvancedTomato logo by Jacky"); %>,<br />
					&nbsp;&nbsp;<% translate("re-vectored by"); %> <a href="http://www.linksysinfo.org/index.php?members/wally3k.52990/">WaLLy3K</a><br />
					- <% translate("Based on Tomato by Shibby"); %>
				</p>
				Copyright (C) 2014 <a href="http://prahec.com/">Jacky Prahec</a>
			</div>
		</div>

		<!-- OPENVPN-BEGIN -->
		<div class="box"><div class="heading"><% translate("OpenVPN integration and GUI"); %></div>
			<div class="content">
				Copyright (C) 2010 Keith Moyer,<br>
				<a href='mailto:tomatovpn@keithmoyer.com'>tomatovpn@keithmoyer.com</a><br>
			</div>
		</div>
		<!-- OPENVPN-END -->

		<div class="box"><div class="heading">"Shibby" <% translate("features"); %></div>
			<div class="content">
				<form action="https://www.paypal.com/cgi-bin/webscr" method="post" class="pull-right" target="_blank">
					<input name="cmd" value="_s-xclick" type="hidden">
					<input name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----" type="hidden">
					<button class="btn btn-primary" value="submit" border="0" name="submit" alt="Donate"><i class="icon-paypal icon-large"></i> <b>Donate</b></button>
					<img alt="" src="https://www.paypalobjects.com/pl_PL/i/scr/pixel.gif" border="0" height="1" width="1">
				</form>
				<p>
					<!-- BBT-BEGIN -->
					- <% translate("Transmission 2.92 integration"); %><br>
					<!-- BBT-END -->
					<!-- BT-BEGIN -->
					- <% translate("GUI for Transmission"); %><br>
					<!-- BT-END -->
					<!-- NFS-BEGIN -->
					- <% translate("NFS utils integration and GUI"); %><br>
					<!-- NFS-END -->
					- <% translate("Custom log file path"); %><br>
					<!-- LINUX26-BEGIN -->
					- <% translate("SD-idle tool integration for kernel 2.6"); %><br>
					<!-- USB-BEGIN -->
					- <% translate("3G Modem support"); %><br>
					&nbsp;&nbsp;(<% translate("big thanks for"); %> @LDevil)<br>
					- <% translate("4G/LTE Modem support"); %><br>
					<!-- USB-END -->
					- <% translate("MutliWAN feature"); %><br>
					&nbsp;&nbsp;(<% translate("written by"); %> @Arctic, <% translate("modified by"); %> @Shibby)<br>
					<!-- LINUX26-END -->
					<!-- SNMP-BEGIN -->
					- <% translate("SNMP integration and GUI"); %><br>
					<!-- SNMP-END -->
					<!-- UPS-BEGIN -->
					- <% translate("APCUPSD integration and GUI"); %> (<% translate("implemented by"); %> @arrmo)<br>
					<!-- UPS-END -->
					<!-- DNSCRYPT-BEGIN -->
					- <% translate("DNScrypt-proxy 1.4.0 integration and GUI"); %><br>
					<!-- DNSCRYPT-END -->
					<!-- TOR-BEGIN -->
					- <% translate("TOR Project integration and GUI"); %><br>
					<!-- TOR-END -->
					<!-- OPENVPN-BEGIN -->
					- <% translate("OpenVPN: Routing Policy"); %><br>
					<!-- OPENVPN-END -->
					- <% translate("TomatoAnon project integration and GUI"); %><br>
					- <% translate("TomatoThemeBase project integration and GUI"); %><br>
					- <% translate("Ethernet Ports State"); %><br>
					- <% translate("Extended MOTD"); %><br>
					&nbsp;&nbsp;(<% translate("written by"); %> @Monter, <% translate("modified by"); %> @Shibby)<br>
					- <% translate("Webmon Backup Script"); %>
				</p>
				Copyright (C) 2011-2013 Michał Rupental<br>
				<a href='http://openlinksys.info' target='_new'>http://openlinksys.info</a><br>
			</div>
		</div>

		<!-- VPN-BEGIN -->
		<div class="box"><div class="heading">"JYAvenard" <% translate("features"); %></div>
			<div class="content">
				<p>
					<!-- OPENVPN-BEGIN -->
					- <% translate("OpenVPN enhancements &amp; username/password only authentication"); %><br>
					<!-- OPENVPN-END -->
					<!-- PPTPD-BEGIN -->
					- <% translate("PPTP VPN Client integration and GUI"); %><br>
					<!-- PPTPD-END -->
				</p>
				Copyright (C) 2010-2012 Jean-Yves Avenard<br>
				<a href='mailto:jean-yves@avenard.org'>jean-yves@avenard.org</a><br>
			</div>
		</div>
		<!-- VPN-END -->

		<div class="box"><div class="heading">"Victek" <% translate("features"); %></div>
			<div class="content">
				<p>
					- <% translate("Extended Sysinfo"); %><br>
					<!-- NOCAT-BEGIN -->
					- <% translate("Captive Portal. (Based in NocatSplash)"); %><br>
					<!-- NOCAT-END -->
					<!-- NGINX-BEGIN -->
					- <% translate("NGINX Web Server"); %><br>
					<!-- NGINX-END -->
					<!-- HFS-BEGIN -->
					- <% translate("HFS / HFS+ filesystem integration"); %><br>
					<!-- HFS-END -->
				</p>

				Copyright (C) 2007-2011 Ofer Chen & Vicente Soriano <br>
				<a href='http://victek.is-a-geek.com' target='_new'>http://victek.is-a-geek.com</a>
			</div>
		</div>

		<div class="box"><div class="heading">"Teaman" <% translate("features"); %></div>
			<div class="content">
				<p>
					- <% translate("QOS-detailed & ctrate filters"); %><br>
					- <% translate("Realtime bandwidth monitoring of LAN clients"); %><br>
					- <% translate("Static ARP binding"); %><br>
					- <% translate("VLAN administration GUI"); %><br>
					- <% translate("Multiple LAN support integration and GUI"); %><br>
					- <% translate("Multiple/virtual SSID support (experimental)"); %><br>
					- <% translate("UDPxy integration and GUI"); %><br>
					<!-- PPTPD-BEGIN -->
					- <% translate("PPTP Server integration and GUI"); %><br>
					<!-- PPTPD-END -->
				</p>
				Copyright (C) 2011 Augusto Bott<br>
				<a href='http://code.google.com/p/tomato-sdhc-vlan/' target='_new'>Tomato-sdhc-vlan Homepage</a><br>
			</div>
		</div>

		<div class="box"><div class="heading">"Lancethepants" <% translate("features"); %></div>
			<div class="content">
				<p>
					<!-- DNSSEC-BEGIN -->
					- <% translate("DNSSEC integration and GUI"); %><br>
					<!-- DNSSEC-END -->
					<!-- DNSCRYPT-BEGIN -->
					- <% translate("DNSCrypt-Proxy selectable/manual resolver"); %><br>
					<!-- DNSCRYPT-END -->
					- <% translate("Comcast DSCP Fix GUI"); %><br>
					<!-- TINC-BEGIN -->
					- <% translate("Tinc Daemon integration and GUI"); %><br>
					<!-- TINC-END -->
				</p>

				Copyright (C) 2014 Lance Fredrickson<br>
				<a href='mailto:lancethepants@gmail.com'>lancethepants@gmail.com</a><br>
			</div>
		</div>

		<div class="box"><div class="heading">"Toastman" <% translate("features"); %></div>
			<div class="content">
				<p>
					- <% translate("Configurable QOS class names"); %><br>
					- <% translate("Comprehensive QOS rule examples set by default"); %><br>
					- <% translate("TC-ATM overhead calculation - patch by tvlz"); %><br>
					- <% translate("GPT support for HDD by Yaniv Hamo"); %><br>
					- <% translate("Tools - System refresh timer"); %>
				</p>
				Copyright (C) 2011 Toastman<br>
				<a href='http://www.linksysinfo.org/index.php?threads/using-qos-tutorial-and-discussion.28349/' target='_new'>Using QoS - Tutorial and discussion</a>
			</div>
		</div>

		<div class="box"><div class="heading">"Tiomo" <% translate("features"); %></div>
			<div class="content">
				<p>
					- <% translate("IMQ based QOS Ingress"); %><br>
					- <% translate("Incoming Class Bandwidth pie chart"); %>
				</p>
				Copyright (C) 2012 Tiomo
			</div>
		</div>

		<!-- SDHC-BEGIN -->
		<div class="box"><div class="heading">"Slodki" <% translate("feature"); %></div>
			<div class="content">
				<p>
					- <% translate("SDHC integration and GUI"); %>
				</p>
				Copyright (C) 2009 Tomasz Słodkowicz <a href='http://gemini.net.pl/~slodki/tomato-sdhc.html' target='_new'>tomato-sdhc</a>
			</div>
		</div>
		<!-- SDHC-END -->

		<div class="box"><div class="heading">"Victek/PrinceAMD/Phykris/Shibby" <% translate("feature"); %></div>
			<div class="content">
				- <% translate("Revised IP/MAC Bandwidth Limiter"); %><br>
			</div>
		</div>

		<!-- NGINX-BEGIN -->
		<div class="box"><div class="heading">Tomato-hyzoom <% translate("feature"); %></div>
			<div class="content">
				- <% translate("MySQL Server integration and GUI"); %><br>
				<i>Copyright (C) 2014 Bao Weiquan, Hyzoom</i>, <a href='mailto:bwq518@gmail.com'>bwq518@gmail.com</a>
			</div>
		</div>
		<!-- NGINX-END -->

	</div>

	<div class="box box-fluid">
		<div class="content">
			<h4><% translate("Special Thanks"); %></h4>
			<p><% translate("We want to express our gratitude to all people not mentioned here but contributed with patches, new models additions, bug solving and updates to Tomato firmware"); %>.</p>

			<h4><% translate("Based on Tomato Firmware"); %> v1.28</h4>
			<p>
				<i>Copyright (C) 2006-2010 Jonathan Zarate</i><br><a href="http://www.polarcloud.com/tomato/" target="_blank">http://www.polarcloud.com/tomato/</a>
			</p>

			<p>
				<% translate("Built on"); %> <% build_time(); %> by tsynik
				<br /><b><% translate("Thanks to everyone who risked their routers, tested, reported bugs, made suggestions and contributed to this project"); %>. ^ _ ^</b>
			</p>

			<!-- Please do not remove or change the homepage link or donate button. Thanks. - Jon -->
			<form action="https://www.paypal.com/cgi-bin/webscr" method="post" style="margin: 0;" target="_blank">
				<input type="hidden" name="cmd" value="_s-xclick">
				<button class="btn btn-primary" value="submit" border="0" name="submit" alt="Donate"><i class="icon-paypal icon-large"></i> <b>Donate</b></button>
				<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----">
			</form>

		</div>
	</div>
</content>
