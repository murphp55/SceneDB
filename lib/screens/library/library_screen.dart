import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/library_provider.dart';
import '../../widgets/filter_sheet.dart';
import 'library_view_mode.dart';
import 'movies_library_tab.dart';
import 'tv_library_tab.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LibraryViewMode _viewMode = LibraryViewMode.grid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    if (_tabController.index == 0) {
      context.go('/library/movies');
    } else {
      context.go('/library/tv');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  bool get _isMoviesTab => _tabController.index == 0;

  LibraryFilter get _currentFilter => _isMoviesTab
      ? ref.read(movieLibraryFilterProvider)
      : ref.read(showLibraryFilterProvider);

  List<String> _availableGenres(List items) {
    final genres = <String>{};
    for (final item in items) {
      genres.addAll(item.genres as List<String>);
    }
    return genres.toList()..sort();
  }

  void _openFilterSheet() {
    final movies = ref.read(trackedMoviesStreamProvider).valueOrNull ?? [];
    final shows = ref.read(trackedShowsStreamProvider).valueOrNull ?? [];
    final genres = _isMoviesTab
        ? _availableGenres(movies)
        : _availableGenres(shows);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterSheet(
        currentFilter: _currentFilter,
        availableGenres: genres,
        onApply: (filter) {
          if (_isMoviesTab) {
            ref.read(movieLibraryFilterProvider.notifier).update(filter);
          } else {
            ref.read(showLibraryFilterProvider.notifier).update(filter);
          }
        },
      ),
    );
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == LibraryViewMode.grid
          ? LibraryViewMode.tier
          : LibraryViewMode.grid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieFilter = ref.watch(movieLibraryFilterProvider);
    final showFilter = ref.watch(showLibraryFilterProvider);
    final filterActive =
        _isMoviesTab ? movieFilter.isActive : showFilter.isActive;
    final isTierView = _viewMode == LibraryViewMode.tier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            tooltip: isTierView ? 'Switch to grid view' : 'Switch to tier list',
            icon: Icon(isTierView
                ? Icons.grid_view_rounded
                : Icons.format_list_bulleted_rounded),
            onPressed: _toggleViewMode,
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: filterActive,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Filter',
            onPressed: _openFilterSheet,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV Shows'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MoviesLibraryTab(viewMode: _viewMode),
          TvLibraryTab(viewMode: _viewMode),
        ],
      ),
    );
  }
}
