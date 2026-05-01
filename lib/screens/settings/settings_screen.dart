import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../../providers/api_key_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyAsync = ref.watch(apiKeyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          const _SectionHeader(title: 'About'),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.movie_filter),
                  title: Text(AppConstants.appName),
                  subtitle: Text('Cross-platform TV show & movie tracker'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  trailing: Text('1.0.0'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          const _SectionHeader(title: 'TMDB API Key'),
          keyAsync.when(
            loading: () => const Card(
              child: ListTile(
                leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                title: Text('Loading key…'),
              ),
            ),
            error: (e, _) => Card(
              child: ListTile(
                leading: Icon(Icons.error_outline,
                    color: Theme.of(context).colorScheme.error),
                title: const Text('Failed to read stored key'),
                subtitle: Text('$e'),
              ),
            ),
            data: (state) => _ApiKeyCard(state: state),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          const _SectionHeader(title: 'Data'),
          const Card(
            child: ListTile(
              leading: Icon(Icons.storage_outlined),
              title: Text('Local Database'),
              subtitle: Text('All data is stored locally on this device'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiKeyCard extends ConsumerStatefulWidget {
  const _ApiKeyCard({required this.state});

  final ApiKeyState state;

  @override
  ConsumerState<_ApiKeyCard> createState() => _ApiKeyCardState();
}

class _ApiKeyCardState extends ConsumerState<_ApiKeyCard> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _maskedPreview(String key) {
    if (key.length <= 4) return '••••';
    return '${'•' * 8}${key.substring(key.length - 4)}';
  }

  ({IconData icon, Color color, String label, String? detail}) _statusFor(
      ApiKeyState s, BuildContext context) {
    switch (s.source) {
      case ApiKeySource.stored:
        return (
          icon: Icons.check_circle,
          color: Colors.green,
          label: 'Configured (stored on this device)',
          detail: _maskedPreview(s.key),
        );
      case ApiKeySource.dartDefine:
        return (
          icon: Icons.build_circle_outlined,
          color: Colors.amber,
          label: 'Using build-time key (--dart-define)',
          detail: _maskedPreview(s.key),
        );
      case ApiKeySource.none:
        return (
          icon: Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          label: 'Not configured',
          detail: 'TMDB requests will fail until a key is provided.',
        );
    }
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(apiKeyProvider.notifier).save(value);
      _controller.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key saved.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save key: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openTmdbApiPage() async {
    final uri = Uri.parse('https://www.themoviedb.org/settings/api');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open browser.')),
      );
    }
  }

  Future<void> _clear() async {
    setState(() => _saving = true);
    try {
      await ref.read(apiKeyProvider.notifier).clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stored key cleared.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(widget.state, context);
    final hasStoredKey = widget.state.source == ApiKeySource.stored;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status row
            Row(
              children: [
                Icon(status.icon, color: status.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status.label,
                          style: Theme.of(context).textTheme.bodyMedium),
                      if (status.detail != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          status.detail!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            // Entry field
            TextField(
              controller: _controller,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: hasStoredKey ? 'Replace API key' : 'Enter API key',
                hintText: 'Paste your TMDB v3 API key',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              onSubmitted: (_) => _saving ? null : _save(),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ),
                if (hasStoredKey) ...[
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving ? null : _clear,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            InkWell(
              onTap: _openTmdbApiPage,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.open_in_new,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Get a free key at themoviedb.org/settings/api',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
