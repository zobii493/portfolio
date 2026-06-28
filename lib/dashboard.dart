import 'package:flutter/material.dart';
import 'package:hire_me/providers/nav_provider.dart';
import 'package:hire_me/sections/about/about_section.dart';
import 'package:hire_me/sections/contact/contact_section.dart';
import 'package:hire_me/sections/footer/footer_section.dart';
import 'package:hire_me/sections/hero/hero_section.dart';
import 'package:hire_me/sections/projects/projects_section.dart';
import 'package:hire_me/sections/skills/skills_section.dart';
import 'package:hire_me/topbar/topbar.dart';
import 'package:provider/provider.dart';
import 'core/app_colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scrollController = ScrollController();

  final _heroKey     = GlobalKey();
  final _aboutKey    = GlobalKey();
  final _skillsKey   = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey  = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNavTap(int index) {
    context.read<NavProvider>().setIndex(index);
    switch (index) {
      case 0: _scrollTo(_heroKey);     break;
      case 1: _scrollTo(_aboutKey);    break;
      case 2: _scrollTo(_skillsKey);   break;
      case 3: _scrollTo(_projectsKey); break;
      case 4: _scrollTo(_contactKey);  break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(10),
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    HeroSection(key: _heroKey,   onHireMe: () => _onNavTap(4)),
                    AboutSection(key: _aboutKey),
                    SkillsSection(key: _skillsKey),
                    ProjectsSection(key: _projectsKey),
                    ContactSection(key: _contactKey),
                    FooterSection(
                      letsTalk: () => _onNavTap(4),
                      onNavTap: _onNavTap,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: PortfolioTopBar(onNavTap: _onNavTap),
          ),
        ],
      ),
    );
  }
}