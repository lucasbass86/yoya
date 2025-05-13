import 'package:yoya/models/_models.dart';

class User {
  String email;
  String password;
  List<ProfileModel> profiles;
  List<ItemModel> items;
  List<HistoryModel> history;

  @override
  String toString() => email;

  User({required this.email, required this.password, required this.profiles, required this.items, required this.history});

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json['email'],
    password: json['password'],
    profiles: (json['profiles'] as List).map((e) => ProfileModel.fromJson(e)).toList(),
    items: (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList(),
    history: (json['history'] as List?)?.map((e) => HistoryModel.fromJson(e)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'profiles': (profiles).map((e) => e.toJson()).toList(),
    'items': (items).map((e) => e.toJson()).toList(),
    'history': (history).map((e) => e.toJson()).toList(),
  };
}
