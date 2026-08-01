<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Enquiry;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class EnquiryController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => Enquiry::query()->with(['category:id,name'])->latest()->get(),
        ]);
    }

    public function show(Enquiry $enquiry): JsonResponse
    {
        return response()->json([
            'data' => $enquiry->load(['category:id,name']),
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $payload = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'email' => ['required', 'email', 'max:180'],
            'subject' => ['required', 'string', 'max:160'],
            'message' => ['required', 'string', 'max:4000'],
            'category_id' => ['nullable', 'exists:categories,id'],
            'status' => ['nullable', Rule::in(['open', 'pending', 'solved'])],
        ]);

        $enquiry = Enquiry::create($payload + [
            'status' => $payload['status'] ?? 'open',
        ]);

        return response()->json([
            'message' => 'Enquiry submitted successfully.',
            'data' => $enquiry,
        ], 201);
    }
}
