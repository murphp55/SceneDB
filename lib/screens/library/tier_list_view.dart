import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../models/enums.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/tier_badge.dart';
import '../../widgets/title_card.dart';

/// Minimal data needed to render an item in a tier-list row. Both
/// `TrackedMovie` and `TrackedShow` are projected into this shape so the same
/// view works for either entity.
class TierListItem {
  const TierListItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.status,
    required this.rating,
    required this.onTap,
  });

  final int id;
  final String title;
  final String? posterPath;
  final WatchStatus status;
  final LetterRating? rating;
  final VoidCallback onTap;
}

/// Tier-list visualization of watched items. Groups them into A → F rows
/// (plus an "Unranked" row for watched items without a tier yet) and renders
/// each row as a horizontal carousel of posters with corner badges.
///
/// Only `status == watched` items are shown — that's the only state where a
/// tier ranking is meaningful.
class TierListView extends StatelessWidget {
  const TierListView({
    super.key,
    required this.items,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyBody,
  });

  final List<TierListItem> items;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyBody;

  @override
  Widget build(BuildContext context) {
    final watched =
        items.where((i) => i.status == WatchStatus.watched).toList();

    if (watched.isEmpty) {
      return EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        body: emptyBody,
      );
    }

    // Group by tier; null ratings collected separately as "Unranked".
    final Map<LetterRating, List<TierListItem>> byTier = {
      for (final r in LetterRating.values) r: <TierListItem>[],
    };
    final List<TierListItem> unranked = [];
    for (final item in watched) {
      if (item.rating == null) {
        unranked.add(item);
      } else {
        byTier[item.rating!]!.add(item);
      }
    }

    final rows = <Widget>[];
    for (final tier in LetterRating.values) {
      final list = byTier[tier]!;
      rows.add(_TierRow(
        tier: tier,
        items: list,
      ));
    }
    if (unranked.isNotEmpty) {
      rows.add(_UnrankedRow(items: unranked));
    }

    return ListView(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      children: rows,
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.items});

  final LetterRating tier;
  final List<TierListItem> items;

  @override
  Widget build(BuildContext context) {
    final color = TierBadge.colorFor(tier);
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(120)),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppConstants.cardBorderRadius),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tier letter column.
          Container(
            width: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withAlpha(80),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.cardBorderRadius),
                bottomLeft: Radius.circular(AppConstants.cardBorderRadius),
              ),
            ),
            child: Text(
              tier.displayName,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          // Posters carousel.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: items.isEmpty
                  ? const _EmptyTierHint()
                  : SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppConstants.smallPadding),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _TierItem(item: item);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnrankedRow extends StatelessWidget {
  const _UnrankedRow({required this.items});

  final List<TierListItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppConstants.cardBorderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 4,
                top: 4,
                bottom: AppConstants.smallPadding,
              ),
              child: Text(
                'Unranked',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppConstants.smallPadding),
                itemBuilder: (context, index) {
                  return _TierItem(item: items[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierItem extends StatelessWidget {
  const _TierItem({required this.item});

  final TierListItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      child: TitleCard(
        title: item.title,
        posterPath: item.posterPath,
        width: 86,
        height: 130,
        tier: item.rating,
        onTap: item.onTap,
      ),
    );
  }
}

class _EmptyTierHint extends StatelessWidget {
  const _EmptyTierHint();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Center(
        child: Text(
          'No titles in this tier yet',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
      ),
    );
  }
}
