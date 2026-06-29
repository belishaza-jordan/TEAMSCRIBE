<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <title>Group Invitation — TeamScribe</title>
  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:#f0f4f8;color:#0a1628}
    .wrap{max-width:520px;margin:40px auto;padding:0 16px}
    .card{background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,.08)}
    .header{background:#0b6b6b;padding:32px;text-align:center}
    .logo{display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:8px}
    .logo-text{font-size:20px;font-weight:800;color:#fff;letter-spacing:-0.5px}
    .header-sub{font-size:13px;color:rgba(255,255,255,.7)}
    .body{padding:32px}
    .greeting{font-size:20px;font-weight:800;color:#0a1628;margin-bottom:12px}
    .text{font-size:14px;color:#637381;line-height:1.7;margin-bottom:24px}
    .group-card{background:#eff9f9;border:1.5px solid #b2e0e0;border-radius:12px;padding:20px 24px;margin-bottom:24px}
    .group-name{font-size:18px;font-weight:800;color:#0a1628;margin-bottom:4px}
    .group-meta{font-size:13px;color:#637381;margin-top:3px}
    .actions{text-align:center;margin-bottom:24px}
    .btn{display:inline-block;text-decoration:none;padding:13px 28px;border-radius:8px;font-size:15px;font-weight:700;margin:0 6px 10px}
    .btn-accept{background:#0b6b6b;color:#ffffff}
    .btn-decline{background:#ffffff;color:#637381;border:1.5px solid #e5e7eb}
    .app-box{background:#f8fafb;border:1.5px solid #e5e7eb;border-radius:12px;padding:18px 24px;text-align:center}
    .app-box-title{font-size:14px;font-weight:700;color:#0a1628;margin-bottom:6px}
    .app-box-text{font-size:13px;color:#637381;line-height:1.6}
    .divider{height:1px;background:#f0f4f8;margin:24px 0}
    .warning{font-size:12px;color:#a0aec0;line-height:1.6;text-align:center}
    .footer{padding:20px 32px;background:#f8fafb;border-top:1px solid #e5e7eb;text-align:center;font-size:11px;color:#a0aec0}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <div class="header">
      <div class="logo">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#fff" width="24" height="24">
          <path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"/>
        </svg>
        <span class="logo-text">TeamScribe</span>
      </div>
      <div class="header-sub">Group Invitation</div>
    </div>

    <div class="body">
      <p class="greeting">You've been invited! 🎉</p>
      <p class="text">
        <strong style="color:#0a1628">{{ $invitation->inviter->name }}</strong>
        has invited you to join their group on TeamScribe.
      </p>

      <div class="group-card">
        <div class="group-name">{{ $invitation->group->name }}</div>
        @if($invitation->group->course)
          <div class="group-meta">📚 {{ $invitation->group->course }}</div>
        @endif
        <div class="group-meta" style="margin-top:6px">
          👥 {{ $invitation->group->members->count() }} member{{ $invitation->group->members->count() === 1 ? '' : 's' }}
        </div>
      </div>

      <div class="actions">
        <a class="btn btn-accept" href="{{ route('invitations.accept', $invitation->token) }}">Accept invitation</a>
        <a class="btn btn-decline" href="{{ route('invitations.reject', $invitation->token) }}">Decline</a>
      </div>

      <div class="app-box">
        <div class="app-box-title">📱 Already use TeamScribe?</div>
        <div class="app-box-text">
          You can also accept or decline from the app —<br>
          just open your <strong>Notifications</strong> tab.
        </div>
      </div>

      <div class="divider"></div>

      <p class="warning">
        This invitation was sent to <strong>{{ $invitation->email }}</strong>.<br>
        If you didn't expect this, you can safely ignore this email.
      </p>
    </div>

    <div class="footer">
      &copy; {{ date('Y') }} TeamScribe &nbsp;·&nbsp; Invited by {{ $invitation->inviter->name }}
    </div>
  </div>
</div>
</body>
</html>
