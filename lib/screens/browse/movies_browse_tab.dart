import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../providers/tmdb_provider.dart';
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
              : _buildSearchResults(context, searchResults),
        ),
      ],
    );
  }

  Widget _buildDiscovery(BuildContext context, AsyncValue trendingAsync,
      AsyncValue topRatedAsync) {
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
                      ))
                  .toList() ??
              [],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, AsyncValue searchAsync) {
    if (searchAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchAsync.hasError) {
      return Center(
        child: Text('Error: ${searchAsync.error}'),
      );
    }
    final results = searchAsync.valueOrNull ?? [];
    if (results.isEmpty) {
      return const Center(child: Text('No results found.'));
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
        );
      },
    );
  }
}
