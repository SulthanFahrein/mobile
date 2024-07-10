import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:test_ta_1/controller/c_home.dart';
import 'package:test_ta_1/page/home_page.dart';
import 'package:test_ta_1/widget/button_custom.dart';

class PropertyAlert extends StatelessWidget {
  final CHome cHome;
  final String iconAsset;
  final String noPropertyText;
  final String findPropertyText;

  const PropertyAlert({
    Key? key,
    required this.cHome,
    required this.iconAsset,
    required this.noPropertyText,
    required this.findPropertyText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          child: Image.asset(
            iconAsset,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 46),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              noPropertyText,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          findPropertyText,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ButtonCustom(
          label: 'View My Maps',
          onTap: () {
            cHome.indexPage = 0;
            Get.offAll(() => HomePage());
          },
        ),
      ],
    );
  }
}
