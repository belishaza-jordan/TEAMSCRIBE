<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>TeamScribe — Password Reset</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background-color: #0D1117; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; color: #E6EDF3; }
    .wrapper { max-width: 520px; margin: 40px auto; padding: 0 16px; }
    .card { background-color: #161B22; border: 1px solid #30363D; border-radius: 16px; overflow: hidden; }
    .header { background-color: #161B22; padding: 32px 40px 24px; border-bottom: 1px solid #30363D; }
    .logo { display: flex; align-items: center; gap: 10px; }
    .logo-icon { width: 36px; height: 36px; background: #1F6FEB22; border: 1px solid #30363D; border-radius: 9px; display: flex; align-items: center; justify-content: center; }
    .logo-text { font-size: 18px; font-weight: 700; color: #E6EDF3; letter-spacing: -0.3px; }
    .body { padding: 32px 40px; }
    .greeting { font-size: 20px; font-weight: 700; color: #E6EDF3; margin-bottom: 12px; }
    .message { font-size: 14px; color: #8B949E; line-height: 1.6; margin-bottom: 32px; }
    .otp-label { font-size: 11px; font-weight: 600; letter-spacing: 0.8px; color: #8B949E; text-transform: uppercase; margin-bottom: 12px; }
    .otp-container { display: flex; gap: 8px; margin-bottom: 32px; }
    .otp-box { width: 52px; height: 60px; background: #0D1117; border: 1.5px solid #2F81F7; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 26px; font-weight: 700; color: #E6EDF3; letter-spacing: 0; }
    .expiry { font-size: 13px; color: #8B949E; line-height: 1.6; padding: 16px; background: #0D111788; border: 1px solid #30363D; border-radius: 8px; margin-bottom: 28px; }
    .expiry strong { color: #E6EDF3; }
    .divider { height: 1px; background: #30363D; margin-bottom: 24px; }
    .footer-text { font-size: 12px; color: #8B949E; line-height: 1.6; }
    .footer-text a { color: #2F81F7; text-decoration: none; }
    .footer { padding: 20px 40px; border-top: 1px solid #30363D; text-align: center; font-size: 11px; color: #8B949E; }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="card">

      {{-- Header --}}
      <div class="header">
        <div class="logo">
          <div class="logo-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2F81F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4 12.5-12.5z"/>
            </svg>
          </div>
          <span class="logo-text">TeamScribe</span>
        </div>
      </div>

      {{-- Body --}}
      <div class="body">
        <p class="greeting">Hi {{ $userName }},</p>
        <p class="message">
          We received a request to reset your TeamScribe password. Use the 5-digit code below. It expires in <strong>10 minutes</strong>.
        </p>

        <p class="otp-label">Your verification code</p>
        <div class="otp-container">
          @foreach (str_split($otp) as $digit)
            <div class="otp-box">{{ $digit }}</div>
          @endforeach
        </div>

        <div class="expiry">
          ⏱ &nbsp;This code expires at <strong>{{ now()->addMinutes(10)->format('H:i') }} ({{ now()->timezone }})</strong>.<br>
          If you did not request a password reset, you can safely ignore this email.
        </div>

        <div class="divider"></div>

        <p class="footer-text">
          For security, never share this code with anyone.<br>
          TeamScribe will <strong>never</strong> ask you for this code by phone or chat.
        </p>
      </div>

      {{-- Footer --}}
      <div class="footer">
        &copy; {{ date('Y') }} TeamScribe &nbsp;·&nbsp; You're receiving this because you requested a password reset.
      </div>

    </div>
  </div>
</body>
</html>
