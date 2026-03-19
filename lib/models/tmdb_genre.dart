import 'package:flutter/foundation.dart';

@immutable
class TmdbGenre {
  const TmdbGenre({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory TmdbGenre.fromJson(Map<String, dynamic> json) {
    return TmdbGenre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbGenre && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
