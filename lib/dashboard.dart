import 'package:flutter/material.dart';
import 'package:hire_me/providers/nav_provider.dart';
import 'package:hire_me/sections/about/about_section.dart';
import 'package:hire_me/sections/contact/contact_section.dart';
import 'package:hire_me/sections/footer/footer_section.dart';
import 'package:hire_me/sections/hero/hero_section.dart';
import 'package:hire_me/sections/projects/projects_section.dart';
import 'package:hire_me/sections/skills/skills_section.dart';
import 'package:hire_me/topbar/topbar.dart';
import 'package:hire_me/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'core/app_colors.dart';
import 'data/projects_data.dart';
import 'data/skills_data.dart';

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

  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    final images = [
      'assets/profile/Frame.png',
      'assets/profile/logo1.png',
      ...kProjects.map((p) => p.image),
      ...kSkillCategories.expand((c) => c.skills.map((s) => s.assetPath)),
    ];

    try {
      await Future.wait(images.map((path) => precacheImage(AssetImage(path), context)));
    } catch (e) {
      debugPrint("Error precaching images: $e");
    }

    // Small extra delay for a professional feel
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

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
    if (_isLoading) {
      return LoadingScreen();
    }

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