#!/bin/bash

# ==============================================
# AWS Application Load Balancer Mini Project
# User Data Script - Server 2
# Author: Newton Nandru
# ==============================================

# Update the system
yum update -y

# Install Apache Web Server
yum install -y httpd

# Enable and Start Apache
systemctl enable httpd
systemctl start httpd

# Create the HTML page
cat <<'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AWS ALB Load Balancer Test - Server 2</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:Arial, Helvetica, sans-serif;
    background:linear-gradient(135deg,#0f172a,#1e3a8a);
    color:white;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.container{
    width:700px;
    background:white;
    color:#222;
    border-radius:15px;
    padding:40px;
    box-shadow:0 10px 30px rgba(0,0,0,.4);
}

h1{
    text-align:center;
    color:#2563eb;
    margin-bottom:30px;
}

table{
    width:100%;
    border-collapse:collapse;
}

td{
    padding:15px;
    border-bottom:1px solid #ddd;
    font-size:20px;
}

.label{
    font-weight:bold;
    width:250px;
}

.value{
    color:#16a34a;
    font-weight:bold;
}

.refresh{
    margin-top:20px;
    text-align:center;
    color:#2563eb;
    font-weight:bold;
}

.footer{
    margin-top:30px;
    text-align:center;
    color:#666;
}

</style>
</head>

<body>

<div class="container">

<h1>🚀 AWS Application Load Balancer Demo</h1>

<table>

<tr>
<td class="label">Server Name</td>
<td class="value" id="server"></td>
</tr>

<tr>
<td class="label">Application Port</td>
<td class="value" id="port"></td>
</tr>

<tr>
<td class="label">Hostname</td>
<td class="value" id="hostname"></td>
</tr>

<tr>
<td class="label">Current Date & Time</td>
<td class="value" id="time"></td>
</tr>

<tr>
<td class="label">Random Request ID</td>
<td class="value" id="request"></td>
</tr>

<tr>
<td class="label">Browser</td>
<td class="value" id="browser"></td>
</tr>

</table>

<div class="refresh">
Page refreshes automatically every 5 seconds
</div>

<div class="footer">
AWS Application Load Balancer Mini Project | Server-2
</div>

</div>

<script>

const SERVER_NAME="SERVER-2";
const APP_PORT="80";

document.getElementById("server").innerHTML=SERVER_NAME;
document.getElementById("port").innerHTML=APP_PORT;
document.getElementById("hostname").innerHTML=window.location.hostname;
document.getElementById("browser").innerHTML=navigator.userAgent;

function update(){
    let now = new Date();

    document.getElementById("time").innerHTML = now.toLocaleString();

    document.getElementById("request").innerHTML =
    Math.random().toString(36).substring(2,12);
}

update();
setInterval(update,1000);

setTimeout(function(){
    location.reload();
},5000);

</script>

</body>
</html>
EOF

# Set ownership and permissions
chown apache:apache /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Restart Apache
systemctl restart httpd
