import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';

class GlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;
  final Color? labelColor;

  const GlowButton({
    super.key,
    required this.label,
    required this.icon,
    required this.filled,
    this.onTap,
    this.labelColor,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.filled
        ? Colors.black
        : (_hovered ? AppColors.primary : AppColors.textSecondary);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: widget.filled
                ? const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
              stops: [0.0, 0.5, 1.0],
            )
                : null,
            color: widget.filled ? null : Colors.transparent,
            border: Border.all(
              color: widget.filled
                  ? Colors.transparent
                  : AppColors.primary.withOpacity(_hovered ? 0.7 : 0.35),
              width: 1.5,
            ),
            boxShadow: widget.filled
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(_hovered ? 0.45 : 0.2),
                blurRadius: _hovered ? 28 : 14,
                spreadRadius: -4,
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: textColor, size: 17),
              const SizedBox(width: 9),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}