import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../providers/library_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/rating_chip.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/title_card.dart';

class MoviesLibraryTab extends ConsumerWidget {
  const MoviesLibraryTab({super.key});

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
  final dynamic status;
  final dynamic rating;
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
        ],
      ),
    );
  }
}

