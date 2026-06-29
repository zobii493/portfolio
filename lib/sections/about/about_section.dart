import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/widgets/animated_section.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      color: AppColors.backColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          AnimatedSection(
            visibilityKey: 'about-title',
            slideBegin: const Offset(0, 0.4),
            child: _buildSectionTitle(),
          ),
          const SizedBox(height: 60),
          if (isMobile)
            Column(
              children: [
                AnimatedSection(
                  visibilityKey: 'about-left',
                  slideBegin: const Offset(-0.2, 0.3),
                  child: _buildLeftContent(),
                ),
                const SizedBox(height: 40),
                AnimatedSection(
                  visibilityKey: 'about-right',
                  slideBegin: const Offset(0.2, 0.3),
                  delay: const Duration(milliseconds: 150),
                  child: _buildRightContent(),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AnimatedSection(
                    visibilityKey: 'about-left',
                    slideBegin: const Offset(-0.2, 0.3),
                    child: _buildLeftContent(),
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  child: AnimatedSection(
                    visibilityKey: 'about-right',
                    slideBegin: const Offset(0.2, 0.3),
                    delay: const Duration(milliseconds: 150),
                    child: _buildRightContent(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 60),
          AnimatedSection(
            visibilityKey: 'about-stats',
            slideBegin: const Offset(0, 0.4),
            delay: const Duration(milliseconds: 150),
            child: _buildStatsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() => Column(
    children: [
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
        ).createShader(b),
        child: Text(
          'About Me',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        width: 80,
        height: 4,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ],
  );

  Widget _buildLeftContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Passionate Flutter Developer',
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          height: 1.3,
        ),
      ),
      const SizedBox(height: 20),
      Text(
        "I'm a dedicated mobile app developer with a strong focus on creating beautiful, performant, and user-friendly applications. With expertise in Flutter and modern development practices, I transform ideas into reality.",
        style: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.8,
        ),
      ),
      const SizedBox(height: 30),
      _KeyPoint(
        icon: Icons.code,
        title: 'Clean Code Advocate',
        description:
            'I write maintainable, scalable code following best practices and design patterns.',
      ),
      const SizedBox(height: 20),
      _KeyPoint(
        icon: Icons.palette,
        title: 'UI/UX Focused',
        description:
            'Creating intuitive interfaces with smooth animations and delightful user experiences.',
      ),
      const SizedBox(height: 20),
      _KeyPoint(
        icon: Icons.speed,
        title: 'Performance Driven',
        description:
            'Optimizing apps for speed, efficiency, and seamless performance across devices.',
      ),
    ],
  );

  Widget _buildRightContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Experience & Education',
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 30),
      _TimelineItem(
        year: '2023 - Present',
        title: 'Flutter Developer',
        company: 'Self-driven Projects',
        description:
            'Building and deploying mobile & web applications independently, focusing on clean architecture, intuitive UI, and scalable solutions.',
        isActive: true,
      ),
      const SizedBox(height: 25),
      _TimelineItem(
        year: '2020 - 2024',
        title: 'Computer Science Degree',
        company: 'Kohat University Of Science & Technology',
        description:
            'Graduated with honors, specialized in mobile development and software engineering.',
        isEducation: true,
      ),
    ],
  );

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00F5FF).withValues(alpha: 0.05),
            const Color(0xFF0080FF).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00F5FF).withValues(alpha: 0.2)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final items = [
            _StatItem(
              number: '2+',
              label: 'Years Experience',
              icon: Icons.work_outline,
            ),
            _StatItem(
              number: '10+',
              label: 'Projects Completed',
              icon: Icons.apps,
            ),
            _StatItem(
              number: '5★',
              label: 'Client Rating',
              icon: Icons.star_outline,
            ),
            _StatItem(
              number: '100%',
              label: 'Client Satisfaction',
              icon: Icons.verified_outlined,
            ),
          ];
          return isMobile
              ? Column(
                  children:
                      items
                          .expand((w) => [w, const SizedBox(height: 30)])
                          .toList()
                        ..removeLast(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items,
                );
        },
      ),
    );
  }
}

// ── Sub widgets ───────────────────────────────────────────────

class _KeyPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _KeyPoint({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F5FF).withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _TimelineItem extends StatelessWidget {
  final String year, title, company, description;
  final bool isActive, isEducation;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.company,
    required this.description,
    this.isActive = false,
    this.isEducation = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isActive
                  ? const LinearGradient(
                      colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
                    )
                  : null,
              color: isActive ? null : const Color(0xFF2A2E45),
              border: Border.all(
                color: isActive
                    ? Colors.transparent
                    : const Color(0xFF00F5FF).withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00F5FF).withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          if (!isEducation)
            Container(width: 2, height: 80, color: const Color(0xFF2A2E45)),
        ],
      ),
      const SizedBox(width: 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                color: const Color(0xFF00F5FF),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              company,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF9D4EDD),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _StatItem extends StatelessWidget {
  final String number, label;
  final IconData icon;

  const _StatItem({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 900),
    curve: Curves.easeOutCubic,
    builder: (context, value, _) => Transform.scale(
      scale: 0.8 + value * 0.2,
      child: Opacity(
        opacity: value,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      const Color(0xFF00F5FF).withValues(alpha: 0.2),
                      const Color(0xFF00F5FF),
                      value,
                    )!,
                    Color.lerp(
                      const Color(0xFF0080FF).withValues(alpha: 0.2),
                      const Color(0xFF0080FF),
                      value,
                    )!,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F5FF).withValues(alpha: 0.3 * value),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
              ).createShader(b),
              child: Text(
                number,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
