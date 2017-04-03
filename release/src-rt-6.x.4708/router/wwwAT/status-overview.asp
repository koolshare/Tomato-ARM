<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta http-equiv="content-type" content="text/html;charset=utf-8">
		<meta name="robots" content="noindex,nofollow">
		<title>[<% ident(); %>] <% translate("Home"); %></title>
		<link href="css/reset.css" rel="stylesheet">
		<link href="css/style.css" rel="stylesheet">
		<link rel="shortcut icon" href="/favicon.ico" />
		<% css(); %>

		<script type="text/javascript" src="js/jquery.min.js"></script>
		<script type="text/javascript" src="tomato.asp"></script>
		<script type="text/javascript" src="advancedtomato.asp"></script>

		<script type="text/javascript">
			// used in pages title, space for gap
			var routerName = '[<% ident(); %>] ';
			//<% nvram("web_nav,at_update,at_navi,tomatoanon_answer"); %>
			//<% anonupdate(); %>

			// Fix for system data display
			var refTimer, wl_ifaces = {}, ajaxLoadingState = false, gui_version = "<% version(0); %>", lastjiffiestotal = 0, lastjiffiesidle = 0, lastjiffiesusage = 100;
			$(document).ready(function() {
				// Attempt match
				match_regex = gui_version.match(/^1\.28\.0*(\d*).?(\w*).(\w*).(\w*).(.*)/);
				// Check matches
				if ( match_regex == null || match_regex[1] == null ) {
					gui_version = '<% translate("More Info"); %>'
				} else {
					gui_version = 'v' + match_regex[1] + ' ' + match_regex[2] + ' ' + match_regex[3];
				}

				// Write version & initiate GUI functions & binds
				$('#gui-version').html('<i class="icon-info-alt"></i> <span class="nav-collapse-hide">' + gui_version + '</span>');

				AdvancedTomato();
			});
		</script>
	</head>
	<body>
		<div id="wrapper">

			<div class="top-header">

				<a href="/">
					<div class="logo">
/* ATOMATO-BEGIN */
<!-- AT LOGO -->						<svg version="1.1" id="logo" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
							width="26px" height="26px" viewBox="0 0 32 32" enable-background="new 0 0 32 32" xml:space="preserve">
							<path fill-rule="evenodd" clip-rule="evenodd" fill="#fff" d="M19.4,10.5C19.4,10.5,19.4,10.5,19.4,10.5c0-0.1,0-0.1,0-0.2
								C19.4,10.2,19.4,10.5,19.4,10.5z M25.2,5.3c-0.4,0.5-1,0.9-1.7,1.4c1.2,0.9,1.8,2,3.2,1.7c0,0-0.3,1.9-2.5,2.7
								c-1.7,0.6-3.3,0.4-4.7-0.6c0,1.5-0.5,4.4-0.4,5.8c-0.1,0-4.9-1.4-5.3-5.7c-1.7,1.1-3.4,1.6-6.1,0.8c-1.3-0.4-2.5-2.1-2.4-2.7
								C7.4,8.8,7.3,8.4,9.4,6c0,0,0.2-0.2,0.2-0.3C9.3,5.6,9,5.4,8.7,5.2c-0.3,0-0.6,0-0.9,0C2.4,5.2,0,10.4,0,16s1.9,16,16,16
								c14.1,0,16-10.5,16-16C32,10.8,29.3,6,25.2,5.3z M14.1,5.4c-0.7,0.7-2,0.2-2.5,0.6C9.5,8.1,9.2,9.4,7.5,9.4c0,0.4,2,0.9,2.6,0.9
								c2.4,0,4.9-2.4,4.9-3.8c0,0,0.1,1.4,0.1,2.8c0,3.2,2.5,4.6,2.6,4.6c0-1,0.3-2.8,0.3-3.7c0-2.9-1-2.7-1-3.8c0.7,0,2.8,3.5,5.4,3.5
								c1.6,0,2.3-0.8,2.3-0.8C23,9.1,21.3,6,19.9,6c2,0,4.4-1.4,4.4-2.6c-0.1,0-0.4,0.3-2.5,0.3c-4.2,0-4,0.9-4.6,0.9
								c0-2.5,1.1-3.9,1.6-4.2c0.6-0.3,0.2-0.5-0.4-0.4c-1.4,0.3-3.3,3.7-3.3,4.7c-0.2-1.4-2.9-2.1-4-2.1c-1.6,0-2.1-0.7-2.6-1.2
								C8.6,1.6,7.9,5,14.1,5.4z"/>
						</svg>
/* ATOMATO-END */
/* XIAOMI-BEGIN */
<!-- XIAOMI LOGO (CSS color) 32px (orange #EC7E23)  -->
<svg version="1.1" id="logo" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 viewBox="0 0 32 32" enable-background="new 0 0 32 32" xml:space="preserve">
<path id="mi" d="M24.5,7.8h3.9v16.4h-3.9V7.8z M10.5,14.1h4v9.9h-4V14.1z M3.6,7.8
	l3.9,0h9.8c2.5,0,4.2,2.2,4.2,4.6c0,3.7,0,11.7,0,11.7l-3.8,0l-0.1-10.5c0-1.5-1-2.4-2.4-2.4c-1.8,0-6.5,0-7.7,0v12.9H3.6V7.8z"/>
</svg>
/* XIAOMI-END */
/* HUAWEI-BEGIN */
<!-- HUAWEI LOGO (CSS color) 32px -->
<svg version="1.1" id="logo" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="32px" height="32px" viewBox="0 0 32 32" style="enable-background:new 0 0 32 32;" xml:space="preserve">
<g id="huawei" transform="matrix(1.25,0,0,-1.25,0,1772.5)">
	<g id="outlines">
		<defs>
			<path id="clip_path" d="M10.7,1398.7c0,0-2.9-2.2-4.1-2.5c-1.4-0.3-2.7,0.8-3.5,2.2L10.7,1398.7z M14.6,1414.2
				c0,0-2.2-2.9-1.1-13.7c0,0,3.9,5.6,4.7,8.8c0,0,0.4,1.4,0,2.3c0,0-0.5,1.8-2.4,2.3C15.7,1414,15.1,1414.1,14.6,1414.2z
				 M23,1407.1c0.1,2.1-1.9,4-1.9,4s-3.9-4.8-6.8-11c0,0,5.4,2.6,7.5,4.6C21.8,1404.7,23,1405.6,23,1407.1z M24.5,1404.9
				c0,0-6.6-3.5-9.7-5.7c0,0,5.8,0,5.9,0c0,0,0.6,0,1.3,0.3c0,0,1.6,0.5,2.4,2.3C24.4,1401.8,25.1,1403.3,24.5,1404.9z M19,1396.2
				c-1.2,0.4-4.1,2.5-4.1,2.5l7.6-0.3C20.9,1395.6,19,1396.2,19,1396.2z M9.9,1414c-1.9-0.5-2.4-2.3-2.4-2.3c-0.4-1.1,0-2.3,0-2.3
				c0.7-3.2,4.7-8.8,4.7-8.8c1.1,10.8-1.1,13.7-1.1,13.7C10.7,1414.2,9.9,1414,9.9,1414z M3.8,1404.7c2.1-2,7.5-4.6,7.5-4.6
				c-2.8,6.3-6.8,11-6.8,11s-2.1-2-1.9-4C2.6,1405.6,3.8,1404.7,3.8,1404.7z M1.3,1401.7c0.8-1.7,2.3-2.2,2.3-2.2
				c0.7-0.3,1.4-0.3,1.4-0.3c0.1,0,5.8,0,5.8,0c-3.1,2.2-9.7,5.7-9.7,5.7C0.5,1403.2,1.3,1401.7,1.3,1401.7"/>
		</defs>
		<use xlink:href="#clip_path"  style="overflow:visible;"/>
		<clipPath id="mask">
			<use xlink:href="#clip_path"  style="overflow:visible;"/>
		</clipPath>
	</g>
</g>
</svg>
/* HUAWEI-END */
						<h1 class="nav-collapse-hide">Advanced<span>Tomato</span></h1>
						<h2 class="currentpage nav-collapse-hide"></h2>
					</div>
				</a>

				<div class="left-container">
					<a data-toggle="tooltip" title="<% translate("Toggle Collapsed Navigation"); %>" href="#" class="toggle-nav"><i class="icon-align-left"></i></a>
				</div>

				<div class="pull-right links">
					<ul>
						<li><a title="<% translate("Tools"); %>" href="#tools-ping.asp"><% translate("Tools"); %> <i class="icon-tools"></i></a></li>
						<li><a title="<% translate("Bandwidth"); %>" href="#bwm-realtime.asp"><% translate("Bandwidth"); %> <i class="icon-graphs"></i></a></li>
						<li><a title="<% translate("IP Traffic"); %>" href="#bwm-ipt-realtime.asp"><% translate("IP Traffic"); %> <i class="icon-globe"></i></a></li>
						<li><a title="<% translate("System"); %>" id="system-ui" href="#system"><% translate("System"); %> <i class="icon-system"></i></a></li>
					</ul>
					<div class="system-ui">

						<div class="datasystem align center"></div>

						<div class="router-control">
							<a href="#" class="btn btn-primary" onclick="reboot();"><% translate("Reboot"); %> <i class="icon-reboot"></i></a>
							<a href="#" class="btn btn-danger" onclick="shutdown();"><% translate("Shutdown"); %> <i class="icon-power"></i></a>
							<a href="#" onclick="logout();" class="btn" style="margin-left:1px"><% translate("Logout"); %> <i class="icon-logout"></i></a>
						</div>
					</div>
				</div>
			</div>

			<div class="navigation">
				<ul>
					<li class="nav-footer" id="gui-version" style="cursor: pointer;" onclick="loadPage('#about.asp');"></li>
				</ul>
			</div>


			<div class="container">
				<div class="ajaxwrap"></div>
				<div class="clearfix"></div>
			</div>

		</div>
	</body>
</html>
