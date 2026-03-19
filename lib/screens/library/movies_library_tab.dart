import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../providers/library_provider.dart';
import '../../widgets/rating_chip.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/title_card.dart';

class MoviesLibraryTab extends ConsumerWidget {
  const MoviesLibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(filteredMoviesProvider);

    return moviesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (movies) {
        if (movies.isEmpty) {
          return const _EmptyLibrary(type: 'movies');
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
            Icons.video_library_outlined,
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
