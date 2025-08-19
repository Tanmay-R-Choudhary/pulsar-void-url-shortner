import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/cubit/url_shortener_cubit.dart';
import '../../features/home/models/url_model.dart';
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

  // State for file selection
  PlatformFile? _selectedFile;
  ShortenType _selectedType = ShortenType.url;

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

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedFile = result.files.single;
        });
      }
    } catch (e) {
      // Handle potential error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
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
                    _buildTypeSelector(),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axisAlignment: -1.0,
                            child: child,
                          ),
                        );
                      },
                      child:
                          _selectedType == ShortenType.url
                              ? _buildUrlInput()
                              : _buildFileInput(),
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordToggle(),
                    _buildPasswordInput(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.voidBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.plasmaGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(ShortenType.url, 'Shorten URL', Icons.link),
          ),
          Expanded(
            child: _buildTypeButton(
              ShortenType.file,
              'Store File',
              Icons.upload_file,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(ShortenType type, String text, IconData icon) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap:
          () => setState(() {
            _selectedType = type;
          }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.plasmaGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.voidBlack : AppTheme.plasmaGreen,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.voidBlack : AppTheme.starlight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlInput() {
    return TextField(
      key: const ValueKey('url_input'),
      controller: _urlController,
      decoration: const InputDecoration(
        labelText: 'Enter your URL',
        hintText: 'https://example.com/very/long/url',
        prefixIcon: Icon(Icons.link),
      ),
    );
  }

  Widget _buildFileInput() {
    return Column(
      key: const ValueKey('file_input'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.attach_file),
          label: const Text('Choose File'),
          onPressed: _pickFile,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.plasmaGreen,
            side: const BorderSide(color: AppTheme.plasmaGreen),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        if (_selectedFile != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.voidBlack,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.plasmaGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: AppTheme.dimStar),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedFile!.name,
                    style: const TextStyle(color: AppTheme.starlight),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.errorRed),
                  onPressed: () => setState(() => _selectedFile = null),
                  tooltip: 'Remove file',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordToggle() {
    return InkWell(
      onTap: () {
        setState(() {
          _showPasswordField = !_showPasswordField;
          if (!_showPasswordField) _passwordController.clear();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Checkbox(
              value: _showPasswordField,
              onChanged: (value) {
                setState(() {
                  _showPasswordField = value ?? false;
                  if (!_showPasswordField) _passwordController.clear();
                });
              },
              activeColor: AppTheme.plasmaGreen,
            ),
            Expanded(
              child: Text(
                'Password protect this',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return AnimatedContainer(
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
    );
  }

  Widget _buildSubmitButton() {
    final buttonText =
        _selectedType == ShortenType.url ? 'Shorten URL' : 'Get Link';
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: ElevatedButton(onPressed: _submit, child: Text(buttonText)),
        );
      },
    );
  }

  void _submit() {
    _buttonController.forward().then((_) => _buttonController.reverse());
    final cubit = context.read<UrlShortenerCubit>();
    final password =
        _showPasswordField ? _passwordController.text.trim() : null;

    if (_selectedType == ShortenType.url) {
      final url = _urlController.text.trim();
      cubit.createShortCodeForUrl(url, password: password);
    } else {
      if (_selectedFile != null && _selectedFile!.bytes != null) {
        cubit.createShortCodeForFile(
          fileName: _selectedFile!.name,
          fileBytes: _selectedFile!.bytes!,
          password: password,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a file to upload.'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
}
