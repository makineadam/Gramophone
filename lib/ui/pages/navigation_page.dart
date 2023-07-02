import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:social_media_app/app/configs/theme.dart';
import 'package:social_media_app/ui/pages/inbox_page.dart';
import 'package:social_media_app/ui/pages/myprofile_page.dart';
import 'package:social_media_app/ui/pages/search_page.dart';

import 'home_page.dart';
import 'chat_page.dart';

class NavigationPage extends StatefulWidget {
  final int index;

  const NavigationPage({Key? key, required this.index}) : super(key: key);

  @override
  State<NavigationPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NavigationPage> {
  late int _selectedIndex;

  final pages = [
    HomePage(),
    const SearchPage(),
    InboxPage(),
    MyProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
      extendBody: true,
    );
  }

  Container _buildBottomNavBar() {
    return Container(
      width: double.infinity,
      height: 130,
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 110,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        padding: const EdgeInsets.all(16),
        //padding: const EdgeInsets.symmetric(horizontal: 16),
        //margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.3),
              blurRadius: 35,
              offset: const Offset(0, 10),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildItemBottomNavBar("assets/images/ic_home.png", "Home", 0),
            _buildItemBottomNavBar("assets/images/ic_search.png", "Search", 1),
            _buildItemBottomNavBar("assets/images/ic_inbox.png", "Inbox", 2),
            _buildItemBottomNavBar(
                "assets/images/ic_profile.png", "Profile", 3),
          ],
        ),
      ),
    );
  }

  _buildItemBottomNavBar(String icon, String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: index == _selectedIndex
              ? AppColors.whiteColor
              : Colors.transparent,
          boxShadow: [
            if (index == _selectedIndex)
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.1),
                blurRadius: 35,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
              color: index == _selectedIndex
                  ? AppColors.primaryColor2
                  : AppColors.blackColor,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTheme.blackTextStyle.copyWith(
                fontWeight: AppTheme.bold,
                fontSize: 12,
                color: index == _selectedIndex
                    ? AppColors.primaryColor2
                    : AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
