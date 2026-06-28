import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/data/skills_data.dart';
import 'package:hire_me/widgets/animated_section.dart';
import 'package:hire_me/widgets/glass_card.dart';
import 'package:hire_me/widgets/section_header.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final Animation<double> _fadeAnim = CurvedAnimation(
    parent: _fadeCtrl,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slideAnim = Tween<Offset>(
    begin: const Offset(0, 0.25),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));

  int _selectedCategory = 0;

  void _selectCategory(int i) {
    setState(() => _selectedCategory = i);
    _fadeCtrl.forward(from: 0);
  }

  @override
  void initState(){
    super.initState();
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSection(
      visibilityKey: 'skills_section',
      visibleFraction: 0.15,
      delay: const Duration(milliseconds: 150),
      child: Container(
        color: AppColors.cardColor,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SectionHeader(label: 'EXPERTISE', title: 'What I Do'),
            const SizedBox(height: 16),
            _buildSubtitle(),
            const SizedBox(height: 64),
            _buildTabBar(),
            const SizedBox(height: 40),
            _buildSkillGrid(),
            const SizedBox(height: 56),
            _buildQuoteCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 640),
    child: Text(
      'Flutter developer passionate about building cross-platform apps with smooth animations, clean architecture, and pixel-perfect UIs.',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: AppColors.textSecondary,
        height: 1.7,
      ),
    ),
  );

  Widget _buildTabBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final tabs = kSkillCategories
            .asMap()
            .entries
            .map(
              (e) => _SkillTab(
                index: e.key,
                category: e.value,
                isSelected: _selectedCategory == e.key,
                isWide: isWide,
                onTap: () => _selectCategory(e.key),
              ),
            )
            .toList();

        return isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tabs
                    .map(
                      (t) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: t,
                      ),
                    )
                    .toList(),
              )
            : Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: tabs,
              );
      },
    );
  }

  Widget _buildSkillGrid() {
    final cat = kSkillCategories[_selectedCategory];
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: cat.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: cat.color.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat.icon, color: cat.color, size: 14),
                  const SizedBox(width: 7),
                  Text(
                    cat.title,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      color: cat.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: cat.skills
                  .map((s) => _SkillCard(skill: s, accentColor: cat.color))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard() => GlassCard(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.format_quote_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              "I actively build web apps, mobile apps and pixel-perfect UIs. Truly passionate about my work, I always strive to raise the bar with every project. In my spare time I enjoy photography and exploring emerging technologies.",
              style: GoogleFonts.inter(
                fontSize: 14.5,
                color: AppColors.textSecondary,
                height: 1.75,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ── Sub widgets ───────────────────────────────────────────────

class _SkillTab extends StatelessWidget {
  final int index;
  final SkillCategory category;
  final bool isSelected, isWide;
  final VoidCallback onTap;

  const _SkillTab({
    required this.index,
    required this.category,
    required this.isSelected,
    required this.isWide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = category.color;
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          constraints: BoxConstraints(maxWidth: isWide ? 200 : 160),
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 18 : 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [c.withOpacity(0.25), c.withOpacity(0.08)],
                  )
                : null,
            color: isSelected ? null : AppColors.surface.withOpacity(0.4),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? c.withOpacity(0.7)
                  : Colors.white.withOpacity(0.08),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: c.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                color: isSelected ? c : AppColors.textSecondary,
                size: 15,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  category.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? c : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillItem skill;
  final Color accentColor;

  const _SkillCard({required this.skill, required this.accentColor});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.skill.color;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: _hovered ? c.withOpacity(0.1) : const Color(0xFF141424),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? c.withOpacity(0.6)
                : Colors.white.withOpacity(0.07),
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: c.withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: c.withOpacity(_hovered ? 0.18 : 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.withOpacity(_hovered ? 0.4 : 0.15)),
              ),
              child: Center(
                child: Image.asset(
                  widget.skill.assetPath,
                  width: 38,
                  height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.code_rounded, color: c, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.skill.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
                  color: _hovered ? Colors.white : AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
