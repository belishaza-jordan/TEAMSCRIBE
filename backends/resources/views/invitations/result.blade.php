<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <title>Invitation — TeamScribe</title>
  <style>
    :root{--c-canvas:#0d1117;--c-surface:#161b22;--c-border:#30363d;--c-fg:#e6edf3;--c-fg2:#8b949e;--c-blue:#2f81f7;--c-green:#3fb950;--c-red:#f85149;--c-yellow:#d29922}
    [data-theme="light"]{--c-canvas:#fff;--c-surface:#f6f8fa;--c-border:#d0d7de;--c-fg:#1f2328;--c-fg2:#636e7b;--c-blue:#0969da;--c-green:#1a7f37;--c-red:#d1242f;--c-yellow:#9a6700}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:var(--c-canvas);color:var(--c-fg);min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px}
    .card{width:100%;max-width:400px;background:var(--c-surface);border:1px solid var(--c-border);border-radius:14px;padding:32px;text-align:center}
    .icon{width:64px;height:64px;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 20px;font-size:28px}
    .icon-green{background:rgba(63,185,80,.12)}
    .icon-red{background:rgba(248,81,73,.12)}
    .icon-yellow{background:rgba(210,153,34,.12)}
    .icon-blue{background:rgba(47,129,247,.12)}
    .title{font-size:20px;font-weight:700;margin-bottom:10px}
    .message{font-size:14px;color:var(--c-fg2);line-height:1.6;margin-bottom:24px}
    .group-name{font-size:13px;font-weight:600;color:var(--c-fg);background:var(--c-canvas);border:1px solid var(--c-border);border-radius:8px;padding:10px 16px;margin-bottom:20px}
    .logo{display:flex;align-items:center;justify-content:center;gap:8px;margin-top:24px;padding-top:20px;border-top:1px solid var(--c-border);font-size:13px;color:var(--c-fg2)}
    .theme-btn{position:fixed;top:12px;right:12px;background:none;border:1px solid var(--c-border);border-radius:6px;padding:5px 10px;cursor:pointer;color:var(--c-fg2);font-size:11px}
  </style>
</head>
<body>
<button class="theme-btn" onclick="toggleTheme()">☀/☾</button>

<div class="card">
  @if($status === 'accepted')
    <div class="icon icon-green">✅</div>
    <div class="title">Invitation Accepted!</div>
  @elseif($status === 'rejected')
    <div class="icon icon-red">✕</div>
    <div class="title">Invitation Declined</div>
  @elseif($status === 'already_member')
    <div class="icon icon-blue">👥</div>
    <div class="title">Already a Member</div>
  @elseif($status === 'no_account')
    <div class="icon icon-yellow">📱</div>
    <div class="title">Account Required</div>
  @else
    <div class="icon icon-yellow">⏱</div>
    <div class="title">Invitation Expired</div>
  @endif

  <div class="group-name">{{ $group->name }}@if($group->course) &nbsp;·&nbsp; {{ $group->course }}@endif</div>

  <p class="message">{{ $message }}</p>

  @if($status === 'accepted')
    <p style="font-size:13px;color:var(--c-fg2)">
      Open the <strong style="color:var(--c-fg)">TeamScribe app</strong> on your phone to start collaborating with your group.
    </p>
  @endif

  <div class="logo">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
      <path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"/>
    </svg>
    TeamScribe
  </div>
</div>

<script>
  const saved=localStorage.getItem('ts-theme')||'dark';
  document.documentElement.setAttribute('data-theme',saved);
  function toggleTheme(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('ts-theme',n);}
</script>
</body>
</html>
