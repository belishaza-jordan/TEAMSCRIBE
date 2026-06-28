<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <title>Group Invitation — TeamScribe</title>
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
    .group-card{background:#0d1117;border:1px solid #30363d;border-radius:10px;padding:16px 20px;margin-bottom:24px}
    .group-name{font-size:17px;font-weight:700;color:#e6edf3;margin-bottom:4px}
    .group-meta{font-size:13px;color:#8b949e}
    .btn-row{display:flex;gap:12px;justify-content:center;margin-bottom:20px;flex-wrap:wrap}
    .btn{display:inline-block;padding:12px 28px;border-radius:8px;font-size:15px;font-weight:600;text-decoration:none;text-align:center}
    .btn-accept{background:#238636;color:#fff;border:1px solid rgba(0,0,0,.2)}
    .btn-reject{background:#21262d;color:#8b949e;border:1px solid #30363d}
    .expiry{font-size:12px;color:#8b949e;text-align:center;margin-bottom:20px}
    .warning{font-size:12px;color:#8b949e;line-height:1.5;text-align:center;border-top:1px solid #21262d;padding-top:16px}
    .footer{padding:16px 32px;border-top:1px solid #30363d;text-align:center;font-size:11px;color:#8b949e}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <div class="header">
      <div class="logo">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#e6edf3" width="26" height="26">
          <path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"/>
        </svg>
        <span class="logo-text">TeamScribe</span>
      </div>
      <div style="font-size:13px;color:#8b949e">Group invitation</div>
    </div>

    <div class="body">
      <p class="greeting">You've been invited! 🎉</p>
      <p class="text">
        <strong style="color:#e6edf3">{{ $invitation->inviter->name }}</strong>
        has invited you to join their group on TeamScribe.
      </p>

      <div class="group-card">
        <div class="group-name">{{ $invitation->group->name }}</div>
        @if($invitation->group->course)
          <div class="group-meta">{{ $invitation->group->course }}</div>
        @endif
        <div class="group-meta" style="margin-top:4px">
          {{ $invitation->group->members->count() }} member{{ $invitation->group->members->count() === 1 ? '' : 's' }}
        </div>
      </div>

      <div class="btn-row">
        <a href="{{ $acceptUrl }}" class="btn btn-accept">✓ Accept invitation</a>
        <a href="{{ $rejectUrl }}" class="btn btn-reject">✕ Decline</a>
      </div>

      <p class="expiry">
        ⏱ This invitation expires at <strong style="color:#e6edf3">{{ $invitation->expires_at->format('M d, Y H:i') }}</strong>
      </p>

      <p class="warning">
        If you don't have a TeamScribe account yet, accepting this invitation will
        guide you to create one. If you didn't expect this email, you can safely ignore it.
      </p>
    </div>

    <div class="footer">
      &copy; {{ date('Y') }} TeamScribe &nbsp;·&nbsp;
      Invited by {{ $invitation->inviter->name }}
    </div>
  </div>
</div>
</body>
</html>
