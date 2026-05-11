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

class MoviesLibraryTab extends ConsumerWidget {
  const MoviesLibraryTab({super.key, this.viewMode = LibraryViewMode.grid});

  final LibraryViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(filteredMoviesProvider);
    final filter = ref.watch(movieLibraryFilterProvider);

    return moviesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load your library.',
        body: '$e',
      ),
      data: (movies) {
        if (movies.isEmpty) {
          if (filter.isActive) {
            return EmptyState(
              icon: Icons.filter_alt_off_outlined,
              title: 'No movies match the current filters.',
              body: 'Clear filters to see your full library.',
              actionLabel: 'Clear filters',
              onAction: () =>
                  ref.read(movieLibraryFilterProvider.notifier).clear(),
            );
          }
          return EmptyState(
            icon: Icons.video_library_outlined,
            title: 'Your movies library is empty.',
            body: 'Browse and add titles to start tracking what you watch.',
            actionLabel: 'Browse movies',
            onAction: () => context.go('/browse/movies'),
          );
        }

        if (viewMode == LibraryViewMode.tier) {
          final items = movies
              .map((m) => TierListItem(
                    id: m.tmdbId,
                    title: m.title,
                    posterPath: m.posterPath,
                    status: m.status,
                    rating: m.rating,
                    onTap: () => context.push('/movie/${m.tmdbId}'),
                  ))
              .toList();
          return TierListView(
            items: items,
            emptyIcon: Icons.emoji_events_outlined,
            emptyTitle: 'No watched movies yet.',
            emptyBody:
                'Mark movies as watched and give them an A–F rating to build your tier list.',
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
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieLibraryCard(
              title: movie.title,
              posterPath: movie.posterPath,
              status: movie.status,
              rating: movie.rating,
              onTap: () => context.push('/movie/${movie.tmdbId}'),
            );
          },
        );
      },
    );
  }
}

class _MovieLibraryCard extends StatelessWidget {
  const _MovieLibraryCard({
    required this.title,
    required this.posterPath,
    required this.status,
    required this.rating,
    required this.onTap,
  });

  final String title;
  final String? posterPath;
  final WatchStatus status;
  final LetterRating? rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Tier badge is only shown on watched items — that's the only state where
    // a tier ranking is meaningful.
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
        ],
      ),
    );
  }
}
