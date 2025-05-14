import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yoya/dialogs/dialogs.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/services/backup_service.dart';
import 'package:yoya/shared/preferences.dart';
import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = 'SettingsPage';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController emailController = TextEditingController(text: Preferences.email);
  late MainProvider mainProvider;
  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  TopWidget(title: 'Configuración', showHelp: true),
                  SizedBox(height: 20),
                  FutureBuilder(
                    future: Utils.checkConnection(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bool resp = snapshot.data as bool;
                        if (resp) {
                          return _email(context);
                        } else {
                          return _noConnection();
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_widgetSaveButton(), _widgetLoadButton()]),
                ],
              ),
            ),
          ),
          _appVersion(),
        ],
      ),
    );
  }

  Positioned _appVersion() {
    return Positioned(
      bottom: 10,
      left: 15,
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PackageInfo packageInfo = snapshot.data as PackageInfo;
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  constraints: const BoxConstraints(maxHeight: 150),
                  backgroundColor: Utils.darkColorBackground,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        children: [Text('Versión: ${packageInfo.version}', style: Utils.normalStyle20), const SizedBox(height: 20), Text('Actualizada el 10/05/2025', style: Utils.normalStyle20)],
                      ),
                    );
                  },
                );
              },
              child: Text('Versión: ${packageInfo.version}', style: Utils.normalStyle20),
            );
          } else {
            return Text('Versión:', style: Utils.normalStyle20);
          }
        },
      ),
    );
  }

  Widget _noConnection() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.wifi_off_rounded), Text('No hay conexión')]);
  }

  Widget _email(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email para las copias', style: Utils.normalStyle30),
        SizedBox(height: 20),
        ZoomIn(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 65,
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Utils.lightColorBackground, borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: emailController,
                    enabled: Preferences.email.isEmpty,
                    decoration: InputDecoration(filled: true, fillColor: Utils.darkColorBackground),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              if (Preferences.email.isEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (emailController.text.isEmpty) {
                      _showSnackBar('Introduce el email');
                    } else {
                      if (Utils.isValidEmail(emailController.text)) {
                        _saveDataBackup(context);
                      } else {
                        _showSnackBar('Email inválido');
                      }
                    }
                  },
                  child: Icon(Icons.save),
                ),
              if (Preferences.email.isNotEmpty) InkWell(borderRadius: BorderRadius.circular(20), onTap: () => _deleteBackupData(context), child: Icon(Icons.delete)),
            ],
          ),
        ),
        SizedBox(height: 40),
        if (Preferences.email.isNotEmpty) Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_widgetUpload(context), _widgetDownload(context)]),
        SizedBox(height: 40),
        Text('Última copia: ${Preferences.backUp.isEmpty ? '--/--/----' : Utils.dateEnglishToSpanish(Preferences.backUp, showTime: true)}', style: Utils.normalStyle20),
      ],
    );
  }

  Widget _widgetDownload(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _downloadData(context),
        child: FadeInRight(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [Text('Cargar datos', style: Utils.normalStyle20), const SizedBox(height: 5), Icon(Icons.restore)]),
          ),
        ),
      ),
    );
  }

  Widget _widgetUpload(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _uploadData(context),
        child: FadeInLeft(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [Text('Subir datos', style: Utils.normalStyle20), const SizedBox(height: 5), Icon(Icons.backup_sharp)]),
          ),
        ),
      ),
    );
  }

  Widget _widgetSaveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _saveData(context),
        child: FadeInDown(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [Text('Guardar', style: Utils.normalStyle20), const SizedBox(height: 5), Icon(Icons.save_alt_rounded)]),
          ),
        ),
      ),
    );
  }

  Widget _widgetLoadButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _loadData(context),
        child: FadeInUp(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [Text('Cargar', style: Utils.normalStyle20), const SizedBox(height: 5), Icon(Icons.restart_alt_rounded)]),
          ),
        ),
      ),
    );
  }

  void _setData(User user) async {
    mainProvider.profiles = user.profiles;
    mainProvider.filterProfiles = user.profiles;
    mainProvider.items = user.items;
    mainProvider.filterItems = user.items;
    mainProvider.history = user.history;
    mainProvider.updateProvider();

    await Utils.boxProfiles.deleteAll(Utils.boxProfiles.keys);
    await Utils.boxItems.deleteAll(Utils.boxItems.keys);
    await Utils.boxHistory.deleteAll(Utils.boxHistory.keys);

    for (ProfileModel p in user.profiles) {
      await Utils.boxProfiles.put(p.id, p.toJson());
    }
    for (ItemModel s in user.items) {
      await Utils.boxItems.put(s.id, s.toJson());
    }
    for (HistoryModel s in user.history) {
      await Utils.boxHistory.put(s.id, s.toJson());
    }
    _showSnackBar('Datos cargados');
  }

  Future<void> _saveDataBackup(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      final dialogContext = context;
      showDialog(context: dialogContext, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

      final pass = await password(context);

      if (!context.mounted) return;

      final pass2 = await password(context, title: 'Repite password');

      // Cerrar el diálogo de carga
      if (context.mounted) {
        Navigator.of(dialogContext).pop();
      }

      // Validar el resultado de password
      if (!context.mounted || pass == null || pass.isEmpty || !pass[0]) return;

      if (pass[1] != pass2[1]) {
        _showSnackBar('Las contraseñas no coinciden.');
        return;
      }

      // Guardar preferencias y actualizar estado
      Preferences.email = emailController.text;
      Preferences.passBackUp = pass[1];
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {});

      _showSnackBar('Email guardado');
    } catch (e) {
      // Cerrar el diálogo de carga en caso de error
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        _showSnackBar('Error al guardar: $e');
      }
    }
  }

  Future<void> _deleteBackupData(BuildContext context) async {
    final confirmed = await showMessage(context: context, message: '¿Borrar todos los datos de la copia?', cancel: true);

    if (!confirmed || !context.mounted) return;

    final unlocked = await showSlideToUnlock(context, backColor: Utils.darkColorBackground, slideColor: Utils.darkColorSecond);

    if (!unlocked || !context.mounted) return;

    try {
      // Mostrar indicador de carga
      final dialogContext = context;
      showDialog(context: dialogContext, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

      await BackupService.deleteBackUp(emailController.text);

      // Actualizar preferencias y estado
      Preferences.email = '';
      Preferences.backUp = '';
      emailController.text = '';
      setState(() {});

      if (context.mounted) {
        // Cerrar el diálogo de carga
        Navigator.of(dialogContext).pop();
        _showSnackBar('Datos borrados');
      }
    } catch (e) {
      if (context.mounted) {
        // Cerrar el diálogo de carga
        Navigator.of(context).pop();
        _showSnackBar('Error al borrar datos: $e');
      }
    }
  }

  Future<void> _uploadData(BuildContext context) async {
    final resp = await showSlideToUnlock(context, backColor: Utils.darkColorSecond, slideColor: Utils.darkColorBackground);
    if (resp) {
      User user = User(email: Preferences.email, password: Preferences.passBackUp, profiles: mainProvider.profiles, items: mainProvider.items, history: mainProvider.history);
      final dialogContext = context;
      if (dialogContext.mounted) {
        showDialog(context: dialogContext, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
      }

      BackupService.addBackUp(user).then((onValue) {
        _showSnackBar('Copia subida');
        Preferences.backUp = DateTime.now().toString();
        setState(() {});
      });
      if (context.mounted) {
        Navigator.of(dialogContext).pop();
      }
    }
  }

  Future<void> _downloadData(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      showDialog(context: context, barrierDismissible: false, builder: (_) => Center(child: CircularProgressIndicator()));

      // Obtener datos del usuario
      final user = await BackupService.getBackUp(Preferences.email);
      if (context.mounted) {
        Navigator.pop(context); // Cerrar indicador de carga
      }
      if (user == null) {
        _showSnackBar('Email no encontrado');
        return;
      }
      // Validar contraseña
      if (context.mounted) {
        final passResult = await password(context);
        if (!passResult[0]) {
          _showSnackBar('Proceso omitido');
          return;
        }
        if (passResult[1] != Preferences.passBackUp) {
          _showSnackBar('La contraseña es incorrecta');
          return;
        }
      }

      // Confirmar acción
      if (context.mounted) {
        final shouldContinue = await showMessage(context: context, message: 'Si hay datos, estos se sustituirán. ¿Continuar?', cancel: true);
        if (!shouldContinue) {
          _showSnackBar('Proceso omitido');
          return;
        }
      }
      if (context.mounted) {
        // Deslizar para desbloquear
        final isUnlocked = await showSlideToUnlock(context, backColor: Utils.darkColorSecond, slideColor: Utils.darkColorBackground);
        if (isUnlocked) {
          _setData(user);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context, false); // Cerrar indicador de carga en caso de error
      }
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _saveData(BuildContext context) async {
    User user = User(email: Preferences.email, password: Preferences.passBackUp, profiles: mainProvider.profiles, items: mainProvider.items, history: mainProvider.history);
    final contenido = json.encode(user.toJson());
    await Utils.guardarArchivoEnDescargas('YoYa save ${Utils.dateEnglishToSpanish(DateTime.now().toString(), showTime: false)}.json', contenido).then((onValue) {
      if (onValue) {
        _showSnackBar('Archivo descargado');
      } else {
        _showSnackBar('Alfo ha fallado . . .');
      }
    });
  }

  Future<void> _loadData(BuildContext context) async {
    final path = await Utils.seleccionarArchivo();
    if (path.isNotEmpty && context.mounted) {
      final resp = await showMessage(context: context, message: '¿Restaurar archivo?');
      if (resp && context.mounted) {
        final unlock = await showSlideToUnlock(context, backColor: Utils.darkColorSecond, slideColor: Utils.darkColorBackground);
        if (unlock) {
          final Map<String, dynamic> dataJson = json.decode(path);
          User user = User.fromJson(dataJson);
          _setData(user);
        } else {
          _showSnackBar('Proceso omitido');
        }
      } else {
        _showSnackBar('Algo ha fallado . . .');
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar(message));
  }
}
