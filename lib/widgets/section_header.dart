import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/core/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String label;      // e.g. 'EXPERTISE'
  final String title;      // e.g. 'What I Do'
  final double titleSize;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.titleSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with lines
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _line(),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                letterSpacing: 4,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            _line(reverse: true),
          ],
        ),
        const SizedBox(height: 20),
        // Gradient title
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.text, AppColors.primary, AppColors.secondary],
            stops: [0.0, 0.55, 1.0],
          ).createShader(b),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: titleSize,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Underline bar
        Container(
          width: 70,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _line({bool reverse = false}) => Container(
    width: 36,
    height: 2,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: reverse
            ? [AppColors.secondary, AppColors.primary]
            : [AppColors.primary, AppColors.secondary],
      ),
    ),
  );
}