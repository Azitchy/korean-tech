<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ $title ?? 'Admin Dashboard' }} - {{ config('app.name', 'Laravel') }}</title>
    @if (file_exists(public_path('build/manifest.json')) || file_exists(public_path('hot')))
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    @else
        <style>
            :root { color-scheme: dark; }
            * { box-sizing: border-box; }
            body { margin: 0; font-family: Arial, sans-serif; background: #020617; color: #e2e8f0; }
            a { color: inherit; text-decoration: none; }
            .min-h-screen { min-height: 100vh; }
            .flex { display: flex; }
            .hidden { display: none; }
            .block { display: block; }
            .w-72 { width: 18rem; }
            .flex-1 { flex: 1; }
            .items-center { align-items: center; }
            .justify-between { justify-content: space-between; }
            .justify-center { justify-content: center; }
            .gap-2 { gap: .5rem; }
            .gap-3 { gap: .75rem; }
            .gap-4 { gap: 1rem; }
            .space-y-2 > * + * { margin-top: .5rem; }
            .space-y-3 > * + * { margin-top: .75rem; }
            .space-y-5 > * + * { margin-top: 1.25rem; }
            .rounded-2xl { border-radius: 1rem; }
            .rounded-3xl { border-radius: 1.5rem; }
            .rounded-full { border-radius: 9999px; }
            .border { border: 1px solid rgba(255,255,255,.1); }
            .border-r { border-right: 1px solid rgba(255,255,255,.1); }
            .border-b { border-bottom: 1px solid rgba(255,255,255,.1); }
            .bg-slate-950 { background: #020617; }
            .bg-slate-900\/70 { background: rgba(15, 23, 42, .7); }
            .bg-white\/5 { background: rgba(255,255,255,.05); }
            .bg-white\/10 { background: rgba(255,255,255,.1); }
            .bg-emerald-400\/10 { background: rgba(74, 222, 128, .1); }
            .bg-teal-400 { background: #2dd4bf; }
            .bg-teal-400\/10 { background: rgba(45, 212, 191, .1); }
            .bg-rose-400\/10 { background: rgba(248, 113, 113, .1); }
            .text-slate-100 { color: #f1f5f9; }
            .text-slate-200 { color: #e2e8f0; }
            .text-slate-300 { color: #cbd5e1; }
            .text-slate-400 { color: #94a3b8; }
            .text-emerald-100 { color: #d1fae5; }
            .text-rose-100 { color: #ffe4e6; }
            .text-rose-300 { color: #fda4af; }
            .text-teal-200 { color: #99f6e4; }
            .text-slate-950 { color: #020617; }
            .font-bold { font-weight: 700; }
            .font-black { font-weight: 900; }
            .font-semibold { font-weight: 600; }
            .text-sm { font-size: .875rem; }
            .text-lg { font-size: 1.125rem; }
            .text-xl { font-size: 1.25rem; }
            .text-2xl { font-size: 1.5rem; }
            .text-3xl { font-size: 1.875rem; }
            .px-4 { padding-left: 1rem; padding-right: 1rem; }
            .px-5 { padding-left: 1.25rem; padding-right: 1.25rem; }
            .py-2 { padding-top: .5rem; padding-bottom: .5rem; }
            .py-3 { padding-top: .75rem; padding-bottom: .75rem; }
            .py-4 { padding-top: 1rem; padding-bottom: 1rem; }
            .py-6 { padding-top: 1.5rem; padding-bottom: 1.5rem; }
            .p-4 { padding: 1rem; }
            .p-5 { padding: 1.25rem; }
            .p-6 { padding: 1.5rem; }
            .pt-2 { padding-top: .5rem; }
            .mt-1 { margin-top: .25rem; }
            .mt-2 { margin-top: .5rem; }
            .mt-5 { margin-top: 1.25rem; }
            .mt-6 { margin-top: 1.5rem; }
            .mb-2 { margin-bottom: .5rem; }
            .mb-6 { margin-bottom: 1.5rem; }
            .mx-auto { margin-left: auto; margin-right: auto; }
            .max-w-7xl { max-width: 80rem; }
            .overflow-hidden { overflow: hidden; }
            .w-full { width: 100%; }
            .text-left { text-align: left; }
            .uppercase { text-transform: uppercase; }
            .tracking-\[0\.3em\] { letter-spacing: .3em; }
            .backdrop-blur { backdrop-filter: blur(12px); }
            .transition { transition: background .15s ease; }
            .hover\:bg-white\/10:hover { background: rgba(255,255,255,.1); }
            .hover\:bg-white\/5:hover { background: rgba(255,255,255,.05); }
            .lg\:block { display: block; }
            .lg\:px-8 { padding-left: 2rem; padding-right: 2rem; }
            .lg\:rounded-t-none { border-top-left-radius: 0; border-top-right-radius: 0; }
            .lg\:rounded-r-lg { border-top-right-radius: .5rem; border-bottom-right-radius: .5rem; }
            .xl\:grid-cols-4 { grid-template-columns: repeat(4, minmax(0, 1fr)); }
            .grid { display: grid; }
            .gap-4 { gap: 1rem; }
            .gap-6 { gap: 1.5rem; }
            .sm\:grid-cols-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .xl\:grid-cols-\[1\.7fr_1fr\] { grid-template-columns: 1.7fr 1fr; }
            .xl\:grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
            .md\:grid-cols-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .bg-slate-950\/70 { background: rgba(2, 6, 23, .7); }
            .shadow-lg { box-shadow: 0 10px 15px rgba(0,0,0,.25); }
            .shadow-black\/20 { box-shadow: 0 10px 15px rgba(0,0,0,.2); }
            .hidden.lg\:block { display: block; }
        </style>
    @endif
</head>
<body class="min-h-screen bg-slate-950 text-slate-100">
    <div class="flex min-h-screen">
        <aside class="hidden w-72 border-r border-white/10 bg-slate-950/95 px-5 py-6 lg:block">
            <div class="mb-8">
                <div class="text-sm uppercase tracking-[0.3em] text-teal-300">ExamVerse</div>
                <div class="mt-2 text-2xl font-black">Admin Panel</div>
                <p class="mt-2 text-sm text-slate-400">Manage the mobile content, exam catalog, and support data from one place.</p>
            </div>

            <nav class="space-y-2">
                <a href="{{ route('admin.dashboard') }}" class="block rounded-2xl px-4 py-3 bg-white/5 hover:bg-white/10 transition">Dashboard</a>
                @foreach($resources as $key => $resource)
                    <a href="{{ route('admin.resources.index', $key) }}" class="block rounded-2xl px-4 py-3 hover:bg-white/10 transition text-slate-300">
                        {{ $resource['label'] }}
                    </a>
                @endforeach
            </nav>
        </aside>

        <main class="flex-1">
            <header class="border-b border-white/10 bg-slate-950/70 backdrop-blur">
                <div class="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 lg:px-8">
                    <div>
                        <div class="text-sm text-slate-400">Online test and examination platform</div>
                        <h1 class="text-xl font-bold">{{ $title ?? 'Dashboard' }}</h1>
                    </div>
                    <div class="rounded-full border border-teal-400/30 bg-teal-400/10 px-4 py-2 text-sm text-teal-200">
                        Live admin workspace
                    </div>
                </div>
            </header>

            <section class="mx-auto max-w-7xl px-4 py-6 lg:px-8">
                @if (session('status'))
                    <div class="mb-6 rounded-2xl border border-emerald-400/20 bg-emerald-400/10 px-4 py-3 text-emerald-100">
                        {{ session('status') }}
                    </div>
                @endif

                @yield('content')
            </section>
        </main>
    </div>
</body>
</html>
