import 'package:flutter/material.dart';

/// Background + foreground colors for a single genre chip.
@immutable
class GenreColor {
  const GenreColor({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

/// Maps TMDB genre IDs to chip colors.
///
/// Color choices follow rough genre/color conventions (red → action, teal → sci-fi,
/// pink → romance, etc.) constrained by a 9-ramp palette. Some less-common pairs
/// share a family (Drama/Documentary blue, Romance/Fantasy pink, Crime/TV Movie
/// gray); split later if a real-world clash looks bad.
const _genreColors = <int, GenreColor>{
  // Movie genres
  28: GenreColor(
      background: Color(0xFFFCEBEB), foreground: Color(0xFF501313)), // Action
  12: GenreColor(
      background: Color(0xFFFAECE7),
      foreground: Color(0xFF4A1B0C)), // Adventure
  16: GenreColor(
      background: Color(0xFFEEEDFE),
      foreground: Color(0xFF26215C)), // Animation
  35: GenreColor(
      background: Color(0xFFFAEEDA), foreground: Color(0xFF412402)), // Comedy
  80: GenreColor(
      background: Color(0xFFF1EFE8), foreground: Color(0xFF2C2C2A)), // Crime
  99: GenreColor(
      background: Color(0xFFE6F1FB),
      foreground: Color(0xFF042C53)), // Documentary
  18: GenreColor(
      background: Color(0xFFE6F1FB), foreground: Color(0xFF042C53)), // Drama
  10751: GenreColor(
      background: Color(0xFFEAF3DE), foreground: Color(0xFF173404)), // Family
  14: GenreColor(
      background: Color(0xFFFBEAF0), foreground: Color(0xFF4B1528)), // Fantasy
  36: GenreColor(
      background: Color(0xFFFAC775), foreground: Color(0xFF412402)), // History
  27: GenreColor(
      background: Color(0xFFF09595), foreground: Color(0xFF501313)), // Horror
  10402: GenreColor(
      background: Color(0xFFF4C0D1), foreground: Color(0xFF4B1528)), // Music
  9648: GenreColor(
      background: Color(0xFFCECBF6), foreground: Color(0xFF26215C)), // Mystery
  10749: GenreColor(
      background: Color(0xFFFBEAF0), foreground: Color(0xFF4B1528)), // Romance
  878: GenreColor(
      background: Color(0xFFE1F5EE),
      foreground: Color(0xFF04342C)), // Science Fiction
  10770: GenreColor(
      background: Color(0xFFF1EFE8),
      foreground: Color(0xFF2C2C2A)), // TV Movie
  53: GenreColor(
      background: Color(0xFFF5C4B3),
      foreground: Color(0xFF4A1B0C)), // Thriller
  10752: GenreColor(
      background: Color(0xFFB4B2A9), foreground: Color(0xFF2C2C2A)), // War
  37: GenreColor(
      background: Color(0xFFFAEEDA), foreground: Color(0xFF412402)), // Western

  // TV-only genres
  10759: GenreColor(
      background: Color(0xFFFCEBEB),
      foreground: Color(0xFF501313)), // Action & Adventure
  10765: GenreColor(
      background: Color(0xFFE1F5EE),
      foreground: Color(0xFF04342C)), // Sci-Fi & Fantasy
  10762: GenreColor(
      background: Color(0xFFEAF3DE), foreground: Color(0xFF173404)), // Kids
  10763: GenreColor(
      background: Color(0xFFB5D4F4), foreground: Color(0xFF042C53)), // News
  10764: GenreColor(
      background: Color(0xFFFAECE7), foreground: Color(0xFF4A1B0C)), // Reality
  10766: GenreColor(
      background: Color(0xFFFBEAF0), foreground: Color(0xFF4B1528)), // Soap
  10767: GenreColor(
      background: Color(0xFFE6F1FB), foreground: Color(0xFF042C53)), // Talk
  10768: GenreColor(
      background: Color(0xFFB4B2A9),
      foreground: Color(0xFF2C2C2A)), // War & Politics
};

const _fallback = GenreColor(
  background: Color(0xFFF1EFE8),
  foreground: Color(0xFF2C2C2A),
);

/// Returns the chip colors for a TMDB genre ID, or a neutral gray fallback
/// for any ID the palette doesn't explicitly know about.
GenreColor genreColor(int tmdbId) => _genreColors[tmdbId] ?? _fallback;
