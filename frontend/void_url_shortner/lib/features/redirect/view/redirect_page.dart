import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../cubit/redirect_cubit.dart';
import '../cubit/redirect_state.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/pulsar_background.dart';
import '../../../shared/widgets/error_dialog.dart';

class RedirectPage extends StatelessWidget {
  final String shortCode;

  const RedirectPage({super.key, required this.shortCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const PulsarBackground(),
          SafeArea(
            child: BlocListener<RedirectCubit, RedirectState>(
              listener: (context, state) {
                if (state is RedirectSuccess) {
                  _launchUrl(state.originalUrl);
                } else if (state is RedirectError) {
                  ErrorDialog.show(
                    context,
                    title: 'Link Not Found',
                    message: state.message,
                    onRetry: () {
                      context.read<RedirectCubit>().processRedirect(shortCode);
                    },
                  );
                }
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: BlocBuilder<RedirectCubit, RedirectState>(
                    builder: (context, state) {
                      if (state is RedirectLoading) {
                        return _buildLoadingState(context);
                      } else if (state is RedirectPasswordRequired ||
                          state is RedirectPasswordError) {
                        return _buildPasswordState(context, state);
                      }
                      return _buildLoadingState(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.plasmaGreen,
                  ),
                  strokeWidth: 4,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Resolving link...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we redirect you',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.dimStar),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordState(BuildContext context, RedirectState state) {
    final passwordController = TextEditingController();
    final isError = state is RedirectPasswordError;

    if (isError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ErrorDialog.show(
          context,
          title: 'Password Error',
          message: (state).message,
        );
      });
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.lock, size: 48, color: AppTheme.magneticField),
              const SizedBox(height: 16),
              Text(
                'Password Required',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This link is password protected',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.dimStar),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  prefixIcon: Icon(Icons.key),
                ),
                onSubmitted: (value) => _submitPassword(context, value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    () => _submitPassword(context, passwordController.text),
                child: const Text('Access Link'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPassword(BuildContext context, String password) {
    context.read<RedirectCubit>().verifyPassword(shortCode, password);
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
