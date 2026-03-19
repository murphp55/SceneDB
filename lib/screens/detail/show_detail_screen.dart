import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../constants/tmdb_constants.dart';
import '../../models/enums.dart';
import '../../providers/library_provider.dart';
import '../../providers/tmdb_provider.dart';
import '../../widgets/add_to_library_sheet.dart';
import '../../widgets/genre_chip.dart';
import '../../widgets/rating_chip.dart';
import '../../widgets/status_chip.dart';

class ShowDetailScreen extends ConsumerWidget {
  const ShowDetailScreen({super.key, required this.tmdbId});

  final int tmdbId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(tvDetailProvider(tmdbId));
    final trackedAsync = ref.watch(trackedShowProvider(tmdbId));

    return Scaffold(
      body: showAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (show) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(
                  context, show.name, show.backdropPath ?? show.posterPath),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildTitleRow(context, show.name, show.firstAirDate,
                        show.voteAverage),
                    const SizedBox(height: AppConstants.smallPadding),
                    if (show.numberOfSeasons != null ||
                        show.numberOfEpisodes != null)
                      _buildSeasonInfo(
                          context, show.numberOfSeasons, show.numberOfEpisodes),
                    const SizedBox(height: AppConstants.defaultPadding),
                    if (show.genreNames.isNotEmpty) ...[
                      _buildGenreRow(show.genreNames),
                      const SizedBox(height: AppConstants.defaultPadding),
                    ],
                    if (show.overview.isNotEmpty) ...[
                      Text('Overview',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(show.overview,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppConstants.defaultPadding),
                    ],
                    trackedAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (tracked) => tracked != null
                          ? _buildLibrarySection(context, ref, tracked,
                              show.name, show.posterPath, show.genreNames)
                          : _buildAddButton(context, ref, show.name,
                              show.posterPath, show.genreNames),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, String title, String? imagePath) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: imagePath != null
            ? CachedNetworkImage(
                imageUrl: '${TmdbConfig.imageBaseUrl}$imagePath',
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(color: Colors.black12),
                errorWidget: (_, __, ___) =>
                    const ColoredBox(color: Colors.black12),
              )
            : const ColoredBox(color: Colors.black12),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, String title,
      String? firstAirDate, double? voteAverage) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(title,
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (voteAverage != null) ...[
          const SizedBox(width: 8),
          Chip(
            avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
            label: Text(voteAverage.toStringAsFixed(1)),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ],
    );
  }

  Widget _buildSeasonInfo(
      BuildContext context, int? seasons, int? episodes) {
    final parts = <String>[];
    if (seasons != null) parts.add('$seasons season${seasons == 1 ? '' : 's'}');
    if (episodes != null) {
      parts.add('$episodes episode${episodes == 1 ? '' : 's'}');
    }
    return Text(
      parts.join(' · '),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }

  Widget _buildGenreRow(List<String> genres) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: genres.map((g) => GenreChip(genre: g)).toList(),
    );
  }

  Widget _buildLibrarySection(
    BuildContext context,
    WidgetRef ref,
    dynamic tracked,
    String title,
    String? posterPath,
    List<String> genres,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('In Your Library',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            StatusChip(status: tracked.status),
            if (tracked.rating != null) RatingChip(rating: tracked.rating),
          ],
        ),
        if (tracked.currentSeason != null || tracked.currentEpisode != null) ...[
          const SizedBox(height: 6),
          Text(
            _progressLabel(tracked.currentSeason, tracked.currentEpisode),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
                onPressed: () => _openEditSheet(
                    context, ref, tracked, title, posterPath, genres),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error),
                label: Text('Remove',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                onPressed: () => _confirmRemove(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _progressLabel(int? season, int? episode) {
    if (season != null && episode != null) {
      return 'Progress: S${season}E$episode';
    }
    if (season != null) return 'Season $season';
    if (episode != null) return 'Episode $episode';
    return '';
  }

  Widget _buildAddButton(BuildContext context, WidgetRef ref, String title,
      String? posterPath, List<String> genres) {
    return FilledButton.icon(
      icon: const Icon(Icons.add),
      label: const Text('Add to Library'),
      onPressed: () => _openAddSheet(context, ref, title, posterPath, genres),
    );
  }

  void _openAddSheet(BuildContext context, WidgetRef ref, String title,
      String? posterPath, List<String> genres) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddToLibrarySheet(
        title: title,
        isShow: true,
        onSave: ({
          required WatchStatus status,
          LetterRating? rating,
          int? currentSeason,
          int? currentEpisode,
        }) {
          ref.read(showLibraryNotifierProvider.notifier).addOrUpdate(
                tmdbId: tmdbId,
                title: title,
                posterPath: posterPath,
                genres: genres,
                status: status,
                rating: rating,
                currentSeason: currentSeason,
                currentEpisode: currentEpisode,
              );
        },
      ),
    );
  }

  void _openEditSheet(BuildContext context, WidgetRef ref, dynamic tracked,
      String title, String? posterPath, List<String> genres) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddToLibrarySheet(
        title: title,
        isShow: true,
        initialStatus: tracked.status,
        initialRating: tracked.rating,
        initialSeason: tracked.currentSeason,
        initialEpisode: tracked.currentEpisode,
        onSave: ({
          required WatchStatus status,
          LetterRating? rating,
          int? currentSeason,
          int? currentEpisode,
        }) {
          ref.read(showLibraryNotifierProvider.notifier).addOrUpdate(
                tmdbId: tmdbId,
                title: title,
                posterPath: posterPath,
                genres: genres,
                status: status,
                rating: rating,
                currentSeason: currentSeason,
                currentEpisode: currentEpisode,
              );
        },
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from Library'),
        content: const Text(
            'Are you sure you want to remove this show from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(showLibraryNotifierProvider.notifier)
                  .remove(tmdbId);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
