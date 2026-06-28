<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Forgot Password — TeamScribe</title>
  <style>
    :root{--c-canvas:#0d1117;--c-surface:#161b22;--c-border:#30363d;--c-fg:#e6edf3;--c-fg2:#8b949e;--c-blue:#2f81f7;--c-green:#3fb950;--c-red:#f85149}
    [data-theme="light"]{--c-canvas:#fff;--c-surface:#f6f8fa;--c-border:#d0d7de;--c-fg:#1f2328;--c-fg2:#636e7b;--c-blue:#0969da;--c-green:#1a7f37;--c-red:#d1242f}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:var(--c-canvas);color:var(--c-fg);min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;font-size:14px}
    a{color:var(--c-blue);text-decoration:none}a:hover{text-decoration:underline}
    .logo{display:flex;flex-direction:column;align-items:center;gap:12px;margin-bottom:16px}
    .logo svg{color:var(--c-fg)}
    .logo-text{font-size:22px;font-weight:700;color:var(--c-fg)}
    .logo-sub{font-size:13px;color:var(--c-fg2)}
    .card{width:100%;max-width:340px;background:var(--c-surface);border:1px solid var(--c-border);border-radius:10px;padding:24px;margin-bottom:16px}
    .card h1{font-size:17px;font-weight:600;margin-bottom:8px;text-align:center}
    .card p{font-size:13px;color:var(--c-fg2);text-align:center;line-height:1.5;margin-bottom:20px}
    .field{margin-bottom:14px}
    .field label{display:block;font-size:13px;font-weight:600;margin-bottom:6px}
    .field input{width:100%;background:var(--c-canvas);border:1px solid var(--c-border);border-radius:6px;padding:7px 12px;color:var(--c-fg);font-size:14px;outline:none}
    .field input:focus{border-color:var(--c-blue);box-shadow:0 0 0 3px rgba(47,129,247,.12)}
    .field input::placeholder{color:var(--c-fg2)}
    .btn-submit{width:100%;background:var(--c-green);border:1px solid rgba(0,0,0,.2);border-radius:6px;padding:8px 16px;color:#fff;font-size:14px;font-weight:600;cursor:pointer;margin-top:4px}
    .btn-submit:hover{background:#2ea043}
    .success{background:rgba(63,185,80,.1);border:1px solid rgba(63,185,80,.3);border-radius:6px;padding:10px 12px;font-size:13px;color:var(--c-green);margin-bottom:14px;text-align:center}
    .error{background:rgba(248,81,73,.1);border:1px solid rgba(248,81,73,.4);border-radius:6px;padding:8px 12px;font-size:13px;color:var(--c-red);margin-bottom:12px}
    .link-card{width:100%;max-width:340px;background:var(--c-surface);border:1px solid var(--c-border);border-radius:10px;padding:14px;text-align:center;font-size:13px;color:var(--c-fg2)}
    .theme-btn{position:fixed;top:12px;right:12px;background:none;border:1px solid var(--c-border);border-radius:6px;padding:6px 10px;cursor:pointer;color:var(--c-fg2);font-size:12px}
  </style>
</head>
<body>
<button class="theme-btn" onclick="toggleTheme()">☀/☾</button>

<div class="logo">
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="40" height="40">
    <path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"></path>
</svg>
  <div class="logo-text">TeamScribe</div>
  <div class="logo-sub">Reset your password</div>
</div>

<div class="card">
  <h1>Forgot password?</h1>
  <p>Enter your email and we'll send you a link to set a new password.</p>

  @if(session('status'))
    <div class="success">✓ {{ session('status') }}</div>
  @endif

  @if($errors->any())
    <div class="error">{{ $errors->first() }}</div>
  @endif

  <form method="POST" action="{{ route('password.email') }}">
    @csrf
    <div class="field">
      <label for="email">Email address</label>
      <input id="email" name="email" type="email" value="{{ old('email') }}"
        required autofocus placeholder="you@example.com" />
    </div>
    <button type="submit" class="btn-submit">Send reset link</button>
  </form>
</div>

<div class="link-card">
  Remembered it? <a href="{{ route('login') }}">Back to sign in</a>
</div>

<script>
  const saved = localStorage.getItem('ts-theme') || 'dark';
  document.documentElement.setAttribute('data-theme', saved);
  function toggleTheme(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('ts-theme',n);}
</script>
</body>
</html>
