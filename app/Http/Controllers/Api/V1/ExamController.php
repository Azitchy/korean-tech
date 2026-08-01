<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Exam;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ExamController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Exam::query()
            ->with(['course.category:id,name', 'course:id,category_id,title', 'questions.options'])
            ->orderByDesc('start_at');

        if ($request->filled('exam_type')) {
            $query->where('exam_type', $request->string('exam_type'));
        }

        if ($request->filled('exclude_exam_type')) {
            $query->where('exam_type', '!=', $request->string('exclude_exam_type'));
        }

        return response()->json([
            'data' => $query->get(),
        ]);
    }

    public function show(Exam $exam): JsonResponse
    {
        return response()->json([
            'data' => $exam->load(['course.category:id,name', 'course:id,category_id,title', 'questions.options']),
        ]);
    }
}
