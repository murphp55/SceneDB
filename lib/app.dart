import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_constants.dart';
import 'screens/shell_screen.dart';
import 'screens/browse/browse_screen.dart';
import 'screens/library/library_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/detail/movie_detail_screen.dart';
import 'screens/detail/show_detail_screen.dart';
import 'screens/watchlist/watchlist_screen.dart';

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/browse/movies',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/browse/movies',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BrowseScreen(initialTab: 0),
            ),
          ),
          GoRoute(
            path: '/browse/tv',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BrowseScreen(initialTab: 1),
            ),
          ),
          GoRoute(
            path: '/watchlist/movies',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WatchlistScreen(initialTab: 0),
            ),
          ),
          GoRoute(
            path: '/watchlist/tv',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WatchlistScreen(initialTab: 1),
            ),
          ),
          GoRoute(
            path: '/library/movies',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryScreen(initialTab: 0),
            ),
          ),
          GoRoute(
            path: '/library/tv',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryScreen(initialTab: 1),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/movie/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MovieDetailScreen(tmdbId: id);
        },
      ),
      GoRoute(
        path: '/show/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ShowDetailScreen(tmdbId: id);
        },
      ),
    ],
  );
});

// ---------------------------------------------------------------------------
// App widget
// ---------------------------------------------------------------------------

class SceneDBApp extends ConsumerWidget {
  const SceneDBApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: router,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3F51B5),
        brightness: Brightness.dark,
      ),
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppConstants.cardBorderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: const ChipThemeData(
        shape: StadiumBorder(),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
