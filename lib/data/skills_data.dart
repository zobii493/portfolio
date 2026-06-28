import 'package:flutter/material.dart';

class SkillItem {
  final String name;
  final String assetPath;
  final Color color;

  const SkillItem({
    required this.name,
    required this.assetPath,
    required this.color,
  });
}

class SkillCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<SkillItem> skills;

  const SkillCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.skills,
  });
}

const kSkillCategories = [
  SkillCategory(
    title: 'Mobile Development',
    icon: Icons.phone_android_rounded,
    color: Color(0xFF00F5FF),
    skills: [
      SkillItem(name: 'Flutter',       assetPath: 'assets/skills/img.png',    color: Color(0xFF02569B)),
      SkillItem(name: 'Dart',          assetPath: 'assets/skills/img_1.png',  color: Color(0xFF0175C2)),
      SkillItem(name: 'Responsive UI', assetPath: 'assets/skills/img_3.png',  color: Color(0xFF8E24AA)),
      SkillItem(name: 'Animations',    assetPath: 'assets/skills/img_4.png',  color: Color(0xFFFF7043)),
      SkillItem(name: 'REST API',      assetPath: 'assets/skills/img_2.png',  color: Color(0xFF00BFA5)),
    ],
  ),
  SkillCategory(
    title: 'State Management',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF6C63FF),
    skills: [
      SkillItem(name: 'Provider', assetPath: 'assets/skills/provider.png', color: Color(0xFF42A5F5)),
      SkillItem(name: 'Riverpod', assetPath: 'assets/skills/img_5.png',    color: Color(0xFF00C853)),
      SkillItem(name: 'GetX',     assetPath: 'assets/skills/img_6.png',    color: Color(0xFF9C27B0)),
    ],
  ),
  SkillCategory(
    title: 'Backend & Database',
    icon: Icons.storage_rounded,
    color: Color(0xFF0080FF),
    skills: [
      SkillItem(name: 'Firebase',  assetPath: 'assets/skills/img_7.png',  color: Color(0xFFFFCA28)),
      SkillItem(name: 'Supabase',  assetPath: 'assets/skills/img_8.png',  color: Color(0xFF3ECF8E)),
      SkillItem(name: 'SQLite',    assetPath: 'assets/skills/img_9.png',  color: Color(0xFF003B57)),
      SkillItem(name: 'NoSQL',     assetPath: 'assets/skills/img_14.png', color: Color(0xFF4CAF50)),
    ],
  ),
  SkillCategory(
    title: 'Tools & Workflow',
    icon: Icons.build_rounded,
    color: Color(0xFFFF7043),
    skills: [
      SkillItem(name: 'Android Studio', assetPath: 'assets/skills/img_16.png', color: Color(0xFF3DDC84)),
      SkillItem(name: 'VS Code',        assetPath: 'assets/skills/img_13.png', color: Color(0xFF007ACC)),
      SkillItem(name: 'Figma',          assetPath: 'assets/skills/img_15.png', color: Color(0xFFF24E1E)),
      SkillItem(name: 'Git',            assetPath: 'assets/skills/img_10.png', color: Color(0xFFF05032)),
      SkillItem(name: 'GitHub',         assetPath: 'assets/skills/img_11.png', color: Color(0xFF6e5494)),
      SkillItem(name: 'Postman',        assetPath: 'assets/skills/img_12.png', color: Color(0xFFFF6C37)),
    ],
  ),
  SkillCategory(
    title: 'Integrations',
    icon: Icons.extension_rounded,
    color: Color(0xFF00C853),
    skills: [
      SkillItem(name: 'Cloudinary', assetPath: 'assets/skills/img_18.png', color: Color(0xFF3448C5)),
      SkillItem(name: 'OneSignal',  assetPath: 'assets/skills/img_17.png', color: Color(0xFFEF6C00)),
    ],
  ),
];