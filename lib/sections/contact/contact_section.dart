import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/core/app_utils.dart';
import 'package:hire_me/widgets/animated_section.dart';
import 'package:hire_me/widgets/glass_card.dart';
import 'package:hire_me/widgets/pulsing_dot.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.25),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _fade, curve: Curves.easeOutCubic));

  bool _isVisible = false;

  // Form
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _msgFocus = FocusNode();

  bool _nameFocused = false, _emailFocused = false, _msgFocused = false;
  bool _sending = false, _sent = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(
      () => setState(() => _nameFocused = _nameFocus.hasFocus),
    );
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
    _msgFocus.addListener(
      () => setState(() => _msgFocused = _msgFocus.hasFocus),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    _fade.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _msgFocus.dispose();
    super.dispose();
  }

  void _onVisible(VisibilityInfo info) {
    if (info.visibleFraction > 0.15 && !_isVisible && mounted) {
      _isVisible = true;
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _fade.forward();
      });
    }
  }

  Future<void> _handleSend() async {
    if (_nameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _msgCtrl.text.isEmpty)
      return;
    setState(() => _sending = true);
    try {
      final res = await http.post(
        Uri.parse('https://formspree.io/f/xqeyeerp'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': _nameCtrl.text,
          'email': _emailCtrl.text,
          'message': _msgCtrl.text,
        },
      );
      if (res.statusCode == 200) {
        setState(() => _sent = true);
        _nameCtrl.clear();
        _emailCtrl.clear();
        _msgCtrl.clear();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return VisibilityDetector(
          key: const Key('contact-section'),
          onVisibilityChanged: _onVisible,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.cardColor),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 80,
                    horizontal: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 920),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 56),
                          w > 640 ? _wideLayout() : _narrowLayout(),
                          const SizedBox(height: 60),
                          _buildDivider(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _wideLayout() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 4, child: _buildContactInfo()),
      const SizedBox(width: 36),
      Expanded(flex: 6, child: _buildForm()),
    ],
  );

  Widget _narrowLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [_buildContactInfo(), const SizedBox(height: 36), _buildForm()],
  );

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Container(
            width: 36,
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'GET IN TOUCH',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              letterSpacing: 4,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [AppColors.text, AppColors.primary, AppColors.secondary],
          stops: [0.0, 0.55, 1.0],
        ).createShader(b),
        child: Text(
          "Let's Work\nTogether",
          style: GoogleFonts.poppins(
            fontSize: 50,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(
        "Have a project in mind? I'd love to hear about it.\nLet's build something amazing together.",
        style: GoogleFonts.inter(
          fontSize: 15,
          color: AppColors.textSecondary,
          height: 1.65,
        ),
      ),
    ],
  );

  Widget _buildContactInfo() {
    final items = [
      _ContactInfo(
        Icons.alternate_email_rounded,
        'Email',
        'zobii493@gmail.com',
        AppColors.primary,
      ),
      _ContactInfo(
        Icons.phone_outlined,
        'Phone',
        '+92 341 9466773',
        AppColors.secondary,
      ),
      _ContactInfo(
        Icons.location_on_outlined,
        'Location',
        'Islamabad, Pakistan',
        AppColors.accent,
      ),
    ];
    final socials = [
      _SocialData(
        FontAwesomeIcons.github,
        'GitHub',
        AppColors.text,
        'https://github.com/zobii493',
      ),
      _SocialData(
        FontAwesomeIcons.linkedin,
        'LinkedIn',
        AppColors.secondary,
        'https://linkedin.com/in/zohaibhassan3',
      ),
      _SocialData(
        FontAwesomeIcons.whatsapp,
        'WhatsApp',
        AppColors.accent,
        'https://wa.me/923419466773',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _InfoCard(item: e),
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final btnSize = constraints.maxWidth < 300 ? 36.0 : 44.0;
            final iconSize = constraints.maxWidth < 300 ? 15.0 : 19.0;
            final spacing = constraints.maxWidth < 300 ? 6.0 : 10.0;
            return Row(
              children: socials
                  .map(
                    (s) => Padding(
                      padding: EdgeInsets.only(right: spacing),
                      child: _SocialBtn(
                        item: s,
                        size: btnSize,
                        iconSize: iconSize,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildForm() => GlassCard(
    borderRadius: 24,
    bgColor: AppColors.surface.withOpacity(0.45),
    borderColor: AppColors.primary.withOpacity(0.14),
    blurX: 16,
    blurY: 16,
    padding: const EdgeInsets.all(28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Send a Message',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'I typically reply within 24 hours.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 22),
        _field(
          _nameCtrl,
          _nameFocus,
          _nameFocused,
          'Your Name',
          Icons.person_outline_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 14),
        _field(
          _emailCtrl,
          _emailFocus,
          _emailFocused,
          'Email Address',
          Icons.alternate_email_rounded,
          AppColors.secondary,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _field(
          _msgCtrl,
          _msgFocus,
          _msgFocused,
          'Your Message',
          Icons.chat_bubble_outline_rounded,
          AppColors.accent,
          maxLines: 5,
        ),
        const SizedBox(height: 22),
        _sendButton(),
      ],
    ),
  );

  Widget _field(
    TextEditingController ctrl,
    FocusNode focus,
    bool isFocused,
    String label,
    IconData icon,
    Color accent, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.background.withOpacity(0.55),
      border: Border.all(
        color: isFocused ? accent.withOpacity(0.75) : accent.withOpacity(0.18),
        width: isFocused ? 1.5 : 1,
      ),
      boxShadow: isFocused
          ? [BoxShadow(color: accent.withOpacity(0.13), blurRadius: 18)]
          : [],
    ),
    child: TextField(
      controller: ctrl,
      focusNode: focus,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: AppColors.text, fontSize: 14),
      cursorColor: accent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: isFocused ? accent : AppColors.textSecondary,
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          color: isFocused ? accent : AppColors.textSecondary,
          size: 18,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
    ),
  );

  Widget _sendButton() => AnimatedBuilder(
    animation: _pulse,
    builder: (_, __) => Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25 + _pulse.value * 0.2),
            blurRadius: 20 + _pulse.value * 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _sending || _sent ? null : _handleSend,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _sent
                  ? [const Color(0xFF00C853), const Color(0xFF69F0AE)]
                  : [AppColors.primary, AppColors.secondary, AppColors.accent],
              stops: _sent ? null : [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _sending
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.2,
                    ),
                  )
                : _sent
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Message Sent!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send Message',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );

  Widget _buildDivider() => Row(
    children: [
      Expanded(
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '✦',
          style: TextStyle(
            color: AppColors.primary.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

// ── Data models ───────────────────────────────────────────────

class _ContactInfo {
  final IconData icon;
  final String label, value;
  final Color color;

  const _ContactInfo(this.icon, this.label, this.value, this.color);
}

class _SocialData {
  final IconData icon;
  final String label, url;
  final Color color;

  const _SocialData(this.icon, this.label, this.color, this.url);
}

class _InfoCard extends StatelessWidget {
  final _ContactInfo item;

  const _InfoCard({required this.item});

  @override
  Widget build(BuildContext context) => GlassCard(
    borderRadius: 16,
    bgColor: AppColors.surface.withOpacity(0.45),
    borderColor: item.color.withOpacity(0.2),
    blurX: 8,
    blurY: 8,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.22),
                item.color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: item.color.withOpacity(0.3)),
          ),
          child: Icon(item.icon, color: item.color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  letterSpacing: 2.5,
                  color: item.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SocialBtn extends StatefulWidget {
  final _SocialData item;
  final double size, iconSize;

  const _SocialBtn({required this.item, this.size = 44, this.iconSize = 19});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: () async => await launchUrl(
        Uri.parse(widget.item.url),
        mode: LaunchMode.externalApplication,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _hovered
              ? widget.item.color.withOpacity(0.15)
              : AppColors.surface.withOpacity(0.5),
          border: Border.all(
            color: _hovered
                ? widget.item.color.withOpacity(0.65)
                : AppColors.primary.withOpacity(0.12),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.item.color.withOpacity(0.22),
                    blurRadius: 14,
                  ),
                ]
              : [],
        ),
        child: Tooltip(
          message: widget.item.label,
          child: Center(
            child: FaIcon(
              widget.item.icon,
              color: _hovered ? widget.item.color : AppColors.textSecondary,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    ),
  );
}
