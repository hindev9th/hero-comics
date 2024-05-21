import 'package:flutter/material.dart';
import 'package:test_app/config/bottom_navi_items.dart';
import 'package:test_app/config/colors.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var selectedIndex = 0;

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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: bottomNavItems[selectedIndex].page,
          ),
          Positioned(
            bottom: 0,
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
                              color:
                                  selectedIndex == index ? clFocus : clPrimary,
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
          )
        ],
      ),
    );
  }
}
