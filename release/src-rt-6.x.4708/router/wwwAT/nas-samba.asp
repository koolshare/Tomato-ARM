<!--
Tomato GUI
Samba Server - !!TB

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title><% translate("File Sharing"); %></title>
<content>
	<script type="text/javascript">
		//	<% nvram("at_update,tomatoanon_answer,smbd_enable,smbd_user,smbd_passwd,smbd_wgroup,smbd_cpage,smbd_custom,smbd_master,smbd_wins,smbd_shares,smbd_autoshare,wan_wins"); %>

		var ssg = new TomatoGrid();

		ssg.exist = function(f, v)
		{
			var data = this.getAllData();
			for (var i = 0; i < data.length; ++i) {
				if (data[i][f] == v) return true;
			}
			return false;
		}

		ssg.existName = function(name)
		{
			return this.exist(0, name);
		}

		ssg.sortCompare = function(a, b) {
			var col = this.sortColumn;
			var da = a.getRowData();
			var db = b.getRowData();
			var r = cmpText(da[col], db[col]);
			return this.sortAscending ? r : -r;
		}

		ssg.dataToView = function(data) {
			return [data[0], data[1], data[2], ['<% translate("Read Only"); %>','<% translate("Read / Write"); %>'][data[3]], ['<% translate("No"); %>','<% translate("Yes"); %>'][data[4]]];
		}

		ssg.fieldValuesToData = function(row) {
			var f = fields.getAll(row);
			return [f[0].value, f[1].value, f[2].value, f[3].value, f[4].value];
		}

		ssg.verifyFields = function(row, quiet)
		{
			var f, s;

			f = fields.getAll(row);

			s = f[0].value.trim().replace(/\s+/g, ' ');
			if (s.length > 0) {
				if (s.search(/^[ a-zA-Z0-9_\-\$]+$/) == -1) {
					ferror.set(f[0], '<% translate("Invalid share name. Only characters"); %> "$ A-Z 0-9 - _" <% translate("and spaces are allowed"); %>.', quiet);
					return 0;
				}
				if (this.existName(s)) {
					ferror.set(f[0], '<% translate("Duplicate share name"); %>.', quiet);
					return 0;
				}
				f[0].value = s;
			}
			else {
				ferror.set(f[0], '<% translate("Empty share name is not allowed"); %>.', quiet);
				return 0;
			}

			if (!v_nodelim(f[1], quiet, '<% translate("Directory"); %>', 1) || !v_path(f[1], quiet, 1)) return 0;
			if (!v_nodelim(f[2], quiet, '<% translate("Description"); %>', 1)) return 0;

			return 1;
		}

		ssg.resetNewEditor = function()
		{
			var f;

			f = fields.getAll(this.newEditor);
			ferror.clearAll(f);

			f[0].value = '';
			f[1].value = '';
			f[2].value = '';
			f[3].selectedIndex = 0;
			f[4].selectedIndex = 0;
		}

		ssg.setup = function()
		{
			this.init('ss-grid', 'sort', 50, [
				{ type: 'text', maxlen: 32 },
				{ type: 'text', maxlen: 256 },
				{ type: 'text', maxlen: 64 },
				{ type: 'select', options: [[0,'<% translate("Read Only"); %>'],[1,'<% translate("Read / Write"); %>']] },
				{ type: 'select', options: [[0,'<% translate("No"); %>'],[1,'<% translate("Yes"); %>']] }
			]);
			this.headerSet(['<% translate("Share Name"); %>', '<% translate("Directory"); %>', '<% translate("Description"); %>', '<% translate("Access Level"); %>','<% translate("Hidden"); %>']);

			var s = nvram.smbd_shares.split('>');
			for (var i = 0; i < s.length; ++i) {
				var t = s[i].split('<');
				if (t.length == 5) {
					this.insertData(-1, t);
				}
			}

			this.sort(0);
			this.showNewEditor();
			this.resetNewEditor();
		}

		function verifyFields(focused, quiet)
		{
			var a, b;

			a = E('_smbd_enable').value;

			elem.display(PR('_smbd_user'), PR('_smbd_passwd'), (a == 2));

			E('_smbd_wgroup').disabled = (a == 0);
			E('_smbd_cpage').disabled = (a == 0);
			E('_smbd_custom').disabled = (a == 0);
			E('_smbd_autoshare').disabled = (a == 0);
			E('_f_smbd_master').disabled = (a == 0);
			E('_f_smbd_wins').disabled = (a == 0 || (nvram.wan_wins != '' && nvram.wan_wins != '0.0.0.0'));

			if (a != 0 && !v_length('_smbd_custom', quiet, 0, 2048)) return 0;

			if (a == 2) {
				if (!v_length('_smbd_user', quiet, 1)) return 0;
				if (!v_length('_smbd_passwd', quiet, 1)) return 0;

				b = E('_smbd_user');
				if (b.value == 'root') {
					ferror.set(b, '<% translate("User Name"); %> \"root\" <% translate("is not allowed"); %>.', quiet);
					return 0;
				}
				ferror.clear(b);
			}

			return 1;
		}

		function save()
		{
			if (ssg.isEditing()) return;
			if (!verifyFields(null, 0)) return;

			var fom = E('_fom');

			var data = ssg.getAllData();
			var r = [];
			for (var i = 0; i < data.length; ++i) r.push(data[i].join('<'));
			fom.smbd_shares.value = r.join('>');
			fom.smbd_master.value = E('_f_smbd_master').checked ? 1 : 0;
			if (nvram.wan_wins == '' || nvram.wan_wins == '0.0.0.0')
				fom.smbd_wins.value = E('_f_smbd_wins').checked ? 1 : 0;
			else
				fom.smbd_wins.value = nvram.smbd_wins;

			form.submit(fom, 1);
		}
	</script>

	<form id="_fom" method="post" action="tomato.cgi">
		<input type="hidden" name="_nextpage" value="/#nas-samba.asp">
		<input type="hidden" name="_service" value="samba-restart">

		<input type="hidden" name="smbd_master">
		<input type="hidden" name="smbd_wins">
		<input type="hidden" name="smbd_shares">

		<div class="box">
			<div class="heading"><% translate("Samba File Sharing"); %></div>
			<div class="content fileshare"></div>
			<script type="text/javascript">
				$('.content.fileshare').forms([
					{ title: '<% translate("Enable File Sharing"); %>', name: 'smbd_enable', type: 'select',
						options: [['0','<% translate("No"); %>'],['1','<% translate("Yes, no Authentication"); %>'],['2','<% translate("Yes, Authentication required"); %>']],
						value: nvram.smbd_enable },
					{ title: '<% translate("User Name"); %>', indent: 2, name: 'smbd_user', type: 'text', maxlen: 50, size: 32,
						value: nvram.smbd_user },
					{ title: '<% translate("Password"); %>', indent: 2, name: 'smbd_passwd', type: 'password', maxlen: 50, size: 32, peekaboo: 1,
						value: nvram.smbd_passwd },
					{ title: '<% translate("Workgroup Name"); %>', name: 'smbd_wgroup', type: 'text', maxlen: 20, size: 32,
						value: nvram.smbd_wgroup },
					{ title: '<% translate("Client Codepage"); %>', name: 'smbd_cpage', type: 'select',
						options: [['','<% translate("Unspecified"); %>'],['437', '437 (United States, Canada)'],['850', '850 (Western Europe)'],['852', '852 (Central / Eastern Europe)'],['866', '866 (Cyrillic / Russian)']
							/* LINUX26-BEGIN */
							,['932', '932 (Japanese)'],['936', '936 (Simplified Chinese)'],['949', '949 (Korean)'],['950', '950 (Traditional Chinese / Big5)']
							/* LINUX26-END */
						],
						suffix: ' <small> (<% translate("start cmd.exe and type chcp to see the current code page"); %>)</small>',
						value: nvram.smbd_cpage },
					{ title: 'Samba <% translate("Custom Configuration"); %>', name: 'smbd_custom', type: 'textarea', value: nvram.smbd_custom, style: 'width: 100%; height: 80px;' },
					{ title: '<% translate("Auto-share all USB Partitions"); %>', name: 'smbd_autoshare', type: 'select',
						options: [['0','<% translate("Disabled"); %>'],['1','<% translate("Read Only"); %>'],['2','<% translate("Read / Write"); %>'],['3','<% translate("Hidden Read / Write"); %>']],
						value: nvram.smbd_autoshare },
					{ title: '<% translate("Options"); %>', multi: [
						{ suffix: '&nbsp; <% translate("Master Browser"); %> &nbsp;&nbsp;&nbsp;', name: 'f_smbd_master', type: 'checkbox', value: nvram.smbd_master == 1 },
						{ suffix: '&nbsp; <% translate("WINS Server"); %> (<% translate("if not defined on Basic/Network page"); %>) &nbsp;',	name: 'f_smbd_wins', type: 'checkbox', value: (nvram.smbd_wins == 1) && (nvram.wan_wins == '' || nvram.wan_wins == '0.0.0.0') }
					] }
				]);
			</script>
		</div>

		<div class="box">
			<div class="heading"><% translate("Additional Shares List"); %></div>
			<div class="content">
				<table class="line-table" id="ss-grid"></table><br />
				<small><% translate("When no shares are specified and auto-sharing is disabled"); %>, <i>/mnt</i> <% translate("directory is shared in Read Only mode"); %>.</small>
			</div>
		</div>

		<button type="button" value="<% translate("Save"); %>" id="save-button" onclick="save()" class="btn btn-primary"><% translate("Save"); %> <i class="icon-check"></i></button>
		<button type="button" value="<% translate("Cancel"); %>" id="cancel-button" onclick="javascript:reloadPage();" class="btn"><% translate("Cancel"); %> <i class="icon-cancel"></i></button>
		<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>

	</form>

	<script type="text/javascript">ssg.setup(); verifyFields(null, 1);</script>
</content>
