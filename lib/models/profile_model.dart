import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:yoya/utils/utils.dart';

class ProfileModel {
  String id;
  String name;
  IconData icon;

  @override
  String toString() => name;

  ProfileModel(this.id, this.name, this.icon);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  void updateFromProfile(ProfileModel profile) {
    icon = profile.icon;
    name = profile.name;
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'icon': icon.codePoint};

  factory ProfileModel.fromMap(Map<String, dynamic> map) =>
      ProfileModel(map['id'], map['name'], Utils.iconFromCode(map['icon']));

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));
}
