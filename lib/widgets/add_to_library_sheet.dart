import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../models/enums.dart';

class AddToLibrarySheet extends StatefulWidget {
  const AddToLibrarySheet({
    super.key,
    required this.title,
    required this.onSave,
    this.initialStatus,
    this.initialRating,
    this.initialSeason,
    this.initialEpisode,
    this.isShow = false,
  });

  final String title;
  final void Function({
    required WatchStatus status,
    LetterRating? rating,
    int? currentSeason,
    int? currentEpisode,
  }) onSave;
  final WatchStatus? initialStatus;
  final LetterRating? initialRating;
  final int? initialSeason;
  final int? initialEpisode;
  final bool isShow;

  @override
  State<AddToLibrarySheet> createState() => _AddToLibrarySheetState();
}

class _AddToLibrarySheetState extends State<AddToLibrarySheet> {
  late WatchStatus _status;
  LetterRating? _rating;
  int? _season;
  int? _episode;

  final _seasonController = TextEditingController();
  final _episodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus ?? WatchStatus.yetToWatch;
    _rating = widget.initialRating;
    _season = widget.initialSeason;
    _episode = widget.initialEpisode;
    if (_season != null) _seasonController.text = _season.toString();
    if (_episode != null) _episodeController.text = _episode.toString();
  }

  @override
  void dispose() {
    _seasonController.dispose();
    _episodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: widget.isShow ? 0.65 : 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,
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
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildSectionTitle('Watch Status'),
                    _buildStatusSelector(),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildSectionTitle('Your Rating'),
                    _buildRatingSelector(),
                    if (widget.isShow) ...[
                      const SizedBox(height: AppConstants.defaultPadding),
                      _buildSectionTitle('Progress'),
                      _buildProgressFields(),
                    ],
                    const SizedBox(height: AppConstants.largePadding),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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

  Widget _buildStatusSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: WatchStatus.values.map((s) {
        final selected = _status == s;
        return ChoiceChip(
          label: Text(s.displayName),
          selected: selected,
          onSelected: (_) => setState(() => _status = s),
        );
      }).toList(),
    );
  }

  Widget _buildRatingSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        ChoiceChip(
          label: const Text('None'),
          selected: _rating == null,
          onSelected: (_) => setState(() => _rating = null),
        ),
        ...LetterRating.values.map((r) {
          final selected = _rating == r;
          return ChoiceChip(
            label: Text(r.displayName),
            selected: selected,
            onSelected: (_) => setState(() => _rating = r),
          );
        }),
      ],
    );
  }

  Widget _buildProgressFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _seasonController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Season',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => _season = int.tryParse(v),
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: TextField(
            controller: _episodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Episode',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => _episode = int.tryParse(v),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return FilledButton.icon(
      onPressed: () {
        widget.onSave(
          status: _status,
          rating: _rating,
          currentSeason: _season,
          currentEpisode: _episode,
        );
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.save),
      label: const Text('Save to Library'),
    );
  }
}
