import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:void_url_shortner/features/home/models/url_model.dart';
import '../cubit/url_shortener_cubit.dart';
import '../cubit/url_shortener_state.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/pulsar_background.dart';
import '../../../shared/widgets/url_input_card.dart';
import '../../../shared/widgets/result_card.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../shared/widgets/error_dialog.dart';
import '../../../shared/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const PulsarBackground(),
          SafeArea(
            child: ResponsiveWrapper(
              child: Scrollbar(
                thumbVisibility: false,
                trackVisibility: false,
                controller: PrimaryScrollController.of(context),
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 1024;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: isDesktop ? 60 : 40),
                          _buildHeader(context, isDesktop),
                          const SizedBox(height: 24),
                          _buildExpirationNotice(context),
                          SizedBox(height: isDesktop ? 56 : 36),
                          BlocConsumer<UrlShortenerCubit, UrlShortenerState>(
                            listener: (context, state) {
                              if (state is UrlShortenerError) {
                                ErrorDialog.show(
                                  context,
                                  title: 'Error',
                                  message: state.message,
                                  onRetry: () {
                                    context.read<UrlShortenerCubit>().reset();
                                  },
                                );
                              } else if (state is UrlCopiedToClipboard) {
                                toastification.show(
                                  context: context,
                                  title: Text(
                                    'Copied to clipboard!',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  autoCloseDuration: const Duration(seconds: 3),
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  backgroundColor: AppTheme.successGreen,
                                  foregroundColor: Colors.white,
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                  showProgressBar: false,
                                  closeButton: ToastCloseButton(
                                    showType: CloseButtonShowType.none,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              UrlModel? urlModel;
                              if (state is UrlShortenerSuccess) {
                                urlModel = state.urlModel;
                              } else if (state is UrlCopiedToClipboard) {
                                urlModel = state.urlModel;
                              }

                              return Column(
                                children: [
                                  const UrlInputCard(),
                                  const SizedBox(height: 32),
                                  if (state is UrlShortenerLoading)
                                    _buildLoadingIndicator(),
                                  if (urlModel != null)
                                    ResultCard(urlModel: urlModel),
                                ],
                              );
                            },
                          ),
                          // SizedBox(height: isDesktop ? 60 : 40),
                          // _buildFooter(context),
                          // const SizedBox(height: 40),
                        ],
                      );
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

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 24 : 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.plasmaGreen.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.plasmaGreen.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.link,
            size: isDesktop ? 60 : 48,
            color: AppTheme.plasmaGreen,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'void',
          style: GoogleFonts.questrial(
            color: AppTheme.plasmaGreen,
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.bold,
            letterSpacing: isDesktop ? 8 : 6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Shorten URLs into the void',
          style: GoogleFonts.inter(
            color: AppTheme.dimStar,
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildExpirationNotice(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.deepSpace.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neutronWhite.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppTheme.neutronWhite, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Links expire after ${AppConstants.urlExpirationHours} hours and are automatically deleted',
              style: GoogleFonts.inter(
                color: AppTheme.dimStar,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.plasmaGreen),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Creating your void link...',
            style: GoogleFonts.inter(
              color: AppTheme.dimStar,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
