enum WatchStatus {
  yetToWatch,
  inProgress,
  watched;

  String get displayName {
    switch (this) {
      case WatchStatus.yetToWatch:
        return 'Yet to Watch';
      case WatchStatus.inProgress:
        return 'In Progress';
      case WatchStatus.watched:
        return 'Watched';
    }
  }

  static WatchStatus fromString(String value) {
    return WatchStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => WatchStatus.yetToWatch,
    );
  }
}

enum LetterRating {
  a,
  b,
  c,
  d,
  f;

  String get displayName {
    switch (this) {
      case LetterRating.a:
        return 'A';
      case LetterRating.b:
        return 'B';
      case LetterRating.c:
        return 'C';
      case LetterRating.d:
        return 'D';
      case LetterRating.f:
        return 'F';
    }
  }

  static LetterRating? fromString(String? value) {
    if (value == null) return null;
    return LetterRating.values.firstWhere(
      (e) => e.name == value,
      orElse: () => LetterRating.a,
    );
  }
}
