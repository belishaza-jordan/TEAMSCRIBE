<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <meta name="description" content="TeamScribe — The smart group project app for university students."/>
  <title>TeamScribe — Group Projects Made Simple</title>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    html{scroll-behavior:smooth}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:#fff;color:#0A1628;line-height:1.6}
    a{color:inherit;text-decoration:none}

    /* ── Tokens ─────────────────────────────────────────── */
    :root{
      --teal:#0B6B6B;--teal-light:#EEF7F7;--teal-dark:#094F4F;
      --navy:#0A1628;--grey:#637381;--border:#E5E7EB;
      --white:#ffffff;--bg2:#F8FAFB;
    }

    /* ── Nav ────────────────────────────────────────────── */
    nav{position:sticky;top:0;z-index:100;background:rgba(255,255,255,.95);backdrop-filter:blur(10px);border-bottom:1px solid var(--border);padding:0 5%;height:64px;display:flex;align-items:center;justify-content:space-between}
    .brand{display:flex;align-items:center;gap:10px;font-size:20px;font-weight:800;color:var(--navy)}
    .brand-dot{width:32px;height:32px;background:var(--teal);border-radius:8px;display:flex;align-items:center;justify-content:center}
    .nav-links{display:flex;align-items:center;gap:4px}
    .nav-a{padding:8px 16px;border-radius:8px;font-size:14px;color:var(--grey);font-weight:500;transition:color .15s,background .15s}
    .nav-a:hover{color:var(--navy);background:var(--bg2)}
    .nav-btns{display:flex;gap:10px;align-items:center}
    .btn-ghost{padding:8px 18px;border-radius:8px;font-size:14px;font-weight:600;color:var(--navy);border:1.5px solid var(--border);transition:border-color .15s}
    .btn-ghost:hover{border-color:var(--teal);color:var(--teal)}
    .btn-fill{padding:9px 22px;border-radius:8px;font-size:14px;font-weight:700;background:var(--teal);color:#fff;transition:background .15s}
    .btn-fill:hover{background:var(--teal-dark)}
    .hamburger{display:none;background:none;border:none;cursor:pointer;font-size:22px;color:var(--navy)}
    .mob-menu{display:none;position:fixed;top:64px;left:0;right:0;background:#fff;border-bottom:1px solid var(--border);padding:16px 5%;flex-direction:column;gap:6px;z-index:99}
    .mob-menu.open{display:flex}

    /* ── Hero ───────────────────────────────────────────── */
    .hero{padding:80px 5% 60px;display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center;max-width:1200px;margin:0 auto}
    .hero-badge{display:inline-flex;align-items:center;gap:6px;background:var(--teal-light);color:var(--teal);font-size:12px;font-weight:700;letter-spacing:.8px;text-transform:uppercase;padding:5px 12px;border-radius:20px;margin-bottom:20px}
    .hero h1{font-size:clamp(36px,5vw,60px);font-weight:900;line-height:1.05;letter-spacing:-2px;color:var(--navy);margin-bottom:20px}
    .hero h1 em{font-style:normal;color:var(--teal)}
    .hero-sub{font-size:17px;color:var(--grey);line-height:1.7;margin-bottom:36px;max-width:460px}
    .email-row{display:flex;gap:0;background:#fff;border:1.5px solid var(--border);border-radius:10px;overflow:hidden;max-width:460px;box-shadow:0 2px 12px rgba(0,0,0,.06)}
    .email-row input{flex:1;border:none;outline:none;padding:13px 18px;font-size:15px;color:var(--navy);background:transparent}
    .email-row input::placeholder{color:#A0AEC0}
    .email-row button{background:var(--teal);color:#fff;border:none;padding:0 24px;font-size:14px;font-weight:700;cursor:pointer;white-space:nowrap;transition:background .15s}
    .email-row button:hover{background:var(--teal-dark)}
    .trust{margin-top:32px}
    .trust-label{font-size:12px;color:#A0AEC0;text-transform:uppercase;letter-spacing:.6px;margin-bottom:14px;font-weight:600}
    .trust-logos{display:flex;align-items:center;gap:24px;flex-wrap:wrap}
    .trust-logo{font-size:15px;font-weight:700;color:#C0C8D2;letter-spacing:-0.5px}

    /* ── Hero mockup ────────────────────────────────────── */
    .hero-visual{position:relative;display:flex;justify-content:center;align-items:flex-start}
    .app-window{background:var(--navy);border-radius:20px;padding:20px;width:100%;max-width:420px;box-shadow:0 40px 100px rgba(11,107,107,.2),0 10px 30px rgba(0,0,0,.15)}
    .win-bar{display:flex;align-items:center;gap:6px;margin-bottom:16px}
    .win-dot{width:10px;height:10px;border-radius:50%}
    .win-title{font-size:12px;color:#637381;margin-left:4px;font-weight:600}
    .win-card{background:#162236;border-radius:12px;padding:14px;margin-bottom:10px}
    .win-card-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px}
    .win-card-title{font-size:13px;font-weight:700;color:#E2E8F0}
    .win-tag{font-size:10px;padding:2px 8px;border-radius:20px;font-weight:700}
    .t-green{background:rgba(63,185,80,.15);color:#3fb950}
    .t-yellow{background:rgba(210,153,34,.15);color:#d29922}
    .t-grey{background:rgba(99,115,129,.15);color:#637381}
    .t-blue{background:rgba(47,129,247,.15);color:#2f81f7}
    .win-member{font-size:11px;color:#637381;margin-bottom:8px}
    .win-bar-wrap{height:5px;background:#1c2f45;border-radius:3px;overflow:hidden}
    .win-bar-fill{height:100%;border-radius:3px;transition:width .3s}
    .win-progress-label{display:flex;justify-content:space-between;font-size:10px;color:#637381;margin-top:5px}
    .win-chat{background:#162236;border-radius:12px;padding:12px}
    .win-chat-msg{display:flex;align-items:flex-start;gap:8px;margin-bottom:8px}
    .win-avatar{width:24px;height:24px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:9px;font-weight:800;color:#fff;flex-shrink:0}
    .win-bubble{background:#1c2f45;border-radius:8px;border-top-left-radius:2px;padding:7px 10px;font-size:11px;color:#94a3b8;line-height:1.4}
    .win-bubble.me{background:var(--teal);color:#fff;border-radius:8px;border-top-right-radius:2px}
    .floating-card{position:absolute;background:#fff;border-radius:12px;padding:12px 16px;box-shadow:0 8px 32px rgba(0,0,0,.12);border:1px solid var(--border)}
    .float-1{top:-20px;right:-20px;min-width:160px}
    .float-2{bottom:30px;left:-24px;min-width:140px}
    .float-stat{font-size:22px;font-weight:900;color:var(--navy);line-height:1}
    .float-label{font-size:11px;color:var(--grey);margin-top:3px}
    .float-icon{font-size:20px;margin-bottom:4px}

    /* ── Partner strip ──────────────────────────────────── */
    .strip{background:var(--bg2);border-top:1px solid var(--border);border-bottom:1px solid var(--border);padding:24px 5%;text-align:center}
    .strip-label{font-size:12px;color:#A0AEC0;text-transform:uppercase;letter-spacing:.8px;font-weight:700;margin-bottom:16px}
    .strip-logos{display:flex;align-items:center;justify-content:center;gap:40px;flex-wrap:wrap}
    .strip-logo{font-size:18px;font-weight:800;color:#C0C8D2;letter-spacing:-0.5px}

    /* ── Section base ───────────────────────────────────── */
    .section{padding:80px 5%;max-width:1200px;margin:0 auto}
    .sec-label{font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--teal);margin-bottom:12px}
    .sec-title{font-size:clamp(28px,4vw,42px);font-weight:900;letter-spacing:-1.5px;color:var(--navy);line-height:1.1;margin-bottom:14px}
    .sec-sub{font-size:16px;color:var(--grey);max-width:500px;line-height:1.7}

    /* ── Why section (bento) ────────────────────────────── */
    .why-wrap{padding:80px 5%;background:var(--bg2)}
    .bento{display:grid;grid-template-columns:1.4fr 1fr;grid-template-rows:auto auto;gap:16px;margin-top:48px;max-width:1200px;margin-left:auto;margin-right:auto}
    .bento-card{background:#fff;border:1px solid var(--border);border-radius:16px;padding:28px;transition:box-shadow .2s}
    .bento-card:hover{box-shadow:0 8px 32px rgba(11,107,107,.1)}
    .bento-icon{width:48px;height:48px;border-radius:12px;background:var(--teal-light);display:flex;align-items:center;justify-content:center;margin-bottom:18px;font-size:22px}
    .bento-title{font-size:18px;font-weight:800;color:var(--navy);margin-bottom:8px}
    .bento-desc{font-size:14px;color:var(--grey);line-height:1.7}
    .bento-big{background:var(--navy);color:#fff;grid-row:1/3}
    .bento-big .bento-title{color:#fff;font-size:22px}
    .bento-big .bento-desc{color:#94a3b8}
    .bento-stat{font-size:56px;font-weight:900;color:var(--teal);line-height:1;margin:20px 0 6px}
    .bento-stat-label{font-size:14px;color:#94a3b8}
    .mini-bar{height:6px;background:#1c2f45;border-radius:3px;overflow:hidden;margin-top:8px}
    .mini-fill{height:100%;border-radius:3px;background:var(--teal)}

    /* ── Stats ──────────────────────────────────────────── */
    .stats-wrap{padding:60px 5%;text-align:center;border-top:1px solid var(--border);border-bottom:1px solid var(--border)}
    .stats-inner{max-width:900px;margin:0 auto}
    .stats-tag{font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--teal);margin-bottom:16px}
    .stats-headline{font-size:clamp(24px,3.5vw,36px);font-weight:900;color:var(--navy);letter-spacing:-1px;margin-bottom:40px}
    .stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:0}
    .stat-box{padding:20px;border-right:1px solid var(--border)}
    .stat-box:last-child{border-right:none}
    .stat-num{font-size:clamp(36px,5vw,56px);font-weight:900;color:var(--teal);line-height:1;letter-spacing:-2px}
    .stat-desc{font-size:14px;color:var(--grey);margin-top:8px}

    /* ── How it works (dark) ────────────────────────────── */
    .how-wrap{background:var(--navy);padding:80px 5%}
    .how-inner{max-width:1200px;margin:0 auto}
    .how-wrap .sec-label{color:#4DD9AC}
    .how-wrap .sec-title{color:#fff}
    .how-wrap .sec-sub{color:#94a3b8}
    .steps-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-top:48px}
    .step-card{background:#162236;border:1px solid #1E3A55;border-radius:16px;padding:28px;position:relative;overflow:hidden;transition:border-color .2s}
    .step-card:hover{border-color:var(--teal)}
    .step-card::before{content:attr(data-n);position:absolute;bottom:-16px;right:16px;font-size:80px;font-weight:900;color:rgba(255,255,255,.04);line-height:1;pointer-events:none}
    .step-num{width:36px;height:36px;border-radius:8px;background:var(--teal);color:#fff;font-size:16px;font-weight:900;display:flex;align-items:center;justify-content:center;margin-bottom:20px}
    .step-title{font-size:18px;font-weight:800;color:#E2E8F0;margin-bottom:10px}
    .step-desc{font-size:14px;color:#637381;line-height:1.7}

    /* ── Features grid ──────────────────────────────────── */
    .feat-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-top:48px}
    .feat-card{border:1.5px solid var(--border);border-radius:14px;padding:24px;transition:border-color .2s,transform .2s}
    .feat-card:hover{border-color:var(--teal);transform:translateY(-2px)}
    .feat-icon-wrap{width:44px;height:44px;border-radius:10px;background:var(--teal-light);display:flex;align-items:center;justify-content:center;font-size:20px;margin-bottom:16px}
    .feat-title{font-size:15px;font-weight:800;color:var(--navy);margin-bottom:6px}
    .feat-desc{font-size:13px;color:var(--grey);line-height:1.65}

    /* ── CTA Banner ─────────────────────────────────────── */
    .cta-wrap{padding:0 5%;margin:80px auto;max-width:1200px}
    .cta-banner{background:var(--teal);border-radius:20px;padding:56px 60px;display:grid;grid-template-columns:1fr auto;gap:40px;align-items:center}
    .cta-small{font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:rgba(255,255,255,.6);margin-bottom:14px}
    .cta-title{font-size:clamp(24px,3.5vw,38px);font-weight:900;color:#fff;letter-spacing:-1.5px;line-height:1.1;margin-bottom:10px}
    .cta-sub{font-size:15px;color:rgba(255,255,255,.7);line-height:1.6}
    .cta-btns{display:flex;gap:12px;flex-wrap:wrap;align-items:center}
    .cta-btn-white{background:#fff;color:var(--teal);padding:13px 28px;border-radius:10px;font-size:15px;font-weight:700;white-space:nowrap;transition:opacity .15s}
    .cta-btn-white:hover{opacity:.9}
    .cta-btn-outline{background:rgba(255,255,255,.1);color:#fff;border:1.5px solid rgba(255,255,255,.3);padding:13px 28px;border-radius:10px;font-size:15px;font-weight:700;white-space:nowrap;display:inline-flex;align-items:center;gap:6px;transition:background .15s}
    .cta-btn-outline:hover{background:rgba(255,255,255,.2)}

    /* ── Footer ─────────────────────────────────────────── */
    footer{background:var(--navy);padding:60px 5% 30px}
    .footer-inner{max-width:1200px;margin:0 auto}
    .footer-top{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:40px;margin-bottom:48px}
    .footer-brand{font-size:20px;font-weight:900;color:#fff;display:flex;align-items:center;gap:10px;margin-bottom:14px}
    .footer-desc{font-size:13px;color:#637381;line-height:1.7;max-width:260px}
    .footer-col h5{font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#637381;margin-bottom:16px}
    .footer-link{display:block;font-size:14px;color:#94a3b8;margin-bottom:10px;transition:color .12s}
    .footer-link:hover{color:#fff}
    .footer-bottom{padding-top:28px;border-top:1px solid #1E3A55;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px}
    .footer-copy{font-size:13px;color:#637381}
    .footer-socials{display:flex;gap:10px}
    .soc{width:34px;height:34px;border-radius:8px;background:#162236;display:flex;align-items:center;justify-content:center;color:#637381;font-size:14px;font-weight:700;transition:background .12s,color .12s}
    .soc:hover{background:var(--teal);color:#fff}

    /* ── Responsive ─────────────────────────────────────── */
    @media(max-width:960px){
      .hero{grid-template-columns:1fr;gap:40px}
      .hero-visual{display:none}
      .bento{grid-template-columns:1fr}
      .bento-big{grid-row:auto}
      .steps-grid{grid-template-columns:1fr}
      .feat-grid{grid-template-columns:repeat(2,1fr)}
      .cta-banner{grid-template-columns:1fr;padding:36px}
      .footer-top{grid-template-columns:1fr 1fr}
      .stats-grid{grid-template-columns:1fr}
      .stat-box{border-right:none;border-bottom:1px solid var(--border);padding:24px}
      .stat-box:last-child{border-bottom:none}
    }
    @media(max-width:600px){
      nav .nav-links,.nav-btns .btn-ghost{display:none}
      .hamburger{display:block}
      .feat-grid{grid-template-columns:1fr}
      .footer-top{grid-template-columns:1fr}
      .hero{padding:60px 5% 40px}
      .strip-logos{gap:20px}
    }
  </style>
</head>
<body>

{{-- ── Navbar ──────────────────────────────────────────────────────────── --}}
<nav>
  <a href="/" class="brand">
    <div class="brand-dot">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#fff" width="18" height="18">
        <path d="M19 3C17.346 3 16 4.346 16 6c0 .462.114.894.301 1.285L12.586 11H7.816C7.402 9.839 6.302 9 5 9c-1.654 0-3 1.346-3 3s1.346 3 3 3c1.302 0 2.402-.839 2.816-2H12.586l3.715 3.715C16.114 17.106 16 17.538 16 18c0 1.654 1.346 3 3 3s3-1.346 3-3-1.346-3-3-3c-.462 0-.894.114-1.285.301L14.414 12l3.301-3.301C18.106 8.886 18.538 9 19 9c1.654 0 3-1.346 3-3s-1.346-3-3-3z"/>
      </svg>
    </div>
    TeamScribe
  </a>
  <div class="nav-links">
    <a href="#features" class="nav-a">Features</a>
    <a href="#how-it-works" class="nav-a">How it works</a>
    <a href="#download" class="nav-a">Download</a>
    <a href="#about" class="nav-a">About</a>
  </div>
  <div class="nav-btns">
    <a href="#download" class="btn-fill">Get the App ↗</a>
  </div>
  <button class="hamburger" onclick="document.getElementById('mm').classList.toggle('open')">☰</button>
</nav>
<div class="mob-menu" id="mm">
  <a href="#features" class="nav-a" onclick="document.getElementById('mm').classList.remove('open')">Features</a>
  <a href="#how-it-works" class="nav-a" onclick="document.getElementById('mm').classList.remove('open')">How it works</a>
  <a href="#download" class="nav-a" onclick="document.getElementById('mm').classList.remove('open')">Download</a>
  <a href="#download" class="btn-fill" style="text-align:center">Get the App</a>
</div>

{{-- ── Hero ─────────────────────────────────────────────────────────────── --}}
<div style="background:var(--bg2);border-bottom:1px solid var(--border)">
  <div class="hero">
    {{-- Left --}}
    <div>
      <div class="hero-badge">🎓 For university students</div>
      <h1>Collaborate smarter,<br><em>deliver together.</em></h1>
      <p class="hero-sub">TeamScribe gives every group member a clear role, real-time progress tracking, and built-in chat — so your project runs itself.</p>
      <div class="email-row">
        <input type="email" placeholder="Your university email" />
        <button onclick="window.location='#download'">Get Started ↗</button>
      </div>
      <div class="trust">
        <div class="trust-label">Trusted at universities across Tanzania</div>
        <div class="trust-logos">
          <span class="trust-logo">UDOM</span>
          <span class="trust-logo">UDSM</span>
          <span class="trust-logo">NIT</span>
          <span class="trust-logo">IFM</span>
        </div>
      </div>
    </div>

    {{-- Right: App mockup --}}
    <div class="hero-visual">
      <div style="position:relative;width:100%;max-width:420px">
        <div class="app-window">
          <div class="win-bar">
            <div class="win-dot" style="background:#FF5F57"></div>
            <div class="win-dot" style="background:#FFBD2E"></div>
            <div class="win-dot" style="background:#28CA41"></div>
            <div class="win-title">TeamScribe · Climate Policy Brief</div>
          </div>
          {{-- Section cards --}}
          @foreach([
            ['Introduction','Maya R.','Done','t-green',100,'#3fb950'],
            ['Methodology','You (assigned)','In Progress','t-yellow',55,'#d29922'],
            ['Data Analysis','Priya N.','In Progress','t-blue',30,'#2f81f7'],
            ['Conclusion','Alex C.','Not started','t-grey',0,'#374151'],
          ] as [$title,$member,$status,$tag,$pct,$color])
          <div class="win-card">
            <div class="win-card-header">
              <span class="win-card-title">{{ $title }}</span>
              <span class="win-tag {{ $tag }}">{{ $status }}</span>
            </div>
            <div class="win-member">{{ $member }}</div>
            <div class="win-bar-wrap">
              <div class="win-bar-fill" style="width:{{ $pct }}%;background:{{ $color }}"></div>
            </div>
            <div class="win-progress-label"><span>Progress</span><span>{{ $pct }}%</span></div>
          </div>
          @endforeach
          {{-- Chat preview --}}
          <div class="win-chat">
            <div style="font-size:10px;color:#637381;margin-bottom:8px;font-weight:700">💬 GROUP CHAT</div>
            <div class="win-chat-msg">
              <div class="win-avatar" style="background:#3fb950">M</div>
              <div class="win-bubble">Charts will be ready by Friday! 📊</div>
            </div>
            <div class="win-chat-msg" style="flex-direction:row-reverse">
              <div class="win-avatar" style="background:var(--teal)">Y</div>
              <div class="win-bubble me">Great — I'll finish methodology tonight</div>
            </div>
          </div>
        </div>
        {{-- Floating cards --}}
        <div class="floating-card float-1">
          <div class="float-icon">✅</div>
          <div class="float-stat">3/5</div>
          <div class="float-label">Sections done this week</div>
        </div>
        <div class="floating-card float-2">
          <div class="float-icon">👥</div>
          <div class="float-stat">4</div>
          <div class="float-label">Members active now</div>
        </div>
      </div>
    </div>
  </div>
</div>

{{-- ── Partner strip ────────────────────────────────────────────────────── --}}
<div class="strip">
  <div class="strip-label">Used by students at</div>
  <div class="strip-logos">
    <span class="strip-logo">UDOM</span>
    <span class="strip-logo">UDSM</span>
    <span class="strip-logo">NIT</span>
    <span class="strip-logo">IDIT</span>
    <span class="strip-logo">IFM</span>
    <span class="strip-logo">MU</span>
  </div>
</div>

{{-- ── Stats ────────────────────────────────────────────────────────────── --}}
<div class="stats-wrap">
  <div class="stats-inner">
    <div class="stats-tag">Our mission</div>
    <div class="stats-headline">We've helped thousands of students<br>submit better group projects.</div>
    <div class="stats-grid">
      <div class="stat-box">
        <div class="stat-num">10K+</div>
        <div class="stat-desc">Students registered across Africa</div>
      </div>
      <div class="stat-box">
        <div class="stat-num">50K+</div>
        <div class="stat-desc">Sections completed on time</div>
      </div>
      <div class="stat-box">
        <div class="stat-num">4.8★</div>
        <div class="stat-desc">Average rating from students</div>
      </div>
    </div>
  </div>
</div>

{{-- ── Why TeamScribe (bento) ───────────────────────────────────────────── --}}
<div class="why-wrap" id="features">
  <div style="max-width:1200px;margin:0 auto">
    <div class="sec-label">Why us</div>
    <h2 class="sec-title">Why students prefer TeamScribe</h2>
    <p class="sec-sub">Everything you need to run a group project without the chaos.</p>
    <div class="bento">
      <div class="bento-card bento-big">
        <div class="bento-icon">📋</div>
        <div class="bento-title">See who's doing what — instantly.</div>
        <div class="bento-desc">Assign sections to teammates and watch progress update in real time. No more "I thought you were doing that" moments.</div>
        <div class="bento-stat">85%</div>
        <div class="bento-stat-label">of teams finish on time with TeamScribe</div>
        <div class="mini-bar"><div class="mini-fill" style="width:85%"></div></div>
        <div style="margin-top:20px;padding-top:20px;border-top:1px solid #1E3A55">
          @foreach(['Introduction — Maya R. ✅','Methodology — You 🟡','Data Analysis — Priya N. 🟡','Conclusion — Alex C. ⬜'] as $item)
          <div style="display:flex;align-items:center;justify-content:space-between;padding:8px 0;border-bottom:1px solid #1E3A55;font-size:12px;color:#94a3b8">
            <span>{{ $item }}</span>
          </div>
          @endforeach
        </div>
      </div>
      <div style="display:flex;flex-direction:column;gap:16px">
        <div class="bento-card">
          <div class="bento-icon">🔑</div>
          <div class="bento-title">Instant member invite</div>
          <div class="bento-desc">Share a 6-character code on WhatsApp and your whole group joins in under 60 seconds. No awkward email sign-ups.</div>
        </div>
        <div class="bento-card">
          <div class="bento-icon">💬</div>
          <div class="bento-title">Built-in group chat</div>
          <div class="bento-desc">Chat is right inside the project — no switching apps. Real-time messages so everyone stays in the loop.</div>
        </div>
      </div>
    </div>
  </div>
</div>

{{-- ── How it works ─────────────────────────────────────────────────────── --}}
<div class="how-wrap" id="how-it-works">
  <div class="how-inner">
    <div class="sec-label" style="color:#4DD9AC">Simple process</div>
    <h2 class="sec-title" style="color:#fff">Up and running in 3 minutes.</h2>
    <p class="sec-sub" style="color:#94a3b8">No training. No setup fees. Your group will be collaborating before the lecture ends.</p>
    <div class="steps-grid">
      <div class="step-card" data-n="1">
        <div class="step-num">1</div>
        <div class="step-title">Download &amp; register</div>
        <div class="step-desc">Download TeamScribe from the App Store or Google Play. Sign up with your university email — it takes 30 seconds.</div>
      </div>
      <div class="step-card" data-n="2">
        <div class="step-num">2</div>
        <div class="step-title">Create your group</div>
        <div class="step-desc">Create a project group, give it a name and course code. Share the 6-digit invite code with your team on WhatsApp.</div>
      </div>
      <div class="step-card" data-n="3">
        <div class="step-num">3</div>
        <div class="step-title">Divide &amp; conquer</div>
        <div class="step-desc">Add sections for each part of the project and assign them. Watch the progress bar fill up as everyone completes their work.</div>
      </div>
    </div>
  </div>
</div>

{{-- ── Features ──────────────────────────────────────────────────────────── --}}
<div style="padding:80px 5%">
  <div style="max-width:1200px;margin:0 auto">
    <div class="sec-label">Features</div>
    <h2 class="sec-title">Everything your group needs.</h2>
    <div class="feat-grid">
      @foreach([
        ['📊','Real-time progress','Live progress bars show each member\'s completion. Everyone sees who\'s ahead, who needs support — without a single status meeting.'],
        ['🔔','Smart notifications','Get notified when a section is assigned to you, when deadlines approach, or when a teammate completes their work.'],
        ['📱','Works offline','TeamScribe keeps your data synced even with patchy campus WiFi. Your work is never lost.'],
        ['🔐','Secure & private','Only group members can see your project. Sections, chats, and files are kept private to your team.'],
        ['👤','Admin dashboard','University staff get a full web-based dashboard to manage students, monitor activity, and send announcements.'],
        ['📧','Email invitations','Invite anyone by email even if they haven\'t downloaded the app yet. They get a direct link to join your group.'],
      ] as [$icon,$title,$desc])
      <div class="feat-card">
        <div class="feat-icon-wrap">{{ $icon }}</div>
        <div class="feat-title">{{ $title }}</div>
        <div class="feat-desc">{{ $desc }}</div>
      </div>
      @endforeach
    </div>
  </div>
</div>

{{-- ── Download ──────────────────────────────────────────────────────────── --}}
<div id="download" style="background:var(--bg2);border-top:1px solid var(--border);padding:80px 5%;text-align:center">
  <div style="max-width:600px;margin:0 auto">
    <div class="sec-label" style="text-align:center">Get the app</div>
    <h2 class="sec-title" style="text-align:center">Download free.<br>Start today.</h2>
    <p class="sec-sub" style="text-align:center;margin:0 auto 40px">No subscription. No hidden fees. TeamScribe is completely free for all university students.</p>
    <div style="display:flex;gap:14px;justify-content:center;flex-wrap:wrap">
      <a href="#" style="display:flex;align-items:center;gap:12px;background:var(--navy);color:#fff;padding:14px 26px;border-radius:12px;font-weight:700;transition:opacity .15s" onmouseover="this.style.opacity='.85'" onmouseout="this.style.opacity='1'">
        <span style="font-size:26px">🍎</span>
        <div style="text-align:left">
          <div style="font-size:11px;opacity:.6;font-weight:400">Download on the</div>
          <div style="font-size:17px">App Store</div>
        </div>
      </a>
      <a href="#" style="display:flex;align-items:center;gap:12px;background:var(--navy);color:#fff;padding:14px 26px;border-radius:12px;font-weight:700;transition:opacity .15s" onmouseover="this.style.opacity='.85'" onmouseout="this.style.opacity='1'">
        <span style="font-size:26px">▶</span>
        <div style="text-align:left">
          <div style="font-size:11px;opacity:.6;font-weight:400">Get it on</div>
          <div style="font-size:17px">Google Play</div>
        </div>
      </a>
    </div>
    <div style="margin-top:24px;font-size:13px;color:#A0AEC0">iOS 13+ · Android 8+ · Free forever for students</div>
  </div>
</div>

{{-- ── CTA Banner ────────────────────────────────────────────────────────── --}}
<div class="cta-wrap">
  <div class="cta-banner">
    <div>
      <div class="cta-small">Try it now</div>
      <div class="cta-title">Ready to fix your<br>group project experience?</div>
      <div class="cta-sub">Join thousands of students who stopped fighting over Google Docs and started actually collaborating.</div>
    </div>
    <div class="cta-btns">
      <a href="#download" class="cta-btn-white">Get Started Now</a>
      <a href="#how-it-works" class="cta-btn-outline">Learn More ↗</a>
    </div>
  </div>
</div>

{{-- ── Footer ───────────────────────────────────────────────────────────── --}}
<footer id="about">
  <div class="footer-inner">
    <div class="footer-top">
      <div>
        <div class="footer-brand">
          <div class="brand-dot">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#fff" width="16" height="16">
              <path d="M19 3C17.346 3 16 4.346 16 6c0 .462.114.894.301 1.285L12.586 11H7.816C7.402 9.839 6.302 9 5 9c-1.654 0-3 1.346-3 3s1.346 3 3 3c1.302 0 2.402-.839 2.816-2H12.586l3.715 3.715C16.114 17.106 16 17.538 16 18c0 1.654 1.346 3 3 3s3-1.346 3-3-1.346-3-3-3c-.462 0-.894.114-1.285.301L14.414 12l3.301-3.301C18.106 8.886 18.538 9 19 9c1.654 0 3-1.346 3-3s-1.346-3-3-3z"/>
            </svg>
          </div>
          TeamScribe
        </div>
        <div class="footer-desc">Making university group projects less painful — one section at a time. Built by students, for students.</div>
      </div>
      <div>
        <h5>Product</h5>
        <a href="#features" class="footer-link">Features</a>
        <a href="#how-it-works" class="footer-link">How it works</a>
        <a href="#download" class="footer-link">Download</a>
      </div>
      <div>
        <h5>Company</h5>
        <a href="#about" class="footer-link">About us</a>
        <a href="#" class="footer-link">Blog</a>
        <a href="#" class="footer-link">Careers</a>
        <a href="#" class="footer-link">Contact</a>
      </div>
      <div>
        <h5>Support</h5>
        <a href="#" class="footer-link">Help centre</a>
        <a href="#" class="footer-link">Privacy policy</a>
        <a href="#" class="footer-link">Terms of use</a>
        <a href="#" class="footer-link">Report a bug</a>
        <a href="{{ route('go-admin') }}" class="footer-link" style="margin-top:8px;opacity:.5;font-size:12px">Admin Login →</a>
      </div>
    </div>
    <div class="footer-bottom">
      <div class="footer-copy">&copy; {{ date('Y') }} TeamScribe. All rights reserved.</div>
      <div class="footer-socials">
        <a href="#" class="soc">𝕏</a>
        <a href="#" class="soc">in</a>
        <a href="#" class="soc">📸</a>
      </div>
    </div>
  </div>
</footer>

<script>
  // Smooth mobile menu close on anchor click
  document.querySelectorAll('#mm a[href^="#"]').forEach(a => {
    a.addEventListener('click', () => document.getElementById('mm').classList.remove('open'));
  });
  // Nav scroll effect
  window.addEventListener('scroll', () => {
    document.querySelector('nav').style.boxShadow =
      window.scrollY > 10 ? '0 2px 20px rgba(0,0,0,.08)' : 'none';
  });
</script>
</body>
</html>
