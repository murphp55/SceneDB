import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../services/tmdb_error.dart';
import 'title_card.dart';

class TrendingRow extends StatelessWidget {
  const TrendingRow({
    super.key,
    required this.title,
    required this.items,
    required this.isLoading,
    this.error,
  });

  final String title;
  final List<TrendingItem> items;
  final bool isLoading;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.defaultPadding,
            AppConstants.defaultPadding,
            AppConstants.defaultPadding,
            AppConstants.smallPadding,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 270,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _errorMessageFor(error!),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppConstants.smallPadding),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return TitleCard(
                          title: item.title,
                          posterPath: item.posterPath,
                          onTap: item.onTap,
                          genreIds: item.genreIds,
                          isTv: item.isTv,
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

String _errorMessageFor(Object error) {
  if (error is TmdbError) return error.userMessage;
  return 'Failed to load.';
}

class TrendingItem {
  const TrendingItem({
    required this.title,
    this.posterPath,
    this.onTap,
    this.genreIds,
    this.isTv = false,
  });

  final String title;
  final String? posterPath;
  final VoidCallback? onTap;
  final List<int>? genreIds;
  final bool isTv;
}

/// Factory helper to build [TrendingRow] from typed data.
class TrendingRowBuilder {
  static TrendingRow movies({
    required String title,
    required List<
            ({
              String name,
              String? posterPath,
              VoidCallback? onTap,
              List<int>? genreIds
            })>
        items,
    required bool isLoading,
    Object? error,
  }) {
    return _build(
      title: title,
      items: items,
      isLoading: isLoading,
      error: error,
      isTv: false,
    );
  }

  static TrendingRow tv({
    required String title,
    required List<
            ({
              String name,
              String? posterPath,
              VoidCallback? onTap,
              List<int>? genreIds
            })>
        items,
    required bool isLoading,
    Object? error,
  }) {
    return _build(
      title: title,
      items: items,
      isLoading: isLoading,
      error: error,
      isTv: true,
    );
  }

  static TrendingRow _build({
    required String title,
    required List<
            ({
              String name,
        