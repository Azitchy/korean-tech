@extends('admin.layout')

@section('content')
    <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        @foreach ($stats as $stat)
            <div class="rounded-3xl border border-white/10 bg-white/5 p-5 shadow-lg shadow-black/20">
                <div class="text-sm text-slate-400">{{ $stat['label'] }}</div>
                <div class="mt-2 text-3xl font-black">{{ $stat['value'] }}</div>
                <div class="mt-2 text-sm text-slate-400">{{ $stat['note'] }}</div>
            </div>
        @endforeach
    </div>

    <div class="mt-6 grid gap-6 xl:grid-cols-[1.7fr_1fr]">
        <div class="rounded-3xl border border-white/10 bg-slate-900/70 p-6">
            <div class="flex items-center justify-between">
                <h2 class="text-lg font-bold">Mobile Section Coverage</h2>
                <span class="text-sm text-slate-400">All section data is driven from content items</span>
            </div>
            <div class="mt-5 grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
                @foreach ($sections as $section)
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-sm text-slate-400">{{ $section->section }}</div>
                        <div class="mt-2 text-2xl font-black">{{ $section->total }}</div>
                    </div>
                @endforeach
            </div>
        </div>

        <div class="rounded-3xl border border-white/10 bg-slate-900/70 p-6">
            <h2 class="text-lg font-bold">Manage Data</h2>
            <p class="mt-2 text-sm text-slate-400">Use the content section or any core resource to update what the mobile app shows.</p>
            <div class="mt-5 space-y-2">
                @foreach ($resources as $key => $resource)
                    <a href="{{ route('admin.resources.index', $key) }}" class="flex items-center justify-between rounded-2xl border border-white/10 bg-white/5 px-4 py-3 hover:bg-white/10 transition">
                        <span>{{ $resource['label'] }}</span>
                        <span class="text-slate-400">Open</span>
                    </a>
                @endforeach
            </div>
        </div>
    </div>
@endsection
