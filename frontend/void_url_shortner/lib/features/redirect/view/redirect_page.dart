import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import '../cubit/redirect_cubit.dart';
import '../cubit/redirect_state.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/error_dialog.dart';
import '../../../shared/widgets/pulsar_background.dart';

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
                  _launchUrl(context, state.destinationUrl, state.isFile);
                } else if (state is RedirectError) {
                  ErrorDialog.show(
                    context,
                    title: 'Link Unavailable',
                    message: state.message,
                    retryButtonText: 'Go to Homepage',
                    onRetry: () {
                      GoRouter.of(context).go('/');
                    },
                  );
                }
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: BlocBuilder<RedirectCubit, RedirectState>(
                    builder: (context, state) {
                      if (state is RedirectAwaitingPassword) {
                        return _buildPasswordState(context, state);
                      }
                      if (state is RedirectSuccess && state.isFile) {
                        return _buildDownloadingState(context);
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
              const SizedBox(
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
                'Please wait while we prepare your destination',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.dimStar),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadingState(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.downloading,
                size: 60,
                color: AppTheme.plasmaGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Your download is starting...',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'If your download does not begin automatically, please check your browser.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.dimStar),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordState(
    BuildContext context,
    RedirectAwaitingPassword state,
  ) {
    final passwordController = TextEditingController();

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock, size: 48, color: AppTheme.magneticField),
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
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  prefixIcon: const Icon(Icons.key),
                  errorText: state.errorMessage,
                ),
                onSubmitted: (value) => _submitPassword(context, value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed:
                    state.isVerifying
                        ? null
                        : () =>
                            _submitPassword(context, passwordController.text),
                child:
                    state.isVerifying
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Access Link'),
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

  Future<void> _launchUrl(BuildContext context, String url, bool isFile) async {
    // For web, the most reliable way to trigger a download is using an anchor tag.
    if (isFile && kIsWeb) {
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute('download', '') // The 'download' attribute is key
            ..style.display = 'none';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      return;
    }

    // For mobile or standard URL redirects on web
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode:
              isFile
                  ? LaunchMode
                      .externalApplication // Let OS handle download
                  : LaunchMode.platformDefault,
          webOnlyWindowName: kIsWeb ? '_self' : '_blank',
        );
      } else {
        _showLaunchError(context, 'The destination could not be opened.');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      _showLaunchError(
        context,
        'An unexpected error occurred while opening the link.',
      );
    }
  }

  void _showLaunchError(BuildContext context, String message) {
    ErrorDialog.show(
      context,
      title: 'Could Not Open Link',
      message: message,
      retryButtonText: 'Go to Homepage',
      onRetry: () {
        GoRouter.of(context).go('/');
      },
    );
  }
}
