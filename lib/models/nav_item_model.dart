import 'package:flutter/material.dart';
import 'package:test_app/pages/bookmark_page.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/search_page.dart';
import 'package:test_app/pages/user_page.dart'; // Import other page widgets as needed

class NavItemModel {
  final Widget page;
  final Icon icon;

  NavItemModel({required this.page, required this.icon});
}
