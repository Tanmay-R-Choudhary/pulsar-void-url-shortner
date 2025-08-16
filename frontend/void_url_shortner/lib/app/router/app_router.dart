import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/view/home_page.dart';
import '../../features/redirect/view/redirect_page.dart';
import '../../features/home/cubit/url_shortener_cubit.dart';
import '../../features/redirect/cubit/redirect_cubit.dart';
import '../../services/api/url_service.dart';

class AppRouter {
  static final _urlService = UrlService();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder:
            (context, state) => BlocProvider(
              create: (context) => UrlShortenerCubit(urlService: _urlService),
              child: const HomePage(),
            ),
      ),
      GoRoute(
        path: '/:shortCode',
        name: 'redirect',
        builder: (context, state) {
          final shortCode = state.pathParameters['shortCode']!;
          return BlocProvider(
            create:
                (context) =>
                    RedirectCubit(urlService: _urlService)
                      ..processRedirect(shortCode),
            child: RedirectPage(shortCode: shortCode),
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  '404 - Page Not Found',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'The page you are looking for does not exist.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
