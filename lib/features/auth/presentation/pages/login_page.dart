import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/submission_status.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/login/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.returnToPrevious = false});

  /// `true` jika halaman ini dibuka dari halaman lain (tamu menekan aksi yang
  /// butuh login): setelah berhasil masuk, kembali ke halaman sebelumnya
  /// alih-alih ke beranda.
  final bool returnToPrevious;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: _LoginView(returnToPrevious: returnToPrevious),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({required this.returnToPrevious});

  final bool returnToPrevious;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginBloc>().add(
          LoginSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case SubmissionStatus.success:
                context
                    .read<AuthBloc>()
                    .add(AuthUserAuthenticated(state.user!));
              case SubmissionStatus.failure:
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Login gagal'),
                    ),
                  );
              case SubmissionStatus.initial:
              case SubmissionStatus.loading:
                break;
            }
          },
        ),
        // Mode "kembali": router tidak mengalihkan ke beranda (lihat
        // `createRouter`), jadi halaman ini yang menutup dirinya.
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == AuthStatus.authenticated,
          listener: (context, state) {
            if (!widget.returnToPrevious) return;
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'FastShop',
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Masuk untuk mulai belanja',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) =>
                            Validators.required(v, field: 'Password'),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (p, c) => p.status != c.status,
                        builder: (context, state) => AppButton(
                          label: 'Masuk',
                          isLoading: state.status == SubmissionStatus.loading,
                          onPressed: _submit,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Belum punya akun? Daftar',
                        variant: AppButtonVariant.text,
                        onPressed: () => context.go(AppRoutes.register),
                      ),
                      if (kDebugMode)
                        AppButton(
                          label: 'Katalog komponen (debug)',
                          variant: AppButtonVariant.text,
                          size: AppButtonSize.small,
                          onPressed: () =>
                              context.push(AppRoutes.designSystem),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
