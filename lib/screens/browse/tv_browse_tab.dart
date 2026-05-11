import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../models/tmdb_tv.dart';
import '../../providers/tmdb_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/title_card.dart';
import '../../widgets/trending_row.dart';

class TvBrowseTab extends ConsumerWidget {
  const TvBrowseTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(tvSearchQueryProvider);
    final searchResults = ref.watch(tvSearchResultsProvider);
    final trending = ref.watch(trendingTvProvider);
    final topRated = ref.watch(topRatedTvProvider);

    return Column(
      children: [
        SearchBarWidget(
          hintText: 'Search TV shows...',
          onChanged: (q) =>
              ref.read(tvSearchQueryProvider.notifier).setQuery(q),
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
      AsyncValue<List<TmdbTv>> trendingAsync,
      AsyncValue<List<TmdbTv>> topRatedAsync) {
    return ListView(
      children: [
        TrendingRowBuilder.tv(
          title: 'Trending This Week',
          isLoading: trendingAsync.isLoading,
          error: trendingAsync.error,
          items: trendingAsync.valueOrNull
                  ?.map((t) => (
                        name: t.name,
                        posterPath: t.posterPath,
                        onTap: () => context.push('/show/${t.id}'),
                        genreIds: t.genreIds,
                      ))
                  .toList() ??
              [],
        ),
        TrendingRowBuilder.tv(
          title: 'Top Rated',
          isLoading: topRatedAsync.isLoading,
          error: topRatedAsync.error,
          items: topRatedAsync.valueOrNull
                  ?.map((t) => (
                        name: t.name,
                        posterPath: t.posterPath,
                        onTap: () => context.push('/show/${t.id}'),
                        genreIds: t.genreIds,
                      ))
                  .toList() ??
              [],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, WidgetRef ref,
      AsyncValue<List<TmdbTv>> searchAsync) {
    if (searchAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchAsync.hasError) {
      return ErrorView(
        error: searchAsync.error,
        onRetry: () => ref.invalidate(tvSearchResultsProvider),
      );
    }
    final results = searchAsync.valueOrNull ?? [];
    if (results.isEmpty) {
      return const EmptyState(
        icon: Icons.tv_off_outlined,
        title: 'No TV shows match that search.',
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
        final show = results[index];
        return TitleCard(
          title: show.name,
          posterPath: show.posterPath,
          onTap: () => context.push('/show/${show.id}'),
          width: double.infinity,
          height: 140,
          genreIds: show.genreIds,
          isTv: true,
        );
      },
    );
  }
}
