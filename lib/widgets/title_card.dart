import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/tmdb_constants.dart';
import 'genre_chip_row.dart';

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
              child: posterPath != null
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
            ),
            const SizedBox(height: 6),
            Text(
              title,
             