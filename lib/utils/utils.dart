import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class Utils {
  //https://colorhunt.co/palette/f5eedd7ae2cf077a7d06202b
  static final Color lightColorBackground = Color.fromARGB(255, 245, 238, 221);
  static final Color darkColorBackground = Color.fromARGB(255, 6, 32, 43);
  static final Color lightColorSecond = Color.fromARGB(255, 122, 226, 207);
  static final Color darkColorSecond = Color.fromARGB(255, 7, 122, 125);

  static final double iconSize = 40;

  static final String fontFamilyName = 'Wonderly';
  static final TextStyle bigTitleStyle = TextStyle(
    fontSize: 35,
    color: lightColorSecond,
    fontFamily: fontFamilyName,
  );
  static final TextStyle normalStyle15 = TextStyle(
    fontSize: 15,
    color: lightColorSecond,
    fontFamily: fontFamilyName,
  );
  static final TextStyle normalStyle20 = TextStyle(
    fontSize: 20,
    color: lightColorSecond,
    fontFamily: fontFamilyName,
  );
  static final TextStyle normalStyle30 = TextStyle(
    fontSize: 30,
    color: lightColorSecond,
    fontFamily: fontFamilyName,
  );

  static final List<IconData> profileIcons = [
    Icons.person,
    Icons.person_2,
    Icons.bakery_dining_rounded,
    Icons.lunch_dining_rounded,
    Icons.delivery_dining_rounded,
    Icons.airplanemode_on_rounded,
    Icons.accessibility_new,
    Icons.agriculture_rounded,
    Icons.cake_rounded,
    Icons.directions_bike_rounded,
    Icons.favorite,
    Icons.star_rate_rounded,
    Icons.face,
    Icons.face_3,
    Icons.face_4,
    Icons.tag_faces_outlined,
    Icons.local_pizza_rounded,
    Icons.coffee,
    Icons.rocket_launch_rounded,
    Icons.fitness_center_outlined,
    Icons.sports_bar_rounded,
    Icons.spa_rounded,
    Icons.thunderstorm_rounded,
    Icons.thumb_up_alt_rounded,
    Icons.lightbulb,
    Icons.star_rate_rounded,
    Icons.savings_rounded,
    Icons.class_rounded,
    Icons.theaters_rounded,
    Icons.beach_access,
    Icons.checkroom,
    Icons.blender_rounded,
    Icons.sunny,
    Icons.self_improvement_rounded,
    Icons.water_drop_rounded,
    Icons.bolt,
    Icons.campaign_rounded,
    Icons.audiotrack_rounded,
    Icons.directions_car_filled_rounded,
  ];

  static IconData iconFromCode(int code) {
    switch (code) {
      case 58513:
        return Icons.person;
      case 985200:
        return Icons.person_2;
      case 62886:
        return Icons.bakery_dining_rounded;
      case 63642:
        return Icons.lunch_dining_rounded;
      case 63129:
        return Icons.delivery_dining_rounded;
      case 62796:
        return Icons.airplanemode_on_rounded;
      case 57405:
        return Icons.accessibility_new;
      case 62785:
        return Icons.agriculture_rounded;
      case 62972:
        return Icons.cake_rounded;
      case 63149:
        return Icons.directions_bike_rounded;
      case 57947:
        return Icons.favorite;
      case 983507:
        return Icons.star_rate_rounded;
      case 57938:
        return Icons.face;
      case 985184:
        return Icons.face_3;
      case 985185:
        return Icons.face_4;
      case 62499:
        return Icons.tag_faces_outlined;
      case 63609:
        return Icons.local_pizza_rounded;
      case 57720:
        return Icons.coffee;
      case 983922:
        return Icons.rocket_launch_rounded;
      case 61562:
        return Icons.fitness_center_outlined;
      case 983480:
        return Icons.sports_bar_rounded;
      case 0xeb4c:
        return Icons.spa_rounded;
      case 983469:
        return Icons.thunderstorm_rounded;
      case 983600:
        return Icons.thumb_up_alt_rounded;
      case 58235:
        return Icons.lightbulb;
      case 983336:
        return Icons.savings_rounded;
      case 63041:
        return Icons.class_rounded;
      case 983594:
        return Icons.theaters_rounded;
      case 57558:
        return Icons.beach_access;
      case 57693:
        return Icons.checkroom;
      case 62909:
        return Icons.blender_rounded;
      case 984437:
        return Icons.sunny;
      case 983364:
        return Icons.self_improvement_rounded;
      case 983988:
        return Icons.water_drop_rounded;
      case 57582:
        return Icons.bolt;
      case 62996:
        return Icons.campaign_rounded;
      case 62867:
        return Icons.audiotrack_rounded;
      case 63154:
        return Icons.directions_car_filled_rounded;
      default:
        return Icons.person;
    }
  }

  static Directory path = Directory('');

  static const String boxProfilesName = 'YoYaProfiles';
  static const String boxItemsName = 'YoYaItems';
  static const String boxHistoryName = 'YoYaHistory';
  static final Box boxProfiles = Hive.box(boxProfilesName);
  static final Box boxItems = Hive.box(boxItemsName);
  static final Box boxHistory = Hive.box(boxHistoryName);

  static SnackBar snackBar(String msg) {
    return SnackBar(content: Text(msg, style: TextStyle(color: darkColorSecond)));
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static Color getContrastingTextColor(Color color, Color dark, Color light) {
    double luminance = color.computeLuminance();
    return luminance > 0.5 ? dark : light;
  }

  static String dateEnglishToSpanish(String date, {bool showTime = false}) {
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    if (!showTime) {
      return "$day-$month-$year";
    } else {
      String hour = date.substring(11, 13);
      String minute = date.substring(14, 16);
      String seconds = date.substring(17, 19);
      return "$day-$month-$year $hour:$minute:$seconds";
    }
  }

  static Future<void> solicitarPermisoStorage() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // print("Permiso ya concedido");
      return;
    }

    if (status.isDenied) {
      // Primer intento o denegado sin "No volver a preguntar"
      var nuevoStatus = await Permission.storage.request();
      if (nuevoStatus.isGranted) {
        // print("Permiso concedido tras solicitarlo");
      } else if (nuevoStatus.isPermanentlyDenied) {
        // Lo denegó y marcó “No volver a preguntar”
        // print("Permiso denegado permanentemente. Redirigiendo a configuración...");
        openAppSettings();
      } else {
        // print("Permiso denegado");
      }
    } else if (status.isPermanentlyDenied) {
      // print("Permiso ya estaba denegado permanentemente. Redirigiendo...");
      openAppSettings();
    }
  }

  static Future<bool> guardarArchivoEnDescargas(String nombreArchivo, String contenido) async {
    // Pide permisos
    solicitarPermisoStorage();

    // Obtiene la ruta de Descargas (solo Android)
    final Directory downloadsDir = Directory('/storage/emulated/0/Download');

    if (downloadsDir.existsSync()) {
      final archivo = File(p.join(downloadsDir.path, nombreArchivo));
      await archivo.writeAsString(contenido);
      notificarSistemaArchivo(archivo.path);
      return true;
    } else {
      return false;
    }
  }

  static Future<void> notificarSistemaArchivo(String pathArchivo) async {
    const platform = MethodChannel('com.lucas.yoya');
    try {
      await platform.invokeMethod('scanFile', {'path': pathArchivo});
    } catch (e) {
      // print("Error al notificar sistema: $e");
    }
  }

  static Future<String> seleccionarArchivo() async {
    FilePickerResult? filePicker = await FilePicker.platform.pickFiles(
      withData: false,
      type: FileType.any,
      allowMultiple: false,
    );
    if (filePicker != null && filePicker.files.single.path != null) {
      File file = File(filePicker.files.single.path!);
      String contenido = await file.readAsString();
      return contenido;
    } else {
      return '';
    }
  }

  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.es');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
