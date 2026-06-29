import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/core/app_utils.dart';
import 'package:hire_me/data/social_data.dart';
import 'package:hire_me/widgets/glow_button.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onHireMe;

  const HeroSection({super.key, this.onHireMe});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _orbitCtrl;
  late final AnimationController _typingCtrl;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _scaleAnim;

  final String _fullRole = "Flutter Developer";
  int _typedChars = 0;
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _typingCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _fullRole.length * 80 + 400),
    );

    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _scaleAnim = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack));

    _entryCtrl.forward();
    Future.delayed(const Duration(milliseconds: 600), _startTyping);
  }

  void _startTyping() {
    _typingCtrl.addListener(() {
      final newCount = (_typingCtrl.value * _fullRole.length).round();
      if (newCount != _typedChars) setState(() => _typedChars = newCount);
    });
    _typingCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), _blinkCursor);
  }

  void _blinkCursor() {
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showCursor = !_showCursor);
      _blinkCursor();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _glowCtrl.dispose();
    _orbitCtrl.dispose();
    _typingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isWide = w > 860;
        final isMid = w > 560;

        return Container(
          width: double.infinity,
          color: AppColors.cardColor,
          child: Stack(
            children: [
              Positioned.fill(child: _BackgroundLayer(ctrl: _glowCtrl)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide
                      ? 72
                      : isMid
                      ? 40
                      : 24,
                  vertical: isWide ? 80 : 60,
                ),
                child: isWide ? _wideLayout() : _narrowLayout(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _wideLayout() => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        flex: 55,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(position: _slideAnim, child: _textContent()),
        ),
      ),
      const SizedBox(width: 48),
      Expanded(
        flex: 45,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: FadeTransition(opacity: _fadeAnim, child: _profileImage()),
        ),
      ),
    ],
  );

  Widget _narrowLayout() => FadeTransition(
    opacity: _fadeAnim,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _profileImage(compact: true),
        const SizedBox(height: 36),
        _textContent(centered: true),
      ],
    ),
  );

  Widget _textContent({bool centered = false}) {
    final cross = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final align = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: cross,
      mainAxisSize: MainAxisSize.min,
      children: [
        _HelloBadge(glowCtrl: _glowCtrl),
        const SizedBox(height: 20),
        _AnimatedName(glowCtrl: _glowCtrl, textAlign: align),
        const SizedBox(height: 14),
        _TypingRole(
          typed: _fullRole.substring(0, _typedChars),
          showCursor: _showCursor,
          textAlign: align,
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            "I craft high-performance, scalable mobile & web apps with Flutter — "
            "focusing on clean architecture, smooth animations, and pixel-perfect UI.",
            textAlign: align,
            style: GoogleFonts.dmSans(
              fontSize: 15.5,
              color: AppColors.textSecondary,
              height: 1.75,
            ),
          ),
        ),
        const SizedBox(height: 30),
        _SocialRow(centered: centered),
        const SizedBox(height: 26),
        // CTA Buttons — GlowButton use kar rahe hain
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 12,
          children: [
            // Hire Me — custom gradient wala (GlowButton filled)
            _HireMeButton(glowCtrl: _glowCtrl, onTap: widget.onHireMe),
            GlowButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              filled: false,
              onTap: downloadCV,
            ),
          ],
        ),
      ],
    );
  }

  Widget _profileImage({bool compact = false}) {
    final size = compact ? 260.0 : 420.0;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 
                        0.07 + _glowCtrl.value * 0.06,
                      ),
                      AppColors.secondary.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _orbitCtrl,
              builder: (_, __) => Transform.rotate(
                angle: _orbitCtrl.value * 2 * math.pi,
                child: CustomPaint(
                  size: Size(size * 0.88, size * 0.88),
                  painter: _OrbitRingPainter(),
                ),
              ),
            ),
            Container(
              width: size * 0.75,
              height: size * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.secondary.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/profile/Frame.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surface,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary.withValues(alpha: 0.4),
                      size: size * 0.35,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: size * 0.08,
              right: size * 0.04,
              child: _FloatingTag(
                label: 'Flutter',
                icon: FontAwesomeIcons.flutter,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              bottom: size * 0.08,
              left: 0,
              child: _FloatingTag(
                label: '2+ Yrs Exp',
                icon: FontAwesomeIcons.solidStar,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub widgets (UI same) ─────────────────────────────────────

class _HelloBadge extends StatelessWidget {
  final AnimationController glowCtrl;

  const _HelloBadge({required this.glowCtrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: glowCtrl,
    builder: (_, __) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2 + glowCtrl.value * 0.25),
        ),
        color: AppColors.primary.withValues(alpha: 0.05 + glowCtrl.value * 0.04),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 
                    0.5 + glowCtrl.value * 0.3,
                  ),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Text(
            "Hello, I'm",
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    ),
  );
}

class _AnimatedName extends StatelessWidget {
  final AnimationController glowCtrl;
  final TextAlign textAlign;

  const _AnimatedName({required this.glowCtrl, required this.textAlign});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: glowCtrl,
    builder: (_, __) => ShaderMask(
      shaderCallback: (b) => LinearGradient(
        colors: [
          Color.lerp(
            AppColors.text,
            AppColors.primary,
            0.15 + glowCtrl.value * 0.1,
          )!,
          Color.lerp(AppColors.primary, AppColors.secondary, glowCtrl.value)!,
          Color.lerp(
            AppColors.secondary,
            AppColors.accent,
            1 - glowCtrl.value,
          )!,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(b),
      child: Text(
        'Zohaib Hassan',
        textAlign: textAlign,
        style: GoogleFonts.playfairDisplay(
          fontSize: 52,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.05,
          letterSpacing: -0.5,
        ),
      ),
    ),
  );
}

class _TypingRole extends StatelessWidget {
  final String typed;
  final bool showCursor;
  final TextAlign textAlign;

  const _TypingRole({
    required this.typed,
    required this.showCursor,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: textAlign == TextAlign.center
        ? Alignment.center
        : Alignment.centerLeft,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '< ',
          style: GoogleFonts.firaCode(
            fontSize: 20,
            color: AppColors.secondary.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          typed,
          style: GoogleFonts.firaCode(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 12),
            ],
          ),
        ),
        AnimatedOpacity(
          opacity: showCursor ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: Text(
            '|',
            style: GoogleFonts.firaCode(
              fontSize: 22,
              color: AppColors.primary,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Text(
          ' />',
          style: GoogleFonts.firaCode(
            fontSize: 20,
            color: AppColors.secondary.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _SocialRow extends StatelessWidget {
  final bool centered;

  const _SocialRow({required this.centered});

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: centered ? WrapAlignment.center : WrapAlignment.start,
    spacing: 10,
    runSpacing: 10,
    children: kSocials.map((s) => _SocialIcon(item: s)).toList(),
  );
}

class _SocialIcon extends StatefulWidget {
  final SocialItem item;

  const _SocialIcon({required this.item});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => openLink(widget.item.url),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: _hovered ? 14 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _hovered
              ? widget.item.color.withValues(alpha: 0.12)
              : AppColors.surface.withValues(alpha: 0.5),
          border: Border.all(
            color: _hovered
                ? widget.item.color.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.07),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.item.color.withValues(alpha: 0.2),
                    blurRadius: 14,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              widget.item.icon,
              size: 15,
              color: _hovered ? widget.item.color : AppColors.textSecondary,
            ),
            if (_hovered) ...[
              const SizedBox(width: 7),
              Text(
                widget.item.label,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: widget.item.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

// Hire Me button — glow animation wali (GlowButton se alag hai isliye alag rakhi)
class _HireMeButton extends StatefulWidget {
  final AnimationController glowCtrl;
  final VoidCallback? onTap;

  const _HireMeButton({required this.glowCtrl, this.onTap});

  @override
  State<_HireMeButton> createState() => _HireMeButtonState();
}

class _HireMeButtonState extends State<_HireMeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: widget.glowCtrl,
        builder: (_, __) {
          final gv = widget.glowCtrl.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(AppColors.primary, AppColors.secondary, gv)!,
                  Color.lerp(AppColors.secondary, AppColors.accent, gv)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 
                    _hovered ? 0.5 : 0.25 + gv * 0.15,
                  ),
                  blurRadius: _hovered ? 32 : 18,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.waving_hand_rounded,
                  color: Colors.black,
                  size: 17,
                ),
                const SizedBox(width: 9),
                Text(
                  'Hire Me',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

class _FloatingTag extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final Color color;

  const _FloatingTag({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: color, size: 13),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.firaCode(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _BackgroundLayer extends StatelessWidget {
  final AnimationController ctrl;

  const _BackgroundLayer({required this.ctrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) => CustomPaint(painter: _BgPainter(ctrl.value)),
  );
}

class _BgPainter extends CustomPainter {
  final double t;

  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
      }
    }
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.38,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.secondary.withValues(alpha: 0.07 + t * 0.05),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(size.width * 0.85, size.height * 0.15),
                radius: size.width * 0.38,
              ),
            ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.85),
      size.width * 0.3,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.accent.withValues(alpha: 0.05 + (1 - t) * 0.04),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(size.width * 0.1, size.height * 0.85),
                radius: size.width * 0.3,
              ),
            ),
    );
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.t != t;
}

class _OrbitRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dashLen = 8.0;
    const gapLen = 6.0;
    final count = (2 * math.pi * radius / (dashLen + gapLen)).floor();
    for (int i = 0; i < count; i++) {
      final startAngle = i * (dashLen + gapLen) / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLen / radius,
        false,
        paint,
      );
    }
    canvas.drawCircle(
      Offset(center.dx + radius, center.dy),
      4,
      Paint()
        ..color = AppColors.primary
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(_OrbitRingPainter old) => false;
}
