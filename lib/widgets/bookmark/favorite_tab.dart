import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/enums/auth.dart';
import 'package:test_app/models/user_model.dart';
import 'package:test_app/pages/auth/login_page.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final storage = const FlutterSecureStorage();
  late UserModal userModal = UserModal();
  late bool isLoading = false;

  Future<void> getAuth() async {
    setState(() {
      isLoading = true;
    });
    await storage.read(key: AuthEnum.user.name).then(
      (value) {
        if (value != null) {
          Map<String, dynamic> data = json.decode(value);
          setState(() {
            userModal = UserModal.fromJson(data);
          });
        }
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAuth();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: clPrimary, size: 50),
          )
        : userModal.token != null
            ? const Center(child: Text("login success"))
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: clPrimary,
                          foregroundColor:
                              clPrimary.withOpacity(0.7) // foreground
                          ),
                      onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const LoginPage(),
                          )),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
  }
}
