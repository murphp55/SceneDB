import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/tmdb_provider.dart';
import '../utils/genre_colors.dart';

/// Renders a wrap of small colored genre chips for a list of TMDB genre IDs.
///
/// Looks up display names from the appropriate genres provider
/// ([movieGenresProvider] or [tvGenresProvider]) so callers only need IDs —
/// which is what list endpoints (trending, search) return.
class GenreChipRow extends ConsumerWidget {
  const GenreChipRow({
    super.key,
    required this.genreIds,
    required this.isTv,
    this.maxChips,
  });

  final List<int> genreIds;
  final bool isTv;
  final int? maxChips;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (genreIds.isEmpty) return const SizedBox.shrink();

    final genresAsync =
        isTv ? ref.watch(tvGenresProvider) : ref.watch(movieGenresProvider);

    final genres = genresAsync.valueOrNull;
    if (genres == null) return const SizedBox.shrink();

    final byId = {for (final g in genres) g.id: g.name};

    final ids = maxChips == null ? genreIds : genreIds.take(maxChips!);
    final chips = <Widget>[];
    for (final id in ids) {
      final name = byId[id];
      if (name == null) continue;
      chips.add(_chip(name, genreColor(id)));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: chips,
    );
  }

  Widget _chip(String name, GenreColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: color.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
