@extends('admin.layout')

@section('content')
    @php
        $editing = $formMode === 'edit';
        $action = $editing
            ? route('admin.resources.update', [$resource, $item->id])
            : route('admin.resources.store', $resource);
    @endphp

    <div class="flex flex-wrap items-center justify-between gap-3">
        <div>
            <h2 class="text-2xl font-black">{{ $editing ? 'Edit' : 'Create' }} {{ $config['label'] }}</h2>
            <p class="mt-1 text-sm text-slate-400">Fill in the fields below and save to update the admin data source.</p>
        </div>
        <a href="{{ route('admin.resources.index', $resource) }}" class="rounded-2xl border border-white/10 px-4 py-3 font-semibold">Back</a>
    </div>

    <form class="mt-6 rounded-3xl border border-white/10 bg-slate-900/70 p-6 space-y-5" method="POST" action="{{ $action }}">
        @csrf
        @if ($editing)
            @method('PUT')
        @endif

        <div class="grid gap-5 md:grid-cols-2">
            @foreach ($config['fields'] as $field)
                <div class="{{ in_array($field['type'], ['textarea', 'json'], true) ? 'md:col-span-2' : '' }}">
                    <label class="mb-2 block text-sm font-semibold text-slate-200">{{ $field['label'] }}</label>
                    @php
                        $value = old($field['key'], data_get($item, $field['key']));
                        if ($field['type'] === 'datetime-local' && $value) {
                            $value = \Illuminate\Support\Carbon::parse($value)->format('Y-m-d\TH:i');
                        }
                        if ($field['type'] === 'tags' && is_array($value)) {
                            $value = implode(",\n", $value);
                        }
                        if ($field['type'] === 'json' && is_array($value)) {
                            $value = json_encode($value, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
                        }
                    @endphp

                    @switch($field['type'])
                        @case('select')
                            <select name="{{ $field['key'] }}" class="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-slate-100">
                                <option value="">Select {{ $field['label'] }}</option>
                                @foreach($selectOptions[$field['key']] ?? [] as $optionValue => $optionLabel)
                                    <option value="{{ $optionValue }}" @selected((string) $value === (string) $optionValue)>{{ $optionLabel }}</option>
                                @endforeach
                            </select>
                            @break
                        @case('textarea')
                        @case('json')
                        @case('tags')
                            <textarea name="{{ $field['key'] }}" rows="5" class="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-slate-100">{{ $value }}</textarea>
                            @break
                        @case('number')
                            <input type="number" name="{{ $field['key'] }}" value="{{ $value }}" class="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-slate-100">
                            @break
                        @case('datetime-local')
                            <input type="datetime-local" name="{{ $field['key'] }}" value="{{ $value }}" class="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-slate-100">
                            @break
                        @case('boolean')
                            <label class="flex items-center gap-3 rounded-2xl border border-white/10 bg-slate-950 px-4 py-3">
                                <input type="checkbox" name="{{ $field['key'] }}" value="1" @checked((bool) $value) class="h-4 w-4 rounded border-white/20 bg-slate-950">
                                <span class="text-sm text-slate-200">Enable {{ $field['label'] }}</span>
                            </label>
                            @break
                        @default
                            <input type="text" name="{{ $field['key'] }}" value="{{ $value }}" class="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-slate-100">
                    @endswitch

                    @error($field['key'])
                        <div class="mt-2 text-sm text-rose-300">{{ $message }}</div>
                    @enderror
                </div>
            @endforeach
        </div>

        <div class="flex flex-wrap gap-3 pt-2">
            <button class="rounded-2xl bg-teal-400 px-5 py-3 font-semibold text-slate-950" type="submit">
                {{ $editing ? 'Update' : 'Create' }}
            </button>
            <a href="{{ route('admin.resources.index', $resource) }}" class="rounded-2xl border border-white/10 px-5 py-3 font-semibold">
                Cancel
            </a>
        </div>
    </form>
@endsection
