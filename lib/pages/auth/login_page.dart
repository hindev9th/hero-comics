import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/config/colors.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/enums/auth.dart';
import 'package:test_app/models/user_model.dart';
import 'package:test_app/widgets/bottom_navigation.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = const FlutterSecureStorage();
  late String username;
  late String password;
  late bool isLoading = false;
  bool isLogin = false;

  Future<void> checkLogin() async {
    String? user = await storage.read(key: AuthEnum.user.name);
    setState(() {
      isLogin = user != null;
    });
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
          Uri.parse('${dotenv.get("PUBLIC_URL_API")}/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'username': username, 'password': password}));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['status'] == 200) {
          UserModal userModal = UserModal.fromJson(data['data']);
          await storage.write(
              key: AuthEnum.user.name, value: jsonEncode(userModal.toJson()));

          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const BottomNavigation(),
                ));
          });
        } else {
          toastification.show(
            context: context,
            icon: const Icon(Icons.error),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text("Lỗi"),
            description: Text(data['message']),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 4),
            animationBuilder: (
              context,
              animation,
              alignment,
              child,
            ) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            borderRadius: BorderRadius.circular(100.0),
            showProgressBar: true,
            dragToClose: true,
          );
        }
      }
    } catch (e) {
      toastification.show(
        context: context,
        icon: const Icon(Icons.error),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text("Lỗi"),
        description: const Text("Không thể kết nối đến server."),
        alignment: Alignment.topRight,
        autoCloseDuration: const Duration(seconds: 4),
        animationBuilder: (
          context,
          animation,
          alignment,
          child,
        ) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        borderRadius: BorderRadius.circular(100.0),
        showProgressBar: true,
        dragToClose: true,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const BottomNavigation(),
            ));
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg.jpg'),
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.modulate),
                    opacity: 1,
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: clFocus,
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                            onPressed: () {
                              if (!isLoading) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Chào mừng bạn đến với",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                ),
                const Text(
                  "Hero Comics",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    enabled: !isLoading,
                    obscureText: false,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)),
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    enabled: !isLoading,
                    cursorColor: Colors.white,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)),
                        labelText: 'Mật khẩu',
                        labelStyle: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: clPrimary,
                          foregroundColor:
                              clPrimary.withOpacity(0.7) // foreground
                          ),
                      onPressed: () {
                        if (!isLoading) {
                          handleLogin();
                        }
                      },
                      child: isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                  color: Colors.white, size: 30),
                            )
                          : const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "hoặc",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 1,
                      width: 100,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Tạo một tài khoản mới ngay bây giờ?",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
