import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'movies_browse_tab.dart';
import 'tv_browse_tab.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      context.go('/browse/movies');
    } else {
      context.go('/browse/tv');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
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
        children: const [
          MoviesBrowseTab(),
          TvBrowseTab(),
        ],
      ),
    );
  }
}
