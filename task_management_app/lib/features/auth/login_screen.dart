import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import 'widgets/social_login_button.dart';
import 'repositories/auth_repository.dart';

/// Login screen with email/password, social login, and remember me option.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacing3xl),

              // Header
              _buildHeader(theme),

              const SizedBox(height: AppConstants.spacing4xl),

              // Email field
              AppTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                prefixIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingLg),

              // Password field
              AppTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                prefixIcon: Iconsax.lock,
                obscureText: true,
                showObscureToggle: true,
                textInputAction: TextInputAction.done,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingMd),

              // Remember me & Forgot password
              _buildRememberForgot(theme),

              const SizedBox(height: AppConstants.spacingXxl),

              // Login button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      label: 'Log In',
                      variant: AppButtonVariant.gradient,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final repo = ref.read(authRepositoryProvider);
                          final success = await repo.login(
                            _emailController.text, 
                            _passwordController.text
                          );
                          if (success && mounted) {
                            context.go('/');
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login Failed: ${e.toString()}')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

              const SizedBox(height: AppConstants.spacingXxl),

              // Divider
              _buildDivider(theme),

              const SizedBox(height: AppConstants.spacingXxl),

              // Social login
              _buildSocialLogin(theme),

              const SizedBox(height: AppConstants.spacing3xl),

              // Register link
              _buildRegisterLink(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.white,
            size: 30,
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              duration: 500.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(),

        const SizedBox(height: AppConstants.spacingXxl),

        Text(
          'Welcome back! 👋',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

        const SizedBox(height: AppConstants.spacingSm),

        Text(
          'Sign in to continue managing your tasks',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1),
      ],
    );
  }

  Widget _buildRememberForgot(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              AnimatedContainer(
                duration: AppConstants.animFast,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _rememberMe
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _rememberMe
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1.5,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),

        // Forgot password
        TextButton(
          onPressed: () => context.push('/forgot-password'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot Password?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.outline.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.outline.withOpacity(0.3))),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildSocialLogin(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            label: 'Google',
            icon: Icons.g_mobiledata_rounded,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SocialLoginButton(
            label: 'Apple',
            icon: Icons.apple_rounded,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SocialLoginButton(
            label: 'GitHub',
            icon: Icons.code_rounded,
            onPressed: () {},
          ),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1);
  }

  Widget _buildRegisterLink(ThemeData theme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/register'),
            child: Text(
              'Sign Up',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}
