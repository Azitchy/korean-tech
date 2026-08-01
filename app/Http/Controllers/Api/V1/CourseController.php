<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Course;
use Illuminate\Http\JsonResponse;

class CourseController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => Course::query()
                ->with(['category:id,name', 'subject:id,name'])
                ->orderBy('title')
                ->get(),
        ]);
    }

    public function show(Course $course): JsonResponse
    {
        return response()->json([
            'data' => $course->load([
                'category:id,name',
                'subject:id,name',
                'exams.questions.options',
            ]),
        ]);
    }
}
