import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/app/configs/theme.dart';
import 'package:social_media_app/app/resources/constant/named_routes.dart';
import 'package:social_media_app/ui/pages/home_page.dart';
import 'package:social_media_app/ui/pages/inbox_page.dart';
import 'package:social_media_app/ui/pages/login_page.dart';
import 'package:social_media_app/ui/pages/profile_page.dart';
import 'package:social_media_app/ui/pages/record_page.dart';
import 'package:social_media_app/ui/pages/navigation_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case NamedRoutes.homeScreen:
            return MaterialPageRoute(builder: (context) => HomePage());
          case NamedRoutes.recordScreen:
            return MaterialPageRoute(builder: (context) => const RecordPage());
          case NamedRoutes.navigationScreen:
            return MaterialPageRoute(
                builder: (context) => const NavigationPage(index: 0));
          case NamedRoutes.inboxPage:
            return MaterialPageRoute(builder: (context) => const InboxPage());
          default:
            return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      },
    );
  } //Deneme
}
