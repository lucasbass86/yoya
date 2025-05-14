import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/pages/_pages.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/routes/routes.dart';
import 'package:yoya/shared/preferences.dart';
import 'package:yoya/themes/themes.dart';
import 'package:yoya/utils/utils.dart';

//PROYECTO EMPEZADO EL 05/05/2025
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Preferences.init();
  Utils.path = await getApplicationDocumentsDirectory();
  Hive.init(Utils.path.path);
  await Hive.openBox(Utils.boxProfilesName);
  await Hive.openBox(Utils.boxItemsName);
  await Hive.openBox(Utils.boxHistoryName);

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => MainProvider(), lazy: true)], child: const MyApp()));
}

/*
  TAREAS PENDIENTES:
  - 
*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of(context, listen: false);
    mainProvider.profiles =
        Utils.boxProfiles.keys.map((e) {
          final value = Utils.boxProfiles.get(e);
          return ProfileModel.fromJson(value);
        }).toList();
    mainProvider.filterProfiles = mainProvider.profiles;
    mainProvider.filterProfiles.sort((a, b) => a.name.compareTo(b.name));
    mainProvider.items =
        Utils.boxItems.keys.map((e) {
          final value = Utils.boxItems.get(e);
          return ItemModel.fromJson(value);
        }).toList();
    mainProvider.filterItems = mainProvider.items;
    mainProvider.filterItems.sort((a, b) => a.description.compareTo(b.description));
    mainProvider.history =
        Utils.boxHistory.keys.map((e) {
          final value = Utils.boxHistory.get(e);
          return HistoryModel.fromJson(value);
        }).toList();

    //BORRAR BOX:
    // Utils.boxProfiles.deleteAll(Utils.boxProfiles.keys);
    // Utils.boxItems.deleteAll(Utils.boxItems.keys);
    // Utils.boxHistory.deleteAll(Utils.boxHistory.keys);

    return MaterialApp(
      title: 'YoYa App',
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: HomePage.routeName,
      darkTheme: darkTheme,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: const [Locale('es')],
    );
  }
}
