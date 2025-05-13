import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yoya/dialogs/dialogs.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

class ProfilesPage extends StatelessWidget {
  static const String routeName = 'ProfilesPage';
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogNewProfile(context).then((onValue) {
            if (onValue[0]) {
              mainProvider.addProfile(ProfileModel(Uuid().v1(), onValue[1], onValue[2]));
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopWidget(title: 'Perfiles'),
                const SizedBox(height: 10),
                if (mainProvider.profiles.isNotEmpty)
                  SearchWidget(
                    onChange: (String value) => mainProvider.loadProfiles(search: value),
                    onClose: () {
                      mainProvider.loadProfiles();
                    },
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        mainProvider.filterProfiles.isNotEmpty
                            ? ListView.builder(
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              physics: const BouncingScrollPhysics(),
                              itemCount: mainProvider.filterProfiles.length,
                              itemBuilder: (context, index) {
                                return FadeInLeft(delay: Duration(milliseconds: 100 * index), child: ProfileWidget(profile: mainProvider.filterProfiles[index]));
                              },
                            )
                            : _noProfiles(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noProfiles() {
    return ZoomIn(
      duration: const Duration(milliseconds: 1500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No hay perfiles', style: Utils.bigTitleStyle), const SizedBox(height: 20), Icon(Icons.group_add_rounded, size: 150)],
        ),
      ),
    );
  }
}
