<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class ResourceController extends Controller
{
    public function index(string $resource): View
    {
        $config = $this->config($resource);
        $query = $this->resourceQuery($config);
        $sort = $config['sort'] ?? 'created_at';
        $direction = $config['direction'] ?? 'desc';

        if ($sort) {
            $query->orderBy($sort, $direction);
        }

        $items = $query->paginate(12)->withQueryString();
        $items->getCollection()->transform(fn (Model $item) => $this->decorateItem($item, $config));

        return view('admin.resources.index', [
            'resource' => $resource,
            'config' => $config,
            'items' => $items,
            'resources' => config('admin_resources'),
        ]);
    }

    public function create(string $resource): View
    {
        $config = $this->config($resource);

        return view('admin.resources.form', [
            'resource' => $resource,
            'config' => $config,
            'item' => null,
            'resources' => config('admin_resources'),
            'formMode' => 'create',
            'selectOptions' => $this->selectOptions($config),
        ]);
    }

    public function store(Request $request, string $resource): RedirectResponse
    {
        $config = $this->config($resource);
        $model = $config['model'];
        $validated = $this->validated($request, $config);
        $payload = $this->normalize($validated, $config);

        $model::create($payload);

        return redirect()
            ->route('admin.resources.index', $resource)
            ->with('status', class_basename($model) . ' created successfully.');
    }

    public function edit(string $resource, int $record): View
    {
        $config = $this->config($resource);
        $item = $this->resourceQuery($config)->findOrFail($record);

        return view('admin.resources.form', [
            'resource' => $resource,
            'config' => $config,
            'item' => $item,
            'resources' => config('admin_resources'),
            'formMode' => 'edit',
            'selectOptions' => $this->selectOptions($config),
        ]);
    }

    public function update(Request $request, string $resource, int $record): RedirectResponse
    {
        $config = $this->config($resource);
        $model = $config['model'];
        $item = $this->resourceQuery($config)->findOrFail($record);
        $validated = $this->validated($request, $config, $item->id);
        $payload = $this->normalize($validated, $config);

        $item->update($payload);

        return redirect()
            ->route('admin.resources.index', $resource)
            ->with('status', class_basename($model) . ' updated successfully.');
    }

    public function destroy(string $resource, int $record): RedirectResponse
    {
        $config = $this->config($resource);
        $model = $config['model'];
        $item = $this->resourceQuery($config)->findOrFail($record);
        $item->delete();

        return redirect()
            ->route('admin.resources.index', $resource)
            ->with('status', class_basename($model) . ' deleted successfully.');
    }

    private function config(string $resource): array
    {
        $config = config("admin_resources.$resource");

        abort_if($config === null, 404);

        return $config;
    }

    private function validated(Request $request, array $config, ?int $ignoreId = null): array
    {
        $rules = [];
        $isCreate = $ignoreId === null;

        foreach ($config['fields'] as $field) {
            $fieldRules = Arr::wrap($field['rules'] ?? 'nullable');

            if (($config['model'] ?? null) === \App\Models\User::class && $field['key'] === 'password') {
                $fieldRules = $isCreate
                    ? ['required', 'string', 'min:8']
                    : ['nullable', 'string', 'min:8'];
            }

            if (!empty($field['unique'])) {
                $model = $config['model'];
                $table = (new $model())->getTable();
                $fieldRules[] = Rule::unique($table, $field['key'])->ignore($ignoreId);
            }

            $rules[$field['key']] = $fieldRules;
        }

        return $request->validate($rules);
    }

    private function normalize(array $validated, array $config): array
    {
        $payload = [];

        foreach ($config['fields'] as $field) {
            $key = $field['key'];
            $type = $field['type'] ?? 'text';
            $value = $validated[$key] ?? null;

            if ($type === 'boolean') {
                $payload[$key] = (bool) ($value ?? false);
                continue;
            }

            if ($type === 'tags') {
                $payload[$key] = $this->parseTags($value);
                continue;
            }

            if ($type === 'json') {
                $payload[$key] = $this->parseJson($value);
                continue;
            }

            if ($type === 'datetime-local') {
                $payload[$key] = $value ? Carbon::parse($value) : null;
                continue;
            }

            if ($key === 'slug' && blank($value)) {
                $sourceKey = $field['source'] ?? 'name';
                $source = $validated[$sourceKey] ?? null;
                $payload[$key] = Str::slug((string) $source);
                continue;
            }

            $payload[$key] = $value;
        }

        if (($config['model'] ?? null) === \App\Models\User::class && blank($payload['password'] ?? null)) {
            unset($payload['password']);
        }

        if (($config['model'] ?? null) === \App\Models\User::class && isset($payload['password'])) {
            $payload['password'] = $payload['password'];
        }

        foreach ($config['defaults'] ?? [] as $key => $value) {
            if (!array_key_exists($key, $payload) || blank($payload[$key])) {
                $payload[$key] = $value;
            }
        }

        return $payload;
    }

    private function resourceQuery(array $config): Builder
    {
        $model = $config['model'];
        $query = $model::query();

        foreach ($config['where'] ?? [] as $column => $value) {
            $query->where($column, $value);
        }

        return $query;
    }

    private function parseTags(mixed $value): array
    {
        if (is_array($value)) {
            return array_values(array_filter(array_map('trim', $value)));
        }

        if (!is_string($value) || trim($value) === '') {
            return [];
        }

        $tokens = preg_split('/[\r\n,]+/', $value) ?: [];

        return array_values(array_filter(array_map('trim', $tokens)));
    }

    private function parseJson(mixed $value): ?array
    {
        if (is_array($value)) {
            return $value;
        }

        if (!is_string($value) || trim($value) === '') {
            return null;
        }

        $decoded = json_decode($value, true);

        return json_last_error() === JSON_ERROR_NONE ? $decoded : ['raw' => $value];
    }

    private function decorateItem(Model $item, array $config): Model
    {
        $item->setAttribute('display_values', []);

        foreach ($config['columns'] as $column) {
            $displayValues = $item->getAttribute('display_values');
            $displayValues[$column['label']] = $this->presentValue($item, $column['field']);
            $item->setAttribute('display_values', $displayValues);
        }

        return $item;
    }

    private function presentValue(Model $item, string $field): string
    {
        $value = data_get($item, $field);

        if (is_array($value)) {
            return implode(', ', $value);
        }

        if (is_bool($value)) {
            return $value ? 'Yes' : 'No';
        }

        if ($value instanceof Carbon) {
            return $value->format('Y-m-d H:i');
        }

        if (blank($value)) {
            return '-';
        }

        return (string) $value;
    }

    private function selectOptions(array $config): array
    {
        $options = [];

        foreach ($config['fields'] as $field) {
            if (($field['type'] ?? null) !== 'select') {
                continue;
            }

            if (isset($field['options'])) {
                $options[$field['key']] = $field['options'];
                continue;
            }

            $sourceModel = $field['source_model'] ?? null;
            $label = $field['source_label'] ?? 'name';

            if ($sourceModel) {
                $options[$field['key']] = $sourceModel::query()
                    ->orderBy($label)
                    ->pluck($label, 'id')
                    ->all();
            }
        }

        return $options;
    }
}
