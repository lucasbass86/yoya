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
      case 0xe491:
        return Icons.person;
      case 0xe7fd:
        return Icons.person_2;
      case 0xef2a:
        return Icons.bakery_dining_rounded;
      case 0xef75:
        return Icons.lunch_dining_rounded;
      case 0xef6c:
        return Icons.delivery_dining_rounded;
      case 0xe539:
        return Icons.airplanemode_on_rounded;
      case 0xe84e:
        return Icons.accessibility_new;
      case 0xeb88:
        return Icons.agriculture_rounded;
      case 0xea66:
        return Icons.cake_rounded;
      case 0xe52f:
        return Icons.directions_bike_rounded;
      case 0xe87d:
        return Icons.favorite;
      case 0xe838:
        return Icons.star_rate_rounded;
      case 0xe87c:
        return Icons.face;
      case 0xf04f:
        return Icons.face_3;
      case 0xf050:
        return Icons.face_4;
      case 0xe420:
        return Icons.tag_faces_outlined;
      case 0xf1c6:
        return Icons.local_pizza_rounded;
      case 0xe541:
        return Icons.coffee;
      case 0xe9a0:
        return Icons.rocket_launch_rounded;
      case 0xe3af:
        return Icons.fitness_center_outlined;
      case 0xef46:
        return Icons.sports_bar_rounded;
      case 0xeb4c:
        return Icons.spa_rounded;
      case 0xe43c:
        return Icons.thunderstorm_rounded;
      case 0xe8dc:
        return Icons.thumb_up_alt_rounded;
      case 0xe3ab:
        return Icons.lightbulb;
      case 0xe2db:
        return Icons.savings_rounded;
      case 0xe86e:
        return Icons.class_rounded;
      case 0xe54d:
        return Icons.theaters_rounded;
      case 0xe3b0:
        return Icons.beach_access;
      case 0xe54f:
        return Icons.checkroom;
      case 0xef55:
        return Icons.blender_rounded;
      case 0xe430:
        return Icons.sunny;
      case 0xe9d8:
        return Icons.self_improvement_rounded;
      case 0xe798:
        return Icons.water_drop_rounded;
      case 0xe837:
        return Icons.bolt;
      case 0xe0b7:
        return Icons.campaign_rounded;
      case 0xe405:
        return Icons.audiotrack_rounded;
      case 0xe531:
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
