@extends('admin.layout')

@section('content')
    <div class="flex flex-wrap items-center justify-between gap-3">
        <div>
            <h2 class="text-2xl font-black">{{ $config['label'] }}</h2>
            <p class="mt-1 text-sm text-slate-400">Create, update, and remove records for this section.</p>
        </div>
        <a href="{{ route('admin.resources.create', $resource) }}" class="rounded-2xl bg-teal-400 px-4 py-3 font-semibold text-slate-950">
            Add New
        </a>
    </div>

    <div class="mt-6 overflow-hidden rounded-3xl border border-white/10 bg-slate-900/70">
        <table class="w-full text-left">
            <thead class="bg-white/5 text-sm text-slate-300">
                <tr>
                    @foreach ($config['columns'] as $column)
                        <th class="px-5 py-4 font-medium">{{ $column['label'] }}</th>
                    @endforeach
                    <th class="px-5 py-4 font-medium">Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse ($items as $item)
                    <tr class="border-t border-white/5">
                        @foreach ($config['columns'] as $column)
                            <td class="px-5 py-4 text-slate-200">
                                {{ data_get($item->display_values, $column['label'], '-') }}
                            </td>
                        @endforeach
                        <td class="px-5 py-4">
                            <div class="flex flex-wrap gap-2">
                                <a href="{{ route('admin.resources.edit', [$resource, $item->id]) }}" class="rounded-xl border border-white/10 px-3 py-2 text-sm hover:bg-white/10">Edit</a>
                                <form action="{{ route('admin.resources.destroy', [$resource, $item->id]) }}" method="POST" onsubmit="return confirm('Delete this record?')">
                                    @csrf
                                    @method('DELETE')
                                    <button class="rounded-xl border border-rose-400/20 bg-rose-400/10 px-3 py-2 text-sm text-rose-100 hover:bg-rose-400/20">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="{{ count($config['columns']) + 1 }}" class="px-5 py-10 text-center text-slate-400">
                            No records found yet.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="mt-5">
        {{ $items->links() }}
    </div>
@endsection
