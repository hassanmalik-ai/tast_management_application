import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/auth_repository.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

/// Register screen with full name, email, password, and confirm password.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create Account ✨',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn().slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingSm),

              Text(
                'Fill in the details to get started',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacing3xl),

              // Full Name
              AppTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
                prefixIcon: Iconsax.user,
                textInputAction: TextInputAction.next,
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingLg),

              // Email
              AppTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                prefixIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingLg),

              // Password
              AppTextField(
                label: 'Password',
                hintText: 'Create a password',
                controller: _passwordController,
                prefixIcon: Iconsax.lock,
                obscureText: true,
                showObscureToggle: true,
                textInputAction: TextInputAction.next,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingLg),

              // Confirm Password
              AppTextField(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                controller: _confirmPasswordController,
                prefixIcon: Iconsax.lock,
                obscureText: true,
                showObscureToggle: true,
                textInputAction: TextInputAction.done,
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),

              const SizedBox(height: AppConstants.spacingLg),

              // Terms checkbox
              GestureDetector(
                onTap: () =>
                    setState(() => _agreedToTerms = !_agreedToTerms),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: AppConstants.animFast,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _agreedToTerms
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _agreedToTerms
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                      child: _agreedToTerms
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.6),
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: AppConstants.spacingXxl),

              // Create Account button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      label: 'Create Account',
                      variant: AppButtonVariant.gradient,
                      onPressed: () async {
                        if (!_agreedToTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please agree to terms')),
                          );
                          return;
                        }
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final repo = ref.read(authRepositoryProvider);
                          final success = await repo.register(
                            _nameController.text,
                            _emailController.text.split('@')[0], // username fallback
                            _emailController.text,
                            '0000000000', // phone fallback
                            _passwordController.text
                          );
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration successful, please login')),
                            );
                            context.pop();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Registration Failed: ${e.toString()}')),
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
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),

              const SizedBox(height: AppConstants.spacingXxl),

              // Login link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Log In',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
