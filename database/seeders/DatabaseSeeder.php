<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Course;
use App\Models\ContentItem;
use App\Models\Enquiry;
use App\Models\Exam;
use App\Models\Package;
use App\Models\Question;
use App\Models\QuestionOption;
use App\Models\Subject;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $now = now();

        $users = [
            ['name' => 'Admin User', 'email' => 'admin@example.com', 'role' => 'admin'],
            ['name' => 'Teacher One', 'email' => 'teacher1@example.com', 'role' => 'teacher'],
            ['name' => 'Teacher Two', 'email' => 'teacher2@example.com', 'role' => 'teacher'],
            ['name' => 'Student One', 'email' => 'student1@example.com', 'role' => 'student'],
            ['name' => 'Student Two', 'email' => 'student2@example.com', 'role' => 'student'],
            ['name' => 'Student Three', 'email' => 'student3@example.com', 'role' => 'student'],
            ['name' => 'Student Four', 'email' => 'student4@example.com', 'role' => 'student'],
            ['name' => 'Student Five', 'email' => 'student5@example.com', 'role' => 'student'],
            ['name' => 'Student Six', 'email' => 'student6@example.com', 'role' => 'student'],
            ['name' => 'Student Seven', 'email' => 'student7@example.com', 'role' => 'student'],
        ];

        foreach ($users as $index => $user) {
            User::query()->updateOrCreate(
                ['email' => $user['email']],
                [
                'name' => $user['name'],
                'password' => bcrypt('password'),
                'role' => $user['role'],
                'phone' => '980000' . str_pad((string) ($index + 1), 4, '0', STR_PAD_LEFT),
                ]
            );
        }

        $categoryData = [
            ['name' => 'IELTS', 'description' => 'Academic and general IELTS practice exams.'],
            ['name' => 'TOEFL', 'description' => 'TOEFL reading, listening, and mock tests.'],
            ['name' => 'SAT', 'description' => 'SAT math, reading, and writing practice.'],
            ['name' => 'Government Jobs', 'description' => 'Competitive exam practice for public service roles.'],
            ['name' => 'School Exams', 'description' => 'Grade 8 to 12 preparation modules.'],
            ['name' => 'University Exams', 'description' => 'Entrance and semester exam preparation.'],
            ['name' => 'Language Courses', 'description' => 'Foundation and communication skill tests.'],
            ['name' => 'GRE', 'description' => 'Graduate readiness and aptitude practice.'],
            ['name' => 'GMAT', 'description' => 'Business school admissions test preparation.'],
            ['name' => 'Banking', 'description' => 'Bank clerk and assistant level examinations.'],
        ];

        $categories = collect();
        foreach ($categoryData as $index => $data) {
            $categories->push(Category::query()->updateOrCreate(
                ['slug' => strtolower(str_replace(' ', '-', $data['name']))],
                [
                    'name' => $data['name'],
                    'description' => $data['description'],
                    'status' => 'active',
                ]
            ));
        }

        $subjectNames = [
            'Reading', 'Listening', 'Writing', 'Speaking', 'Grammar',
            'Vocabulary', 'Quantitative', 'Reasoning', 'General Knowledge', 'Computer Basics',
        ];

        $subjects = collect();
        foreach ($categories as $index => $category) {
            $subjectName = $subjectNames[$index];
            $subjects->push(Subject::query()->updateOrCreate(
                ['slug' => strtolower(str_replace(' ', '-', $category->name . ' ' . $subjectName))],
                [
                    'category_id' => $category->id,
                    'name' => $subjectName,
                    'description' => $category->name . ' ' . $subjectName . ' practice set.',
                    'status' => 'active',
                ]
            ));
        }

        $courses = collect();
        foreach ($categories as $index => $category) {
            $subject = $subjects[$index];
            $courses->push(Course::query()->updateOrCreate(
                ['slug' => strtolower(str_replace(' ', '-', $category->name . ' foundation course'))],
                [
                    'category_id' => $category->id,
                    'subject_id' => $subject->id,
                    'title' => $category->name . ' Foundation Course',
                    'description' => 'Structured preparation course for ' . $category->name . '.',
                    'level' => $index % 3 === 0 ? 'beginner' : ($index % 3 === 1 ? 'intermediate' : 'advanced'),
                    'status' => 'active',
                ]
            ));
        }

        $packageNames = [
            ['name' => 'Basic', 'price' => 9.99, 'duration_days' => 30, 'exam_limit' => 10],
            ['name' => 'Starter', 'price' => 14.99, 'duration_days' => 30, 'exam_limit' => 20],
            ['name' => 'Plus', 'price' => 19.99, 'duration_days' => 45, 'exam_limit' => 40],
            ['name' => 'Standard', 'price' => 24.99, 'duration_days' => 60, 'exam_limit' => 60],
            ['name' => 'Premium', 'price' => 29.99, 'duration_days' => 90, 'exam_limit' => 999],
            ['name' => 'Premium Plus', 'price' => 39.99, 'duration_days' => 120, 'exam_limit' => 999],
            ['name' => 'VIP', 'price' => 59.99, 'duration_days' => 180, 'exam_limit' => 999],
            ['name' => 'Elite', 'price' => 79.99, 'duration_days' => 240, 'exam_limit' => 999],
            ['name' => 'Pro', 'price' => 99.99, 'duration_days' => 300, 'exam_limit' => 999],
            ['name' => 'Annual', 'price' => 129.99, 'duration_days' => 365, 'exam_limit' => 999],
        ];

        foreach ($packageNames as $index => $packageData) {
            Package::query()->updateOrCreate(
                ['name' => $packageData['name']],
                [
                    'price' => $packageData['price'],
                    'duration_days' => $packageData['duration_days'],
                    'exam_limit' => $packageData['exam_limit'],
                    'features' => [
                        'Unlimited practice tests',
                        'Listening support',
                        'Detailed analytics',
                        'Bookmarks and review mode',
                    ],
                    'status' => 'active',
                ]
            );
        }

        $questionPrompts = [
            'Which section of IELTS is audio based?',
            'How many options are shown in a typical MCQ?',
            'What is the main purpose of a mock exam?',
            'Which feature lets students continue later?',
            'What file type is commonly used for listening audio?',
            'Which section measures vocabulary and grammar?',
            'What is used to show recent performance?',
            'Which module is used to message a teacher?',
            'What happens when a result is published?',
            'Which package feature is best for repeated practice?',
        ];

        foreach ($courses as $index => $course) {
            $exam = Exam::query()->updateOrCreate(
                ['course_id' => $course->id, 'title' => $course->title . ' Test ' . str_pad((string) ($index + 1), 2, '0', STR_PAD_LEFT)],
                [
                    'exam_type' => $index % 2 === 0 ? 'mock' : 'practice',
                    'duration_minutes' => 30 + ($index * 5),
                    'total_marks' => 100,
                    'pass_mark' => 40,
                    'question_count' => 1,
                    'start_at' => $now->copy()->addDays($index + 1),
                    'end_at' => $now->copy()->addDays($index + 2),
                    'random_questions' => true,
                    'random_options' => true,
                    'is_published' => true,
                ]
            );

            $question = Question::query()->updateOrCreate(
                ['exam_id' => $exam->id, 'prompt' => $questionPrompts[$index]],
                [
                    'course_id' => $course->id,
                    'type' => $index % 3 === 0 ? 'listening' : 'mcq',
                    'explanation' => 'This is a seeded explanation for test data.',
                    'difficulty_level' => $index % 3 === 0 ? 'easy' : ($index % 3 === 1 ? 'medium' : 'hard'),
                    'marks' => 1,
                    'audio_url' => $index % 3 === 0 ? 'https://example.com/audio/sample-' . ($index + 1) . '.mp3' : null,
                ]
            );

            foreach ([
                ['label' => 'A', 'text' => 'Option A ' . ($index + 1), 'is_correct' => false, 'sort_order' => 1],
                ['label' => 'B', 'text' => 'Option B ' . ($index + 1), 'is_correct' => $index % 2 === 0, 'sort_order' => 2],
                ['label' => 'C', 'text' => 'Option C ' . ($index + 1), 'is_correct' => false, 'sort_order' => 3],
                ['label' => 'D', 'text' => 'Option D ' . ($index + 1), 'is_correct' => false, 'sort_order' => 4],
            ] as $optionData) {
                QuestionOption::query()->updateOrCreate(
                    ['question_id' => $question->id, 'label' => $optionData['label']],
                    [
                        'text' => $optionData['text'],
                        'is_correct' => $optionData['is_correct'],
                        'sort_order' => $optionData['sort_order'],
                    ]
                );
            }
        }

        for ($index = 0; $index < 10; $index++) {
            $category = $categories[$index % $categories->count()];

            Enquiry::query()->updateOrCreate(
                [
                    'email' => 'student' . ($index + 1) . '@example.com',
                    'subject' => 'Exam question ' . ($index + 1),
                ],
                [
                    'name' => 'Student ' . str_pad((string) ($index + 1), 2, '0', STR_PAD_LEFT),
                    'message' => 'This is a sample enquiry message for testing the support flow.',
                    'category_id' => $category->id,
                    'status' => $index % 3 === 0 ? 'open' : ($index % 3 === 1 ? 'pending' : 'solved'),
                ]
            );
        }

        $contentItems = [
            ['section' => 'dashboard_stats', 'title' => 'Available Exams', 'subtitle' => '24', 'metadata' => ['icon' => 'assignment_turned_in', 'accent' => '#0EA5A4'], 'sort_order' => 1],
            ['section' => 'dashboard_stats', 'title' => 'Purchased Package', 'subtitle' => 'Premium', 'metadata' => ['icon' => 'workspace_premium', 'accent' => '#F97316'], 'sort_order' => 2],
            ['section' => 'dashboard_stats', 'title' => 'EPS Books', 'subtitle' => '10', 'metadata' => ['icon' => 'menu_book', 'accent' => '#14B8A6'], 'sort_order' => 3],
            ['section' => 'dashboard_stats', 'title' => 'All Courses', 'subtitle' => '10', 'metadata' => ['icon' => 'photo_library_outlined', 'accent' => '#6366F1'], 'sort_order' => 4],
            ['section' => 'notifications', 'title' => 'IELTS mock exam is live', 'subtitle' => '5m ago', 'body' => 'A new practice exam is ready for your batch.', 'metadata' => ['type' => 'exam'], 'sort_order' => 1],
            ['section' => 'notifications', 'title' => 'Teacher replied to your enquiry', 'subtitle' => '1h ago', 'body' => 'Your question about exam time limits has an update.', 'metadata' => ['type' => 'reply'], 'sort_order' => 2],
            ['section' => 'notifications', 'title' => 'Subscription expiring soon', 'subtitle' => 'Today', 'body' => 'Your premium package renews in 6 days.', 'metadata' => ['type' => 'billing'], 'sort_order' => 3],
            ['section' => 'results', 'title' => 'IELTS Mock Test 01', 'subtitle' => 'PASS', 'body' => 'Score: 84% - correct 42, wrong 6, skipped 2', 'metadata' => ['percentage' => 84, 'correct' => 42, 'wrong' => 6, 'skipped' => 2, 'status' => 'PASS'], 'sort_order' => 1],
            ['section' => 'leaderboard', 'title' => 'Aarav Shrestha', 'subtitle' => '98', 'body' => 'Fastest completion: 14:22', 'metadata' => ['rank' => 1, 'score' => 98, 'fastest_completion' => '14:22'], 'sort_order' => 1],
            ['section' => 'leaderboard', 'title' => 'Sita Karki', 'subtitle' => '95', 'body' => 'Fastest completion: 15:08', 'metadata' => ['rank' => 2, 'score' => 95, 'fastest_completion' => '15:08'], 'sort_order' => 2],
            ['section' => 'gallery', 'title' => 'Flutter Quick Start', 'subtitle' => 'ExamVerse Studio', 'body' => 'A beginner-friendly sample book for app onboarding and reading flow demo.', 'metadata' => ['category' => 'Programming', 'pages' => 84, 'asset_path' => 'lib/src/assets/sample_book.pdf', 'accent' => '#5B8DEF'], 'sort_order' => 1],
            ['section' => 'gallery', 'title' => 'Practice Test Guide', 'subtitle' => 'ExamVerse Studio', 'body' => 'A short handbook that mirrors the exam preparation experience.', 'metadata' => ['category' => 'Study Guide', 'pages' => 52, 'asset_path' => 'lib/src/assets/sample_book.pdf', 'accent' => '#00A8A8'], 'sort_order' => 2],
            ['section' => 'bookmarks', 'title' => 'IELTS Listening Question 3', 'subtitle' => 'Saved for later review', 'body' => null, 'metadata' => ['question_id' => 3], 'sort_order' => 1],
            ['section' => 'streak', 'title' => '14 day streak', 'subtitle' => 'Current streak', 'body' => 'Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed', 'metadata' => ['days' => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed']], 'sort_order' => 1],
            ['section' => 'certificates', 'title' => 'IELTS Mock Certificate - 84%', 'subtitle' => 'Downloadable achievement', 'body' => 'Certificate ready for download.', 'metadata' => ['download_url' => '#'], 'sort_order' => 1],
            ['section' => 'profile_badges', 'title' => 'Streak', 'subtitle' => '14 days', 'body' => null, 'metadata' => ['value' => '14 days'], 'sort_order' => 1],
            ['section' => 'profile_badges', 'title' => 'Accuracy', 'subtitle' => '86%', 'body' => null, 'metadata' => ['value' => '86%'], 'sort_order' => 2],
            ['section' => 'weekly_progress', 'title' => 'Mon', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.55], 'sort_order' => 1],
            ['section' => 'weekly_progress', 'title' => 'Tue', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.67], 'sort_order' => 2],
            ['section' => 'weekly_progress', 'title' => 'Wed', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.48], 'sort_order' => 3],
            ['section' => 'weekly_progress', 'title' => 'Thu', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.82], 'sort_order' => 4],
            ['section' => 'weekly_progress', 'title' => 'Fri', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.74], 'sort_order' => 5],
            ['section' => 'weekly_progress', 'title' => 'Sat', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.91], 'sort_order' => 6],
            ['section' => 'weekly_progress', 'title' => 'Sun', 'subtitle' => null, 'body' => null, 'metadata' => ['value' => 0.88], 'sort_order' => 7],
            ['section' => 'menu_shortcuts', 'title' => 'Settings', 'subtitle' => 'Open app settings', 'body' => null, 'metadata' => ['icon' => 'settings'], 'sort_order' => 1],
            ['section' => 'menu_shortcuts', 'title' => 'Downloads', 'subtitle' => 'Offline resources', 'body' => null, 'metadata' => ['icon' => 'download'], 'sort_order' => 2],
        ];

        foreach ($contentItems as $item) {
            ContentItem::query()->updateOrCreate(
                [
                    'section' => $item['section'],
                    'title' => $item['title'],
                ],
                [
                    'subtitle' => $item['subtitle'] ?? null,
                    'body' => $item['body'] ?? null,
                    'metadata' => $item['metadata'] ?? null,
                    'status' => 'active',
                    'sort_order' => $item['sort_order'] ?? 0,
                    'published_at' => $now,
                ]
            );
        }
    }
}
