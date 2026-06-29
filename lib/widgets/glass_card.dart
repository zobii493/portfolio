import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hire_me/core/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? bgColor;
  final double blurX;
  final double blurY;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
    this.bgColor,
    this.blurX = 12,
    this.blurY = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.surface.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}