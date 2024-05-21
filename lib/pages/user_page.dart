import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/enums/auth.dart';
import 'package:test_app/models/user_model.dart';
import 'package:test_app/pages/auth/login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final storage = const FlutterSecureStorage();
  late UserModal userModal = UserModal();
  late bool isLoading = false;
  late bool isLoadingLogout = false;

  Future<void> getAuth() async {
    setState(() {
      isLoading = true;
    });
    await storage.read(key: AuthEnum.user.name).then(
      (value) {
        if (value != null) {
          Map<String, dynamic> data = jsonDecode(value);
          setState(() {
            userModal = UserModal.fromJson(data);
          });
        } else {
          setState(() {
            userModal = UserModal();
          });
        }
      },
    );
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getAuth();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: clPrimary),
                  borderRadius: BorderRadius.circular(50)),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/images/User-avatar.png"),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                userModal.name ?? "",
                style: const TextStyle(
                    color: clPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            userModal.token != null
                ? Card(
                    surfaceTintColor: Colors.red,
                    child: ListTile(
                      title: const Text("Đăng xuất"),
                      leading: const Icon(Icons.logout),
                      trailing: isLoadingLogout
                          ? LoadingAnimationWidget.fourRotatingDots(
                              color: clPrimary, size: 20)
                          : const SizedBox(),
                      onTap: () async {
                        setState(() {
                          isLoadingLogout = true;
                        });
                        await storage.delete(key: AuthEnum.user.name);
                        getAuth();
                        setState(() {
                          isLoadingLogout = false;
                        });
                      },
                    ),
                  )
                : Card(
                    surfaceTintColor: clPrimary,
                    child: ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text("Đăng nhập"),
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const LoginPage(),
                          )),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
