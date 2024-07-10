import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/config/app_route.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/page/change_pass.dart';
import 'package:test_ta_1/page/edit_profile.dart';
import 'package:test_ta_1/page/filter_page.dart';
import 'package:test_ta_1/page/information_page.dart';
import 'package:test_ta_1/page/maps_page.dart';
import 'package:test_ta_1/page/schedule_success_page.dart';
import 'package:test_ta_1/page/favorite_page.dart';
import 'package:test_ta_1/page/history_page.dart';
import 'package:test_ta_1/page/home_page.dart';
import 'package:test_ta_1/page/intro_page.dart';
import 'package:test_ta_1/page/notification_page.dart';
import 'package:test_ta_1/page/profile_page.dart';
import 'package:test_ta_1/page/search_page.dart';
import 'package:test_ta_1/page/signin_page.dart';
import 'package:test_ta_1/page/signup_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()..loadUser()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,  // Menambahkan performance overlay
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: AppColor.backGroundScaffold,
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
      ),
      routes: {
        '/': (context) {
          return FutureBuilder(
            future: Provider.of<SessionProvider>(context, listen: false).getToken(),
            builder: (context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Placeholder widget while waiting for token check
              } else {
                if (snapshot.hasData && snapshot.data != null) {
                  return HomePage(); // Navigate to HomePage if token exists
                } else {
                  return const IntroPage(); // Navigate to IntroPage if no token
                }
              }
            },
          );
        },
        AppRoute.signin: (context) => SigninPage(),
        AppRoute.intro: (context) => const IntroPage(),
        AppRoute.signup: (context) => SignupPage(),
        AppRoute.home: (context) => HomePage(),
        AppRoute.history: (context) => const HistoryPage(),
        AppRoute.profile: (context) => const ProfilePage(),
        AppRoute.favorite: (context) => FavoritePage(),
        AppRoute.search: (context) => SearchPage(),
        AppRoute.notif: (context) => const NotificationPage(),
        AppRoute.schedulesuccess: (context) => const ScheduleSuccessPage(),
        AppRoute.maps: (context) => const MapsPage(),
        AppRoute.editprofile: (context) => EditProfile(),
        AppRoute.filter: (context) => FilterPage(),
        AppRoute.changepass: (context) => ChangePass(),
        AppRoute.information: (context) => Information(),
      },
    );
  }
}
