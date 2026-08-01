<?php

use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\CourseController;
use App\Http\Controllers\Api\V1\DashboardController;
use App\Http\Controllers\Api\V1\EnquiryController;
use App\Http\Controllers\Api\V1\ExamController;
use App\Http\Controllers\Api\V1\SectionController;
use App\Http\Controllers\Api\V1\PackageController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::get('/health', fn () => response()->json([
        'status' => 'ok',
        'service' => 'Online Test & Examination API',
        'version' => 'v1',
    ]));

    Route::get('/dashboard', [DashboardController::class, 'index']);
    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/categories/{category}', [CategoryController::class, 'show']);
    Route::get('/courses', [CourseController::class, 'index']);
    Route::get('/courses/{course}', [CourseController::class, 'show']);
    Route::get('/packages', [PackageController::class, 'index']);
    Route::get('/packages/{package}', [PackageController::class, 'show']);
    Route::get('/exams', [ExamController::class, 'index']);
    Route::get('/exams/{exam}', [ExamController::class, 'show']);

    Route::get('/mobile/dashboard', [DashboardController::class, 'index']);
    Route::get('/mobile/notifications', fn () => app(SectionController::class)('notifications'));
    Route::get('/mobile/results', fn () => app(SectionController::class)('results'));
    Route::get('/mobile/leaderboard', fn () => app(SectionController::class)('leaderboard'));
    Route::get('/mobile/gallery', fn () => app(SectionController::class)('gallery'));
    Route::get('/mobile/bookmarks', fn () => app(SectionController::class)('bookmarks'));
    Route::get('/mobile/streak', fn () => app(SectionController::class)('streak'));
    Route::get('/mobile/certificates', fn () => app(SectionController::class)('certificates'));
    Route::get('/mobile/profile', fn () => app(SectionController::class)('profile_badges'));
    Route::get('/mobile/menu', fn () => app(SectionController::class)('menu_shortcuts'));
    Route::get('/mobile/content/{section}', SectionController::class);

    Route::get('/enquiries', [EnquiryController::class, 'index']);
    Route::post('/enquiries', [EnquiryController::class, 'store']);
    Route::get('/enquiries/{enquiry}', [EnquiryController::class, 'show']);
});
