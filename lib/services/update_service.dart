import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

List<Versiones> versionesFromJson(String str) => List<Versiones>.from(json.decode(str).map((x) => Versiones.fromJson(x)));

class Versiones {
  String appname;
  String appversion;

  @override
  String toString() {
    return '$appname:$appversion';
  }

  Versiones({required this.appname, required this.appversion});

  factory Versiones.fromJson(Map<String, dynamic> json) => Versiones(appname: json["APPNAME"], appversion: json["APPVERSION"]);
}

List<CResultado> cResultadoFromJson(String str) => List<CResultado>.from(json.decode(str).map((x) => CResultado.fromJson(x)));

class CResultado {
  String resultado;

  @override
  String toString() {
    return resultado;
  }

  CResultado({required this.resultado});

  factory CResultado.fromJson(Map<String, dynamic> json) => CResultado(resultado: json["RESULTADO"].toString());
}

class UpdateService {
  static final String _urlVersiones = 'http://libros.escayolasdelucas.com/getVersiones.php';
  final String _urlUsuarios = 'http://libros.escayolasdelucas.com/set_user_app.php';
  final String _urlUserLock = 'http://libros.escayolasdelucas.com/set_user_lock.php';
  static List<Versiones> versiones = [];
  List<CResultado> resultado = [];
  final String app = 'YOYA';

  static Future<List<Versiones>> getVersiones() async {
    final response = await http.get(Uri.parse(_urlVersiones));
    versiones = versionesFromJson(response.body);
    return versiones;
  }

  Future<List<CResultado>> setUser(String id, String info) async {
    final response = await http.post(Uri.parse(_urlUsuarios), body: {'app': app, 'id': id, 'info': info});
    resultado = cResultadoFromJson(response.body);
    return resultado;
  }

  Future<List<CResultado>> getUserLock(String id, String info) async {
    final params = {'app': app, 'id': id};
    final uri = Uri.parse(_urlUserLock).replace(queryParameters: params);
    final response = await http.get(uri);

    resultado = cResultadoFromJson(response.body);
    return resultado;
  }
}

class UpdatePage extends StatelessWidget {
  static const String routeName = 'UpdatePage';
  const UpdatePage({super.key});
  final String urlUpdatePath = 'https://drive.google.com/file/d/18GoDS5SDaS7oVhtmvUoT70z-FFfv2gm_/view?usp=drive_link';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(),
          Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, right: 30),
                  child: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Omitir', style: TextStyle(fontWeight: FontWeight.bold, color: Utils.lightColorBackground))),
                ),
              ),
              Expanded(child: Icon(Icons.download_rounded, size: 150)),
              Text('Existe una versión más reciente', style: Utils.bigTitleStyle, textAlign: TextAlign.center),
              GestureDetector(
                onTap: () async {
                  !await launchUrl(Uri.parse(urlUpdatePath), mode: LaunchMode.externalApplication);
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40, top: 40),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Utils.lightColorBackground, borderRadius: BorderRadius.circular(40)),
                  child: Center(child: Text('Aceptar', style: Utils.normalStyle20.copyWith(color: Utils.darkColorGreen))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
