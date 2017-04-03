<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title><% translate("Configuration"); %></title>
<content>
	<script type="text/javascript">

		//	<% nvram("at_update,tomatoanon_answer,et0macaddr,t_features,t_model_name"); %>
		//	<% nvstat(); %>

		function backupNameChanged() {

			var name = fixFile(E('backup-name').value);

			/* Not required
			if (name.length > 1) {
			E('backup-link').href = 'cfg/' + name + '.cfg?_http_id=' + nvram.http_id;
			}
			else {
			E('backup-link').href = '?';
			}
			*/
		}

		function backupButton()
		{
			var name = fixFile(E('backup-name').value);
			if (name.length <= 1) {
				alert('<% translate("Invalid filename"); %>');
				return;
			}
			location.href = 'cfg/' + name + '.cfg?_http_id=' + nvram.http_id;
		}

		function restoreButton()
		{
			var name, i, f;

			name = fixFile(E('restore-name').value);
			name = name.toLowerCase();
			if ((name.indexOf('.cfg') != (name.length - 4)) && (name.indexOf('.cfg.gz') != (name.length - 7))) {
				alert('<% translate("Incorrect filename. Expecting a"); %> ".cfg" <% translate("file"); %>.');
				return;
			}
			if (!confirm('<% translate("Are you sure?"); %>')) return;
			E('restore-button').disabled = 1;

			f = E('restore-form');
			form.addIdAction(f);
			f.submit();
		}

		function resetButton()
		{
			var i;

			i = E('restore-mode').value;
			if (i == 0) return;
			if ((i == 2) && (features('!nve'))) {
				if (!confirm('<% translate("WARNING: Erasing the NVRAM on a"); %> ' + nvram.t_model_name + ' <% translate("router may be harmful. It may not be able to re-setup the NVRAM correctly after a complete erase. Proceeed anyway?"); %>')) return;
			}
			if (!confirm('<% translate("Are you sure?"); %>')) return;
			E('reset-button').disabled = 1;
			form.submit('aco-reset-form');
		}
	</script>

	<div class="box">
	<div class="heading"><% translate("Router Configuration"); %></div>
	<div class="content">

		<h4><% translate("Backup Configuration"); %></h4>
		<div class="section" id="backup">
			<div class="input-append">
				<button name="f_backup_button" onclick="backupButton()" value="<% translate("Backup"); %>" class="btn"><% translate("Backup"); %> <i class="icon-download"></i></button>
			</div><br /><hr>
		</div>

		<h4><% translate("Restore Configuration"); %></h4>
		<div class="section">
			<form id="restore-form" method="post" action="cfg/restore.cgi" encType="multipart/form-data">
				<input class="uploadfile" type="file" size="40" id="restore-name" name="filename">
				<button type="button" name="f_restore_button" id="restore-button" value="<% translate("Restore"); %>" onclick="restoreButton()" class="btn"><% translate("Restore"); %> <i class="icon-upload"></i></button>
			</form><hr>
		</div>

		<h4><% translate("Restore Default Configuration"); %></h4>
		<div class="section">
			<form id="aco-reset-form" method="post" action="cfg/defaults.cgi">
				<div class="input-append"><select name="mode" id="restore-mode">
						<option value=0><% translate("Select"); %>...</option>
						<option value=1><% translate("Restore default router settings (normal)"); %></option>
						<option value=2><% translate("Erase all data in NVRAM memory (thorough)"); %></option>
					</select>
					<button type="button" value="<% translate("OK"); %>" onclick="resetButton()" id="reset-button" class="btn"><% translate("OK"); %></button>
				</div>
			</form><hr>
		</div>

		<div class="section" id="nvram">
			<script type="text/javascript">
				var a = nvstat.free / nvstat.size * 100.0;
				createFieldTable('', [
					{ title: '<b><% translate("Total / Free NVRAM"); %></b>:', text: scaleSize(nvstat.size) + ' / ' + scaleSize(nvstat.free) + ' <small>(' + (a).toFixed(2) + '%)</small>' }
					], '#nvram', '');

				if (a <= 5) {
					$('#nvram').append('<div class="alert alert-warning">' +
						'<% translate("The NVRAM free space is very low. It is strongly recommended to"); %> ' +
						'<% translate("erase all data in NVRAM memory, and reconfigure the router manually"); %> ' +
						'<% translate("in order to clean up all unused and obsolete entries"); %>.' +
						'</div>');
				}

				$('#backup .input-append').prepend('<input type="text" size="40" maxlength="64" id="backup-name" onchange="backupNameChanged()" value="tomato_v' + ("<% version(); %>".replace(/\./g, "")) + '_m' + nvram.et0macaddr.replace(/:/g, "").substring(6, 12) + '">');
			</script>
		</div>
	</div>
</content>
