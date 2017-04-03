<title><% translate("Status Overview"); %></title>
<content>
	<script type="text/javascript" src="js/wireless.jsx?_http_id=<% nv(http_id); %>"></script>
	<script type="text/javascript" src="js/interfaces.js?_http_id=<% nv(http_id); %>"></script>
	<script type="text/javascript" src="status-data.asp?_http_id=<% nv(http_id); %>"></script>
	<script type="text/javascript">
		//    <% nvstat(); %>
		//    <% etherstates(); %>
		wmo = {'ap':'<% translate("Access Point"); %>','sta':'<% translate("Wireless Client"); %>','wet':'<% translate("Wireless Ethernet Bridge"); %>','wds':'<% translate("WDS"); %>'};
		auth = {'disabled':'-','wep':'WEP','wpa_personal':'WPA Personal (PSK)','wpa_enterprise':'WPA Enterprise','wpa2_personal':'WPA2 Personal (PSK)','wpa2_enterprise':'WPA2 Enterprise','wpaX_personal':'WPA / WPA2 Personal','wpaX_enterprise':'WPA / WPA2 Enterprise','radius':'Radius'};
		enc = {'tkip':'TKIP','aes':'AES','tkip+aes':'TKIP / AES'};
		bgmo = {'disabled':'-','mixed':'Auto','b-only':'B Only','g-only':'G Only','bg-mixed':'B/G Mixed','lrs':'LRS','n-only':'N Only'};
	</script>
	<script type="text/javascript">
		show_dhcpc = [];
		show_codi = [];
		for (var uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
			var u ;
			u = (uidx>1) ? uidx : '';
			proto = nvram['wan'+u+'_proto'];
			if (proto != 'disabled') show_langateway = 0;
			show_dhcpc[uidx-1] = ((proto == 'dhcp') || (proto == 'lte') || (((proto == 'l2tp') || (proto == 'pptp') || (proto == 'pppoe')) && (nvram['wan'+u+'_pptp_dhcp'] == '1')));
			show_codi[uidx-1] = ((proto == 'pppoe') || (proto == 'l2tp') || (proto == 'pptp') || (proto == 'ppp3g'));
		}

		show_radio = [];
		for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
			/* REMOVE-BEGIN
			//	show_radio.push((nvram['wl'+wl_unit(uidx)+'_radio'] == '1'));
			REMOVE-END */
			if (wl_sunit(uidx)<0)
				show_radio.push((nvram['wl'+wl_fface(uidx)+'_radio'] == '1'));
		}

		nphy = features('11n');

		function dhcpc(what, wan_prefix)
		{
			form.submitHidden('dhcpc.cgi', { exec: what, prefix: wan_prefix, _redirect: '/#status-home.asp' });
		}

		function serv(service, sleep)
		{
			form.submitHidden('service.cgi', { _service: service, _redirect: '/#status-home.asp', _sleep: sleep });
		}

		function wan_connect(uidx)
		{
			serv('wan'+uidx+'-restart', 5);
		}

		function wan_disconnect(uidx)
		{
			serv('wan'+uidx+'-stop', 2);
		}

		function wlenable(uidx, n)
		{
			form.submitHidden('wlradio.cgi', { enable: '' + n, _nextpage: 'status-overview.asp', _nextwait: n ? 6 : 3, _wl_unit: wl_unit(uidx) });
		}

		var ref = new TomatoRefresh('status-data.asp', '', 0, 'status_overview_refresh');

		ref.refresh = function(text)
		{
			stats = {};
			try {
				eval(text);
			}
			catch (ex) {
				stats = {};
			}
			show();
		}


		function c(id, htm)
		{
			E(id).cells[1].innerHTML = htm;
		}

		function ethstates()
		{
			var status, speed, code = '';

			if (etherstates.port0 == "disable" || typeof (etherstates.port0) == 'undefined' || typeof (etherstates.port1) == 'undefined' || typeof (etherstates.port2) == 'undefined' || typeof (etherstates.port3) == 'undefined' || typeof (etherstates.port4) == 'undefined') {
				$('#ethernetPorts').remove();
				return false;
			}

			// Above code checks if ETH ports are Disabled/Enabled
			code += '<div id="ethPorts">';

			// WAN
			if (etherstates.port0 == "DOWN") { status = 'off'; speed = etherstates.port0.replace("DOWN","<% translate("Unplugged"); %>");
			} else { status = 'on'; speed = etherstates.port0.replace('HD', 'M HD'); speed = speed.replace("FD","M FD"); }
			if (stats.lan_desc != '1') { speed = ' '; }

			code += '<div class="eth ' + status + ' wan"><div class="title">WAN</div><div class="speed">' + speed + '</div></div>';

			// LAN 1
			if (etherstates.port1 == "DOWN") { status = 'off'; speed = etherstates.port1.replace("DOWN","<% translate("Unplugged"); %>");
			} else { status = 'on'; speed = etherstates.port1.replace('HD', 'M HD'); speed = speed.replace("FD","M FD"); }
			if (stats.lan_desc != '1') { speed = ' '; }

			code += '<div class="eth ' + status + '"><div class="title">LAN 1</div><div class="speed">' + speed + '</div></div>';

			// LAN 2
			if (etherstates.port2 == "DOWN") { status = 'off'; speed = etherstates.port2.replace("DOWN","<% translate("Unplugged"); %>");
			} else { status = 'on'; speed = etherstates.port2.replace('HD', 'M HD'); speed = speed.replace("FD","M FD"); }
			if (stats.lan_desc != '1') { speed = ' '; }

			code += '<div class="eth ' + status + '"><div class="title">LAN 2</div><div class="speed">' + speed + '</div></div>';

			// LAN 3
			if (etherstates.port3 == "DOWN") { status = 'off'; speed = etherstates.port3.replace("DOWN","<% translate("Unplugged"); %>");
			} else { status = 'on'; speed = etherstates.port3.replace('HD', 'M HD'); speed = speed.replace("FD","M FD"); }
			if (stats.lan_desc != '1') { speed = ' '; }

			code += '<div class="eth ' + status + '"><div class="title">LAN 3</div><div class="speed">' + speed + '</div></div>';

			// LAN 4
			if (etherstates.port4 == "DOWN") { status = 'off'; speed = etherstates.port4.replace("DOWN","<% translate("Unplugged"); %>");
			} else { status = 'on'; speed = etherstates.port4.replace('HD', 'M HD'); speed = speed.replace("FD","M FD"); }
			if (stats.lan_desc != '1') { speed = ' '; }

			code += '<div class="eth ' + status + '"><div class="title">LAN 4</div><div class="speed">' + speed + '</div></div>';

			code += '</div>';
			$("#ethernetPorts .content").html(code);
		}

		function show() {

			c('cpu', stats.cpuload);
			c('cpupercent', stats.cpupercent);
			c('uptime', stats.uptime);
			c('time', stats.time);
			/* REMOVE-BEGIN
			//c('wanprebuf',stats.wanprebuf); //Victek
			REMOVE-END */
			c('memory', stats.memory + '<div class="progress"><div class="bar" style="width: ' + stats.memoryperc + ';"></div></div>');
			c('swap', stats.swap + '<div class="progress"><div class="bar" style="width: ' + stats.swapperc + ';"></div></div>');
			elem.display('swap', stats.swap != '');

			/* IPV6-BEGIN */
			c('ip6_wan', stats.ip6_wan);
			elem.display('ip6_wan', stats.ip6_wan != '');
			c('ip6_lan', stats.ip6_lan);
			elem.display('ip6_lan', stats.ip6_lan != '');
			c('ip6_lan_ll', stats.ip6_lan_ll);
			elem.display('ip6_lan_ll', stats.ip6_lan_ll != '');
			/* IPV6-END */

			var uidx;

			for (uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
				var u = (uidx > 1) ? uidx : '';

				c('wan'+u+'ip', stats.wanip[uidx-1]);
				c('wan'+u+'netmask', stats.wannetmask[uidx-1]);
				c('wan'+u+'gateway', stats.wangateway[uidx-1]);
				c('wan'+u+'dns', stats.dns[uidx-1]);
				c('wan'+u+'status', ((stats.wanstatus[uidx-1] == 'Connected') ? '<% translate("Connected"); %> <span class="text-green"><i class="icon-globe"></i></span>' : (stats.wanstatus[uidx-1] == 'Disconnected') ? '<b><% translate("Disconnected"); %></b> <span class="text-red"><i class="icon-cancel"></i></span>' : '<b>' + stats.wanstatus[uidx-1] + '</b>'));
				c('wan'+u+'uptime', stats.wanuptime[uidx-1]);
				if (show_dhcpc[uidx-1]) c('wan'+u+'lease', stats.wanlease[uidx-1]);
				if (show_codi[uidx-1]) {
					if (stats.wanup[uidx-1]) {
						$('#b'+u+'_connect').hide();
						$('#b'+u+'_disconnect').show();
					} else {
						$('#b'+u+'_connect').show();
						$('#b'+u+'_disconnect').hide();	
					}
				}
			}

			for (uidx = 0; uidx < wl_ifaces.length; ++uidx) {
				if (wl_sunit(uidx)<0) {
					c('radio'+uidx, wlstats[uidx].radio ? '<% translate("Enabled"); %> <span class="text-green"><i class="icon-check"></i></span>' : '<b><% translate("Disabled"); %></b> <span class="text-red"><i class="icon-cancel"></i></span>');
					c('rate'+uidx, wlstats[uidx].rate);

					if (show_radio[uidx]) {
						if (wlstats[uidx].radio) {
							$('#b_wl'+uidx+'_enable').hide();
							$('#b_wl'+uidx+'_disable').show();
						} else {
							$('#b_wl'+uidx+'_enable').show();
							$('#b_wl'+uidx+'_disable').hide();
						}

					} else {

						// Interface disabled, hide enable/disable
						$('#b_wl'+uidx+'_enable').hide();
						$('#b_wl'+uidx+'_disable').hide();

					}

					c('channel'+uidx, stats.channel[uidx]);
					if (nphy) {
						c('nbw'+uidx, wlstats[uidx].nbw);
					}
					c('interference'+uidx, stats.interference[uidx]);
					elem.display('interference'+uidx, stats.interference[uidx] != '');

					if (wlstats[uidx].client) {
						c('rssi'+uidx, wlstats[uidx].rssi || '');
						c('noise'+uidx, wlstats[uidx].noise || '');
						c('qual'+uidx, stats.qual[uidx] || '');
					}
				}
				c('ifstatus'+uidx, wlstats[uidx].ifstatus || '');
			}
		}

		function earlyInit()
		{
			var uidx;
			for (uidx = 1; uidx <= nvram.mwan_num; ++uidx) {
				var u = (uidx > 1) ? uidx : '';
				elem.display('b'+u+'_dhcpc', show_dhcpc[uidx-1]);
				elem.display('b'+u+'_connect', 'b'+u+'_disconnect', show_codi[uidx-1]);
				elem.display('wan'+u+'-title', 'sesdiv_wan'+u, (nvram['wan'+u+'_proto'] != 'disabled'));
			}
			for (uidx = 0; uidx < wl_ifaces.length; ++uidx) {
				if (wl_sunit(uidx)<0)
					$('#b_wl'+wl_fface(uidx)+'_enable').closest('.btn-control-group').show();
			}

			ethstates();
			init();
		}

		function init() {

			$('.refresher').after(genStdRefresh(1,1,'ref.toggle()'));
			ref.initPage(3000, 3);
			show();

		}

	</script>

	<div class="fluid-grid">

		<!-- SYS -->
		<div class="box" data-box="home_systembox">
			<div class="heading"><% translate("System"); %></div>
			<div class="content" id="sesdiv_system">
				<div class="section"></div>
				<script type="text/javascript">
					var a = (nvstat.size - nvstat.free) / nvstat.size * 100.0;
					createFieldTable('', [
						{ title: '<% translate("Name"); %>', text: nvram.router_name },
						{ title: '<% translate("Model"); %>', text: nvram.t_model_name },
						{ title: '<% translate("Chipset"); %>', text: stats.systemtype },
						{ title: '<% translate("CPU Freq"); %>', text: stats.cpumhz },
						{ title: '<% translate("Flash Size"); %>', text: stats.flashsize },
						null,
						{ title: '<% translate("Time"); %>', rid: 'time', text: stats.time },
						{ title: '<% translate("Uptime"); %>', rid: 'uptime', text: stats.uptime },
						{ title: '<% translate("CPU Usage"); %>', rid: 'cpupercent', text: stats.cpupercent },
						{ title: '<% translate("Temperature"); %> <small>(CPU / WL0 / WL1)</small>', rid: 'temps', text: stats.cputemp + ' / ' + stats.wl0temp + ' / ' + stats.wl1temp +'C'},
						/* SMARTCTL-BEGIN */
						{ title: '<% translate("Temperature"); %> HDD', rid: 'hddtemp', text: stats.hddtemp+'C'},
						/* SMARTCTL-END */
						{ title: '<% translate("CPU Load"); %> <small>(1 / 5 / 15 <% translate("mins"); %>)</small>', rid: 'cpu', text: stats.cpuload },
						{ title: '<% translate("Memory Usage"); %>', rid: 'memory', text: stats.memory + '<div class="progress"><div class="bar" style="width: ' + stats.memoryperc + ';"></div></div>' },
						{ title: '<% translate("SWAP Usage"); %>', rid: 'swap', text: stats.swap + '<div class="progress"><div class="bar" style="width: ' + stats.swapperc + ';"></div></div>', hidden: (stats.swap == '') },
						{ title: '<% translate("NVRAM Usage"); %>', text: scaleSize(nvstat.size - nvstat.free) + ' <small>/</small> ' + scaleSize(nvstat.size) + ' (' + (a).toFixed(2) + '%) <div class="progress"><div class="bar" style="width: ' + (a).toFixed(2) + '%;"></div></div>' },
						], '#sesdiv_system', 'data-table dataonly');
				</script>
			</div>
		</div>

		<!-- WAN -->
		<div id="wan-interfaces"></div>
		<script type='text/javascript'>

		for (var uidx = 1; uidx <= nvram.mwan_num; ++uidx) {

		var u = (uidx>1) ? uidx : '';
		var data = "";

		data+=	'<div class="box" id="wan'+u+'-title" data-box="home_wanbox">';
			data+=	'<div class="heading"><% translate("WAN"); %>'+u+'</div>';
			data+=	'<div class="content" id="sesdiv_wan'+u+'">';
				data+=	'<div class="WANField"></div>';
				data+=	createFieldTable('', [
						{ title: '<% translate("MAC Address"); %>', text: nvram['wan'+u+'_hwaddr'] },
						{ title: '<% translate("Connection Type"); %>', text: { 'dhcp':'DHCP', 'static':'Static IP', 'pppoe':'PPPoE', 'pptp':'PPTP', 'l2tp':'L2TP', 'ppp3g':'3G Modem', 'lte':'4G/LTE' }[nvram['wan'+u+'_proto']] || '-' },
						{ title: '<% translate("IP Address"); %>', rid: 'wan'+u+'ip', text: stats.wanip[uidx-1] },
						{ title: '<% translate("Subnet Mask"); %>', rid: 'wan'+u+'netmask', text: stats.wannetmask[uidx-1] },
						{ title: '<% translate("Gateway"); %>', rid: 'wan'+u+'gateway', text: stats.wangateway[uidx-1] },
						/* IPV6-BEGIN */
						{ title: '<% translate("IPv6 Address"); %>', rid: 'ip6_wan', text: stats.ip6_wan, hidden: (stats.ip6_wan == '') },
						/* IPV6-END */
						{ title: '<% translate("DNS"); %>', rid: 'wan'+u+'dns', text: stats.dns[uidx-1] },
						{ title: '<% translate("MTU"); %>', text: nvram['wan'+u+'_run_mtu'] },
						null,	// GAP
						{ title: '<% translate("Status"); %>', rid: 'wan'+u+'status', text: ((stats.wanstatus[uidx-1] == 'Connected') ? '<% translate("Connected"); %> <span class="text-green"><i class="icon-globe"></i></span>' : (stats.wanstatus[uidx-1] == 'Disconnected') ? '<b><% translate("Disconnected"); %></b> <span class="text-red"><i class="icon-cancel"></i></span>' : '<b>' + stats.wanstatus[uidx-1] + '</b>') },
						{ title: '<% translate("Connection Uptime"); %>', rid: 'wan'+u+'uptime', text: stats.wanuptime[uidx-1] },
						{ title: '<% translate("Remaining Lease Time"); %>', rid: 'wan'+u+'lease', text: stats.wanlease[uidx-1], ignore: !show_dhcpc[uidx-1] }
						], null, 'data-table dataonly');

			data+=	'<button type="button" class="btn btn-primary pull-left" onclick="wan_connect('+uidx+')" value="<% translate("Connect"); %>" id="b'+u+'_connect" style="display:none"><% translate("Connect"); %> <i class="icon-check"></i></button>';
			data+=	'<button type="button" class="btn btn-danger pull-left" onclick="wan_disconnect('+uidx+')" value="<% translate("Disconnect"); %>" id="b'+u+'_disconnect" style="display:none"><% translate("Disconnect"); %> <i class="icon-disable"></i></button>';

			data+=	'<div id="b'+u+'_dhcpc" class="btn-group pull-left" style="margin-left: 5px; display:none;">';
				data+=	'<button type="button" class="btn" onclick="dhcpc(\'renew\', \'wan'+u+'\')" value="Renew"><% translate("Renew"); %></button>';
				data+=	'<button type="button" class="btn" onclick="dhcpc(\'release\', \'wan'+u+'\')" value="Release"><% translate("Release"); %></button>';
			data+=	'</div>';

			data+=	'<div class="clearfix"></div>';

			data+=	'</div>';
		data+=	'</div>';

		$('#wan-interfaces').append(data);
		}
		</script>

		<!-- PORTS -->
		<div class="box" id="ethernetPorts" data-box="home_ethports">
			<div class="heading"><% translate("Ethernet Ports State"); %>
				<a class="ajaxload pull-right" data-toggle="tooltip" title="<% translate("Configure Settings"); %>" href="#basic-network.asp"><i class="icon-system"></i></a>
			</div>
			<div class="content" id="sesdiv_lan-ports"></div>
		</div>

		<!-- LAN -->
		<div class="box" id="LAN-settings" data-box="home_lanbox">
			<div class="heading"><% translate("LAN"); %></div>
			<div class="content" id="sesdiv_lan">
				<script type="text/javascript">

					function h_countbitsfromleft(num) {
						if (num == 255 ){
							return(8);
						}
						var i = 0;
						var bitpat=0xff00; 
						while (i < 8){
							if (num == (bitpat & 0xff)){
								return(i);
							}
							bitpat=bitpat >> 1;
							i++;
						}
						return(Number.NaN);
					}

					function numberOfBitsOnNetMask(netmask) {
						var total = 0;
						var t = netmask.split('.');
						for (var i = 0; i<= 3 ; i++) {
							total += h_countbitsfromleft(t[i]);
						}
						return total;
					}

					var s='';
					var t='';
					for (var i = 0 ; i <= MAX_BRIDGE_ID ; i++) {
						var j = (i == 0) ? '' : i.toString();
						var lannr = (i == 0) ? '' : (i + 1).toString();	// LAN1->LAN2
						if (nvram['lan' + j + '_ifname'].length > 0) {
							if (nvram['lan' + j + '_proto'] == 'dhcp') {
								if ((!fixIP(nvram.dhcpd_startip)) || (!fixIP(nvram.dhcpd_endip))) {
									var x = nvram['lan' + j + '_ipaddr'].split('.').splice(0, 3).join('.') + '.';
									nvram['dhcpd' + j + '_startip'] = x + nvram['dhcp' + j + '_start'];
									nvram['dhcpd' + j + '_endip'] = x + ((nvram['dhcp' + j + '_start'] * 1) + (nvram['dhcp' + j + '_num'] * 1) - 1);
								}
								s += ((s.length>0)&&(s.charAt(s.length-1) != ' ')) ? '<br>' : '';
								s += '<b>LAN' + lannr + '</b> (br' + i + ') - ' + nvram['dhcpd' + j + '_startip'] + ' - ' + nvram['dhcpd' + j + '_endip'];
							} else {
								s += ((s.length>0)&&(s.charAt(s.length-1) != ' ')) ? '<br>' : '';
								s += '<b>LAN' + lannr + '</b> (br' + i + ') - <% translate("Disabled"); %>';
							}
							t += ((t.length>0)&&(t.charAt(t.length-1) != ' ')) ? '<br>' : '';
							t += '<b>LAN' + lannr + '</b> (br' + i + ') - ' + nvram['lan' + j + '_ipaddr'] + '/' + numberOfBitsOnNetMask(nvram['lan' + j + '_netmask']);

						}
					}
					createFieldTable('', [
						{ title: '<% translate("Router MAC Address"); %>', text: nvram.et0macaddr },
						{ title: '<% translate("Router IP Address"); %>', text: nvram.lan_ipaddr },
//						{ title: '<% translate("Subnet Mask"); %>', text: nvram.lan_netmask },
						{ title: '<% translate("Gateway"); %>', text: nvram.lan_gateway, ignore: nvram.wan_proto != 'disabled' },
						/* IPV6-BEGIN */
						{ title: '<% translate("Router IPv6 Address"); %>', rid: 'ip6_lan', text: stats.ip6_lan, hidden: (stats.ip6_lan == '') },
						{ title: '<% translate("IPv6 Link-local Address"); %>', rid: 'ip6_lan_ll', text: stats.ip6_lan_ll, hidden: (stats.ip6_lan_ll == '') },
						/* IPV6-END */
						{ title: '<% translate("DNS"); %>', rid: 'dns', text: stats.dns, ignore: nvram.wan_proto != 'disabled' },
						{ title: '<% translate("DHCP"); %>', text: s }
						], '#sesdiv_lan', 'data-table dataonly');

				</script>
			</div>
		</div>

		<!-- Wi-Fi -->
		<div id="wi-fi-interfaces"></div>
		<script type="text/javascript">

			for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {

				var data = "";

				/* REMOVE-BEGIN
				//	u = wl_unit(uidx);
				REMOVE-END */
				u = wl_fface(uidx);
				data += '<div class="box" data-box="home_wl' + u +'"><div class="heading" id="wl'+u+'-title"><% translate("Wireless"); %>';
				if (wl_ifaces.length > 0)
					data += ' (' + wl_display_ifname(uidx) + ')';
				data += '</div>';
				data += '<div class="content" id="sesdiv_wl_'+u+'">';
				sec = auth[nvram['wl'+u+'_security_mode']] + '';
				if (sec.indexOf('WPA') != -1) sec += ' + ' + enc[nvram['wl'+u+'_crypto']];

				wmode = wmo[nvram['wl'+u+'_mode']] + '';
				if ((nvram['wl'+u+'_mode'] == 'ap') && (nvram['wl'+u+'_wds_enable'] * 1)) wmode += ' + WDS';

				data += createFieldTable('', [
					{ title: '<% translate("MAC Address"); %>', text: nvram['wl'+u+'_hwaddr'] },
					{ title: '<% translate("Wireless Mode"); %>', text: wmode },
					{ title: '<% translate("Wireless Network Mode"); %>', text: bgmo[nvram['wl'+u+'_net_mode']], ignore: (wl_sunit(uidx)>=0) },
					{ title: '<% translate("Interface Status"); %>', rid: 'ifstatus'+uidx, text: wlstats[uidx].ifstatus },
					{ title: '<% translate("Radio"); %>', rid: 'radio'+uidx, text: (wlstats[uidx].radio == 0) ? '<b><% translate("Disabled"); %></b> <span class="text-red"><i class="icon-cancel"></i></span>' : '<% translate("Enabled"); %> <span class="text-green"><i class="icon-check"></i></span>', ignore: (wl_sunit(uidx)>=0) },
					/* REMOVE-BEGIN */
					//	{ title: '<% translate("SSID"); %>', text: (nvram['wl'+u+'_ssid'] + ' <small><i>' + ((nvram['wl'+u+'_mode'] != 'ap') ? '' : ((nvram['wl'+u+'_closed'] == 0) ? '(Broadcast Enabled)' : '(Broadcast Disabled)')) + '</i></small>') },
					/* REMOVE-END */
					{ title: '<% translate("SSID"); %>', text: nvram['wl'+u+'_ssid'] },
					{ title: '<% translate("Broadcast"); %>', text: (nvram['wl'+u+'_closed'] == 0) ? '<% translate("Enabled"); %> <span class="text-green"><i class="icon-check"></i></span>' : '<b><% translate("Disabled"); %></b> <span class="text-red"><i class="icon-cancel"></i></span>', ignore: (nvram['wl'+u+'_mode'] != 'ap') },
					{ title: '<% translate("Security"); %>', text: sec },
					{ title: '<% translate("Channel"); %>', rid: 'channel'+uidx, text: stats.channel[uidx], ignore: (wl_sunit(uidx)>=0) },
					{ title: '<% translate("Channel Width"); %>', rid: 'nbw'+uidx, text: wlstats[uidx].nbw, ignore: ((!nphy) || (wl_sunit(uidx)>=0)) },
					{ title: '<% translate("Interference Level"); %>', rid: 'interference'+uidx, text: stats.interference[uidx], hidden: ((stats.interference[uidx] == '') || (wl_sunit(uidx)>=0)) },
					{ title: '<% translate("Rate"); %>', rid: 'rate'+uidx, text: wlstats[uidx].rate, ignore: (wl_sunit(uidx)>=0) },
					{ title: '<% translate("RSSI"); %>', rid: 'rssi'+uidx, text: wlstats[uidx].rssi || '', ignore: ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) },
					{ title: '<% translate("Noise"); %>', rid: 'noise'+uidx, text: wlstats[uidx].noise || '', ignore: ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) },
					{ title: '<% translate("Signal Quality"); %>', rid: 'qual'+uidx, text: stats.qual[uidx] || '', ignore: ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) }
					], null, 'data-table dataonly');

				data += '<div class="btn-control-group" style="display: none;">';
				data += '<button type="button" class="btn btn-primary" onclick="wlenable('+uidx+', 1)" id="b_wl'+uidx+'_enable" value="Enable"><% translate("Enable"); %> <i class="icon-check"></i></button>';
				data += '<button type="button" class="btn btn-danger" onclick="wlenable('+uidx+', 0)" id="b_wl'+uidx+'_disable" value="Disable"><% translate("Disable"); %> <i class="icon-disable"></i></button>';
				data += '</div></div></div>';
				
				$('#wi-fi-interfaces').append(data);
			}
		</script>
	</div>

	<div class="clearfix refresher"></div>
	<script type="text/javascript">earlyInit();</script>
</content>
