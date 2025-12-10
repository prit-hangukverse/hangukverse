// lib/routes/app_routes.dart

import 'package:flutter/material.dart';

// core screens
import '../screens/splash/splash_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';

// toggle menu screens
import '../screens/toggle/menu/home_menu_screen.dart';
import '../screens/toggle/menu/about_us_menu_screen.dart';
import '../screens/toggle/menu/community_menu_screen.dart';
import '../screens/toggle/menu/membership_menu_screen.dart';
import '../screens/toggle/menu/my_collection_menu_screen.dart';
import '../screens/toggle/menu/event_entries_menu_screen.dart';
import '../screens/toggle/menu/magazine_menu_screen.dart';
import '../screens/toggle/menu/hangukverse_concert_menu_screen.dart';
import '../screens/toggle/menu/setting_menu_screen.dart';
import '../screens/toggle/menu/survey_menu_screen.dart';

// lift & floor screens
import '../screens/lift/lift_sreen.dart';
import '../screens/lift/in_lift.dart';
import '../screens/lift/floor/first_f.dart';

// first-floor menu (rooms)
import '../screens/lift/floor/first_menu/Kdrama_discussion.dart';
import '../screens/lift/floor/first_menu/korean_kitchen.dart';
import '../screens/lift/floor/first_menu/kpop_room.dart';
import '../screens/lift/floor/first_menu/Meetup_room.dart';
import '../screens/lift/floor/first_menu/Webtoon_room.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    // core
    SplashScreen.routeName: (_) => const SplashScreen(),
    WelcomeScreen.routeName: (_) => const WelcomeScreen(),
    LoginScreen.routeName: (_) => const LoginScreen(),
    RegisterScreen.routeName: (_) => const RegisterScreen(),
    ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
    HomeScreen.routeName: (_) => const HomeScreen(),

    // toggle menus
    HomeMenuScreen.routeName: (_) => const HomeMenuScreen(),
    AboutUsMenuScreen.routeName: (_) => const AboutUsMenuScreen(),
    CommunityMenuScreen.routeName: (_) => const CommunityMenuScreen(),
    MembershipMenuScreen.routeName: (_) => const MembershipMenuScreen(),
    MyCollectionMenuScreen.routeName: (_) => const MyCollectionMenuScreen(),
    EventEntriesMenuScreen.routeName: (_) => const EventEntriesMenuScreen(),
    MagazineMenuScreen.routeName: (_) => const MagazineMenuScreen(),
    HangukverseConcertMenuScreen.routeName: (_) =>
        const HangukverseConcertMenuScreen(),
    SurveyMenuScreen.routeName: (_) => const SurveyMenuScreen(),
    SettingMenuScreen.routeName: (_) => const SettingMenuScreen(),

    // lift & floor
    LiftScreen.routeName: (_) => const LiftScreen(),
    InLiftScreen.routeName: (_) => const InLiftScreen(),
    FirstFloorScreen.routeName: (_) => const FirstFloorScreen(),

    // first-floor room screens
    KdramaDiscussionScreen.routeName: (_) => const KdramaDiscussionScreen(),
    KoreanKitchenScreen.routeName: (_) => const KoreanKitchenScreen(),
    KpopRoomScreen.routeName: (_) => const KpopRoomScreen(),
    MeetupRoomScreen.routeName: (_) => const MeetupRoomScreen(),
    WebtoonRoomScreen.routeName: (_) => const WebtoonRoomScreen(),
  };
}
