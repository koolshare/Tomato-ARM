<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title><% translate("Triggered Forwarding"); %></title>
<content>
	<style type="text/css">
		#tg-grid .co1 {
			width: 5%;
			text-align: center;
		}
		#tg-grid .co2 {
			width: 10%;
		}
		#tg-grid .co3 {
			width: 20%;
		}
		#tg-grid .co4 {
			width: 20%;
		}
		#tg-grid .co5 {
			width: 45%;
		}
	</style>
	<script type="text/javascript">
		//	<% nvram("at_update,tomatoanon_answer,trigforward"); %>

		var tg = new TomatoGrid();

		tg.sortCompare = function(a, b) {
			var col = this.sortColumn;
			var da = a.getRowData();
			var db = b.getRowData();
			var r;

			switch (col) {
				case 2:	// t prt
				case 3:	// f prt
					r = cmpInt(da[col], db[col]);
					break;
				default:
					r = cmpText(da[col], db[col]);
					break;
			}

			return this.sortAscending ? r : -r;
		}

		tg.dataToView = function(data) {
			return [data[0] ? '<i class="icon-check icon-green"></i>' : '<i class="icon-cancel icon-red"></i>', ['TCP', 'UDP','<% translate("Both"); %>'][data[1] - 1], data[2], data[3], data[4]];
		}

		tg.fieldValuesToData = function(row) {
			var f = fields.getAll(row);
			return [f[0].checked ? 1 : 0, f[1].value, f[2].value, f[3].value, f[4].value];
		}

		tg.verifyFields = function(row, quiet) {
			var f = fields.getAll(row);
			ferror.clearAll(f);
			if (!v_portrange(f[2], quiet)) return 0;
			if (!v_portrange(f[3], quiet)) return 0;
			f[4].value = f[4].value.replace(/>/g, '_');
			if (!v_nodelim(f[4], quiet, 'Description')) return 0;
			return 1;
		}

		tg.resetNewEditor = function() {
			var f = fields.getAll(this.newEditor);
			f[0].checked = 1;
			f[1].selectedIndex = 0;
			f[2].value = '';
			f[3].value = '';
			f[4].value = '';
			ferror.clearAll(f);
		}

		tg.setup = function() {
			this.init('tg-grid', 'sort', 50, [
				{ type: 'checkbox' },
				{ type: 'select', options: [[1,'<% translate("TCP"); %>'],[2,'<% translate("UDP"); %>'],[3,'<% translate("Both"); %>']], class : 'input-small' },
				{ type: 'text', maxlen: 16 },
				{ type: 'text', maxlen: 16 },
				{ type: 'text', maxlen: 32 }]);
			this.headerSet(['<% translate("On"); %>', '<% translate("Protocol"); %>', '<% translate("Trigger Ports"); %>', '<% translate("Forwarded Ports"); %>','<% translate("Description"); %>']);
			var nv = nvram.trigforward.split('>');
			for (var i = 0; i < nv.length; ++i) {
				var r;
				if (r = nv[i].match(/^(\d)<(\d)<(.+?)<(.+?)<(.*)$/)) {
					r[1] *= 1;
					r[2] *= 1;
					r[3] = r[3].replace(/:/g, '-');
					r[4] = r[4].replace(/:/g, '-');
					tg.insertData(-1, r.slice(1, 6));
				}
			}
			tg.sort(4);
			tg.showNewEditor();
		}


		function save()
		{
			if (tg.isEditing()) return;

			var data = tg.getAllData();
			var s = '';
			for (var i = 0; i < data.length; ++i) {
				data[i][2] = data[i][2].replace(/-/g, ':');
				data[i][3] = data[i][3].replace(/-/g, ':');
				s += data[i].join('<') + '>';
			}
			var fom = E('_fom');
			fom.trigforward.value = s;
			form.submit(fom, 1);
		}

		function init()
		{
			tg.recolor();
			tg.resetNewEditor();
			var c;
			if (((c = cookie.get('forward_basic_notes_vis')) != null) && (c == '1')) toggleVisibility("notes");
		}

		function toggleVisibility(whichone) {
			if (E('sesdiv_' + whichone).style.display == '') {
				E('sesdiv_' + whichone).style.display = 'none';
				E('sesdiv_' + whichone + '_showhide').innerHTML = '<i class="icon-chevron-up"></i>';
				cookie.set('forward_triggered_' + whichone + '_vis', 0);
			} else {
				E('sesdiv_' + whichone).style.display='';
				E('sesdiv_' + whichone + '_showhide').innerHTML = '<i class="icon-chevron-down"></i>';
				cookie.set('forward_triggered_' + whichone + '_vis', 1);
			}
		}

	</script>

	<form id="_fom" method="post" action="tomato.cgi">
	<input type="hidden" name="_nextpage" value="/#forward.asp">
	<input type="hidden" name="_service" value="firewall-restart">
	<input type="hidden" name="trigforward">

	<div class="box">
		<div class="heading"><% translate("Triggered Port Forwarding"); %></div>
		<div class="content">
			<table class="line-table" id="tg-grid"></table>
		</div>
	</div>

	<!-- NOTES -->
	<div class="box">
		<div class="heading"><% translate("Notes"); %> <a class="pull-right" data-toggle="tooltip" title="<% translate("Hide/Show Notes"); %>" href="javascript:toggleVisibility('notes');"><span id="sesdiv_notes_showhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdiv_notes" style="display:none">
			<ul>
				<li><% translate("Use '-' to specify a range of ports"); %> (200-300).</li>
				<li><% translate("Trigger Ports are the initial LAN to WAN 'trigger'"); %>.</li>
				<li><% translate("Forwarded Ports are the WAN to LAN ports that are opened if the 'trigger' is activated"); %>.</li>
				<li><% translate("These ports are automatically closed after a few minutes of inactivity"); %>.</li>
			</ul>
		</div>
	</div>

	<button type="button" value="<% translate("Save"); %>" id="save-button" onclick="save()" class="btn btn-primary"><% translate("Save"); %> <i class="icon-check"></i></button>
	<button type="button" value="<% translate("Cancel"); %>" id="cancel-button" onclick="javascript:reloadPage();" class="btn"><% translate("Cancel"); %> <i class="icon-cancel"></i></button>
	<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>

	<script type="text/javascript">tg.setup(); init();</script>
</content>
