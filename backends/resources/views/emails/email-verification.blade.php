<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Verify your TeamScribe account</title>
  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:#0d1117;color:#e6edf3}
    .wrap{max-width:520px;margin:40px auto;padding:0 16px}
    .card{background:#161b22;border:1px solid #30363d;border-radius:12px;overflow:hidden}
    .header{padding:28px 32px 24px;border-bottom:1px solid #30363d;text-align:center}
    .logo{display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:14px}
    .logo-text{font-size:18px;font-weight:700;color:#e6edf3}
    .body{padding:28px 32px}
    .greeting{font-size:18px;font-weight:700;margin-bottom:10px}
    .text{font-size:14px;color:#8b949e;line-height:1.6;margin-bottom:20px}
    .otp-label{font-size:11px;font-weight:600;letter-spacing:.8px;color:#8b949e;text-transform:uppercase;margin-bottom:12px}
    .otp-row{display:flex;gap:8px;justify-content:center;margin-bottom:24px}
    .otp-box{width:52px;height:60px;background:#0d1117;border:1.5px solid #2f81f7;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:28px;font-weight:700;color:#e6edf3}
    .expiry{font-size:13px;color:#8b949e;background:#0d1117;border:1px solid #30363d;border-radius:8px;padding:12px 14px;margin-bottom:20px;line-height:1.5}
    .warning{font-size:12px;color:#8b949e;line-height:1.5}
    .footer{padding:18px 32px;border-top:1px solid #30363d;text-align:center;font-size:11px;color:#8b949e}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <div class="header">
      <div class="logo">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#e6edf3" width="28" height="28">
          <path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"/>
        </svg>
        <span class="logo-text">TeamScribe</span>
      </div>
      <div style="font-size:13px;color:#8b949e">Email verification code</div>
    </div>

    <div class="body">
      <p class="greeting">Hi {{ $userName }} 👋</p>
      <p class="text">
        Thanks for creating your TeamScribe account. Enter this 5-digit code in the app to verify your email address.
      </p>

      <div class="otp-label">Your verification code</div>
      <div class="otp-row">
        @foreach(str_split($otp) as $digit)
          <div class="otp-box">{{ $digit }}</div>
        @endforeach
      </div>

      <div class="expiry">
        ⏱ &nbsp;This code expires at <strong style="color:#e6edf3">{{ now()->addMinutes(10)->format('H:i') }}</strong> — valid for <strong style="color:#e6edf3">10 minutes</strong>.
      </div>

      <p class="warning">
        If you did not create a TeamScribe account, you can safely ignore this email.
        Never share this code with anyone.
      </p>
    </div>

    <div class="footer">
      &copy; {{ date('Y') }} TeamScribe &nbsp;·&nbsp; Email verification
    </div>
  </div>
</div>
</body>
</html>
