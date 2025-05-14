import 'package:flutter/material.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/pages/_pages.dart';
import 'package:yoya/utils/utils.dart';

class ProfileWidget extends StatelessWidget {
  final ProfileModel profile;
  const ProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.pushNamed(context, ProfileDetailPage.routeName, arguments: profile),
          child: Ink(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [Icon(profile.icon), const SizedBox(width: 10), Text(profile.name, style: Utils.normalStyle30)]),
          ),
        ),
      ),
    );
  }
}
