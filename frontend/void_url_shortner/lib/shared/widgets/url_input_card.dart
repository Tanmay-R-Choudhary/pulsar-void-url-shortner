import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/cubit/url_shortener_cubit.dart';
import '../theme/app_theme.dart';
import 'animated_card.dart';

class UrlInputCard extends StatefulWidget {
  const UrlInputCard({super.key});

  @override
  State<UrlInputCard> createState() => _UrlInputCardState();
}

class _UrlInputCardState extends State<UrlInputCard>
    with SingleTickerProviderStateMixin {
  final _urlController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPasswordField = false;

  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _passwordController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      delay: const Duration(milliseconds: 300),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth =
              constraints.maxWidth > 800 ? 600.0 : constraints.maxWidth * 0.9;

          return Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your URL',
                          hintText: 'https://example.com/very/long/url',
                          prefixIcon: Icon(Icons.link),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showPasswordField = !_showPasswordField;
                          if (!_showPasswordField) {
                            _passwordController.clear();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: Checkbox(
                                value: _showPasswordField,
                                onChanged: (value) {
                                  setState(() {
                                    _showPasswordField = value ?? false;
                                    if (!_showPasswordField) {
                                      _passwordController.clear();
                                    }
                                  });
                                },
                                activeColor: AppTheme.plasmaGreen,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Password protect this link',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: _showPasswordField ? 72 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showPasswordField ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password (optional)',
                              hintText: 'Enter password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: _buttonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _buttonScaleAnimation.value,
                          child: ElevatedButton(
                            onPressed: () => _submitUrl(),
                            onLongPress: () {
                              _buttonController.forward().then((_) {
                                _buttonController.reverse();
                              });
                            },
                            child: const Text('Shorten URL'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitUrl() {
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    final url = _urlController.text.trim();
    final password =
        _showPasswordField ? _passwordController.text.trim() : null;

    context.read<UrlShortenerCubit>().shortenUrl(url, password: password);
  }
}
