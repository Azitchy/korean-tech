<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Package;
use Illuminate\Http\JsonResponse;

class PackageController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => Package::query()->orderBy('price')->get(),
        ]);
    }

    public function show(Package $package): JsonResponse
    {
        return response()->json([
            'data' => $package,
        ]);
    }
}
