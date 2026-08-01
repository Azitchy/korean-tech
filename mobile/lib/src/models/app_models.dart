import 'package:flutter/material.dart';

class SummaryStat {
  const SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
}

class DashboardNotification {
  const DashboardNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.time,
  });

  factory DashboardNotification.fromJson(Map<String, dynamic> json) {
    return DashboardNotification(
      title: _string(json['title']) ?? '',
      body: _string(json['body']) ?? '',
      type: _string(_mapValue(json['metadata'])?['type']) ?? 'system',
      time:
          _string(json['subtitle']) ??
          _string(json['published_at']) ??
          'Just now',
    );
  }

  final String title;
  final String body;
  final String type;
  final String time;
}

class ExamCardData {
  const ExamCardData({
    required this.id,
    required this.title,
    required this.category,
    required this.mode,
    required this.duration,
    required this.questions,
    required this.score,
    required this.startsAt,
    required this.isLocked,
  });

  factory ExamCardData.fromJson(Map<String, dynamic> json) {
    final course = _mapValue(json['course']);
    final category = _mapValue(course?['category']);
    final type = _string(json['exam_type']) ?? 'practice';
    final startsAt = _string(json['start_at']);

    return ExamCardData(
      id: _int(json['id']) ?? 0,
      title: _string(json['title']) ?? 'Untitled exam',
      category:
          _string(category?['name']) ?? _string(course?['title']) ?? 'General',
      mode: _labelize(type),
      duration: '${_int(json['duration_minutes']) ?? 0} min',
      questions: _int(json['question_count']) ?? 0,
      score: _int(json['total_marks']) ?? 0,
      startsAt: startsAt == null ? 'Available now' : _formatDate(startsAt),
      isLocked: !(_bool(json['is_published']) ?? true),
    );
  }

  final int id;
  final String title;
  final String category;
  final String mode;
  final String duration;
  final int questions;
  final int score;
  final String startsAt;
  final bool isLocked;
}

class ExamOptionData {
  const ExamOptionData({
    required this.label,
    required this.text,
    required this.isCorrect,
  });

  factory ExamOptionData.fromJson(Map<String, dynamic> json) {
    return ExamOptionData(
      label: _string(json['label']) ?? '',
      text: _string(json['text']) ?? '',
      isCorrect: _bool(json['is_correct']) ?? false,
    );
  }

  final String label;
  final String text;
  final bool isCorrect;
}

class ExamQuestionData {
  const ExamQuestionData({required this.prompt, required this.options});

  factory ExamQuestionData.fromJson(Map<String, dynamic> json) {
    final options = _list(json['options'])
        .map(
          (item) => ExamOptionData.fromJson(
            _mapValue(item) ?? const <String, dynamic>{},
          ),
        )
        .toList();

    return ExamQuestionData(
      prompt: _string(json['prompt']) ?? '',
      options: options,
    );
  }

  final String prompt;
  final List<ExamOptionData> options;
}

class ExamDetailData {
  const ExamDetailData({required this.exam, required this.questions});

  final ExamCardData exam;
  final List<ExamQuestionData> questions;
}

class PackagePlan {
  const PackagePlan({
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    required this.isFeatured,
  });

  factory PackagePlan.fromJson(Map<String, dynamic> json) {
    final price = _double(json['price']) ?? 0;
    return PackagePlan(
      name: _string(json['name']) ?? '',
      price: '\$${price.toStringAsFixed(2)}',
      duration: '${_int(json['duration_days']) ?? 0} days',
      features: _list(json['features']).map((item) => item.toString()).toList(),
      isFeatured:
          (_string(json['status']) ?? '') == 'featured' ||
          (_string(json['name']) ?? '') == 'Premium',
    );
  }

  final String name;
  final String price;
  final String duration;
  final List<String> features;
  final bool isFeatured;
}

class ResultSnapshot {
  const ResultSnapshot({
    required this.title,
    required this.percentage,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.status,
  });

  final String title;
  final int percentage;
  final int correct;
  final int wrong;
  final int skipped;
  final String status;
}

class EnquiryThread {
  const EnquiryThread({
    required this.subject,
    required this.category,
    required this.status,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory EnquiryThread.fromJson(Map<String, dynamic> json) {
    final category = _mapValue(json['category']);
    return EnquiryThread(
      subject: _string(json['subject']) ?? '',
      category: _string(category?['name']) ?? 'General',
      status: _string(json['status']) ?? 'open',
      lastMessage:
          _string(json['teacher_reply']) ?? _string(json['message']) ?? '',
      updatedAt: _string(json['updated_at']) ?? 'Just now',
    );
  }

  final String subject;
  final String category;
  final String status;
  final String lastMessage;
  final String updatedAt;
}

class ProfileBadge {
  const ProfileBadge({required this.label, required this.value});

  factory ProfileBadge.fromJson(Map<String, dynamic> json) {
    return ProfileBadge(
      label: _string(json['title']) ?? '',
      value:
          _string(_mapValue(json['metadata'])?['value']) ??
          _string(json['subtitle']) ??
          '',
    );
  }

  final String label;
  final String value;
}

class PerformancePoint {
  const PerformancePoint({required this.label, required this.value});

  factory PerformancePoint.fromJson(Map<String, dynamic> json) {
    return PerformancePoint(
      label: _string(json['title']) ?? '',
      value: _double(_mapValue(json['metadata'])?['value']) ?? 0,
    );
  }

  final String label;
  final double value;
}

class ContentItemData {
  const ContentItemData({
    required this.id,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.metadata,
    required this.status,
    required this.sortOrder,
    required this.publishedAt,
  });

  factory ContentItemData.fromJson(Map<String, dynamic> json) {
    return ContentItemData(
      id: _int(json['id']) ?? 0,
      section: _string(json['section']) ?? '',
      title: _string(json['title']) ?? '',
      subtitle: _string(json['subtitle']),
      body: _string(json['body']),
      metadata: _mapValue(json['metadata']) ?? const <String, dynamic>{},
      status: _string(json['status']) ?? 'active',
      sortOrder: _int(json['sort_order']) ?? 0,
      publishedAt: _string(json['published_at']),
    );
  }

  final int id;
  final String section;
  final String title;
  final String? subtitle;
  final String? body;
  final Map<String, dynamic> metadata;
  final String status;
  final int sortOrder;
  final String? publishedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': section,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'metadata': metadata,
      'status': status,
      'sort_order': sortOrder,
      'published_at': publishedAt,
    };
  }
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.fastestCompletion,
  });

  factory LeaderboardEntry.fromContent(ContentItemData item) {
    return LeaderboardEntry(
      rank: _int(item.metadata['rank']) ?? item.sortOrder,
      name: item.title,
      score:
          _int(item.metadata['score']) ??
          int.tryParse(item.subtitle ?? '') ??
          0,
      fastestCompletion:
          _string(item.metadata['fastest_completion']) ??
          _string(item.body) ??
          '',
    );
  }

  final int rank;
  final String name;
  final int score;
  final String fastestCompletion;
}

class CourseSummaryData {
  const CourseSummaryData({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.category,
    required this.subject,
  });

  factory CourseSummaryData.fromJson(Map<String, dynamic> json) {
    final category = _mapValue(json['category']);
    final subject = _mapValue(json['subject']);
    return CourseSummaryData(
      id: _int(json['id']) ?? 0,
      title: _string(json['title']) ?? '',
      description: _string(json['description']) ?? '',
      level: _string(json['level']) ?? '',
      category: _string(category?['name']) ?? '',
      subject: _string(subject?['name']) ?? '',
    );
  }

  final int id;
  final String title;
  final String description;
  final String level;
  final String category;
  final String subject;
}

class CategorySummaryData {
  const CategorySummaryData({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.courseCount,
  });

  factory CategorySummaryData.fromJson(Map<String, dynamic> json) {
    return CategorySummaryData(
      id: _int(json['id']) ?? 0,
      name: _string(json['name']) ?? '',
      description: _string(json['description']) ?? '',
      status: _string(json['status']) ?? 'active',
      courseCount: _int(json['courses_count']) ?? 0,
    );
  }

  final int id;
  final String name;
  final String description;
  final String status;
  final int courseCount;
}

class DashboardSectionSummary {
  const DashboardSectionSummary({required this.section, required this.total});

  factory DashboardSectionSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSectionSummary(
      section: _string(json['section']) ?? '',
      total: _int(json['total']) ?? 0,
    );
  }

  final String section;
  final int total;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.summary,
    required this.categories,
    required this.upcomingExams,
    required this.featuredPackages,
    required this.notifications,
    required this.results,
    required this.leaderboard,
    required this.gallery,
    required this.bookmarks,
    required this.streak,
    required this.certificates,
    required this.profileBadges,
    required this.weeklyProgress,
    required this.menuShortcuts,
    required this.sections,
  });

  factory DashboardSnapshot.fromJson(Map<String, dynamic> json) {
    final summary = _mapValue(json['summary']) ?? const <String, dynamic>{};
    return DashboardSnapshot(
      summary: summary,
      categories: _list(json['categories'])
          .map(
            (item) => CategorySummaryData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      upcomingExams: _list(json['upcoming_exams'])
          .map(
            (item) => ExamCardData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      featuredPackages: _list(json['featured_packages'])
          .map(
            (item) => PackagePlan.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      notifications: _list(json['notifications'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      results: _list(json['results'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      leaderboard: _list(json['leaderboard'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      gallery: _list(json['gallery'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      bookmarks: _list(json['bookmarks'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      streak: _list(json['streak'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      certificates: _list(json['certificates'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      profileBadges: _list(_mapValue(json['profile'])?['badges'])
          .map(
            (item) => ProfileBadge.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      weeklyProgress: _list(json['weekly_progress'])
          .map(
            (item) => PerformancePoint.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      menuShortcuts: _list(json['menu'])
          .map(
            (item) => ContentItemData.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
      sections: _list(json['sections'])
          .map(
            (item) => DashboardSectionSummary.fromJson(
              _mapValue(item) ?? const <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }

  final Map<String, dynamic> summary;
  final List<CategorySummaryData> categories;
  final List<ExamCardData> upcomingExams;
  final List<PackagePlan> featuredPackages;
  final List<ContentItemData> notifications;
  final List<ContentItemData> results;
  final List<ContentItemData> leaderboard;
  final List<ContentItemData> gallery;
  final List<ContentItemData> bookmarks;
  final List<ContentItemData> streak;
  final List<ContentItemData> certificates;
  final List<ProfileBadge> profileBadges;
  final List<PerformancePoint> weeklyProgress;
  final List<ContentItemData> menuShortcuts;
  final List<DashboardSectionSummary> sections;
}

int? _int(dynamic value) {
  if (value is int) {
    return value;
  }
  return int.tryParse(value?.toString() ?? '');
}

double? _double(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '');
}

double? _decimal(dynamic value) => _double(value);

bool? _bool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  final text = value?.toString().toLowerCase();
  if (text == null) {
    return null;
  }
  if (text == 'true' || text == '1' || text == 'yes') {
    return true;
  }
  if (text == 'false' || text == '0' || text == 'no') {
    return false;
  }
  return null;
}

String? _string(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString();
  return text.isEmpty ? null : text;
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

List<dynamic> _list(dynamic value) {
  if (value is List) {
    return value;
  }
  return const [];
}

String _formatDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return value;
  }
  return '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')} '
      '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
}

String _labelize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}
