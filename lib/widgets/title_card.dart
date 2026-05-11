import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/tmdb_constants.dart';
import '../models/enums.dart';
import 'genre_chip_row.dart';
import 'tier_badge.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
    this.posterPath,
    this.onTap,
    this.width = 120,
    this.height = 180,
    this.genreIds,
    this.isTv = false,
    this.tier,
  });

  final String title;
  final String? posterPath;
  final VoidCallback? onTap;
  final double width;
  final double height;

  /// Optional TMDB genre IDs. When provided (and non-empty), renders a row of
  /// colored genre chips below the title. Names are looked up via Riverpod.
  final List<int>? genreIds;

  /// Whether this card represents a TV show (drives which genres provider is
  /// consulted for names). Ignored when [genreIds] is null/empty.
  final bool isTv;

  /// Optional tier (letter rating) shown as a small badge in the poster's
  /// top-right corner. Only pass this when the item is `watched` — that's the
  /// only state where a tier is meaningful.
  final LetterRating? tier;

  @override
  Widget build(BuildContext context) {
    final showGenres = genreIds != null && genreIds!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cardBorderRadius),
              ),
              child: Stack(
                children: [
                  posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: '${TmdbConfig.imageBaseUrl}$posterPath',
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _placeholder(context),
                          errorWidget: (context, url, error) =>
                              _placeholder(context),
                        )
                      : _placeholder(context),
                  if (tier != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: TierBadge(rating: tier!),
                    ),
                ],
              ),
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (showGenres) ...[
              const SizedBox(height: 4),
              GenreChipRow(
                genreIds: genreIds!,
                isTv: isTv,
                maxChips: 3,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.movie, size: 40),
    );
  }
}
