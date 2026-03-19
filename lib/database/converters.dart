import 'dart:convert';

import 'package:drift/drift.dart';

import '../models/enums.dart';

class WatchStatusConverter extends TypeConverter<WatchStatus, String> {
  const WatchStatusConverter();

  @override
  WatchStatus fromSql(String fromDb) => WatchStatus.fromString(fromDb);

  @override
  String toSql(WatchStatus value) => value.name;
}

class NullableLetterRatingConverter
    extends TypeConverter<LetterRating?, String?> {
  const NullableLetterRatingConverter();

  @override
  LetterRating? fromSql(String? fromDb) => LetterRating.fromString(fromDb);

  @override
  String? toSql(LetterRating? value) => value?.name;
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb);
    if (decoded is List) {
      return decoded.cast<String>();
    }
    return [];
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}
