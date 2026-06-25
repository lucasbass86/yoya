import 'package:flutter/material.dart';
import 'package:yoya/pages/_pages.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomePage.routeName: (_) => const HomePage(),
  ProfilesPage.routeName: (_) => const ProfilesPage(),
  ProfileDetailPage.routeName: (_) => const ProfileDetailPage(),
  ItemDetailPage.routeName: (_) => const ItemDetailPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
  HelpPage.routeName: (_) => const HelpPage(),
};
