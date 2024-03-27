import 'package:flutter/material.dart';
import 'package:test_app/models/nav_item_model.dart';
import 'package:test_app/pages/bookmark_page.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/search_page.dart';
import 'package:test_app/pages/user_page.dart';

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    icon: const Icon(
      Icons.home_rounded,
      size: 36,
    ),
    page: const HomePage(),
  ),
  NavItemModel(
    icon: const Icon(
      Icons.search_rounded,
      size: 36,
    ),
    page: const SearchPage(),
  ),
  NavItemModel(
    icon: const Icon(
      Icons.bookmarks_outlined,
      size: 36,
    ),
    page: const BookmarkPage(),
  ),
  NavItemModel(
    icon: const Icon(
      Icons.person,
      size: 36,
    ),
    page: const UserPage(),
  )
];
