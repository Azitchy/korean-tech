<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;

class CategoryController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => Category::query()->withCount('courses')->orderBy('name')->get(),
        ]);
    }

    public function show(Category $category): JsonResponse
    {
        return response()->json([
            'data' => $category->load(['subjects', 'courses']),
        ]);
    }
}
