import 'package:flutter/material.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/config/app_route.dart';
import 'package:test_ta_1/widget/map_content.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        searchField(context),
        const SizedBox(height: 20),
         MapContent(),
      ],
    );
  }

  Widget searchField(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: Stack(
                children: [
                  TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoute.search);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Warna latar belakang
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30.0), // Sudut tombol
                              side: BorderSide(
                                  color: Colors.grey.shade400), // Garis pinggir
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color:
                                      Colors.grey), // Icon pencarian (opsional)
                              SizedBox(width: 8.0),
                              Text(
                                'Search',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.circular(45),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(45),
                        child: const SizedBox(
                          height: 45,
                          width: 45,
                          child: Center(
                            child: ImageIcon(
                              AssetImage(AppAsset.iconSearch),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(45),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.filter);
              },
              borderRadius: BorderRadius.circular(45),
              child: const SizedBox(
                height: 45,
                width: 45,
                child: Center(
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(45),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.notif);
              },
              borderRadius: BorderRadius.circular(45),
              child: const SizedBox(
                height: 45,
                width: 45,
                child: Center(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
