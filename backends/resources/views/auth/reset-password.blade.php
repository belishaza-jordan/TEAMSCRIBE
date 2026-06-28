<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Set New Password — TeamScribe</title>
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
    .card h1{font-size:17px;font-weight:600;margin-bottom:16px;text-align:center}
    .field{margin-bottom:14px}
    .field label{display:block;font-size:13px;font-weight:600;margin-bottom:6px;color:var(--c-fg)}
    .field input{width:100%;background:var(--c-canvas);border:1px solid var(--c-border);border-radius:6px;padding:7px 12px;color:var(--c-fg);font-size:14px;outline:none}
    .field input:focus{border-color:var(--c-blue);box-shadow:0 0 0 3px rgba(47,129,247,.12)}
    .field input::placeholder{color:var(--c-fg2)}
    .field-error{color:var(--c-red);font-size:11px;margin-top:4px}
    .btn-submit{width:100%;background:var(--c-green);border:1px solid rgba(0,0,0,.2);border-radius:6px;padding:8px 16px;color:#fff;font-size:14px;font-weight:600;cursor:pointer;margin-top:4px}
    .btn-submit:hover{background:#2ea043}
    .error{background:rgba(248,81,73,.1);border:1px solid rgba(248,81,73,.4);border-radius:6px;padding:8px 12px;font-size:13px;color:var(--c-red);margin-bottom:12px}
    .hint{font-size:11px;color:var(--c-fg2);margin-top:4px}
    .theme-btn{position:fixed;top:12px;right:12px;background:none;border:1px solid var(--c-border);border-radius:6px;padding:6px 10px;cursor:pointer;color:var(--c-fg2);font-size:12px}
    .link-card{width:100%;max-width:340px;background:var(--c-surface);border:1px solid var(--c-border);border-radius:10px;padding:14px;text-align:center;font-size:13px;color:var(--c-fg2)}

    .pw-wrap{position:relative}
    .pw-wrap input{padding-right:40px!important}
    .pw-eye{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--c-fg2);font-size:16px;line-height:1;padding:2px}
    .pw-eye:hover{color:var(--c-fg)}
  </style>
</head>
<body>
<button class="theme-btn" onclick="toggleTheme()">☀/☾</button>

<div class="logo">
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="40" height="40">
    <path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"></path>
</svg>
  <div class="logo-text">TeamScribe</div>
  <div class="logo-sub">Set your new password</div>
</div>

<div class="card">
  <h1>New password</h1>

  @if($errors->any())
    <div class="error">{{ $errors->first() }}</div>
  @endif

  <form method="POST" action="{{ route('password.store') }}">
    @csrf
    <input type="hidden" name="token" value="{{ $request->route('token') }}" />

    <div class="field">
      <label for="email">Email address</label>
      <input id="email" name="email" type="email"
        value="{{ old('email', $request->email) }}"
        required autofocus autocomplete="username" placeholder="you@example.com" />
      @error('email')<div class="field-error">{{ $message }}</div>@enderror
    </div>

    <div class="field">
      <label for="password">New password</label>
      <div class="pw-wrap" style="position:relative"><input id="password" name="password" type="password"
        required autocomplete="new-password" placeholder="Minimum 8 characters" /><button type="button" class="pw-eye" onclick="togglePw(this)"><svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0Z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8Zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"/></svg></button></div>
      <div class="hint">At least 8 characters.</div>
      @error('password')<div class="field-error">{{ $message }}</div>@enderror
    </div>

    <div class="field">
      <label for="password_confirmation">Confirm new password</label>
      <div class="pw-wrap" style="position:relative"><input id="password_confirmation" name="password_confirmation" type="password"
        required autocomplete="new-password" placeholder="Re-enter your password" /><button type="button" class="pw-eye" onclick="togglePw(this)"><svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0Z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8Zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"/></svg></button></div>
      @error('password_confirmation')<div class="field-error">{{ $message }}</div>@enderror
    </div>

    <button type="submit" class="btn-submit">Set new password</button>
  </form>
</div>

<div class="link-card">
  <a href="{{ route('login') }}">← Back to sign in</a>
</div>

<script>
  const saved = localStorage.getItem('ts-theme') || 'dark';
  document.documentElement.setAttribute('data-theme', saved);
  function toggleTheme(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('ts-theme',n);}

function togglePw(btn){
  const inp=btn.previousElementSibling;
  const show=inp.type==='password';
  inp.type=show?'text':'password';
  btn.innerHTML=show?'<svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7.028 7.028 0 0 0-2.79.588l.77.771A5.944 5.944 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13.134 13.134 0 0 1 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755-.165.165-.337.328-.517.486l.708.709Z"/><path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829l.822.822Zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829Z"/><path d="M3.35 5.47c-.18.16-.353.322-.518.487A13.134 13.134 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7.029 7.029 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.709Z"/><path d="M13.646 14.354l-12-12 .708-.708 12 12-.708.708Z"/></svg>':'<svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0Z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8Zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"/></svg>';
}

</script>
</body>
</html>
