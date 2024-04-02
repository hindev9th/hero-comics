import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/config/bottomNaviItems.dart';
import 'package:test_app/config/colors.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var selectedIndex = 0;
  bool isHideBottomBar = false;
  ScrollController scrollController = ScrollController();

  Future<void> _pullRefresh() async {
    setState(() {});
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          isHideBottomBar = true;
        });
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          isHideBottomBar = false;
        });
      }
    });
  }

  void setSelectedIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: bottomNavItems[selectedIndex].page,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: isHideBottomBar
                  ? Matrix4.translationValues(0, 100, 0)
                  : Matrix4.translationValues(0, 0, 0),
              child: Container(
                height: 66,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                decoration: BoxDecoration(
                    color: clPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: clPrimary.withOpacity(0.3),
                        offset: const Offset(0, 20),
                        blurRadius: 20,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                      bottomNavItems.length,
                      (index) => Container(
                            decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? clFocus
                                    : clPrimary,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              icon: bottomNavItems[index].icon,
                              color: selectedIndex == index
                                  ? Colors.black
                                  : Colors.white,
                              onPressed: () {
                                setSelectedIndex(index);
                              },
                            ),
                          )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
