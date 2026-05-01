import 'package:flutter/material.dart';

import '../models/enums.dart';

class RatingChip extends StatelessWidget {
  const RatingChip({super.key, required this.rating});

  final LetterRating rating;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rating);
    return Chip(
      label: Text(
        rating.displayName,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      side: BorderSide(color: color),
      backgroundColor: color.withAlpha(30),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Color _colorFor(LetterRating rating) {
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
}
