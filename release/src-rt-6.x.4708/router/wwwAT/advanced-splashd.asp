<!--
Tomato GUI
Copyright (C) 2006-2008 Jonathan Zarate
http://www.polarcloud.com/tomato/

Copyright (C) 2011 Ofer Chen (Roadkill), Vicente Soriano (Victek)
Adapted & Modified from Dual WAN Tomato Firmware.

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title><% translate("Captive Portal Management"); %></title>
<content>
	<script type="text/javascript">
		//	<% nvram("NC_enable,NC_Verbosity,NC_GatewayName,NC_GatewayPort,NC_ForcedRedirect,NC_HomePage,NC_DocumentRoot,NC_LoginTimeout,NC_IdleTimeout,NC_MaxMissedARP,NC_ExcludePorts,NC_IncludePorts,NC_AllowedWebHosts,NC_MACWhiteList,NC_BridgeLAN,lan_ifname,lan1_ifname,lan2_ifname,lan3_ifname"); %>

		function fix(name)
		{
			var i;
			if (((i = name.lastIndexOf('/')) > 0) || ((i = name.lastIndexOf('\\')) > 0))
				name = name.substring(i + 1, name.length);
			return name;
		}

		function uploadButton()
		{
			var fom;
			var name;
			var i;
			name = fix(E('upload-name').value);
			name = name.toLowerCase();
			if ((name.length <= 5) || (name.substring(name.length - 5, name.length).toLowerCase() != '.html')) {
				alert('Wrong filename, the correct extension is ".html".');
				return;
			}
			if (!confirm('Are you sure the file ' + name + 'must be uploaded to the device?')) return;
			E('upload-button').disabled = 1;
			fields.disableAll(E('config-section'), 1);
			E('upload-form').submit();
		}

		function verifyFields(focused, quiet)
		{
			var a = E('_f_NC_enable').checked;

			E('_NC_Verbosity').disabled = !a;
			E('_NC_GatewayName').disabled = !a;
			E('_NC_GatewayPort').disabled = !a;
			E('_f_NC_ForcedRedirect').disabled = !a;
			E('_NC_HomePage').disabled = !a;
			E('_NC_DocumentRoot').disabled = !a;
			E('_NC_LoginTimeout').disabled = !a;
			E('_NC_IdleTimeout').disabled = !a;
			E('_NC_MaxMissedARP').disabled = !a;
			E('_NC_ExcludePorts').disabled = !a;
			E('_NC_IncludePorts').disabled = !a;
			E('_NC_AllowedWebHosts').disabled = !a;
			E('_NC_MACWhiteList').disabled = !a;
			E('_NC_BridgeLAN').disabled = !a;

			var bridge = E('_NC_BridgeLAN');
			if(nvram.lan_ifname.length < 1)
				bridge.options[0].disabled=true;
			if(nvram.lan1_ifname.length < 1)
				bridge.options[1].disabled=true;
			if(nvram.lan2_ifname.length < 1)
				bridge.options[2].disabled=true;
			if(nvram.lan3_ifname.length < 1)
				bridge.options[3].disabled=true;

			if ( (E('_f_NC_ForcedRedirect').checked) && (!v_length('_NC_HomePage', quiet, 1, 255))) return 0;
			if (!v_length('_NC_GatewayName', quiet, 1, 255)) return 0;
			if ( (E('_NC_IdleTimeout').value != '0') && (!v_range('_NC_IdleTimeout', quiet, 300))) return 0;
			return 1;
		}

		function save()
		{
			if (verifyFields(null, 0)==0) return;
			var fom = E('_fom');
			fom.NC_enable.value = E('_f_NC_enable').checked ? 1 : 0;
			fom.NC_ForcedRedirect.value = E('_f_NC_ForcedRedirect').checked ? 1 : 0;

			// blank spaces with commas
			e = E('_NC_ExcludePorts');
			e.value = e.value.replace(/\,+/g, ' ');

			e = E('_NC_IncludePorts');
			e.value = e.value.replace(/\,+/g, ' ');

			e = E('_NC_AllowedWebHosts');
			e.value = e.value.replace(/\,+/g, ' ');

			e = E('_NC_MACWhiteList');
			e.value = e.value.replace(/\,+/g, ' ');

			fields.disableAll(E('upload-section'), 1);
			if (fom.NC_enable.value == 0) {
				fom._service.value = 'splashd-stop';
			}
			else {
				fom._service.value = 'splashd-restart';
			}
			form.submit('_fom', 1);
		}

	</script>

	<div class="box">
		<div class="heading"><% translate("Captive Portal Management"); %></div>
		<div class="content">
			<form id="_fom" method="post" action="tomato.cgi">
				<input type="hidden" name="_nextpage" value="/#advanced-splashd.asp">
				<input type="hidden" name="_service" value="splashd-restart">
				<input type="hidden" name="NC_enable">
				<input type="hidden" name="NC_ForcedRedirect">
				<div id="cat-configure"></div><hr>
				<script type="text/javascript">
					$('#cat-configure').forms([
						{ title: '<% translate("Enable Function"); %>', name: 'f_NC_enable', type: 'checkbox', value: nvram.NC_enable == '1' },
						/* VLAN-BEGIN */
						{ title: '<% translate("Interface"); %>', multi: [
							{ name: 'NC_BridgeLAN', type: 'select', options: [
								['br0','<% translate("LAN"); %> (br0) *'],
								['br1','<% translate("LAN2"); %> (br1)'],
								['br2','<% translate("LAN3"); %> (br2)'],
								['br3','<% translate("LAN4"); %> (br3)']
								], value: nvram.NC_BridgeLAN, suffix: ' <small> * <% translate("default"); %></small> ' } ] },
						/* VLAN-END */
						{ title: '<% translate("Gateway Name"); %>', name: 'NC_GatewayName', type: 'text', maxlen: 255, size: 34, value: nvram.NC_GatewayName },
						{ title: '<% translate("Captive Site Forwarding"); %>', name: 'f_NC_ForcedRedirect', type: 'checkbox', value: (nvram.NC_ForcedRedirect == '1') },
						{ title: '<% translate("Home Page"); %>', name: 'NC_HomePage', type: 'text', maxlen: 255, size: 34, value: nvram.NC_HomePage },
						{ title: '<% translate("Welcome html Path"); %>', name: 'NC_DocumentRoot', type: 'text', maxlen: 255, size: 20, value: nvram.NC_DocumentRoot, suffix: '<span>&nbsp;/splash.html</span>' },
						{ title: '<% translate("Login Timeout"); %>', name: 'NC_LoginTimeout', type: 'text', maxlen: 8, size: 4, value: nvram.NC_LoginTimeout, suffix: ' <% translate("seconds"); %> <small>(<% translate("default"); %>: 3600 <% translate("seconds"); %> <% translate("or"); %> 1 <% translate("hour"); %>)</small>' },
						{ title: '<% translate("Idle Timeout"); %>', name: 'NC_IdleTimeout', type: 'text', maxlen: 8, size: 4, value: nvram.NC_IdleTimeout, suffix: ' <% translate("seconds"); %> <small>(0 - <% translate("unlimited"); %>)</small>' },
						{ title: '<% translate("Max Missed ARP"); %>', name: 'NC_MaxMissedARP', type: 'text', maxlen: 10, size: 2, value: nvram.NC_MaxMissedARP, suffix: ' <small>(<% translate("default"); %>: 5)</small>' },
						null,
						{ title: '<% translate("Log Info Level"); %>', name: 'NC_Verbosity', type: 'text', maxlen: 10, size: 2, value: nvram.NC_Verbosity,  suffix: ' <small>(<% translate("default"); %>: 2)</small>' },
						{ title: '<% translate("Gateway Port"); %>', name: 'NC_GatewayPort', type: 'text', maxlen: 10, size: 7, value: fixPort(nvram.NC_GatewayPort, 5280), suffix: ' <small>(<% translate("default"); %> 5280)</small>' },
						{ title: '<% translate("Excluded Ports to be redirected"); %>', name: 'NC_ExcludePorts', type: 'text', maxlen: 255, size: 34, value: nvram.NC_ExcludePorts },
						{ title: '<% translate("Included Ports to be redirected"); %>', name: 'NC_IncludePorts', type: 'text', maxlen: 255, size: 34, value: nvram.NC_IncludePorts },
						{ title: '<% translate("Excluded URLs"); %>', name: 'NC_AllowedWebHosts', type: 'text', maxlen: 255, size: 34, value: nvram.NC_AllowedWebHosts },
						{ title: '<% translate("MAC Address Whitelist"); %>', name: 'NC_MACWhiteList', type: 'text', maxlen: 255, size: 34, value: nvram.NC_MACWhiteList }
					]);
				</script>
			</form>


			<h4><% translate("Customized Splash File"); %></h4>
			<div class="section" id="upload-section">
				<form id="upload-form" method="post" action="uploadsplash.cgi?_http_id=<% nv(http_id); %>" enctype="multipart/form-data">
					<fieldset><label class="col-sm-3 control-left-label" for="upload-name"><% translate("Custom splash file"); %></label>
						<div class="col-sm-9">
							<input class="uploadfile" type="file" size="40" id="upload-name" name="upload_name">
							<button type="button" name="f_upload_button" id="upload-button" value="Upload" onclick="uploadButton()" class="btn btn-danger"><% translate("Upload"); %> <i class="icon-upload"></i></button>
						</div>
					</fieldset>
				</form>
			</div>
			<hr>
			<h5><% translate("User Guide"); %></h5>
			<div class="section" id="sesdivnotes">
				<ul>
					<li><b><% translate("Enable Function"); %></b> - <% translate("The router will show a Welcome banner when a client attempts to access the Internet"); %>.<br>
					<li><b><% translate("Interface"); %>:</b> - <% translate("Select one of the bridges on which the Captive Portal will listen"); %>.<br>
					<li><b><% translate("Gateway Name"); %></b> - <% translate("The name of the Gateway appearing in the welcome banner"); %>.<br>
					<li><b><% translate("Gateway Port"); %></b> - <% translate("The port number of the gateway"); %>.<br>
					<li><b><% translate("Captive Site Forwarding"); %></b> - <% translate("When active, a 'Home Page' will appear after you click 'Agree' in the Welcome banner"); %>.<br>
					<li><b><% translate("Home Page"); %></b> - <% translate("The URL for the 'Home Page' mentioned above is located"); %>.<br>
					<li><b><% translate("Welcome html Path"); %></b> - <% translate("The location where the Welcome banner is stored"); %><br>
					<li><b><% translate("Login Timeout"); %></b> - <% translate("The client can use the internet until this time expires"); %>.<br>
					<li><b><% translate("Idle Timeout"); %></b> - <% translate("How often the ARP cache will be checked"); %> (<% translate("seconds"); %>)<br>
					<li><b><% translate("Max Missed ARP"); %></b> - <% translate("Number of lost ARP before considering the client has leaved the connection"); %>.<br>
					<li><b><% translate("Log Info Level"); %></b> - <% translate("Verbosity level for log messages from this module, Level"); %> 0=<% translate("Silent"); %>, 10=<% translate("Verbose"); %>.<br>

					<li><b><% translate("Included ports"); %></b> - <% translate("TCP ports to allow access to after login, all others will be denied"); %>.<br>
					<li><b><% translate("Excluded ports"); %></b> - <% translate("TCP ports to denied access to after login, all others will be allowed"); %>.<br>
					<% translate("Leave a blank space between each port number. Use only one of these two options to avoid conflicts"); %>.<br>

					<li><b><% translate("Excluded URLs"); %></b> - <% translate("URLs that can be accessed without the Welcome banner screen appearing. When you set allowed url's also leave a blank space between each url. i.e;"); %> http://www.google.com http://www.google.es<br>
					<li><b><% translate("MAC Address Whitelist"); %></b> - <% translate("MAC addresses excluded from the portal. Leave a blank space between each MAC Address, i.e;"); %> 11:22:33:44:55:66 11:22:33:44:55:67<br>
					<li><b><% translate("Customized Splash File"); %></b> - <% translate("Here you can upload your personal Welcome banner that will overwrite the default one"); %>.<br><br>
					<span style="color:red">
						<% translate("When the client's lease has expired, he must enter the Splash page again to get a new lease. No warning is given, therefore you may wish to give a long lease time to avoid problems."); %>
					</span>
				</ul>
			</div>

		</div>
	</div>

	<button type="button" value="<% translate("Save"); %>" id="save-button" onclick="save()" class="btn btn-primary"><% translate("Save"); %> <i class="icon-check"></i></button>
	<button type="button" value="<% translate("Cancel"); %>" id="cancel-button" onclick="javascript:reloadPage();" class="btn"><% translate("Cancel"); %> <i class="icon-cancel"></i></button>
	<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span><br /><br />
	<script type="text/javascript">verifyFields(null, 1);</script>

</content>
