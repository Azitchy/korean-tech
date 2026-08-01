<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\ContentItem;
use Illuminate\Http\JsonResponse;

class SectionController extends Controller
{
    public function __invoke(string $section): JsonResponse
    {
        $items = ContentItem::query()
            ->forSection($section)
            ->published()
            ->orderBy('sort_order')
            ->latest('published_at')
            ->get();

        return response()->json([
            'section' => $section,
            'data' => $items,
        ]);
    }
}
