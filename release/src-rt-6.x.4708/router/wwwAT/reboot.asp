<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="content-type" content="text/html;charset=utf-8">
		<meta name="robots" content="noindex,nofollow">
		<title>[<% ident(); %>] <% translate("Rebooting"); %>...</title>

		<style>
			body {
				font: 14px 'Verdana', sans-serif;
				background-color: #bfbfbf;
				color: #585858;
			}
			.progress {
				position: relative;
				overflow: hidden;
				height: 4px;
				margin: 10px 0;
				background-color: #f0f0f0;
				border-radius: 2px;
				-webkit-border-radius: 2px;
				box-shadow: inset 0 -1px 0 rgba(0,0,0,0.02);
				-webkit-box-shadow: inset 0 -1px 0 rgba(0,0,0,0.02);
			}
			.progress .bar {
				float: left;
				width: 0%;
				height: 100%;
				color: #ffffff;
				text-align: center;
				background-color: #706e6e;
				-webkit-transition: width 0.6s ease;
				transition: width 0.6s ease;
				box-shadow: inset 0 -1px 0 rgba(0,0,0,.15);
				-webkit-box-shadow: inset 0 -1px 0 rgba(0,0,0,.15);
			}

			.bar .txt {
				color: #000;
				position: absolute;
				width: 100%;
				top: 0;
				left: 0;
				text-align: center;
				font-size: 13px;
				line-height: 20px;
			}

			.btn {
				font-family: Verdana;
				display: inline-block;
				text-align: center;
				cursor: pointer;
				background-image: none;
				padding: 5px 16px;
				margin: 0;
				font-size: 13px;
				font-weight: bold;
				line-height: 1.42857143;
				color: #555 !important;
				background: #f0f0f0;
				transition: 0.1s ease-out;
				border-radius: 4px;
				-webkit-border-radius: 4px;
				border: 1px solid #706e6e;
			}

			.btn:hover {
				color: #fff !important;
				background: #555;
				border: 1px solid #555;
			}

			.btn:active, .btn:focus {
				transition: none;
				border-width: 1px;
			}

		</style>
		<script type="text/javascript">
			var Max = 80 + parseInt('0<% nv("wait_time"); %>');
			var n = 0;
			function tick()
			{

				var e = document.getElementById('prog');
				var d = document.getElementById('progTXT');
				var c = document.getElementById('continue');

				e.style.width = (((n++) / Max) * 100) + '%';
				d.innerHTML = (Max - n) + ' <% translate("s."); %>';

				if (n == Max) {
					d.innerHTML = '';
					e.style.width = '100%';
					go();
					return;
				}

				if (n == (Max-15)) c.style.display = 'block';
				setTimeout(tick, 1000);
			}
			function go()
			{
				window.location.replace('/');
			}
			function init()
			{
				resmsg = '';
				//<% resmsg(); %>
				if (resmsg.length) {
					e = document.getElementById('msg');
					e.innerHTML = resmsg;
					e.style.display = '';
				}
				tick()
			}

		</script>
	</head>

	<body>
		<div style="width:100%; max-width: 600px; margin: 10% auto; text-align: center;">
			<div style='width:90%; margin:5px auto;padding:5px 5%;'>
				<span id="msg"></span><br />
				<span id="re"><div class="spinner"></div>
				<% translate("Rebooting, please wait"); %> <span class="txt" id="progTXT"></span>
				</span><br />
				<div id="progbar" class="progress">
					<div class="bar success" id="prog">
						&nbsp;
					</div>
				</div>
				<div id="continue" style="display: none;">
					<button class="btn" type="button" name="go" onclick="go()"><% translate("Continue"); %></button>
				</div>
				<script type="text/javascript">init();</script>
			</div>
		</div>
	</body>
</html>
