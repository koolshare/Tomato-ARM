<html><head><title><% translate("Firmware Upgrade"); %></title></head>
<body>
<h1><% translate("Firmware Upgrade"); %></h1>
<b><% translate("WARNING"); %>:</b>
<ul>
<li><% translate("There is no upload status information in this page and there will be no change in the display after the Upgrade button is pushed. You will be shown a new page only after the upgrade completes"); %>.
<li><% translate("It may take up to 3 minutes for the upgrade to complete. Do not interrupt the router or the browser during this time"); %>.
</ul>

<br>
<form name="firmware_upgrade" method="post" action="upgrade.cgi?<% nv(http_id) %>" encType="multipart/form-data">
<input type="hidden" name="submit_button" value="<% translate("Upgrade"); %>">
Firmware: <input type="file" name="file"> <input type="submit" value="<% translate("Upgrade"); %>">
</form>
</body></html>
