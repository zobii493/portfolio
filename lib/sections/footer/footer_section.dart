import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/core/app_utils.dart';
import 'package:hire_me/widgets/glow_button.dart';
import 'package:hire_me/widgets/pulsing_dot.dart';
import 'dart:html' as html;

class FooterSection extends StatefulWidget {
  final VoidCallback? letsTalk;
  final ValueChanged<int>? onNavTap;

  const FooterSection({super.key, this.letsTalk, this.onNavTap});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  final _navLinks = const [
    ('Home', 0),
    ('About', 1),
    ('Skills', 2),
    ('Projects', 3),
    ('Contact', 4),
  ];

  final _socials = const [
    _FooterSocial(
      FontAwesomeIcons.github,
      'GitHub',
      'https://github.com/zobii493',
      Color(0xFF6e5494),
    ),
    _FooterSocial(
      FontAwesomeIcons.linkedin,
      'LinkedIn',
      'https://www.linkedin.com/in/zohaibhassan3',
      Color(0xFF0A66C2),
    ),
    _FooterSocial(
      FontAwesomeIcons.envelope,
      'Email',
      'zobii493@gmail.com',
      Color(0xFF00C853),
    ),
  ];

  final _services = const [
    'Flutter App Development',
    'Responsive Web Apps',
    'UI/UX Implementation',
    'Firebase Integration',
    'REST API Integration',
    'App Performance Tuning',
  ];

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_topDivider(), _heroStrip(), _mainFooter(), _bottomBar()],
      ),
    );
  }

  Widget _topDivider() => AnimatedBuilder(
    animation: _glowCtrl,
    builder: (_, __) => Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primary.withOpacity(0.3 + _glowCtrl.value * 0.4),
            AppColors.secondary.withOpacity(0.5 + _glowCtrl.value * 0.3),
            AppColors.accent.withOpacity(0.3 + _glowCtrl.value * 0.4),
            Colors.transparent,
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
    ),
  );

  Widget _heroStrip() => LayoutBuilder(
    builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 48 : 72,
          horizontal: isMobile ? 24 : 40,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.surface.withOpacity(0.3),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulseBadge(ctrl: _glowCtrl),
                SizedBox(height: isMobile ? 20 : 28),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [
                      AppColors.text,
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(b),
                  child: Text(
                    "Have a Project\nIn Mind?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 34 : 52,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 18),
                Text(
                  isMobile
                      ? "Let's turn your idea into a beautiful product."
                      : "Let's collaborate and turn your idea into a beautiful,\nfunctional product that users will love.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 13 : 15,
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
                SizedBox(height: isMobile ? 28 : 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    GlowButton(
                      label: "Let's Talk",
                      icon: Icons.waving_hand_rounded,
                      filled: true,
                      onTap: widget.letsTalk,
                    ),
                    GlowButton(
                      label: 'Download CV',
                      icon: Icons.download_rounded,
                      filled: false,
                      onTap: downloadCV,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _mainFooter() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    color: const Color(0xFF030308),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final isWide = constraints.maxWidth > 720;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _brandCol()),
                  const SizedBox(width: 48),
                  Expanded(flex: 3, child: _navCol()),
                  const SizedBox(width: 48),
                  Expanded(flex: 4, child: _servicesCol()),
                  const SizedBox(width: 48),
                  Expanded(flex: 4, child: _socialCol()),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _brandCol(),
                const SizedBox(height: 44),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _navCol()),
                    const SizedBox(width: 32),
                    Expanded(child: _servicesCol()),
                  ],
                ),
                const SizedBox(height: 44),
                _socialCol(),
              ],
            );
          },
        ),
      ),
    ),
  );

  Widget _brandCol() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '</>',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ).createShader(b),
              child: Text(
                'Zohaib.dev',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      Text(
        'Flutter developer crafting beautiful, high-performance cross-platform applications with clean code and modern design.',
        style: GoogleFonts.inter(
          fontSize: 13.5,
          color: AppColors.textSecondary,
          height: 1.75,
        ),
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00C853).withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF00C853).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PulsingDot(color: const Color(0xFF00C853)),
            const SizedBox(width: 8),
            Text(
              'Available for freelance',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF00C853),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _navCol() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _colTitle('Navigation'),
      const SizedBox(height: 20),
      ..._navLinks.map(
        (e) => _FooterNavItem(label: e.$1, index: e.$2, onTap: widget.onNavTap),
      ),
    ],
  );

  Widget _servicesCol() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _colTitle('Services'),
      const SizedBox(height: 20),
      ..._services.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  s,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _socialCol() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _colTitle('Connect'),
      const SizedBox(height: 20),
      ..._socials.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _SocialCard(social: s),
        ),
      ),
    ],
  );

  Widget _colTitle(String title) => Row(
    children: [
      Container(
        width: 20,
        height: 2,
        color: AppColors.primary.withOpacity(0.7),
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          letterSpacing: 0.5,
        ),
      ),
    ],
  );

  Widget _bottomBar() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      color: const Color(0xFF020206),
    ),
    child: LayoutBuilder(
      builder: (ctx, constraints) {
        final isWide = constraints.maxWidth > 600;
        final left = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '© ${DateTime.now().year} ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ).createShader(b),
              child: Text(
                'Zohaib.dev',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              ' · All rights reserved',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ),
          ],
        );
        final right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Built with ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.flutter,
              color: AppColors.primary,
              size: 14,
            ),
            Text(
              ' Flutter & Dart ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.dartLang,
              color: AppColors.secondary,
              size: 12,
            ),
          ],
        );
        return isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [left, right],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [left, const SizedBox(height: 8), right],
              );
      },
    ),
  );
}

// ── Sub widgets ───────────────────────────────────────────────

class _PulseBadge extends StatelessWidget {
  final AnimationController? ctrl;

  const _PulseBadge({this.ctrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl ?? const AlwaysStoppedAnimation(0.5),
    builder: (_, __) {
      final v = ctrl?.value ?? 0.5;
      return LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 320;
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 10 : 18,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25 + v * 0.35),
              ),
              color: AppColors.primary.withOpacity(0.06 + v * 0.04),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1 + v * 0.12),
                  blurRadius: 20 + v * 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulsingDot(color: AppColors.primary),
                SizedBox(width: isNarrow ? 6 : 10),
                Flexible(
                  child: Text(
                    isNarrow
                        ? 'Open to opportunities'
                        : 'Open to new opportunities',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: isNarrow ? 9 : 11,
                      letterSpacing: isNarrow ? 0.5 : 1.5,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _FooterSocial {
  final IconData icon;
  final String label, handle;
  final Color color;

  const _FooterSocial(this.icon, this.label, this.handle, this.color);
}

class _FooterNavItem extends StatefulWidget {
  final String label;
  final int index;
  final ValueChanged<int>? onTap;

  const _FooterNavItem({required this.label, required this.index, this.onTap});

  @override
  State<_FooterNavItem> createState() => _FooterNavItemState();
}

class _FooterNavItemState extends State<_FooterNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: () => widget.onTap?.call(widget.index),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: _hovered ? AppColors.primary : AppColors.textSecondary,
            fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: _hovered ? 14 : 0,
                height: 1,
                color: AppColors.primary,
              ),
              if (_hovered) const SizedBox(width: 6),
              Flexible(child: Text(widget.label)),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SocialCard extends StatefulWidget {
  final _FooterSocial social;

  const _SocialCard({required this.social});

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _hovered = false;

  void _open() {
    final h = widget.social.handle;
    final url = h.contains('@') ? 'mailto:$h' : h;
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.social.color;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovered ? c.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: _hovered
                  ? c.withOpacity(0.45)
                  : Colors.white.withOpacity(0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: c.withOpacity(_hovered ? 0.2 : 0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: FaIcon(
                    widget.social.icon,
                    color: _hovered ? c : AppColors.textSecondary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.social.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _hovered ? c : AppColors.text,
                      ),
                    ),
                    Text(
                      widget.social.handle,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                color: _hovered ? c : Colors.transparent,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
