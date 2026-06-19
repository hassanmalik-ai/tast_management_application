import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

/// Reusable button widget with multiple variants.
///
/// Variants:
/// - [AppButtonVariant.primary] — Filled primary color
/// - [AppButtonVariant.secondary] — Filled secondary color
/// - [AppButtonVariant.outlined] — Border only
/// - [AppButtonVariant.text] — Text only
/// - [AppButtonVariant.gradient] — Gradient background
enum AppButtonVariant { primary, secondary, outlined, text, gradient }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? AppConstants.radiusMd;
    final btnHeight = height ?? 52.0;

    switch (variant) {
      case AppButtonVariant.gradient:
        return _buildGradientButton(context, radius, btnHeight);
      case AppButtonVariant.outlined:
        return _buildOutlinedButton(context, radius, btnHeight);
      case AppButtonVariant.text:
        return _buildTextButton(context);
      case AppButtonVariant.secondary:
        return _buildFilledButton(context, radius, btnHeight,
            bgColor: theme.colorScheme.secondary,
            fgColor: theme.colorScheme.onSecondary);
      case AppButtonVariant.primary:
      default:
        return _buildFilledButton(context, radius, btnHeight,
            bgColor: theme.colorScheme.primary,
            fgColor: theme.colorScheme.onPrimary);
    }
  }

  Widget _buildGradientButton(
      BuildContext context, double radius, double btnHeight) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: btnHeight,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Center(child: _buildContent(Colors.white)),
        ),
      ),
    );
  }

  Widget _buildFilledButton(BuildContext context, double radius,
      double btnHeight,
      {required Color bgColor, required Color fgColor}) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: btnHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
        ),
        child: _buildContent(fgColor),
      ),
    );
  }

  Widget _buildOutlinedButton(
      BuildContext context, double radius, double btnHeight) {
    final theme = Theme.of(context);
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: btnHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          side: BorderSide(color: theme.colorScheme.outline),
        ),
        child: _buildContent(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildContent(theme.colorScheme.primary),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
