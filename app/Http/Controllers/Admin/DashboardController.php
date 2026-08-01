<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\ContentItem;
use App\Models\Course;
use App\Models\Enquiry;
use App\Models\Exam;
use App\Models\Package;
use App\Models\Subject;
use App\Models\User;
use Illuminate\View\View;

class DashboardController extends Controller
{
    public function index(): View
    {
        $stats = [
            ['label' => 'Users', 'value' => User::count(), 'note' => 'Admin, teacher, and student accounts'],
            ['label' => 'Categories', 'value' => Category::count(), 'note' => 'Course groups in the catalog'],
            ['label' => 'Subjects', 'value' => Subject::count(), 'note' => 'Subject trees under categories'],
            ['label' => 'Courses', 'value' => Course::count(), 'note' => 'Learning and exam tracks'],
            ['label' => 'Packages', 'value' => Package::count(), 'note' => 'Subscription plans'],
            ['label' => 'Exams', 'value' => Exam::count(), 'note' => 'Practice and live exams'],
            ['label' => 'Enquiries', 'value' => Enquiry::count(), 'note' => 'Student support threads'],
            ['label' => 'Mobile Items', 'value' => ContentItem::count(), 'note' => 'Dashboard, results, leaderboard, and other mobile sections'],
        ];

        $sections = ContentItem::query()
            ->selectRaw('section, count(*) as total')
            ->groupBy('section')
            ->orderBy('section')
            ->get();

        return view('admin.dashboard', [
            'stats' => $stats,
            'sections' => $sections,
            'resources' => config('admin_resources'),
        ]);
    }
}
