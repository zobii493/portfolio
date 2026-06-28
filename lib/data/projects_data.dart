import 'package:flutter/material.dart';
import 'package:hire_me/core/app_colors.dart';

class ProjectItem {
  final String title;
  final String description;
  final String image;
  final String githubUrl;
  final String liveUrl;
  final List<String> tags;
  final Color accentColor;

  const ProjectItem({
    required this.title,
    required this.description,
    required this.image,
    required this.githubUrl,
    required this.liveUrl,
    this.tags = const [],
    this.accentColor = AppColors.primary,
  });
}

const kProjects = [
  ProjectItem(
    title: 'KistFlow – Installment Management App',
    description:
    'Built a Flutter-based installment management app that allows users to manage customer records, track payments, monitor dues, and securely store data using Firebase.',
    image: 'assets/projects/kistflow.png',
    githubUrl: 'https://github.com/zobii493/KistFlow',
    liveUrl: '',
    tags: ['Flutter', 'Dart', 'Firebase', 'Riverpod'],
    accentColor: Color(0xFF00F5FF),
  ),
  ProjectItem(
    title: 'MosquePro – Mosque Management System',
    description:
    'Developed a mosque management app that enables admins to manage prayer timings, announcements, funds, bills, and send notifications to mosque members.',
    image: 'assets/projects/mosquepro.png',
    githubUrl: 'https://github.com/zobii493/mosque_management_system',
    liveUrl: '',
    tags: ['Flutter', 'Firebase', 'OneSignal', 'Provider'],
    accentColor: Color(0xFF6C63FF),
  ),
  ProjectItem(
    title: 'Zikar Notebook – Islamic Tracking App',
    description:
    'Created an Islamic app for tracking daily, weekly, and total Zikar counts, helping users monitor and maintain their spiritual activities.',
    image: 'assets/projects/zikarnotebook.png',
    githubUrl: 'https://github.com/zobii493/zikar_notebook',
    liveUrl: '',
    tags: ['Flutter', 'Dart', 'Firebase', 'Provider'],
    accentColor: Color(0xFF00C853),
  ),
];