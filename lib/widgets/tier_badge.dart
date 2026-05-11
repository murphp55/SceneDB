import 'package:flutter/material.dart';

import '../models/enums.dart';

/// A small letter-rating "tier" badge — used as a corner overlay on posters
/// (via [TitleCard.tier]) and standalone in tier-list layouts.
///
/// Caller decides whether the underlying item is `watched`; this widget only
/// renders.
class TierBadge extends StatelessWidget {
  const TierBadge({
    super.key,
    required this.rating,
    this.size = 22,
    this.fontSize = 12,
  });

  final LetterRating rating;
  final double size;
  final double fontSize;

  /// Color associated with a given tier letter. Kept in sync with
  /// [RatingChip] so colors are consistent across the app.
  static Color colorFor(LetterRating rating) {
    switch (rating) {
      case LetterRating.a:
        return Colors.green;
      case LetterRating.b:
        return Colors.lightGreen;
      case LetterRating.c:
        return Colors.yellow;
      case LetterRating.d:
        return Colors.orange;
      case LetterRating.f:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(rating);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        rating.displayName,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          height: 1,
        ),
      ),
    );
  }
}
