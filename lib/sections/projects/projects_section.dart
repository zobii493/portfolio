import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/core/app_utils.dart';
import 'package:hire_me/data/projects_data.dart';
import 'package:hire_me/widgets/animated_section.dart';
import 'package:hire_me/widgets/glass_card.dart';
import 'package:hire_me/widgets/section_header.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < 600;
        final isTablet = w >= 600 && w < 1000;

        return Container(
          width: double.infinity,
          color: AppColors.backColor,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 32
                : 40,
            vertical: isMobile
                ? 60
                : isTablet
                ? 80
                : 100,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSection(
                visibilityKey: 'projects-header',
                child: SectionHeader(
                  label: 'PORTFOLIO',
                  title: 'My Projects',
                  titleSize: isMobile
                      ? 32
                      : isTablet
                      ? 40
                      : 48,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSection(
                visibilityKey: 'projects-subtitle',
                delay: const Duration(milliseconds: 200),
                child: _buildSubtitle(isMobile),
              ),
              SizedBox(height: isMobile ? 40 : 72),
              ..._buildProjectList(isMobile, isTablet),
              SizedBox(height: isMobile ? 40 : 60),
              AnimatedSection(
                visibilityKey: 'projects-cta',
                child: _buildBottomCTA(isMobile),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildProjectList(bool isMobile, bool isTablet) {
    final widgets = <Widget>[];
    for (int i = 0; i < kProjects.length; i++) {
      final imageOnLeft = isMobile ? true : i % 2 == 0;
      final slideBegin = isMobile
          ? const Offset(0, 0.3)
          : imageOnLeft
          ? const Offset(-0.15, 0.2)
          : const Offset(0.15, 0.2);

      widgets.add(
        AnimatedSection(
          visibilityKey: 'project-$i',
          slideBegin: slideBegin,
          child: _ProjectRow(
            project: kProjects[i],
            imageOnLeft: imageOnLeft,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ),
      );

      if (i < kProjects.length - 1) {
        widgets.add(SizedBox(height: isMobile ? 48 : 42));
      }
    }
    return widgets;
  }

  Widget _buildSubtitle(bool isMobile) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Turning Ideas into Real-World Applications',
        style: GoogleFonts.poppins(
          fontSize: isMobile ? 16 : 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Text(
          'A showcase of featured work where creativity meets clean architecture, performance, and modern user experience.',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 13 : 15,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );

  Widget _buildBottomCTA(bool isMobile) => GlassCard(
    padding: EdgeInsets.symmetric(
      horizontal: isMobile ? 16 : 36,
      vertical: isMobile ? 14 : 28,
    ),
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: isMobile ? 16 : 20,
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Text(
              'Want to see more? ',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => openLink('https://github.com/zobii493'),
          child: Text(
            'Visit my GitHub →',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Project Row ───────────────────────────────────────────────

class _ProjectRow extends StatelessWidget {
  final ProjectItem project;
  final bool imageOnLeft, isMobile, isTablet;

  const _ProjectRow({
    required this.project,
    required this.imageOnLeft,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [_image(), const SizedBox(height: 20), _info()],
      );
    }
    final img = Flexible(flex: 1, child: _image());
    final info = Flexible(flex: 1, child: _info());
    final gap = SizedBox(width: isTablet ? 24 : 28);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageOnLeft ? [img, gap, info] : [info, gap, img],
    );
  }

  Widget _image() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.surface,
    ),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          project.image,
          fit: BoxFit.cover,
          height: isMobile
              ? 220
              : isTablet
              ? 250
              : 280,
          width: double.infinity,
        ),
      ),
    ),
  );

  Widget _info() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: isMobile ? 0 : 16),
      Text(
        project.title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: isMobile
              ? 18
              : isTablet
              ? 20
              : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        project.description,
        maxLines: isMobile ? 4 : 3,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: isMobile ? 13 : 14,
          height: 1.6,
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: project.tags.map((t) => _tag(t)).toList(),
      ),
      const SizedBox(height: 16),
      _codeButton(),
    ],
  );

  Widget _tag(String label) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: AppColors.surface,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Text(
      label,
      style: GoogleFonts.inter(color: AppColors.accent, fontSize: 11),
    ),
  );

  Widget _codeButton() => InkWell(
    onTap: () => openLink(project.githubUrl),
    child: Container(
      height: isMobile ? 42 : 50,
      width: isMobile ? 90 : 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.accent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_rounded,
            color: AppColors.text,
            size: isMobile ? 16 : 20,
          ),
          const SizedBox(width: 6),
          Text(
            'Code',
            style: GoogleFonts.poppins(
              color: AppColors.text,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    ),
  );
}
