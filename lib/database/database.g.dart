// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TrackedMoviesTable extends TrackedMovies
    with TableInfo<$TrackedMoviesTable, TrackedMovie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedMoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _posterPathMeta =
      const VerificationMeta('posterPath');
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
      'poster_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> genres =
      GeneratedColumn<String>('genres', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>($TrackedMoviesTable.$convertergenres);
  @override
  late final GeneratedColumnWithTypeConverter<WatchStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('yetToWatch'))
          .withConverter<WatchStatus>($TrackedMoviesTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<LetterRating?, String> rating =
      GeneratedColumn<String>('rating', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<LetterRating?>($TrackedMoviesTable.$converterrating);
  static const VerificationMeta _watchedOnMeta =
      const VerificationMeta('watchedOn');
  @override
  late final GeneratedColumn<DateTime> watchedOn = GeneratedColumn<DateTime>(
      'watched_on', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tmdbId,
        title,
        posterPath,
        genres,
        status,
        rating,
        watchedOn,
        addedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracked_movies';
  @override
  VerificationContext validateIntegrity(Insertable<TrackedMovie> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
          _posterPathMeta,
          posterPath.isAcceptableOrUnknown(
              data['poster_path']!, _posterPathMeta));
    }
    if (data.containsKey('watched_on')) {
      context.handle(_watchedOnMeta,
          watchedOn.isAcceptableOrUnknown(data['watched_on']!, _watchedOnMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedMovie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackedMovie(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      posterPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poster_path']),
      genres: $TrackedMoviesTable.$convertergenres.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genres'])!),
      status: $TrackedMoviesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      rating: $TrackedMoviesTable.$converterrating.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rating'])),
      watchedOn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}watched_on']),
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $TrackedMoviesTable createAlias(String alias) {
    return $TrackedMoviesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertergenres =
      const StringListConverter();
  static TypeConverter<WatchStatus, String> $converterstatus =
      const WatchStatusConverter();
  static TypeConverter<LetterRating?, String?> $converterrating =
      const NullableLetterRatingConverter();
}

class TrackedMovie extends DataClass implements Insertable<TrackedMovie> {
  final int id;
  final int tmdbId;
  final String title;
  final String? posterPath;
  final List<String> genres;
  final WatchStatus status;
  final LetterRating? rating;
  final DateTime? watchedOn;
  final DateTime addedAt;
  const TrackedMovie(
      {required this.id,
      required this.tmdbId,
      required this.title,
      this.posterPath,
      required this.genres,
      required this.status,
      this.rating,
      this.watchedOn,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    {
      map['genres'] =
          Variable<String>($TrackedMoviesTable.$convertergenres.toSql(genres));
    }
    {
      map['status'] =
          Variable<String>($TrackedMoviesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] =
          Variable<String>($TrackedMoviesTable.$converterrating.toSql(rating));
    }
    if (!nullToAbsent || watchedOn != null) {
      map['watched_on'] = Variable<DateTime>(watchedOn);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  TrackedMoviesCompanion toCompanion(bool nullToAbsent) {
    return TrackedMoviesCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      title: Value(title),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      genres: Value(genres),
      status: Value(status),
      rating:
          rating == null && nullToAbsent ? const Value.absent() : Value(rating),
      watchedOn: watchedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(watchedOn),
      addedAt: Value(addedAt),
    );
  }

  factory TrackedMovie.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedMovie(
      id: serializer.fromJson<int>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      title: serializer.fromJson<String>(json['title']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      genres: serializer.fromJson<List<String>>(json['genres']),
      status: serializer.fromJson<WatchStatus>(json['status']),
      rating: serializer.fromJson<LetterRating?>(json['rating']),
      watchedOn: serializer.fromJson<DateTime?>(json['watchedOn']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'title': serializer.toJson<String>(title),
      'posterPath': serializer.toJson<String?>(posterPath),
      'genres': serializer.toJson<List<String>>(genres),
      'status': serializer.toJson<WatchStatus>(status),
      'rating': serializer.toJson<LetterRating?>(rating),
      'watchedOn': serializer.toJson<DateTime?>(watchedOn),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  TrackedMovie copyWith(
          {int? id,
          int? tmdbId,
          String? title,
          Value<String?> posterPath = const Value.absent(),
          List<String>? genres,
          WatchStatus? status,
          Value<LetterRating?> rating = const Value.absent(),
          Value<DateTime?> watchedOn = const Value.absent(),
          DateTime? addedAt}) =>
      TrackedMovie(
        id: id ?? this.id,
        tmdbId: tmdbId ?? this.tmdbId,
        title: title ?? this.title,
        posterPath: posterPath.present ? posterPath.value : this.posterPath,
        genres: genres ?? this.genres,
        status: status ?? this.status,
        rating: rating.present ? rating.value : this.rating,
        watchedOn: watchedOn.present ? watchedOn.value : this.watchedOn,
        addedAt: addedAt ?? this.addedAt,
      );
  TrackedMovie copyWithCompanion(TrackedMoviesCompanion data) {
    return TrackedMovie(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      title: data.title.present ? data.title.value : this.title,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      genres: data.genres.present ? data.genres.value : this.genres,
      status: data.status.present ? data.status.value : this.status,
      rating: data.rating.present ? data.rating.value : this.rating,
      watchedOn: data.watchedOn.present ? data.watchedOn.value : this.watchedOn,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackedMovie(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('genres: $genres, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('watchedOn: $watchedOn, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tmdbId, title, posterPath, genres, status,
      rating, watchedOn, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedMovie &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.title == this.title &&
          other.posterPath == this.posterPath &&
          other.genres == this.genres &&
          other.status == this.status &&
          other.rating == this.rating &&
          other.watchedOn == this.watchedOn &&
          other.addedAt == this.addedAt);
}

class TrackedMoviesCompanion extends UpdateCompanion<TrackedMovie> {
  final Value<int> id;
  final Value<int> tmdbId;
  final Value<String> title;
  final Value<String?> posterPath;
  final Value<List<String>> genres;
  final Value<WatchStatus> status;
  final Value<LetterRating?> rating;
  final Value<DateTime?> watchedOn;
  final Value<DateTime> addedAt;
  const TrackedMoviesCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.title = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.genres = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.watchedOn = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  TrackedMoviesCompanion.insert({
    this.id = const Value.absent(),
    required int tmdbId,
    required String title,
    this.posterPath = const Value.absent(),
    this.genres = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.watchedOn = const Value.absent(),
    this.addedAt = const Value.absent(),
  })  : tmdbId = Value(tmdbId),
        title = Value(title);
  static Insertable<TrackedMovie> custom({
    Expression<int>? id,
    Expression<int>? tmdbId,
    Expression<String>? title,
    Expression<String>? posterPath,
    Expression<String>? genres,
    Expression<String>? status,
    Expression<String>? rating,
    Expression<DateTime>? watchedOn,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (title != null) 'title': title,
      if (posterPath != null) 'poster_path': posterPath,
      if (genres != null) 'genres': genres,
      if (status != null) 'status': status,
      if (rating != null) 'rating': rating,
      if (watchedOn != null) 'watched_on': watchedOn,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  TrackedMoviesCompanion copyWith(
      {Value<int>? id,
      Value<int>? tmdbId,
      Value<String>? title,
      Value<String?>? posterPath,
      Value<List<String>>? genres,
      Value<WatchStatus>? status,
      Value<LetterRating?>? rating,
      Value<DateTime?>? watchedOn,
      Value<DateTime>? addedAt}) {
    return TrackedMoviesCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      genres: genres ?? this.genres,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      watchedOn: watchedOn ?? this.watchedOn,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(
          $TrackedMoviesTable.$convertergenres.toSql(genres.value));
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $TrackedMoviesTable.$converterstatus.toSql(status.value));
    }
    if (rating.present) {
      map['rating'] = Variable<String>(
          $TrackedMoviesTable.$converterrating.toSql(rating.value));
    }
    if (watchedOn.present) {
      map['watched_on'] = Variable<DateTime>(watchedOn.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedMoviesCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('genres: $genres, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('watchedOn: $watchedOn, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $TrackedShowsTable extends TrackedShows
    with TableInfo<$TrackedShowsTable, TrackedShow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedShowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _posterPathMeta =
      const VerificationMeta('posterPath');
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
      'poster_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> genres =
      GeneratedColumn<String>('genres', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>($TrackedShowsTable.$convertergenres);
  @override
  late final GeneratedColumnWithTypeConverter<WatchStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('yetToWatch'))
          .withConverter<WatchStatus>($TrackedShowsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<LetterRating?, String> rating =
      GeneratedColumn<String>('rating', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<LetterRating?>($TrackedShowsTable.$converterrating);
  static const VerificationMeta _watchedOnMeta =
      const VerificationMeta('watchedOn');
  @override
  late final GeneratedColumn<DateTime> watchedOn = GeneratedColumn<DateTime>(
      'watched_on', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentSeasonMeta =
      const VerificationMeta('currentSeason');
  @override
  late final GeneratedColumn<int> currentSeason = GeneratedColumn<int>(
      'current_season', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentEpisodeMeta =
      const VerificationMeta('currentEpisode');
  @override
  late final GeneratedColumn<int> currentEpisode = GeneratedColumn<int>(
      'current_episode', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tmdbId,
        title,
        posterPath,
        genres,
        status,
        rating,
        watchedOn,
        addedAt,
        currentSeason,
        currentEpisode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracked_shows';
  @override
  VerificationContext validateIntegrity(Insertable<TrackedShow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
          _posterPathMeta,
          posterPath.isAcceptableOrUnknown(
              data['poster_path']!, _posterPathMeta));
    }
    if (data.containsKey('watched_on')) {
      context.handle(_watchedOnMeta,
          watchedOn.isAcceptableOrUnknown(data['watched_on']!, _watchedOnMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    if (data.containsKey('current_season')) {
      context.handle(
          _currentSeasonMeta,
          currentSeason.isAcceptableOrUnknown(
              data['current_season']!, _currentSeasonMeta));
    }
    if (data.containsKey('current_episode')) {
      context.handle(
          _currentEpisodeMeta,
          currentEpisode.isAcceptableOrUnknown(
              data['current_episode']!, _currentEpisodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedShow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackedShow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      posterPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poster_path']),
      genres: $TrackedShowsTable.$convertergenres.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genres'])!),
      status: $TrackedShowsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      rating: $TrackedShowsTable.$converterrating.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rating'])),
      watchedOn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}watched_on']),
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
      currentSeason: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_season']),
      currentEpisode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_episode']),
    );
  }

  @override
  $TrackedShowsTable createAlias(String alias) {
    return $TrackedShowsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertergenres =
      const StringListConverter();
  static TypeConverter<WatchStatus, String> $converterstatus =
      const WatchStatusConverter();
  static TypeConverter<LetterRating?, String?> $converterrating =
      const NullableLetterRatingConverter();
}

class TrackedShow extends DataClass implements Insertable<TrackedShow> {
  final int id;
  final int tmdbId;
  final String title;
  final String? posterPath;
  final List<String> genres;
  final WatchStatus status;
  final LetterRating? rating;
  final DateTime? watchedOn;
  final DateTime addedAt;
  final int? currentSeason;
  final int? currentEpisode;
  const TrackedShow(
      {required this.id,
      required this.tmdbId,
      required this.title,
      this.posterPath,
      required this.genres,
      required this.status,
      this.rating,
      this.watchedOn,
      required this.addedAt,
      this.currentSeason,
      this.currentEpisode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    {
      map['genres'] =
          Variable<String>($TrackedShowsTable.$convertergenres.toSql(genres));
    }
    {
      map['status'] =
          Variable<String>($TrackedShowsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] =
          Variable<String>($TrackedShowsTable.$converterrating.toSql(rating));
    }
    if (!nullToAbsent || watchedOn != null) {
      map['watched_on'] = Variable<DateTime>(watchedOn);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || currentSeason != null) {
      map['current_season'] = Variable<int>(currentSeason);
    }
    if (!nullToAbsent || currentEpisode != null) {
      map['current_episode'] = Variable<int>(currentEpisode);
    }
    return map;
  }

  TrackedShowsCompanion toCompanion(bool nullToAbsent) {
    return TrackedShowsCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      title: Value(title),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      genres: Value(genres),
      status: Value(status),
      rating:
          rating == null && nullToAbsent ? const Value.absent() : Value(rating),
      watchedOn: watchedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(watchedOn),
      addedAt: Value(addedAt),
      currentSeason: currentSeason == null && nullToAbsent
          ? const Value.absent()
          : Value(currentSeason),
      currentEpisode: currentEpisode == null && nullToAbsent
          ? const Value.absent()
          : Value(currentEpisode),
    );
  }

  factory TrackedShow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedShow(
      id: serializer.fromJson<int>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      title: serializer.fromJson<String>(json['title']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      genres: serializer.fromJson<List<String>>(json['genres']),
      status: serializer.fromJson<WatchStatus>(json['status']),
      rating: serializer.fromJson<LetterRating?>(json['rating']),
      watchedOn: serializer.fromJson<DateTime?>(json['watchedOn']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      currentSeason: serializer.fromJson<int?>(json['currentSeason']),
      currentEpisode: serializer.fromJson<int?>(json['currentEpisode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'title': serializer.toJson<String>(title),
      'posterPath': serializer.toJson<String?>(posterPath),
      'genres': serializer.toJson<List<String>>(genres),
      'status': serializer.toJson<WatchStatus>(status),
      'rating': serializer.toJson<LetterRating?>(rating),
      'watchedOn': serializer.toJson<DateTime?>(watchedOn),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'currentSeason': serializer.toJson<int?>(currentSeason),
      'currentEpisode': serializer.toJson<int?>(currentEpisode),
    };
  }

  TrackedShow copyWith(
          {int? id,
          int? tmdbId,
          String? title,
          Value<String?> posterPath = const Value.absent(),
          List<String>? genres,
          WatchStatus? status,
          Value<LetterRating?> rating = const Value.absent(),
          Value<DateTime?> watchedOn = const Value.absent(),
          DateTime? addedAt,
          Value<int?> currentSeason = const Value.absent(),
          Value<int?> currentEpisode = const Value.absent()}) =>
      TrackedShow(
        id: id ?? this.id,
        tmdbId: tmdbId ?? this.tmdbId,
        title: title ?? this.title,
        posterPath: posterPath.present ? posterPath.value : this.posterPath,
        genres: genres ?? this.genres,
        status: status ?? this.status,
        rating: rating.present ? rating.value : this.rating,
        watchedOn: watchedOn.present ? watchedOn.value : this.watchedOn,
        addedAt: addedAt ?? this.addedAt,
        currentSeason:
            currentSeason.present ? currentSeason.value : this.currentSeason,
        currentEpisode:
            currentEpisode.present ? currentEpisode.value : this.currentEpisode,
      );
  TrackedShow copyWithCompanion(TrackedShowsCompanion data) {
    return TrackedShow(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      title: data.title.present ? data.title.value : this.title,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      genres: data.genres.present ? data.genres.value : this.genres,
      status: data.status.present ? data.status.value : this.status,
      rating: data.rating.present ? data.rating.value : this.rating,
      watchedOn: data.watchedOn.present ? data.watchedOn.value : this.watchedOn,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      currentSeason: data.currentSeason.present
          ? data.currentSeason.value
          : this.currentSeason,
      currentEpisode: data.currentEpisode.present
          ? data.currentEpisode.value
          : this.currentEpisode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackedShow(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('genres: $genres, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('watchedOn: $watchedOn, ')
          ..write('addedAt: $addedAt, ')
          ..write('currentSeason: $currentSeason, ')
          ..write('currentEpisode: $currentEpisode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tmdbId, title, posterPath, genres, status,
      rating, watchedOn, addedAt, currentSeason, currentEpisode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedShow &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.title == this.title &&
          other.posterPath == this.posterPath &&
          other.genres == this.genres &&
          other.status == this.status &&
          other.rating == this.rating &&
          other.watchedOn == this.watchedOn &&
          other.addedAt == this.addedAt &&
          other.currentSeason == this.currentSeason &&
          other.currentEpisode == this.currentEpisode);
}

class TrackedShowsCompanion extends UpdateCompanion<TrackedShow> {
  final Value<int> id;
  final Value<int> tmdbId;
  final Value<String> title;
  final Value<String?> posterPath;
  final Value<List<String>> genres;
  final Value<WatchStatus> status;
  final Value<LetterRating?> rating;
  final Value<DateTime?> watchedOn;
  final Value<DateTime> addedAt;
  final Value<int?> currentSeason;
  final Value<int?> currentEpisode;
  const TrackedShowsCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.title = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.genres = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.watchedOn = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.currentSeason = const Value.absent(),
    this.currentEpisode = const Value.absent(),
  });
  TrackedShowsCompanion.insert({
    this.id = const Value.absent(),
    required int tmdbId,
    required String title,
    this.posterPath = const Value.absent(),
    this.genres = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.watchedOn = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.currentSeason = const Value.absent(),
    this.currentEpisode = const Value.absent(),
  })  : tmdbId = Value(tmdbId),
        title = Value(title);
  static Insertable<TrackedShow> custom({
    Expression<int>? id,
    Expression<int>? tmdbId,
    Expression<String>? title,
    Expression<String>? posterPath,
    Expression<String>? genres,
    Expression<String>? status,
    Expression<String>? rating,
    Expression<DateTime>? watchedOn,
    Expression<DateTime>? addedAt,
    Expression<int>? currentSeason,
    Expression<int>? currentEpisode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (title != null) 'title': title,
      if (posterPath != null) 'poster_path': posterPath,
      if (genres != null) 'genres': genres,
      if (status != null) 'status': status,
      if (rating != null) 'rating': rating,
      if (watchedOn != null) 'watched_on': watchedOn,
      if (addedAt != null) 'added_at': addedAt,
      if (currentSeason != null) 'current_season': currentSeason,
      if (currentEpisode != null) 'current_episode': currentEpisode,
    });
  }

  TrackedShowsCompanion copyWith(
      {Value<int>? id,
      Value<int>? tmdbId,
      Value<String>? title,
      Value<String?>? posterPath,
      Value<List<String>>? genres,
      Value<WatchStatus>? status,
      Value<LetterRating?>? rating,
      Value<DateTime?>? watchedOn,
      Value<DateTime>? addedAt,
      Value<int?>? currentSeason,
      Value<int?>? currentEpisode}) {
    return TrackedShowsCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      genres: genres ?? this.genres,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      watchedOn: watchedOn ?? this.watchedOn,
      addedAt: addedAt ?? this.addedAt,
      currentSeason: currentSeason ?? this.currentSeason,
      currentEpisode: currentEpisode ?? this.currentEpisode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(
          $TrackedShowsTable.$convertergenres.toSql(genres.value));
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $TrackedShowsTable.$converterstatus.toSql(status.value));
    }
    if (rating.present) {
      map['rating'] = Variable<String>(
          $TrackedShowsTable.$converterrating.toSql(rating.value));
    }
    if (watchedOn.present) {
      map['watched_on'] = Variable<DateTime>(watchedOn.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (currentSeason.present) {
      map['current_season'] = Variable<int>(currentSeason.value);
    }
    if (currentEpisode.present) {
      map['current_episode'] = Variable<int>(currentEpisode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedShowsCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('genres: $genres, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('watchedOn: $watchedOn, ')
          ..write('addedAt: $addedAt, ')
          ..write('currentSeason: $currentSeason, ')
          ..write('currentEpisode: $currentEpisode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrackedMoviesTable trackedMovies = $TrackedMoviesTable(this);
  late final $TrackedShowsTable trackedShows = $TrackedShowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [trackedMovies, trackedShows];
}

typedef $$TrackedMoviesTableCreateCompanionBuilder = TrackedMoviesCompanion
    Function({
  Value<int> id,
  required int tmdbId,
  required String title,
  Value<String?> posterPath,
  Value<List<String>> genres,
  Value<WatchStatus> status,
  Value<LetterRating?> rating,
  Value<DateTime?> watchedOn,
  Value<DateTime> addedAt,
});
typedef $$TrackedMoviesTableUpdateCompanionBuilder = TrackedMoviesCompanion
    Function({
  Value<int> id,
  Value<int> tmdbId,
  Value<String> title,
  Value<String?> posterPath,
  Value<List<String>> genres,
  Value<WatchStatus> status,
  Value<LetterRating?> rating,
  Value<DateTime?> watchedOn,
  Value<DateTime> addedAt,
});

class $$TrackedMoviesTableFilterComposer
    extends Composer<_$AppDatabase, $TrackedMoviesTable> {
  $$TrackedMoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get genres => $composableBuilder(
          column: $table.genres,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<WatchStatus, WatchStatus, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<LetterRating?, LetterRating, String>
      get rating => $composableBuilder(
          column: $table.rating,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get watchedOn => $composableBuilder(
      column: $table.watchedOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));
}

class $$TrackedMoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackedMoviesTable> {
  $$TrackedMoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genres => $composableBuilder(
      column: $table.genres, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get watchedOn => $composableBuilder(
      column: $table.watchedOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));
}

class $$TrackedMoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackedMoviesTable> {
  $$TrackedMoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WatchStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LetterRating?, String> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get watchedOn =>
      $composableBuilder(column: $table.watchedOn, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$TrackedMoviesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrackedMoviesTable,
    TrackedMovie,
    $$TrackedMoviesTableFilterComposer,
    $$TrackedMoviesTableOrderingComposer,
    $$TrackedMoviesTableAnnotationComposer,
    $$TrackedMoviesTableCreateCompanionBuilder,
    $$TrackedMoviesTableUpdateCompanionBuilder,
    (
      TrackedMovie,
      BaseReferences<_$AppDatabase, $TrackedMoviesTable, TrackedMovie>
    ),
    TrackedMovie,
    PrefetchHooks Function()> {
  $$TrackedMoviesTableTableManager(_$AppDatabase db, $TrackedMoviesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackedMoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackedMoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackedMoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<List<String>> genres = const Value.absent(),
            Value<WatchStatus> status = const Value.absent(),
            Value<LetterRating?> rating = const Value.absent(),
            Value<DateTime?> watchedOn = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              TrackedMoviesCompanion(
            id: id,
            tmdbId: tmdbId,
            title: title,
            posterPath: posterPath,
            genres: genres,
            status: status,
            rating: rating,
            watchedOn: watchedOn,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tmdbId,
            required String title,
            Value<String?> posterPath = const Value.absent(),
            Value<List<String>> genres = const Value.absent(),
            Value<WatchStatus> status = const Value.absent(),
            Value<LetterRating?> rating = const Value.absent(),
            Value<DateTime?> watchedOn = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              TrackedMoviesCompanion.insert(
            id: id,
            tmdbId: tmdbId,
            title: title,
            posterPath: posterPath,
            genres: genres,
            status: status,
            rating: rating,
            watchedOn: watchedOn,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrackedMoviesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrackedMoviesTable,
    TrackedMovie,
    $$TrackedMoviesTableFilterComposer,
    $$TrackedMoviesTableOrderingComposer,
    $$TrackedMoviesTableAnnotationComposer,
    $$TrackedMoviesTableCreateCompanionBuilder,
    $$TrackedMoviesTableUpdateCompanionBuilder,
    (
      TrackedMovie,
      BaseReferences<_$AppDatabase, $TrackedMoviesTable, TrackedMovie>
    ),
    TrackedMovie,
    PrefetchHooks Function()>;
typedef $$TrackedShowsTableCreateCompanionBuilder = TrackedShowsCompanion
    Function({
  Value<int> id,
  required int tmdbId,
  required String title,
  Value<String?> posterPath,
  Value<List<String>> genres,
  Value<WatchStatus> status,
  Value<LetterRating?> rating,
  Value<DateTime?> watchedOn,
  Value<DateTime> addedAt,
  Value<int?> currentSeason,
  Value<int?> currentEpisode,
});
typedef $$TrackedShowsTableUpdateCompanionBuilder = TrackedShowsCompanion
    Function({
  Value<int> id,
  Value<int> tmdbId,
  Value<String> title,
  Value<String?> posterPath,
  Value<List<String>> genres,
  Value<WatchStatus> status,
  Value<LetterRating?> rating,
  Value<DateTime?> watchedOn,
  Value<DateTime> addedAt,
  Value<int?> currentSeason,
  Value<int?> currentEpisode,
});

class $$TrackedShowsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackedShowsTable> {
  $$TrackedShowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get genres => $composableBuilder(
          column: $table.genres,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<WatchStatus, WatchStatus, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<LetterRating?, LetterRating, String>
      get rating => $composableBuilder(
          column: $table.rating,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get watchedOn => $composableBuilder(
      column: $table.watchedOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentSeason => $composableBuilder(
      column: $table.currentSeason, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentEpisode => $composableBuilder(
      column: $table.currentEpisode,
      builder: (column) => ColumnFilters(column));
}

class $$TrackedShowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackedShowsTable> {
  $$TrackedShowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genres => $composableBuilder(
      column: $table.genres, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get watchedOn => $composableBuilder(
      column: $table.watchedOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentSeason => $composableBuilder(
      column: $table.currentSeason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentEpisode => $composableBuilder(
      column: $table.currentEpisode,
      builder: (column) => ColumnOrderings(column));
}

class $$TrackedShowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackedShowsTable> {
  $$TrackedShowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WatchStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LetterRating?, String> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get watchedOn =>
      $composableBuilder(column: $table.watchedOn, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<int> get currentSeason => $composableBuilder(
      column: $table.currentSeason, builder: (column) => column);

  GeneratedColumn<int> get currentEpisode => $composableBuilder(
      column: $table.currentEpisode, builder: (column) => column);
}

class $$TrackedShowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrackedShowsTable,
    TrackedShow,
    $$TrackedShowsTableFilterComposer,
    $$TrackedShowsTableOrderingComposer,
    $$TrackedShowsTableAnnotationComposer,
    $$TrackedShowsTableCreateCompanionBuilder,
    $$TrackedShowsTableUpdateCompanionBuilder,
    (
      TrackedShow,
      BaseReferences<_$AppDatabase, $TrackedShowsTable, TrackedShow>
    ),
    TrackedShow,
    PrefetchHooks Function()> {
  $$TrackedShowsTableTableManager(_$AppDatabase db, $TrackedShowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackedShowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackedShowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackedShowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<List<String>> genres = const Value.absent(),
            Value<WatchStatus> status = const Value.absent(),
            Value<LetterRating?> rating = const Value.absent(),
            Value<DateTime?> watchedOn = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
            Value<int?> currentSeason = const Value.absent(),
            Value<int?> currentEpisode = const Value.absent(),
          }) =>
              TrackedShowsCompanion(
            id: id,
            tmdbId: tmdbId,
            title: title,
            posterPath: posterPath,
            genres: genres,
            status: status,
            rating: rating,
            watchedOn: watchedOn,
            addedAt: addedAt,
            currentSeason: currentSeason,
            currentEpisode: currentEpisode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tmdbId,
            required String title,
            Value<String?> posterPath = const Value.absent(),
            Value<List<String>> genres = const Value.absent(),
            Value<WatchStatus> status = const Value.absent(),
            Value<LetterRating?> rating = const Value.absent(),
            Value<DateTime?> watchedOn = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
            Value<int?> currentSeason = const Value.absent(),
            Value<int?> currentEpisode = const Value.absent(),
          }) =>
              TrackedShowsCompanion.insert(
            id: id,
            tmdbId: tmdbId,
            title: title,
            posterPath: posterPath,
            genres: genres,
            status: status,
            rating: rating,
            watchedOn: watchedOn,
            addedAt: addedAt,
            currentSeason: currentSeason,
            currentEpisode: currentEpisode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrackedShowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrackedShowsTable,
    TrackedShow,
    $$TrackedShowsTableFilterComposer,
    $$TrackedShowsTableOrderingComposer,
    $$TrackedShowsTableAnnotationComposer,
    $$TrackedShowsTableCreateCompanionBuilder,
    $$TrackedShowsTableUpdateCompanionBuilder,
    (
      TrackedShow,
      BaseReferences<_$AppDatabase, $TrackedShowsTable, TrackedShow>
    ),
    TrackedShow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrackedMoviesTableTableManager get trackedMovies =>
      $$TrackedMoviesTableTableManager(_db, _db.trackedMovies);
  $$TrackedShowsTableTableManager get trackedShows =>
      $$TrackedShowsTableTableManager(_db, _db.trackedShows);
}
