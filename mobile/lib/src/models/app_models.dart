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

  final String title;
  final String body;
  final String type;
  final String time;
}

class ExamCardData {
  const ExamCardData({
    required this.title,
    required this.category,
    required this.mode,
    required this.duration,
    required this.questions,
    required this.score,
    required this.startsAt,
    required this.isLocked,
  });

  final String title;
  final String category;
  final String mode;
  final String duration;
  final int questions;
  final int score;
  final String startsAt;
  final bool isLocked;
}

class PackagePlan {
  const PackagePlan({
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    required this.isFeatured,
  });

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

class PerformancePoint {
  const PerformancePoint({required this.label, required this.value});

  final String label;
  final double value;
}

class EnquiryThread {
  const EnquiryThread({
    required this.subject,
    required this.category,
    required this.status,
    required this.lastMessage,
    required this.updatedAt,
  });

  final String subject;
  final String category;
  final String status;
  final String lastMessage;
  final String updatedAt;
}

class ProfileBadge {
  const ProfileBadge({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
