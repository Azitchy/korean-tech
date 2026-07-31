import 'package:flutter/material.dart';

import '../models/app_models.dart';

class MockExamRepository {
  MockExamRepository._();

  static final MockExamRepository instance = MockExamRepository._();

  final List<SummaryStat> _stats = const [
    SummaryStat(label: 'Available Exams', value: '24', icon: Icons.assignment_turned_in, accent: Color(0xFF0EA5A4)),
    SummaryStat(label: 'Purchased Package', value: 'Premium', icon: Icons.workspace_premium, accent: Color(0xFFF97316)),
    SummaryStat(label: 'EPS Books', value: '10', icon: Icons.menu_book, accent: Color(0xFF14B8A6)),
    SummaryStat(label: 'All Courses', value: '10', icon: Icons.photo_library_outlined, accent: Color(0xFF6366F1)),
  ];

  final List<DashboardNotification> _notifications = const [
    DashboardNotification(
      title: 'IELTS mock exam is live',
      body: 'A new practice exam is ready for your batch.',
      type: 'exam',
      time: '5m ago',
    ),
    DashboardNotification(
      title: 'Teacher replied to your enquiry',
      body: 'Your question about exam time limits has an update.',
      type: 'reply',
      time: '1h ago',
    ),
    DashboardNotification(
      title: 'Subscription expiring soon',
      body: 'Your premium package renews in 6 days.',
      type: 'billing',
      time: 'Today',
    ),
    DashboardNotification(
      title: 'New course unlocked',
      body: 'Banking aptitude lessons are now available.',
      type: 'content',
      time: 'Today',
    ),
    DashboardNotification(
      title: 'Daily quiz ready',
      body: 'Your practice quiz for today has been published.',
      type: 'exam',
      time: 'Today',
    ),
    DashboardNotification(
      title: 'Certificate generated',
      body: 'Your latest passing certificate is ready to download.',
      type: 'result',
      time: 'Yesterday',
    ),
    DashboardNotification(
      title: 'System maintenance',
      body: 'The app will have a brief maintenance window tonight.',
      type: 'system',
      time: 'Yesterday',
    ),
    DashboardNotification(
      title: 'Leaderboard updated',
      body: 'You moved up 3 places after your last exam.',
      type: 'ranking',
      time: '2 days ago',
    ),
    DashboardNotification(
      title: 'Teacher message',
      body: 'Your question explanation has been expanded.',
      type: 'reply',
      time: '2 days ago',
    ),
    DashboardNotification(
      title: 'Package offer',
      body: 'A seasonal discount is available for premium plans.',
      type: 'promotion',
      time: '3 days ago',
    ),
    DashboardNotification(
      title: 'Mock exam reminder',
      body: 'Your scheduled simulation starts tomorrow morning.',
      type: 'exam',
      time: '3 days ago',
    ),
  ];

  final List<ExamCardData> _exams = const [
    ExamCardData(
      title: 'IELTS Listening Practice 01',
      category: 'IELTS',
      mode: 'Listening',
      duration: '30 min',
      questions: 25,
      score: 100,
      startsAt: 'Tomorrow, 10:00 AM',
      isLocked: false,
    ),
    ExamCardData(
      title: 'TOEFL Quick Test',
      category: 'TOEFL',
      mode: 'MCQ',
      duration: '45 min',
      questions: 40,
      score: 120,
      startsAt: 'Friday, 04:00 PM',
      isLocked: false,
    ),
    ExamCardData(
      title: 'SAT Mixed Mock',
      category: 'SAT',
      mode: 'Adaptive',
      duration: '90 min',
      questions: 60,
      score: 200,
      startsAt: 'Locked by package',
      isLocked: true,
    ),
    ExamCardData(
      title: 'Government Jobs GK Test',
      category: 'Government Jobs',
      mode: 'MCQ',
      duration: '35 min',
      questions: 30,
      score: 100,
      startsAt: 'Monday, 09:00 AM',
      isLocked: false,
    ),
    ExamCardData(
      title: 'University Entrance Drill',
      category: 'University Exams',
      mode: 'MCQ',
      duration: '50 min',
      questions: 45,
      score: 120,
      startsAt: 'Wednesday, 01:00 PM',
      isLocked: false,
    ),
    ExamCardData(
      title: 'Language Course Level Check',
      category: 'Language Courses',
      mode: 'Listening',
      duration: '25 min',
      questions: 20,
      score: 80,
      startsAt: 'Thursday, 03:00 PM',
      isLocked: false,
    ),
    ExamCardData(
      title: 'GRE Quant Sprint',
      category: 'GRE',
      mode: 'Adaptive',
      duration: '60 min',
      questions: 40,
      score: 170,
      startsAt: 'Friday, 11:00 AM',
      isLocked: true,
    ),
    ExamCardData(
      title: 'GMAT Data Insights',
      category: 'GMAT',
      mode: 'MCQ',
      duration: '55 min',
      questions: 35,
      score: 200,
      startsAt: 'Saturday, 02:00 PM',
      isLocked: true,
    ),
    ExamCardData(
      title: 'Banking Aptitude Mock',
      category: 'Banking',
      mode: 'MCQ',
      duration: '40 min',
      questions: 35,
      score: 100,
      startsAt: 'Sunday, 10:30 AM',
      isLocked: false,
    ),
  ];

  final List<PackagePlan> _packages = const [
    PackagePlan(
      name: 'Basic',
      price: '\$9',
      duration: '30 days',
      features: ['10 exams', 'Results history', 'Bookmark practice'],
      isFeatured: false,
    ),
    PackagePlan(
      name: 'Premium',
      price: '\$29',
      duration: '90 days',
      features: ['Unlimited exams', 'Listening tests', 'Performance analytics'],
      isFeatured: true,
    ),
    PackagePlan(
      name: 'VIP',
      price: '\$79',
      duration: '365 days',
      features: ['Certificates', 'Mock events', 'Priority support'],
      isFeatured: false,
    ),
    PackagePlan(
      name: 'Starter Plus',
      price: '\$12',
      duration: '15 days',
      features: ['5 exams', 'Bookmark practice', 'Result history'],
      isFeatured: false,
    ),
    PackagePlan(
      name: 'Exam Bundle',
      price: '\$18',
      duration: '30 days',
      features: ['20 exams', 'Audio questions', 'Review mode'],
      isFeatured: false,
    ),
    PackagePlan(
      name: 'Coach',
      price: '\$34',
      duration: '90 days',
      features: ['Teacher replies', 'Performance charts', 'Weekly ranking'],
      isFeatured: true,
    ),
    PackagePlan(
      name: 'Scholar',
      price: '\$49',
      duration: '120 days',
      features: ['Certificates', 'Offline notes', 'Practice simulation'],
      isFeatured: false,
    ),
    PackagePlan(
      name: 'Master',
      price: '\$59',
      duration: '180 days',
      features: ['Unlimited attempts', 'Daily quiz', 'Adaptive tests'],
      isFeatured: false,
    ),
    PackagePlan(
      name: 'Annual Pro',
      price: '\$129',
      duration: '365 days',
      features: ['Full access', 'Mock exams', 'Priority support'],
      isFeatured: false,
    ),
  ];

  final List<ResultSnapshot> _results = const [
    ResultSnapshot(title: 'IELTS Mock Test 01', percentage: 84, correct: 42, wrong: 6, skipped: 2, status: 'PASS'),
    ResultSnapshot(title: 'TOEFL Practice 04', percentage: 76, correct: 38, wrong: 8, skipped: 4, status: 'PASS'),
    ResultSnapshot(title: 'SAT Mini Quiz', percentage: 61, correct: 25, wrong: 10, skipped: 5, status: 'REVIEW'),
    ResultSnapshot(title: 'Government Jobs GK Test', percentage: 88, correct: 44, wrong: 4, skipped: 2, status: 'PASS'),
    ResultSnapshot(title: 'University Entrance Drill', percentage: 72, correct: 36, wrong: 9, skipped: 5, status: 'PASS'),
    ResultSnapshot(title: 'Language Level Check', percentage: 67, correct: 27, wrong: 8, skipped: 5, status: 'REVIEW'),
    ResultSnapshot(title: 'GRE Quant Sprint', percentage: 79, correct: 31, wrong: 7, skipped: 2, status: 'PASS'),
    ResultSnapshot(title: 'GMAT Data Insights', percentage: 74, correct: 30, wrong: 10, skipped: 0, status: 'PASS'),
    ResultSnapshot(title: 'Banking Aptitude Mock', percentage: 83, correct: 33, wrong: 5, skipped: 2, status: 'PASS'),
    ResultSnapshot(title: 'Daily Practice Quiz', percentage: 91, correct: 18, wrong: 1, skipped: 1, status: 'PASS'),
  ];

  final List<EnquiryThread> _enquiries = const [
    EnquiryThread(
      subject: 'Can I resume after network loss?',
      category: 'Exam support',
      status: 'Answered',
      lastMessage: 'Yes, your answers auto-save while you are online.',
      updatedAt: '2h ago',
    ),
    EnquiryThread(
      subject: 'How do I download a certificate?',
      category: 'Certificate',
      status: 'Open',
      lastMessage: 'Please check your result page after passing the exam.',
      updatedAt: 'Yesterday',
    ),
    EnquiryThread(
      subject: 'How do I purchase a package?',
      category: 'Billing',
      status: 'Answered',
      lastMessage: 'You can buy a plan from the packages screen.',
      updatedAt: 'Yesterday',
    ),
    EnquiryThread(
      subject: 'Where are the listening files?',
      category: 'Listening',
      status: 'Open',
      lastMessage: 'Audio files are attached to each listening question.',
      updatedAt: '2 days ago',
    ),
    EnquiryThread(
      subject: 'Can I change my profile photo?',
      category: 'Profile',
      status: 'Answered',
      lastMessage: 'Yes, open profile settings and update the avatar.',
      updatedAt: '2 days ago',
    ),
    EnquiryThread(
      subject: 'How is leaderboard rank calculated?',
      category: 'Ranking',
      status: 'Open',
      lastMessage: 'Rank is based on score and completion time.',
      updatedAt: '3 days ago',
    ),
    EnquiryThread(
      subject: 'Why is my exam locked?',
      category: 'Package',
      status: 'Answered',
      lastMessage: 'Some tests require a higher tier package.',
      updatedAt: '3 days ago',
    ),
    EnquiryThread(
      subject: 'Can I practice offline?',
      category: 'Downloads',
      status: 'Open',
      lastMessage: 'Offline downloads are available for notes and audio.',
      updatedAt: '4 days ago',
    ),
    EnquiryThread(
      subject: 'How do I report a question?',
      category: 'Support',
      status: 'Answered',
      lastMessage: 'Use the question report button during review mode.',
      updatedAt: '4 days ago',
    ),
    EnquiryThread(
      subject: 'Do certificates expire?',
      category: 'Certificate',
      status: 'Open',
      lastMessage: 'Certificates stay in your profile for download anytime.',
      updatedAt: '5 days ago',
    ),
  ];

  final List<ProfileBadge> _badges = const [
    ProfileBadge(label: 'Streak', value: '14 days'),
    ProfileBadge(label: 'Accuracy', value: '86%'),
    ProfileBadge(label: 'Courses', value: '4 active'),
    ProfileBadge(label: 'Bookmarks', value: '18 saved'),
    ProfileBadge(label: 'Certificates', value: '3 earned'),
    ProfileBadge(label: 'Mock Tests', value: '27 taken'),
    ProfileBadge(label: 'Listening', value: '92%'),
    ProfileBadge(label: 'MCQ', value: '88%'),
    ProfileBadge(label: 'Rank', value: '#12'),
    ProfileBadge(label: 'Payments', value: '2 active'),
  ];

  final List<PerformancePoint> _weeklyProgress = const [
    PerformancePoint(label: 'Mon', value: 0.55),
    PerformancePoint(label: 'Tue', value: 0.67),
    PerformancePoint(label: 'Wed', value: 0.48),
    PerformancePoint(label: 'Thu', value: 0.82),
    PerformancePoint(label: 'Fri', value: 0.74),
    PerformancePoint(label: 'Sat', value: 0.91),
    PerformancePoint(label: 'Sun', value: 0.88),
    PerformancePoint(label: 'W1', value: 0.62),
    PerformancePoint(label: 'W2', value: 0.71),
    PerformancePoint(label: 'W3', value: 0.78),
  ];

  Future<List<SummaryStat>> loadStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _stats;
  }

  Future<List<DashboardNotification>> loadNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _notifications;
  }

  Future<List<ExamCardData>> loadExams() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _exams;
  }

  Future<List<PackagePlan>> loadPackages() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _packages;
  }

  Future<List<ResultSnapshot>> loadResults() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _results;
  }

  Future<List<EnquiryThread>> loadEnquiries() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _enquiries;
  }

  Future<List<ProfileBadge>> loadBadges() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _badges;
  }

  Future<List<PerformancePoint>> loadWeeklyProgress() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _weeklyProgress;
  }
}
