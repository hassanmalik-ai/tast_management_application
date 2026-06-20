import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Error / 404 screen with illustration and retry action.
class ErrorScreen extends StatelessWidget {
  final String errorType;

  const ErrorScreen({super.key, required this.errorType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNotFound = errorType == 'notFound';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error illustration
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: isNotFound
                      ? AppColors.warningGradient
                      : AppColors.errorGradient,
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [
                    BoxShadow(
                      color: (isNotFound
                              ? AppColors.warning
                              : AppColors.error)
                          .withOpacity(0.25),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Icon(
                  isNotFound
                      ? Icons.search_off_rounded
                      : Icons.wifi_off_rounded,
                  size: 72,
                  color: Colors.white.withOpacity(0.9),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),

              const SizedBox(height: AppConstants.spacing4xl),

              // Title
              Text(
                isNotFound ? 'Page Not Found' : 'No Connection',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

              const SizedBox(height: AppConstants.spacingMd),

              // Subtitle
              Text(
                isNotFound
                    ? "The page you're looking for doesn't exist or has been moved."
                    : 'Please check your internet connection and try again.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

              const SizedBox(height: AppConstants.spacing4xl),

              // Action buttons
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Go Home'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

              const SizedBox(height: AppConstants.spacingLg),

              if (!isNotFound)
                TextButton.icon(
                  onPressed: () {
                    // Retry — just pop or reload
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
