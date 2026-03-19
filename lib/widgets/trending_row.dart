import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
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
          height: 220,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(child: Text('Failed to load', style: TextStyle(color: Theme.of(context).colorScheme.error)))
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
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class TrendingItem {
  const TrendingItem({
    required this.title,
    this.posterPath,
    this.onTap,
  });

  final String title;
  final String? posterPath;
  final VoidCallback? onTap;
}

/// Factory helper to build [TrendingRow] from typed data.
class TrendingRowBuilder {
  static TrendingRow movies({
    required String title,
    required List<({String name, String? posterPath, VoidCallback? onTap})> items,
    required bool isLoading,
    Object? error,
  }) {
    return TrendingRow(
      title: title,
      isLoading: isLoading,
      error: error,
      items: items
          .map((e) => TrendingItem(
                title: e.name,
                posterPath: e.posterPath,
                onTap: e.onTap,
              ))
          .toList(),
    );
  }
}
