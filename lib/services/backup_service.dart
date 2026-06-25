import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yoya/models/_models.dart';
import 'package:yoya/secret/secret.dart';

class BackupService {
  static final _baseUrl = Secret.firebaseUrl;
  static final _appName = 'yoya';

  static Future<void> addBackUp(User user) async {
    final String emailKey = user.email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '$_appName/$emailKey.json');
    // final resp = await http.put(url, body: jsonEncode(user.toJson()));
    await http.put(url, body: jsonEncode(user.toJson()));
    //final decodedData = resp.body;
  }

  static Future<User?> getBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '$_appName/$emailKey.json');
    final resp = await http.get(url);
    if (resp.statusCode != 200 || resp.body == 'null') {
      return null;
    }
    final Map<String, dynamic> data = jsonDecode(resp.body);
    User user = User.fromJson(data);
    return user;
  }

  static Future<void> deleteBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '$_appName/$emailKey.json');
    // final resp = await http.delete(url);
    await http.delete(url);
  }
}
