import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoya/pages/_pages.dart';
import 'package:yoya/utils/utils.dart';

class TopWidget extends StatelessWidget {
  final bool showBack;
  final bool showProfiles;
  final bool showExit;
  final bool showSettings;
  final bool showHelp;
  final bool showDelete;
  final Function? onDelete;
  final String title;
  const TopWidget({
    super.key,
    this.showBack = true,
    this.showProfiles = false,
    this.showExit = false,
    required this.title,
    this.showSettings = false,
    this.showHelp = false,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Row(
        children: [
          if (showBack) InkWell(borderRadius: BorderRadius.circular(20), onTap: () => _close(context), child: Icon(Icons.arrow_back_ios_new)),
          GestureDetector(onTap: () => _close(context), child: Text(title, style: Utils.bigTitleStyle)),
          Expanded(child: const SizedBox(width: 1)),
          if (showProfiles) InkWell(borderRadius: BorderRadius.circular(20), onTap: () => Navigator.pushNamed(context, ProfilesPage.routeName), child: Icon(Icons.group_outlined)),
          if (showSettings) InkWell(borderRadius: BorderRadius.circular(20), onTap: () => Navigator.pushNamed(context, SettingsPage.routeName), child: Icon(Icons.settings)),
          if (showExit) InkWell(borderRadius: BorderRadius.circular(20), onTap: () => SystemNavigator.pop(), child: Icon(Icons.power_settings_new_rounded)),
          if (showHelp) InkWell(borderRadius: BorderRadius.circular(20), onTap: () => Navigator.pushNamed(context, HelpPage.routeName), child: Icon(Icons.live_help_outlined)),
          if (showDelete)
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (onDelete != null) {
                  onDelete!.call();
                }
              },
              child: Icon(Icons.delete),
            ),
        ],
      ),
    );
  }

  void _close(BuildContext context) {
    if (ModalRoute.of(context)!.settings.name != HomePage.routeName) {
      Navigator.pop(context);
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Utils.darkColorBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) {
          return SizedBox(height: 200, width: double.infinity, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('LUCAS')]));
        },
      );
    }
  }
}
