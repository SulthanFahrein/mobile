import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:test_ta_1/controller/c_home.dart';
import 'package:test_ta_1/page/home_page.dart';
import 'package:test_ta_1/widget/button_custom.dart';

class ScheduleSuccessPage extends StatelessWidget {
  const ScheduleSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cHome = Get.put(CHome());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Icon(
                  Icons.check_circle_outline_sharp,
                  size: 150, // Adjust size as needed
                  color: Theme.of(context)
                    .primaryColor, // Adjust icon color as needed
                ),
            ),
          const SizedBox(height: 46),
          Text(
            'The schedule has been saved',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Please wait for a reply\nfrom the Qirby admin',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 46),
          ButtonCustom(
            label: 'View My Booking',
            onTap: () {
              cHome.indexPage = 1;
              Get.offAll(() => HomePage());
            },
          ),
        ],
      ),
    );
  }
}
