import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../models/enums.dart';
import '../../providers/library_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/title_card.dart';
import 'library_view_mode.dart';
import 'tier_list_view.dart';

class TvLibraryTab extends ConsumerWidget {
  const TvLibraryTab({super.key, this.viewMode = LibraryViewMode.grid});

  final LibraryViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showsAsync = ref.watch(filteredShowsProvider);
    final filter = ref.watch(showLibraryFilterProvider);

    return showsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load your library.',
        body: '$e',
      ),
      data: (shows) {
        if (shows.isEmpty) {
          if (filter.isActive) {
            return EmptyState(
              icon: Icons.filter_alt_off_outlined,
              title: 'No shows match the current filters.',
              body: 'Clear filters to see your full library.',
              actionLabel: 'Clear filters',
              onAction: () =>
                  ref.read(showLibraryFilterProvider.notifier).clear(),
            );
          }
          return EmptyState(
            icon: Icons.tv_outlined,
            title: 'Your TV library is empty.',
            body: 'Browse and add shows to start tracking what you watch.',
            actionLabel: 'Browse TV',
            onAction: () => context.go('/browse/tv'),
          );
        }

        if (viewMode == LibraryViewMode.tier) {
          final items = shows
              .map((s) => TierListItem(
                    id: s.tmdbId,
                    title: s.title,
                    posterPath: s.posterPath,
                    status: s.status,
                    rating: s.rating,
                    onTap: () => context.push('/show/${s.tmdbId}'),
                  ))
              .toList();
          return TierListView(
            items: items,
            emptyIcon: Icons.emoji_events_outlined,
            emptyTitle: 'No watched shows yet.',
            emptyBody:
                'Mark shows as watched and give them an A–F rating to build your tier list.',
          );
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
  final WatchStatus status;
  final LetterRating? rating;
  final int? currentSeason;
  final int? currentEpisode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Tier badge is only shown on watched items.
    final showTier = status == WatchStatus.watched && rating != null;
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
            tier: showTier ? rating : null,
          ),
          const SizedBox(height: 4),
          StatusChip(status: status),
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
