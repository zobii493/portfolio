import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';
import 'package:hire_me/widgets/pulsing_dot.dart';
import 'package:provider/provider.dart';
import 'package:hire_me/providers/nav_provider.dart';

const _navItems = ['Home', 'About', 'Skills', 'Projects'];

class TopBarDelegate extends SliverPersistentHeaderDelegate {
  final double _height = 70;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const PortfolioTopBar();
  }

  @override
  bool shouldRebuild(TopBarDelegate old) => false;
}

class PortfolioTopBar extends StatefulWidget {
  final ValueChanged<int>? onNavTap;

  const PortfolioTopBar({super.key, this.onNavTap});

  @override
  State<PortfolioTopBar> createState() => _PortfolioTopBarState();
}

class _PortfolioTopBarState extends State<PortfolioTopBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider se activeIndex lo
    final activeIndex = context.watch<NavProvider>().activeIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 780;
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) => Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.82),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.primary.withOpacity(
                        0.08 + _glowCtrl.value * 0.10,
                      ),
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: isWide ? 48 : 24),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/profile/logo1.png',
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                    const Spacer(),
                    if (isWide) ...[
                      ..._navItems.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _NavItem(
                            label: e.value,
                            isActive: activeIndex == e.key,
                            onTap: () => widget.onNavTap?.call(e.key),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                      _HireMeBtn(
                        glowCtrl: _glowCtrl,
                        onTap: () => widget.onNavTap?.call(4),
                      ),
                    ],
                    if (!isWide)
                      _HamburgerBtn(
                        glowCtrl: _glowCtrl,
                        activeIndex: activeIndex,
                        onSelect: (i) => widget.onNavTap?.call(i),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Nav Item ──────────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: widget.isActive || _hovered
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: widget.isActive
                    ? AppColors.primary
                    : _hovered
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: widget.isActive ? 20 : (_hovered ? 10 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Hire Me Btn ───────────────────────────────────────────────

class _HireMeBtn extends StatefulWidget {
  final AnimationController glowCtrl;
  final VoidCallback? onTap;

  const _HireMeBtn({required this.glowCtrl, this.onTap});

  @override
  State<_HireMeBtn> createState() => _HireMeBtnState();
}

class _HireMeBtnState extends State<_HireMeBtn> {
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
        builder: (_, __) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                  AppColors.primary,
                  AppColors.secondary,
                  widget.glowCtrl.value,
                )!,
                Color.lerp(
                  AppColors.secondary,
                  AppColors.accent,
                  widget.glowCtrl.value,
                )!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(
                  _hovered ? 0.45 : 0.18 + widget.glowCtrl.value * 0.12,
                ),
                blurRadius: _hovered ? 24 : 14,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Text(
            'Hire Me',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}

// ── Hamburger ─────────────────────────────────────────────────

class _HamburgerBtn extends StatefulWidget {
  final AnimationController glowCtrl;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const _HamburgerBtn({
    required this.glowCtrl,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  State<_HamburgerBtn> createState() => _HamburgerBtnState();
}

class _HamburgerBtnState extends State<_HamburgerBtn> {
  OverlayEntry? _overlayEntry;

  void _open() {
    _overlayEntry = OverlayEntry(
      builder: (_) => _DrawerOverlay(
        activeIndex: widget.activeIndex,
        onSelect: (i) {
          _close();
          widget.onSelect(i);
        },
        onClose: _close,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _open,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: widget.glowCtrl,
        builder: (_, __) => Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: AppColors.surface.withOpacity(0.7),
            border: Border.all(
              color: AppColors.primary.withOpacity(
                0.15 + widget.glowCtrl.value * 0.15,
              ),
            ),
          ),
          child: const Icon(
            Icons.menu_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ),
    ),
  );
}

// ── Drawer Overlay ────────────────────────────────────────────

class _DrawerOverlay extends StatefulWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onClose;

  const _DrawerOverlay({
    required this.activeIndex,
    required this.onSelect,
    required this.onClose,
  });

  @override
  State<_DrawerOverlay> createState() => _DrawerOverlayState();
}

class _DrawerOverlayState extends State<_DrawerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  )..forward();

  void _close() async {
    await _ctrl.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Stack(
        children: [
          GestureDetector(
            onTap: _close,
            child: Container(
              color: Colors.black.withOpacity(0.5 * _ctrl.value),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
                  ),
              child: _MobileDrawer(
                activeIndex: widget.activeIndex,
                onSelect: widget.onSelect,
                onClose: _close,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ── Mobile Drawer ─────────────────────────────────────────────

class _MobileDrawer extends StatefulWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onClose;

  const _MobileDrawer({
    required this.activeIndex,
    required this.onSelect,
    required this.onClose,
  });

  @override
  State<_MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<_MobileDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _stagger = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  )..forward();

  @override
  void dispose() {
    _stagger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: 280,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.95),
          border: Border(
            left: BorderSide(
              color: AppColors.primary.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: AppColors.surface.withOpacity(0.6),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withOpacity(0.06)),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._navItems.asMap().entries.map((e) {
                        final delay = e.key * 0.1;
                        return AnimatedBuilder(
                          animation: _stagger,
                          builder: (_, __) {
                            final t = math.max(
                              0.0,
                              (_stagger.value - delay) / (1 - delay),
                            );
                            final curved = Curves.easeOutCubic.transform(
                              t.clamp(0.0, 1.0),
                            );
                            return Opacity(
                              opacity: curved,
                              child: Transform.translate(
                                offset: Offset(20 * (1 - curved), 0),
                                child: _DrawerNavItem(
                                  label: e.value,
                                  index: e.key,
                                  isActive: widget.activeIndex == e.key,
                                  onTap: () => widget.onSelect(e.key),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GestureDetector(
                          onTap: () {
                            widget.onSelect(4);
                            widget.onClose();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Hire Me',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xFF00C853).withOpacity(0.1),
                            border: Border.all(
                              color: const Color(0xFF00C853).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PulsingDot(color: const Color(0xFF00C853)),
                              const SizedBox(width: 8),
                              Text(
                                'Available for work',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF00C853),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ── Drawer Nav Item ───────────────────────────────────────────

class _DrawerNavItem extends StatefulWidget {
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DrawerNavItem> createState() => _DrawerNavItemState();
}

class _DrawerNavItemState extends State<_DrawerNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: widget.isActive
              ? AppColors.primary.withOpacity(0.1)
              : _hovered
              ? AppColors.surface.withOpacity(0.5)
              : Colors.transparent,
          border: Border.all(
            color: widget.isActive
                ? AppColors.primary.withOpacity(0.35)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: widget.isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surface.withOpacity(0.6),
              ),
              child: Center(
                child: Text(
                  '0${widget.index + 1}',
                  style: GoogleFonts.firaCode(
                    fontSize: 10,
                    color: widget.isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              widget.label,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                color: widget.isActive
                    ? AppColors.primary
                    : _hovered
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (widget.isActive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
