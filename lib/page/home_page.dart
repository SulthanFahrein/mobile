import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/controller/c_home.dart';
import 'package:test_ta_1/page/favorite_page.dart';
import 'package:test_ta_1/page/history_page.dart';
import 'package:test_ta_1/page/maps_page.dart';
import 'package:test_ta_1/page/profile_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final cHome = Get.put(CHome());
  final List<Map> listNav = [
    {'icon': AppAsset.iconMaps, 'label': 'Maps'},
    {'icon': AppAsset.iconHistory, 'label': 'History'},
    {'icon': AppAsset.iconFavorite, 'label': 'Favorite'},
    {'icon': AppAsset.iconProfile, 'label': 'Profile'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (cHome.indexPage == 0) {
          return const MapsPage();
        }
        if (cHome.indexPage == 1) {
          return  const HistoryPage();
        }
        if (cHome.indexPage == 2) {
          return  FavoritePage();
        }
        return ProfilePage();
      }),
      bottomNavigationBar: Obx(() {
        return Material(
          elevation: 8,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: BottomNavigationBar(
                currentIndex: cHome.indexPage,
                onTap: (value) => cHome.indexPage = value,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.black,
                selectedIconTheme: const IconThemeData(
                  color: AppColor.primary,
                ),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                selectedFontSize: 12,
                items: listNav.map((e) {
                  return BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(e['icon'])),
                    label: e['label'],
                  );
                }).toList()),
          ),
        );
      }),
    );
  }
}
