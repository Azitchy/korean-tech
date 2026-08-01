import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../models/gallery_book.dart';
import 'api_service.dart';

class ExamRepository {
  ExamRepository._();

  static final ExamRepository instance = ExamRepository._();

  final ApiService _api = ApiService();

  Future<List<SummaryStat>> loadStats() async {
    final dashboard = await _dashboard();
    final summary = _map(dashboard['summary']);

    return [
      SummaryStat(
        label: 'Users',
        value: '${_int(summary['users']) ?? 0}',
        icon: Icons.people_outline,
        accent: const Color(0xFF0EA5A4),
      ),
      SummaryStat(
        label: 'Categories',
        value: '${_int(summary['categories']) ?? 0}',
        icon: Icons.layers_outlined,
        accent: const Color(0xFFF97316),
      ),
      SummaryStat(
        label: 'Subjects',
        value: '${_int(summary['subjects']) ?? 0}',
        icon: Icons.book_outlined,
        accent: const Color(0xFF14B8A6),
      ),
      SummaryStat(
        label: 'Courses',
        value: '${_int(summary['courses']) ?? 0}',
        icon: Icons.menu_book,
        accent: const Color(0xFF6366F1),
      ),
      SummaryStat(
        label: 'Packages',
        value: '${_int(summary['packages']) ?? 0}',
        icon: Icons.workspace_premium,
        accent: const Color(0xFFF97316),
      ),
      SummaryStat(
        label: 'Exams',
        value: '${_int(summary['exams']) ?? 0}',
        icon: Icons.assignment_turned_in,
        accent: const Color(0xFF0EA5A4),
      ),
      SummaryStat(
        label: 'Enquiries',
        value: '${_int(summary['enquiries']) ?? 0}',
        icon: Icons.forum_outlined,
        accent: const Color(0xFFEC4899),
      ),
      SummaryStat(
        label: 'Mobile Items',
        value: '${_int(summary['mobile_items']) ?? 0}',
        icon: Icons.phone_android_outlined,
        accent: const Color(0xFF14B8A6),
      ),
    ];
  }

  Future<List<DashboardNotification>> loadNotifications() async {
    final items = await loadSectionItems('notifications');
    return items.map((item) => DashboardNotification.fromJson(item.toJson())).toList();
  }

  Future<List<ExamCardData>> loadExams() async {
    final exams = await _loadExams('/exams?exclude_exam_type=audio');
    return exams.map(ExamCardData.fromJson).toList();
  }

  Future<List<ExamCardData>> loadAudioExams() async {
    final exams = await _loadExams('/exams?exam_type=audio');
    return exams.map(ExamCardData.fromJson).toList();
  }

  Future<ExamDetailData> loadExamDetail(int examId) async {
    final response = await _api.getJson('/exams/$examId');
    final data = _map(response['data']);
    final exam = ExamCardData.fromJson(data);
    final questions = _items(data['questions'])
        .map((item) => ExamQuestionData.fromJson(_map(item)))
        .toList();

    return ExamDetailData(exam: exam, questions: questions);
  }

  Future<List<PackagePlan>> loadPackages() async {
    final packages = await _api.getList('/packages');
    return packages.cast<Map<String, dynamic>>().map(PackagePlan.fromJson).toList();
  }

  Future<List<ResultSnapshot>> loadResults() async {
    final items = await loadSectionItems('results');
    return items
        .map((item) {
          final metadata = item.metadata;
          return ResultSnapshot(
            title: item.title,
            percentage: _int(metadata['percentage']) ?? 0,
            correct: _int(metadata['correct']) ?? 0,
            wrong: _int(metadata['wrong']) ?? 0,
            skipped: _int(metadata['skipped']) ?? 0,
            status: _string(metadata['status']) ?? item.subtitle ?? 'PASS',
          );
        })
        .toList();
  }

  Future<List<EnquiryThread>> loadEnquiries() async {
    final enquiries = await _api.getList('/enquiries');
    return enquiries.cast<Map<String, dynamic>>().map(EnquiryThread.fromJson).toList();
  }

  Future<List<ProfileBadge>> loadBadges() async {
    final items = await loadSectionItems('profile_badges');
    return items.map((item) => ProfileBadge(label: item.title, value: item.subtitle ?? '')).toList();
  }

  Future<List<PerformancePoint>> loadWeeklyProgress() async {
    final items = await loadSectionItems('weekly_progress');
    return items.map((item) => PerformancePoint.fromJson(item.toJson())).toList();
  }

  Future<List<GalleryBook>> loadGalleryBooks() async {
    final items = await loadSectionItems('gallery');
    return items.map(GalleryBook.fromContentItem).toList();
  }

  Future<List<CourseSummaryData>> loadCourses() async {
    final courses = await _api.getList('/courses');
    return courses.cast<Map<String, dynamic>>().map(CourseSummaryData.fromJson).toList();
  }

  Future<List<ContentItemData>> loadBookmarks() => loadSectionItems('bookmarks');

  Future<List<ContentItemData>> loadStreakItems() => loadSectionItems('streak');

  Future<List<ContentItemData>> loadCertificates() => loadSectionItems('certificates');

  Future<List<LeaderboardEntry>> loadLeaderboard() async {
    final items = await loadSectionItems('leaderboard');
    return items.map(LeaderboardEntry.fromContent).toList();
  }

  Future<List<ContentItemData>> loadMenuShortcuts() => loadSectionItems('menu_shortcuts');

  Future<List<ContentItemData>> loadSectionItems(String section) async {
    final response = await _api.getJson('/mobile/content/$section');
    return _items(response['data']).map((item) => ContentItemData.fromJson(_map(item))).toList();
  }

  Future<void> submitEnquiry({
    required String name,
    required String email,
    required String subject,
    required String message,
    int? categoryId,
  }) async {
    await _api.postJson(
      '/enquiries',
      {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        if (categoryId != null) 'category_id': categoryId,
      },
    );
  }

  Future<List<Map<String, dynamic>>> _loadExams([String path = '/exams']) async {
    final items = await _api.getList(path);
    return items.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> _dashboard() async {
    final response = await _api.getJson('/dashboard');
    return _map(response);
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  List<dynamic> _items(dynamic value) {
    if (value is List) {
      return value;
    }
    return const [];
  }

  int? _int(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '');
  }

  String? _string(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString();
    return text.isEmpty ? null : text;
  }
}
