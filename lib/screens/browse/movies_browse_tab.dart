import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../models/tmdb_movie.dart';
import '../../providers/tmdb_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/title_card.dart';
import '../../widgets/trending_row.dart';

class MoviesBrowseTab extends ConsumerWidget {
  const MoviesBrowseTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(movieSearchQueryProvider);
    final searchResults = ref.watch(movieSearchResultsProvider);
    final trending = ref.watch(trendingMoviesProvider);
    final topRated = ref.watch(topRatedMoviesProvider);

    return Column(
      children: [
        SearchBarWidget(
          hintText: 'Search movies...',
          onChanged: (q) =>
              ref.read(movieSearchQueryProvider.notifier).setQuery(q),
        ),
        Expanded(
          child: query.trim().isEmpty
              ? _buildDiscovery(context, trending, topRated)
              : _buildSearchResults(context, ref, searchResults),
        ),
      ],
    );
  }

  Widget _buildDiscovery(
      BuildContext context,
      AsyncValue<List<TmdbMovie>> trendingAsync,
      AsyncValue<List<TmdbMovie>> topRatedAsync) {
    return ListView(
      children: [
        TrendingRowBuilder.movies(
          title: 'Trending This Week',
          isLoading: trendingAsync.isLoading,
          error: trendingAsync.error,
          items: trendingAsync.valueOrNull
                  ?.map((m) => (
                        name: m.title,
                        posterPath: m.posterPath,
                        onTap: () => context.push('/movie/${m.id}'),
                        genreIds: m.genreIds,
                      ))
                  .toList() ??
              [],
        ),
        TrendingRowBuilder.movies(
          title: 'Top Rated',
          isLoading: topRatedAsync.isLoading,
          error: topRatedAsync.error,
          items: topRatedAsync.valueOrNull
                  ?.map((m) => (
                        name: m.title,
                        posterPath: m.posterPath,
                        onTap: () => context.push('/movie/${m.id}'),
                        genreIds: m.genreIds,
                      ))
                  .toList() ??
              [],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, WidgetRef ref,
      AsyncValue<List<TmdbMovie>> searchAsync) {
    if (searchAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchAsync.hasError) {
      return ErrorView(
        error: searchAsync.error,
        onRetry: () => ref.invalidate(movieSearchResultsProvider),
      );
    }
    final results = searchAsync.valueOrNull ?? [];
    if (results.isEmpty) {
      return const EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'No movies match that search.',
        body: 'Try a different title or check the spelling.',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppConstants.smallPadding,
        mainAxisSpacing: AppConstants.smallPadding,
        childAspectRatio: 0.55,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final movie = results[index];
        return TitleCard(
          title: movie.title,
          posterPath: movie.posterPath,
          onTap: () => context.push('/movie/${movie.id}'),
          width: double.infinity,
          height: 140,
          genreIds: movie.genreIds,
        );
      },
    );
  }
}
