import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../providers/library_provider.dart';
import '../../widgets/rating_chip.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/title_card.dart';

class TvLibraryTab extends ConsumerWidget {
  const TvLibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showsAsync = ref.watch(filteredShowsProvider);

    return showsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (shows) {
        if (shows.isEmpty) {
          return const _EmptyLibrary(type: 'TV shows');
        }
        return GridView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppConstants.smallPadding,
            mainAxisSpacing: AppConstants.smallPadding,
            childAspectRatio: 0.48,
          ),
          itemCount: shows.length,
          itemBuilder: (context, index) {
            final show = shows[index];
            return _ShowLibraryCard(
              title: show.title,
              posterPath: show.posterPath,
              status: show.status,
              rating: show.rating,
              currentSeason: show.currentSeason,
              currentEpisode: show.currentEpisode,
              onTap: () => context.push('/show/${show.tmdbId}'),
            );
          },
        );
      },
    );
  }
}

class _ShowLibraryCard extends StatelessWidget {
  const _ShowLibraryCard({
    required this.title,
    required this.posterPath,
    required this.status,
    required this.rating,
    required this.onTap,
    this.currentSeason,
    this.currentEpisode,
  });

  final String title;
  final String? posterPath;
  final dynamic status;
  final dynamic rating;
  final int? currentSeason;
  final int? currentEpisode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleCard(
            title: title,
            posterPath: posterPath,
            width: double.infinity,
            height: 130,
          ),
          const SizedBox(height: 4),
          StatusChip(status: status),
          if (rating != null) ...[
            const SizedBox(height: 2),
            RatingChip(rating: rating),
          ],
          if (currentSeason != null || currentEpisode != null) ...[
            const SizedBox(height: 2),
            Text(
              _progressLabel(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _progressLabel() {
    if (currentSeason != null && currentEpisode != null) {
      return 'S${currentSeason}E$currentEpisode';
    }
    if (currentSeason != null) return 'Season $currentSeason';
    if (currentEpisode != null) return 'Ep $currentEpisode';
    return '';
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tv_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'No $type in your library yet.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Browse and add titles to get started.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
