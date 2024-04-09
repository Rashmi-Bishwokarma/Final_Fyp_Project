import 'package:fyp_rememory/app/modules/explore/views/explore_view.dart';

import 'package:fyp_rememory/app/modules/profile/views/profile_view.dart';
import 'package:fyp_rememory/app/modules/showjournal/views/showjournal_view.dart';
import 'package:fyp_rememory/app/modules/to_do_list/views/to_do_list_view.dart';
import 'package:fyp_rememory/app/modules/user_home/views/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: HeroIcon(
            HeroIcons.documentText,
            style: HeroIconStyle.outline,
            size: 30,
          ),
          label: 'Journal',
        ),
        BottomNavigationBarItem(
          icon: HeroIcon(
            HeroIcons.globeAlt,
            style: HeroIconStyle.outline, // Outlined icons are used by default.

            size: 30,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            size: 30,
          ),
          label: 'To-Do List',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: const Color.fromARGB(255, 71, 58, 121),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        _handleNavigation(index);
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Get.off(() => UserHomeView());
        break;
      case 1:
        Get.off(() => ShowJournalView());
        break;
      case 2:
        Get.off(() => ExploreView());
        break;
      case 3:
        Get.off(() => ToDoListView());
        break;
      case 4:
        Get.off(() => ProfileView());
        break;
    }
  }
}
