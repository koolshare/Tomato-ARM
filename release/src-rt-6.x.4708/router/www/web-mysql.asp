<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
	Tomato MySQL GUI
	Copyright (C) 2014 Hyzoom, bwq518@gmail.com
	http://openlinksys.info
	For use with Tomato Shibby Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] <% translate("MySQL Database Server"); %></title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>
<style type='text/css'>
textarea {
 width: 98%;
 height: 15em;
}
</style>
<script type='text/javascript'>
//	<% nvram("mysql_enable,mysql_sleep,mysql_check,mysql_check_time,mysql_binary,mysql_binary_custom,mysql_usb_enable,mysql_dlroot,mysql_datadir,mysql_tmpdir,mysql_server_custom,mysql_port,mysql_allow_anyhost,mysql_init_rootpass,mysql_username,mysql_passwd,mysql_key_buffer,mysql_max_allowed_packet,mysql_thread_stack,mysql_thread_cache_size,mysql_init_priv,mysql_table_open_cache,mysql_sort_buffer_size,mysql_read_buffer_size,mysql_query_cache_size,mysql_read_rnd_buffer_size,mysql_max_connections,nginx_port"); %>

var ams_link = '&nbsp;&nbsp;<a href="http://' + location.hostname + ':' + nvram.nginx_port + '/adminer.php" target="_blank"><i>[<% translate("Click here to manage MySQL"); %>]</i></a>';
//	<% usbdevices(); %>
var usb_disk_list = new Array();
function refresh_usb_disk()
{
	var i, j, k, a, b, c, e, s, desc, d, parts, p;
	var partcount;
	list = [];
	for (i = 0; i < list.length; ++i) {
		list[i].type = '';
		list[i].host = '';
		list[i].vendor = '';
		list[i].product = '';
		list[i].serial = '';
		list[i].discs = [];
		list[i].is_mounted = 0;
	}
	for (i = usbdev.length - 1; i >= 0; --i) {
		a = usbdev[i];
		e = {
			type: a[0],
			host: a[1],
			vendor: a[2],
			product: a[3],
			serial: a[4],
			discs: a[5],
			is_mounted: a[6]
		};
		list.push(e);
	}
	partcount = 0;
	for (i = list.length - 1; i >= 0; --i) {
		e = list[i];
		if (e.discs) {
			for (j = 0; j <= e.discs.length - 1; ++j) {
				d = e.discs[j];
				parts = d[1];
				for (k = 0; k <= parts.length - 1; ++k) {
					p = parts[k];					
					if ((p) && (p[1] >= 1) && (p[3] != 'swap')) {
						usb_disk_list[partcount] = new Array();
						usb_disk_list[partcount][0] = p[2];
						usb_disk_list[partcount][1] = '<% translate("Partition"); %> ' + p[0] + ' <% translate("mounted on"); %> '+p[2]+' (' + p[3]+ ' - ' + doScaleSize(p[6])+ ' <% translate("available, total"); %> ' + doScaleSize(p[5]) + ')';
						partcount++;
					}
				}
			}
		}
	}
	list = [];
}


function verifyFields(focused, quiet)
{
	var ok = 1;

	var a = E('_f_mysql_enable').checked;
	var o = E('_f_mysql_check').checked;
	var u = E('_f_mysql_usb_enable').checked;
	var i = E('_f_mysql_init_priv').checked;
	var r = E('_f_mysql_init_rootpass').checked;
	var h = E('_f_mysql_allow_anyhost').checked;
	
	E('_f_mysql_check').disabled = !a;
	E('_mysql_check_time').disabled = !a || !o;
	E('_mysql_sleep').disabled = !a;
	E('_mysql_binary').disabled = !a;
	E('_f_mysql_init_priv').disabled = !a;
	E('_f_mysql_init_rootpass').disabled = !a;
	E('_mysql_username').disabled = true;
	E('_mysql_passwd').disabled = !a || !r;
	E('_mysql_server_custom').disabled = !a;
	E('_f_mysql_usb_enable').disabled = !a;
	E('_mysql_dlroot').disabled = !a || !u;
	E('_mysql_datadir').disabled = !a;
	E('_mysql_tmpdir').disabled = !a;
	E('_mysql_port').disabled = !a;
	E('_f_mysql_allow_anyhost').disabled = !a;
	E('_mysql_key_buffer').disabled = !a;
	E('_mysql_max_allowed_packet').disabled = !a;
	E('_mysql_thread_stack').disabled = !a;
	E('_mysql_thread_cache_size').disabled = !a;
	E('_mysql_table_open_cache').disabled = !a;
	E('_mysql_sort_buffer_size').disabled = !a;
	E('_mysql_read_buffer_size').disabled = !a;
	E('_mysql_query_cache_size').disabled = !a;
	E('_mysql_read_rnd_buffer_size').disabled = !a;
	E('_mysql_max_connections').disabled = !a;
	
	var p = (E('_mysql_binary').value == 'custom');
	elem.display('_mysql_binary_custom', p && a);

	elem.display('_mysql_dlroot', u && a);

	var x;
	if ( r && a ) x = '';
	else x = 'none';
        PR(E('_mysql_username')).style.display = x;
        PR(E('_mysql_passwd')).style.display = x;

	var e;
	e = E('_mysql_passwd');
        s = e.value.trim();
        if ( s == '' ) {
                ferror.set(e, '<% translate("Password can not be NULL value"); %>.', quiet);
		ok = 0;
        }

	return ok;
}

function save()
{
  if (verifyFields(null, 0)==0) return;
  var fom = E('_fom');
  
  fom.mysql_enable.value               = E('_f_mysql_enable').checked ? 1 : 0;
  fom.mysql_check.value                = E('_f_mysql_check').checked ? 1 : 0;
  fom.mysql_usb_enable.value           = E('_f_mysql_usb_enable').checked ? 1 : 0;
  fom.mysql_init_priv.value            = E('_f_mysql_init_priv').checked ? 1 : 0;
  fom.mysql_init_rootpass.value        = E('_f_mysql_init_rootpass').checked ? 1 : 0;
  fom.mysql_allow_anyhost.value        = E('_f_mysql_allow_anyhost').checked ? 1 : 0;
	
  if (fom.mysql_enable.value == 0) {
  	fom._service.value = 'mysql-stop';
  }
  else {
  	fom._service.value = 'mysql-restart'; 
  }
  form.submit('_fom', 1);
}

function init()
{
}
</script>
</head>

<body onLoad="init()">
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
<div class='title'>Tomato</div>
<div class='version'><% translate("Version"); %> <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>
<form id='_fom' method='post' action='tomato.cgi'>
<input type='hidden' name='_nextpage' value='mysql.asp'>
<input type='hidden' name='_service' value='mysql-restart'>
<input type='hidden' name='mysql_enable'>
<input type='hidden' name='mysql_check'>
<input type='hidden' name='mysql_usb_enable'>
<input type='hidden' name='mysql_init_priv'>
<input type='hidden' name='mysql_init_rootpass'>
<input type='hidden' name='mysql_allow_anyhost'>

<div class='section-title'><% translate("Basic Settings"); %><script>W(ams_link);</script></div>
<div class='section' id='config-section'>
<script type='text/javascript'>
	
refresh_usb_disk();

createFieldTable('', [
	{ title: '<% translate("Enable MySQL server"); %>', name: 'f_mysql_enable', type: 'checkbox', value: nvram.mysql_enable == 1, suffix: ' <small>*</small>' },
	{ title: '<% translate("MySQL binary path"); %>', multi: [
		{ name: 'mysql_binary', type: 'select', options: [
			['internal','<% translate("Internal"); %> (/usr/bin)'],
			['optware','<% translate("Optware"); %> (/opt/bin)'],
			['custom','<% translate("Custom"); %>'] ], value: nvram.mysql_binary, suffix: ' <small>*</small> ' },
		{ name: 'mysql_binary_custom', type: 'text', maxlen: 40, size: 40, value: nvram.mysql_binary_custom , suffix: ' <small><% translate("Not include"); %> "/mysqld"</small>' }
	] },
	{ title: '<% translate("Keep alive"); %>', name: 'f_mysql_check', type: 'checkbox', value: nvram.mysql_check == 1, suffix: ' <small>*</small>' },
	{ title: '<% translate("Check alive every"); %>', indent: 2, name: 'mysql_check_time', type: 'text', maxlen: 5, size: 7, value: nvram.mysql_check_time, suffix: ' <small><% translate("minutes"); %> (<% translate("range"); %>: 1 - 55; <% translate("default"); %>: 1)</small>' },
	{ title: '<% translate("Delay at startup"); %>', name: 'mysql_sleep', type: 'text', maxlen: 5, size: 7, value: nvram.mysql_sleep, suffix: ' <small><% translate("seconds"); %> (<% translate("range"); %>: 1 - 60; <% translate("default"); %>: 2)</small>' },
	{ title: '<% translate("MySQL listen port"); %>', name: 'mysql_port', type: 'text', maxlen: 5, size: 7, value: nvram.mysql_port, suffix: ' <small> <% translate("default"); %>: 3306</small>' },
	{ title: '<% translate("Allow Anyhost to access"); %>', name: 'f_mysql_allow_anyhost', type: 'checkbox', value: nvram.mysql_allow_anyhost == 1, suffix: ' <small><% translate("Allowed any hosts to access database server"); %>.</small>' },
	{ title: '<% translate("Re-init priv. table"); %>', name: 'f_mysql_init_priv', type: 'checkbox', value: nvram.mysql_init_priv== 1, suffix: ' <small><% translate("If checked, privileges table will be forced to re-initialize by mysql_install_db"); %>.</small>' },
	{ title: '<% translate("Re-init root password"); %>', name: 'f_mysql_init_rootpass', type: 'checkbox', value: nvram.mysql_init_rootpass == 1, suffix: ' <small><% translate("If checked, root password will be forced to re-initialize"); %>.</small>' },
	{ title: '<% translate("root user name"); %>', name: 'mysql_username', type: 'text', maxlen: 32, size: 16, value: nvram.mysql_username, suffix: ' <small><% translate("user name connected to server"); %> (<% translate("default"); %>: root)</small>' },
	{ title: '<% translate("root password"); %>', name: 'mysql_passwd', type: 'password', maxlen: 32, size: 16, peekaboo: 1, value: nvram.mysql_passwd, suffix: ' <small><% translate("not allowed NULL"); %> (<% translate("default"); %>: admin)</small>' },
	{ title: '<% translate("Enable USB Partition"); %>', multi: [
		{ name: 'f_mysql_usb_enable', type: 'checkbox', value: nvram.mysql_usb_enable == 1, suffix: '  ' },
		{ name: 'mysql_dlroot', type: 'select', options: usb_disk_list, value: nvram.mysql_dlroot, suffix: ' '} ] },
	{ title: '<% translate("Data dir."); %>', indent: 2, name: 'mysql_datadir', type: 'text', maxlen: 50, size: 40, value: nvram.mysql_datadir, suffix: ' <small><% translate("Directory name under mounted partition"); %>.</small>' },
	{ title: '<% translate("Tmp dir."); %>', indent: 2, name: 'mysql_tmpdir', type: 'text', maxlen: 50, size: 40, value: nvram.mysql_tmpdir, suffix: ' <small><% translate("Directory name under mounted partition"); %>.</small>' }
]);
</script>
	<ul>
		<li><b><% translate("Enable MySQL server"); %></b> - <% translate("Caution!"); %> - <% translate("If your router has only 32MB of RAM, you'll have to use swap"); %>.
		<li><b><% translate("MySQL binary path"); %></b> - <% translate("Path to the directory containing mysqld etc. Not include program name"); %> "/mysqld"
		<li><b><% translate("Keep alive"); %></b> - <% translate("If enabled, mysqld will be checked at the specified interval and will re-launch after a crash"); %>.
		<li><b><% translate("Data and tmp dir."); %></b> - <% translate("Attention! Must not use NAND for datadir and tmpdir"); %>.
	</ul>
</div>
</div>

<div class='section-title'><% translate("Advanced Settings"); %></div>
<div class='section' id='config-section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '<% translate("Key buffer"); %>', name: 'mysql_key_buffer', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_key_buffer, suffix: ' <small>MB (<% translate("range"); %>: 1 - 1024; <% translate("default"); %>: 8)</small>' },
	{ title: '<% translate("Max allowed packet"); %>', name: 'mysql_max_allowed_packet', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_max_allowed_packet, suffix: ' <small>MB (<% translate("range"); %>: 1 - 1024; <% translate("default"); %>: 4)</small>' },
	{ title: '<% translate("Thread stack"); %>', name: 'mysql_thread_stack', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_thread_stack, suffix: ' <small>KB (<% translate("range"); %>: 1 - 1024000; <% translate("default"); %>: 192)</small>' },
	{ title: '<% translate("Thread cache size"); %>', name: 'mysql_thread_cache_size', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_thread_cache_size, suffix: ' <small>(<% translate("range"); %>: 1 - 999999; <% translate("default"); %>: 8)</small>' },
	{ title: '<% translate("Table open cache"); %>', name: 'mysql_table_open_cache', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_table_open_cache, suffix: ' <small>(<% translate("range"); %>: 1 - 999999; <% translate("default"); %>: 4)</small>' },
	{ title: '<% translate("Query cache size"); %>', name: 'mysql_query_cache_size', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_query_cache_size, suffix: ' <small>MB (<% translate("range"); %>: 0 - 1024; <% translate("default"); %>: 16)</small>' },
	{ title: '<% translate("Sort buffer size"); %>', name: 'mysql_sort_buffer_size', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_sort_buffer_size, suffix: ' <small>KB (<% translate("range"); %>: 0 - 1024000; <% translate("default"); %>: 128)</small>' },
	{ title: '<% translate("Read buffer size"); %>', name: 'mysql_read_buffer_size', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_read_buffer_size, suffix: ' <small>KB (<% translate("range"); %>: 0 - 1024000; <% translate("default"); %>: 128)</small>' },
	{ title: '<% translate("Read rand buffer size"); %>', name: 'mysql_read_rnd_buffer_size', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_read_rnd_buffer_size, suffix: ' <small>KB (<% translate("range"); %>: 1 - 1024000; <% translate("default"); %>: 256)</small>' },
	{ title: '<% translate("Max connections"); %>', name: 'mysql_max_connections', type: 'text', maxlen: 10, size: 10, value: nvram.mysql_max_connections, suffix: ' <small>(<% translate("range"); %>: 0 - 999999; <% translate("default"); %>: 1000)</small>' },
	{ title: '<% translate("MySQL server custom config."); %>', name: 'mysql_server_custom', type: 'textarea', value: nvram.mysql_server_custom }
]);
</script>
	<ul>
		<li><b><% translate("MySQL Server custom config."); %></b> - <% translate("input like:  param=value   e.g.  connect_timeout=10"); %>
	</ul>
</div>
</div>
</form>
</div>
</td></tr>
<tr><td id='footer' colspan=2>
 <form>
 <span id='footer-msg'></span>
 <input type='button' value='<% translate("Save"); %>' id='save-button' onclick='save()'>
 <input type='button' value='<% translate("Cancel"); %>' id='cancel-button' onclick='javascript:reloadPage();'>
 </form>
</div>
</td></tr>
</table>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
