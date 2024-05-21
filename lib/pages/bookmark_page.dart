import 'package:flutter/material.dart';
import 'package:test_app/widgets/bookmark/favorite_tab.dart';
import 'package:test_app/widgets/bookmark/history_tab.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            text: "Lịch sử",
            icon: Icon(Icons.history),
          ),
          Tab(
            text: "Yêu thích",
            icon: Icon(Icons.favorite),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          HistoryTab(),
          FavoriteTab(),
        ],
      ),
    );
  }
}
