import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../models/enums.dart';
import '../providers/library_provider.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.currentFilter,
    required this.availableGenres,
    required this.onApply,
  });

  final LibraryFilter currentFilter;
  final List<String> availableGenres;
  final ValueChanged<LibraryFilter> onApply;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<WatchStatus> _statuses;
  late Set<LetterRating?> _ratings;
  late Set<String> _genres;

  @override
  void initState() {
    super.initState();
    _statuses = Set.of(widget.currentFilter.statuses);
    _ratings = Set.of(widget.currentFilter.ratings);
    _genres = Set.of(widget.currentFilter.genres);
  }

  void _toggleStatus(WatchStatus s) {
    setState(() {
      if (_statuses.contains(s)) {
        _statuses.remove(s);
      } else {
        _statuses.add(s);
      }
    });
  }

  void _toggleRating(LetterRating? r) {
    setState(() {
      if (_ratings.contains(r)) {
        _ratings.remove(r);
      } else {
        _ratings.add(r);
      }
    });
  }

  void _toggleGenre(String g) {
    setState(() {
      if (_genres.contains(g)) {
        _genres.remove(g);
      } else {
        _genres.add(g);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            _buildHandle(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                children: [
                  _buildSectionTitle('Watch Status'),
                  _buildStatusChips(),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildSectionTitle('Rating'),
                  _buildRatingChips(),
                  if (widget.availableGenres.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildSectionTitle('Genre'),
                    _buildGenreChips(),
                  ],
                  const SizedBox(height: AppConstants.largePadding),
                  _buildButtons(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: WatchStatus.values.map((s) {
        final selected = _statuses.contains(s);
        return FilterChip(
          label: Text(s.displayName),
          selected: selected,
          onSelected: (_) => _toggleStatus(s),
        );
      }).toList(),
    );
  }

  Widget _buildRatingChips() {
    final options = <LetterRating?>[...LetterRating.values, null];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: options.map((r) {
        final selected = _ratings.contains(r);
        final label = r == null ? 'Unrated' : r.displayName;
        return FilterChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => _toggleRating(r),
        );
      }).toList(),
    );
  }

  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widget.availableGenres.map((g) {
        final selected = _genres.contains(g);
        return FilterChip(
          label: Text(g),
          selected: selected,
          onSelected: (_) => _toggleGenre(g),
        );
      }).toList(),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _statuses.clear();
                _ratings.clear();
                _genres.clear();
              });
            },
            child: const Text('Clear All'),
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: FilledButton(
            onPressed: () {
              widget.onApply(LibraryFilter(
                statuses: Set.of(_statuses),
                ratings: Set.of(_ratings),
                genres: Set.of(_genres),
              ));
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }
}
