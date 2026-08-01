<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\ContentItem;
use App\Models\Course;
use App\Models\Enquiry;
use App\Models\Exam;
use App\Models\Package;
use App\Models\Subject;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Carbon;

class DashboardController extends Controller
{
    public function index(): JsonResponse
    {
        $today = Carbon::now();
        $sections = ContentItem::query()
            ->selectRaw('section, count(*) as total')
            ->groupBy('section')
            ->orderBy('section')
            ->get();

        return response()->json([
            'summary' => [
                'users' => User::count(),
                'categories' => Category::count(),
                'subjects' => Subject::count(),
                'courses' => Course::count(),
                'packages' => Package::count(),
                'exams' => Exam::count(),
                'enquiries' => Enquiry::count(),
                'mobile_items' => ContentItem::count(),
                'todays_exams' => Exam::whereDate('start_at', $today)->count(),
            ],
            'categories' => Category::query()->withCount('courses')->orderBy('name')->get(),
            'upcoming_exams' => Exam::query()
                ->with(['course:id,title'])
                ->whereNotNull('start_at')
                ->orderBy('start_at')
                ->limit(5)
                ->get(),
            'featured_packages' => Package::query()
                ->orderBy('price')
                ->limit(3)
                ->get(),
            'notifications' => ContentItem::query()->forSection('notifications')->published()->orderBy('sort_order')->limit(10)->get(),
            'results' => ContentItem::query()->forSection('results')->published()->orderBy('sort_order')->limit(10)->get(),
            'leaderboard' => ContentItem::query()->forSection('leaderboard')->published()->orderBy('sort_order')->limit(10)->get(),
            'gallery' => ContentItem::query()->forSection('gallery')->published()->orderBy('sort_order')->limit(10)->get(),
            'bookmarks' => ContentItem::query()->forSection('bookmarks')->published()->orderBy('sort_order')->limit(10)->get(),
            'streak' => ContentItem::query()->forSection('streak')->published()->orderBy('sort_order')->limit(10)->get(),
            'certificates' => ContentItem::query()->forSection('certificates')->published()->orderBy('sort_order')->limit(10)->get(),
            'profile' => [
                'badges' => ContentItem::query()->forSection('profile_badges')->published()->orderBy('sort_order')->limit(10)->get(),
            ],
            'weekly_progress' => ContentItem::query()->forSection('weekly_progress')->published()->orderBy('sort_order')->limit(10)->get(),
            'menu' => ContentItem::query()->forSection('menu_shortcuts')->published()->orderBy('sort_order')->limit(10)->get(),
            'sections' => $sections,
        ]);
    }
}
