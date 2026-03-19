import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/tmdb_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _SectionHeader(title: 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.movie_filter),
                  title: const Text(AppConstants.appName),
                  subtitle: const Text('Cross-platform TV show & movie tracker'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  trailing: const Text('1.0.0'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _SectionHeader(title: 'TMDB API'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.key_outlined),
                  title: const Text('API Key Status'),
                  subtitle: Text(
                    TmdbConfig.apiKey == 'YOUR_TMDB_API_KEY'
                        ? 'Not configured — replace the placeholder in tmdb_constants.dart'
                        : 'Configured',
                    style: TextStyle(
                      color: TmdbConfig.apiKey == 'YOUR_TMDB_API_KEY'
                          ? Theme.of(context).colorScheme.error
                          : Colors.green,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text('Get a TMDB API Key'),
                  subtitle: const Text('themoviedb.org/settings/api'),
                  onTap: () {
                    // Open browser — requires url_launcher if desired
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Visit https://www.themoviedb.org/settings/api'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _SectionHeader(title: 'Data'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: const Text('Local Database'),
              subtitle: const Text('All data is stored locally on this device'),
            ),
          ),
        ],
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
