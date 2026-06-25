import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static const String _sEmail = 'email';
  static const String _sPassBackUp = 'passBackUp';
  static const String _sbackUp = 'backUp';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String _backUp = '';
  static String get backUp => _prefs.getString(_sbackUp) ?? _backUp;
  static set backUp(String value) {
    _backUp = value;
    _prefs.setString(_sbackUp, _backUp);
  }

  static String _email = '';
  static String get email => _prefs.getString(_sEmail) ?? _email;
  static set email(String value) {
    _email = value;
    _prefs.setString(_sEmail, value);
  }

  static String _passBackUp = '';
  static String get passBackUp => _prefs.getString(_sPassBackUp) ?? _passBackUp;
  static set passBackUp(String value) {
    _passBackUp = value;
    _prefs.setString(_sPassBackUp, value);
  }

  static const String _sLicense = 'license';
  static String _license = '';
  static String get license => _prefs.getString(_sLicense) ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString(_sLicense, value);
  }
}
