import 'package:flutter/material.dart';

import '../models/enums.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final WatchStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);
    return Chip(
      label: Text(
        status.displayName,
        style: TextStyle(color: color, fontSize: 12),
      ),
      side: BorderSide(color: color),
      backgroundColor: color.withAlpha(30),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Color _colorFor(WatchStatus status) {
    switch (status) {
      case WatchStatus.watched:
        return Colors.green;
      case WatchStatus.inProgress:
        return Colors.orange;
      case WatchStatus.yetToWatch:
        return Colors.blueGrey;
    }
  }
}
