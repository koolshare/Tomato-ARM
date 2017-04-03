<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
	Tomato GUI
	Copyright (C) 2012 Shibby
	http://openlinksys.info
	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] <% translate("Admin"); %>: <% translate("TomatoAnon Project"); %></title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>
<script type='text/javascript'>
//	<% nvram("tomatoanon_enable,tomatoanon_answer,tomatoanon_id,tomatoanon_notify"); %>

var anon_link = '&nbsp;&nbsp;<a href="http://anon.groov.pl/index.php?search=9&routerid=<% nv('tomatoanon_id'); %>" target="_blank"><i>[<% translate("Checkout my router"); %>]</i></a>';

function verifyFields(focused, quiet)
{
	var o = (E('_tomatoanon_answer').value == '1');
	var s = (E('_tomatoanon_enable').value == '1');

	E('_tomatoanon_enable').disabled = !o;
	E('_f_tomatoanon_notify').disabled = !o || !s;

	return 1;
}

function save()
{
	if (verifyFields(null, 0)==0) return;
	var fom = E('_fom');

	fom.tomatoanon_notify.value = E('_f_tomatoanon_notify').checked ? 1 : 0;

	fom._service.value = 'tomatoanon-restart';
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
<input type='hidden' name='_nextpage' value='admin-tomatoanon.asp'>
<input type='hidden' name='_service' value='tomatoanon-restart'>
<input type='hidden' name='tomatoanon_notify'>
<div class='section-title'><% translate("About TomatoAnon Project"); %></div>
<div class="fields"><div class="about">
<b><% translate("Hello"); %>,</b><br>
<br>
<% translate("I would like to present you with a new project I've been working on, called TomatoAnon"); %>.<br>
<% translate("The TomatoAnon script will send (to a database) information about your router's model and installed version of Tomato"); %>.<br>
<% translate("The information submitted is 100% anonymous and will ONLY be used for statistical purposes"); %>.<br>
<b><% translate("This script does NOT send any private or personal information whatsoever (like MAC`s, IP`s etc)"); %>!</b><br>
<% translate("Script is fully open, and written in bash. Anyone is free to look at the content that is submitted to the database"); %>.<br>
<br>
<% translate("The submitted results can be viewed on the"); %> <a href=http://tomato.groov.pl/tomatoanon.php target=_blanc><b>http://tomato.groov.pl/tomatoanon.php</b></a> <% translate("page"); %>.<br>
<% translate("This information may help you when choosing the best and most popular router available in your country"); %>.<br>
<% translate("You can check which version of Tomato is most commonly used and which one is the most stable"); %>.<br>
<br>
<% translate("If you don't agree with this script, or do not wish to use it, you can simply disable it"); %>.<br>
<% translate("You can always re-enable it at any time"); %>.<br>
<br>
<% translate("The following data is sent by TomatoAnon"); %>:<br>
 - <% translate("MD5SUM of WAN+LAN MAC addresses"); %> - <% translate("this will identify a router. Ex"); %>: 1c1dbd4202d794251ec1acf1211bb2c8<br>
 - <% translate("Model of router. Ex"); %>: Asus RT-N66U<br>
 - <% translate("Installed version of Tomato. Ex"); %>: 102 K26 USB<br>
 - <% translate("Builtype. Ex"); %>: Mega-VPN-64K<br>
 - <% translate("Uptime of your router. Ex: 3 days"); %><br>
<% translate("That`s it"); %>!<br>
<br>
<% translate("Thank you for reading and please make the right choice to help this project"); %>.<br>
<br>
<b><% translate("Best Regards"); %>!</b></font>
</div></div>
<br>
<br>
<div class='section-title'><% translate("TomatoAnon Settings"); %> <script>W(anon_link);</script></div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '<% translate("Do you know what TomatoAnon doing"); %>?', name: 'tomatoanon_answer', type: 'select', options: [ ['0','<% translate("No, i don`t. Have to read all information, before i will make a choice"); %>'], ['1','<% translate("Yes, i do and want to make a choice"); %>'] ], value: nvram.tomatoanon_answer, suffix: ' '},
	{ title: '<% translate("Do you want enable TomatoAnon"); %>?', name: 'tomatoanon_enable', type: 'select', options: [ ['-1','<% translate("I`m not sure right now"); %>'], ['1','<% translate("Yes, i`m sure i do"); %>'], ['0','<% translate("No, i definitely wont enable it"); %>'] ], value: nvram.tomatoanon_enable, suffix: ' '}
]);
</script>
</div>

<div class='section-title'><% translate("Tomato Update Notification System"); %></div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
{ title: '<% translate("Enable"); %>', name: 'f_tomatoanon_notify', type: 'checkbox', value: nvram.tomatoanon_notify == '1' }
]);
</script>
<ul>
	<li><% translate("When new tomato version will be available, you will be notified about this on"); %> <% translate("Status"); %> - <% translate("Overview"); %>.
</ul>
</div>
</form>
<div></div>
</td></tr>
<tr><td id='footer' colspan=2>
 <form>
 <span id='footer-msg'></span>
 <input type='button' value='<% translate("Save"); %>' id='save-button' onclick='save()'>
 <input type='button' value='<% translate("Cancel"); %>' id='cancel-button' onclick='javascript:reloadPage();'>
 </form>
<div></div>
</td></tr>
</table>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
