import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../models/enums.dart';
import '../../providers/library_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/title_card.dart';

/// Top-level Watchlist screen. Shows everything currently in the
/// `yetToWatch` (and optionally `inProgress`) state, across movies + TV, with
/// a quick "Mark Watched" action so the user can keep the list moving without
/// drilling into the detail screen.
class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _includeInProgress = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    if (_tabController.index == 0) {
      context.go('/watchlist/movies');
    } else {
      context.go('/watchlist/tv');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          IconButton(
            tooltip: _includeInProgress
                ? 'Hide in-progress'
                : 'Show in-progress',
            icon: Icon(_includeInProgress
                ? Icons.play_circle
                : Icons.play_circle_outline),
            onPressed: () =>
                setState(() => _includeInProgress = !_includeInProgress),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV Shows'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MoviesWatchlist(includeInProgress: _includeInProgress),
          _ShowsWatchlist(includeInProgress: _includeInProgress),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Movies
// ---------------------------------------------------------------------------

class _MoviesWatchlist extends ConsumerWidget {
  const _MoviesWatchlist({required this.includeInProgress});

  final bool includeInProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(trackedMoviesStreamProvider);

    return moviesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load your watchlist.',
        body: '$e',
      ),
      data: (movies) {
        final list = movies.where((m) {
          if (m.status == WatchStatus.yetToWatch) return true;
          if (includeInProgress && m.status == WatchStatus.inProgress) {
            return true;
          }
          return false;
        }).toList()
          ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.bookmark_border,
            title: 'Your movie watchlist is empty.',
            body: 'Add titles from Browse to start your watchlist.',
            actionLabel: 'Browse movies',
            onAction: () => context.go('/browse/movies'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: list.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppConstants.smallPadding),
          itemBuilder: (context, index) {
            final movie = list[index];
            return _WatchlistRow(
              title: movie.title,
              posterPath: movie.posterPath,
              status: movie.status,
              subtitle: _movieSubtitle(movie.status, movie.genres),
              onTap: () => context.push('/movie/${movie.tmdbId}'),
              onMarkWatched: () => ref
                  .read(movieLibraryNotifierProvider.notifier)
                  .addOrUpdate(
                    tmdbId: movie.tmdbId,
                    title: movie.title,
                    posterPath: movie.posterPath,
                    genres: movie.genres,
                    status: WatchStatus.watched,
                    rating: movie.rating,
                    watchedOn: DateTime.now(),
                  ),
              onRemove: () => ref
                  .read(movieLibraryNotifierProvider.notifier)
                  .remove(movie.tmdbId),
            );
          },
        );
      },
    );
  }

  String _movieSubtitle(WatchStatus status, List<String> genres) {
    final base = status.displayName;
    if (genres.isEmpty) return base;
    final first = genres.take(2).join(', ');
    return '$base  •  $first';
  }
}

// ---------------------------------------------------------------------------
// Shows
// ---------------------------------------------------------------------------

class _ShowsWatchlist extends ConsumerWidget {
  const _ShowsWatchlist({required this.includeInProgress});

  final bool includeInProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showsAsync = ref.watch(trackedShowsStreamProvider);

    return showsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load your watchlist.',
        body: '$e',
      ),
      data: (shows) {
        final list = shows.where((s) {
          if (s.status == WatchStatus.yetToWatch) return true;
          if (includeInProgress && s.status == WatchStatus.inProgress) {
            return true;
          }
          return false;
        }).toList()
          ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.bookmark_border,
            title: 'Your TV watchlist is empty.',
            body: 'Add shows from Browse to start your watchlist.',
            actionLabel: 'Browse TV',
            onAction: () => context.go('/browse/tv'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: list.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppConstants.smallPadding),
          itemBuilder: (context, index) {
            final show = list[index];
            return _WatchlistRow(
              title: show.title,
              posterPath: show.posterPath,
              status: show.status,
              subtitle: _showSubtitle(show.status, show.currentSeason,
                  show.currentEpisode, show.genres),
              onTap: () => context.push('/show/${show.tmdbId}'),
              onMarkWatched: () => ref
                  .read(showLibraryNotifierProvider.notifier)
                  .addOrUpdate(
                    tmdbId: show.tmdbId,
                    title: show.title,
                    posterPath: show.posterPath,
                    genres: show.genres,
                    status: WatchStatus.watched,
                    rating: show.rating,
                    watchedOn: DateTime.now(),
                    currentSeason: show.currentSeason,
                    currentEpisode: show.currentEpisode,
                  ),
              onRemove: () => ref
                  .read(showLibraryNotifierProvider.notifier)
                  .remove(show.tmdbId),
            );
          },
        );
      },
    );
  }

  String _showSubtitle(
      WatchStatus status, int? season, int? episode, List<String> genres) {
    final parts = <String>[status.displayName];
    if (season != null && episode != null) {
      parts.add('S${season}E$episode');
    } else if (season != null) {
      parts.add('Season $season');
    } else if (episode != null) {
      parts.add('Ep $episode');
    }
    if (genres.isNotEmpty) {
      parts.add(genres.take(2).join(', '));
    }
    return parts.join('  •  ');
  }
}

// ---------------------------------------------------------------------------
// Row widget
// ---------------------------------------------------------------------------

class _WatchlistRow extends StatelessWidget {
  const _WatchlistRow({
    required this.title,
    required this.posterPath,
    required this.status,
    required this.subtitle,
    required this.onTap,
    required this.onMarkWatched,
    required this.onRemove,
  });

  final String title;
  final String? posterPath;
  final WatchStatus status;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onMarkWatched;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleCard(
                title: '',
                posterPath: posterPath,
                width: 56,
                height: 84,
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Mark watched',
                icon: const Icon(Icons.check_circle_outline),
                color: Colors.green,
                onPressed: () {
                  onMarkWatched();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Marked "$title" as watched'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                tooltip: 'More',
                onSelected: (value) {
                  if (value == 'remove') {
                    onRemove();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed "$title"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Remove from watchlist'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
