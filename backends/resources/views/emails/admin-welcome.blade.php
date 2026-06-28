<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Welcome to TeamScribe Admin</title>
  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:#0d1117;color:#e6edf3}
    .wrap{max-width:520px;margin:40px auto;padding:0 16px}
    .card{background:#161b22;border:1px solid #30363d;border-radius:12px;overflow:hidden}
    .header{padding:28px 32px 24px;border-bottom:1px solid #30363d;text-align:center}
    .logo{display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:16px}
    .logo-text{font-size:18px;font-weight:700;color:#e6edf3}
    .body{padding:28px 32px}
    .greeting{font-size:18px;font-weight:700;margin-bottom:10px}
    .text{font-size:14px;color:#8b949e;line-height:1.6;margin-bottom:16px}
    .info-box{background:#0d1117;border:1px solid #30363d;border-radius:8px;padding:14px 16px;margin-bottom:24px;font-size:13px}
    .info-row{display:flex;gap:8px;padding:5px 0;border-bottom:1px solid #21262d}
    .info-row:last-child{border-bottom:none}
    .info-label{color:#8b949e;width:80px;flex-shrink:0}
    .info-value{color:#e6edf3;font-weight:500}
    .btn-wrap{text-align:center;margin:24px 0}
    .btn{display:inline-block;background:#238636;color:#fff;text-decoration:none;padding:12px 28px;border-radius:6px;font-size:15px;font-weight:600;border:1px solid rgba(0,0,0,.2)}
    .warning{background:rgba(210,153,34,.1);border:1px solid rgba(210,153,34,.3);border-radius:8px;padding:12px 14px;font-size:12px;color:#d29922;margin-top:20px;line-height:1.5}
    .url-box{background:#0d1117;border:1px solid #30363d;border-radius:6px;padding:10px 14px;font-size:11px;color:#8b949e;word-break:break-all;margin-top:8px;font-family:monospace}
    .footer{padding:18px 32px;border-top:1px solid #30363d;text-align:center;font-size:11px;color:#8b949e}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">

    <div class="header">
      <div class="logo">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="28" height="28"><path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"/></svg>
        <span class="logo-text">TeamScribe</span>
      </div>
      <div style="font-size:13px;color:#8b949e">You've been added as an admin</div>
    </div>

    <div class="body">
      <div class="greeting">Hi {{ $user->name }} 👋</div>
      <p class="text">
        <strong style="color:#e6edf3">{{ $invitedBy }}</strong> has added you as an
        <span style="color:#2f81f7;font-weight:600">Admin</span> on the TeamScribe platform.
        You can now manage students, groups, and platform settings.
      </p>

      <div class="info-box">
        <div class="info-row">
          <span class="info-label">Email</span>
          <span class="info-value">{{ $user->email }}</span>
        </div>
        <div class="info-row">
          <span class="info-label">Role</span>
          <span class="info-value" style="color:#2f81f7">Administrator</span>
        </div>
        <div class="info-row">
          <span class="info-label">Platform</span>
          <span class="info-value">TeamScribe Admin Dashboard</span>
        </div>
      </div>

      <p class="text">
        Click the button below to set your password and access your admin account.
        This link expires in <strong style="color:#e6edf3">60 minutes</strong>.
      </p>

      <div class="btn-wrap">
        <a href="{{ $resetUrl }}" class="btn">Set my password →</a>
      </div>

      <div class="warning">
        ⚠ If you did not expect this invitation, you can safely ignore this email.
        Your account will remain inactive until you set a password.
      </div>

      <div class="url-box">{{ $resetUrl }}</div>
    </div>

    <div class="footer">
      &copy; {{ date('Y') }} TeamScribe &nbsp;·&nbsp;
      This email was sent because an admin created an account for you.
    </div>

  </div>
</div>
</body>
</html>
