import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/models/url_model.dart';
import '../../features/home/cubit/url_shortener_cubit.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'animated_card.dart';

class ResultCard extends StatefulWidget {
  final ShortCodeModel shortCodeModel;

  const ResultCard({super.key, required this.shortCodeModel});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFile = widget.shortCodeModel.type == ShortenType.file;
    final successMessage =
        isFile ? 'File Link Created!' : 'URL Shortened Successfully!';

    return AnimatedCard(
      delay: const Duration(milliseconds: 200),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSuccessHeader(successMessage),
                const SizedBox(height: 20),
                _buildShortenedUrlDisplay(),
                const SizedBox(height: 16),
                _buildExpirationNotice(context),
                if (widget.shortCodeModel.password != null &&
                    widget.shortCodeModel.password!.isNotEmpty)
                  _buildPasswordNotice(context),
                const SizedBox(height: 20),
                _buildCreateAnotherButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(String message) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Icon(
                Icons.check_circle,
                color: AppTheme.successGreen,
                size: 24,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.successGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildShortenedUrlDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.voidBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.plasmaGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.shortCodeModel.shortenedUrl,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.plasmaGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _copyToClipboard(context),
            icon: const Icon(Icons.copy),
            color: AppTheme.plasmaGreen,
            tooltip: 'Copy to clipboard',
          ),
        ],
      ),
    );
  }

  Widget _buildExpirationNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.neutronWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: AppTheme.neutronWhite, size: 16),
          const SizedBox(width: 8),
          Text(
            'This link will expire in ${AppConstants.urlExpirationHours} hours',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutronWhite,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordNotice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: Row(
          children: [
            Icon(Icons.lock, color: AppTheme.magneticField, size: 16),
            const SizedBox(width: 8),
            Text(
              'This link is password protected',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.magneticField),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAnotherButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _createAnother(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.plasmaGreen),
        foregroundColor: AppTheme.plasmaGreen,
      ),
      child: const Text('Create Another'),
    );
  }

  void _copyToClipboard(BuildContext context) {
    context.read<UrlShortenerCubit>().copyToClipboard(
      widget.shortCodeModel.shortenedUrl,
    );
  }

  void _createAnother(BuildContext context) {
    context.read<UrlShortenerCubit>().reset();
  }
}
