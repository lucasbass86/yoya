import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yoya/dialogs/dialogs.dart';
import 'package:yoya/pages/_pages.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/shared/preferences.dart';
import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'HomePage';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          _checkUpdates(context);
          _checkBackUp(context);
        }
      });
    });

    return Scaffold(
      floatingActionButton: _fab(mainProvider, context),
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopWidget(title: 'YoYa', showProfiles: true, showBack: false, showExit: true, showSettings: true),
                const SizedBox(height: 10),
                SearchWidget(
                  onChange: (String value) => mainProvider.loadItems(search: value),
                  onClose: () {
                    mainProvider.loadItems();
                  },
                ),
                const SizedBox(height: 10),
                Expanded(child: _items(mainProvider)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fab(MainProvider mainProvider, BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (mainProvider.profiles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('No hay perfiles'));
          return;
        } else if (mainProvider.profiles.length < 2) {
          ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('No hay perfiles suficientes'));
          return;
        }
        Navigator.pushNamed(context, ItemDetailPage.routeName);
      },
      child: Icon(Icons.add),
    );
  }

  Widget _items(MainProvider mainProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child:
          mainProvider.filterItems.isNotEmpty
              ? ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                itemCount: mainProvider.filterItems.length,
                itemBuilder: (context, index) {
                  return FadeInLeft(delay: Duration(milliseconds: index * 200), child: ItemWidget(item: mainProvider.filterItems[index]));
                },
              )
              : _noItems(),
    );
  }

  Widget _noItems() {
    return ZoomIn(
      duration: const Duration(milliseconds: 1500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No hay registros', style: Utils.bigTitleStyle), const SizedBox(height: 20), Icon(Icons.workspaces_filled, size: 150)],
        ),
      ),
    );
  }

  Future<void> _checkBackUp(BuildContext context) async {
    final navigator = Navigator.of(context);
    if (Preferences.backUp.isNotEmpty && Utils.boxItems.values.isNotEmpty) {
      if (DateTime.now().difference(DateTime.parse(Preferences.backUp)).inDays >= 15) {
        final resp = await showMessage(context: context, message: 'Llevas ciertos días sin hacer copia de seguridad. ¿Hacer copia?', cancel: true);
        if (resp) {
          navigator.pushNamed(SettingsPage.routeName);
        }
      }
    }
  }

  Future<void> _checkUpdates(BuildContext context) async {
    late PackageInfo packageInfo;
    final hasConnected = await Utils.checkConnection();
    if (hasConnected) {
      PackageInfo.fromPlatform().then((value) async {
        packageInfo = value;
        final List<Versiones> rest = await UpdateService.getVersiones();
        if (rest.isNotEmpty) {
          if (rest.firstWhere((v) => v.appname == 'yoya').appversion.compareTo(packageInfo.version) != 0) {
            if (context.mounted) {
              Navigator.pushNamed(context, UpdatePage.routeName);
            }
          }
        }
      });
    }
  }
}
