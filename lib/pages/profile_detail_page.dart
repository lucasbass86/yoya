import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yoya/dialogs/dialogs.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

class ProfileDetailPage extends StatefulWidget {
  static const String routeName = 'ProfileDetailPage';
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  TextEditingController nameController = TextEditingController();
  IconData icon = Utils.profileIcons[0];
  late ProfileModel profile;
  late MainProvider mainProvider;
  bool isOnLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isOnLoad) {
      mainProvider = Provider.of<MainProvider>(context);
      profile = ModalRoute.of(context)!.settings.arguments as ProfileModel;
      nameController.text = profile.name;
      icon = profile.icon;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        mainProvider.loadItemsFromProfile(profile);
      });
      isOnLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => _save(context), child: Icon(Icons.save)),
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopWidget(title: 'Detalle Perfil', showDelete: true, onDelete: () => _delete(context)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ZoomIn(
                        child: TextField(controller: nameController, maxLength: 75, decoration: InputDecoration(labelText: 'Nombre', counterText: ''), textCapitalization: TextCapitalization.words),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FadeInRight(
                      child: DropdownButton(
                        value: icon,
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: Utils.lightColorBackground,
                        underline: Container(),
                        items:
                            Utils.profileIcons.map((iconData) {
                              return DropdownMenuItem(value: iconData, child: Icon(iconData, color: Utils.darkColorSecond));
                            }).toList(),
                        selectedItemBuilder: (context) {
                          return Utils.profileIcons.map((iconData) {
                            return Icon(icon, color: Utils.lightColorSecond);
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            icon = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Utils.lightColorSecond),
                const SizedBox(height: 10),
                SearchWidget(
                  onChange: (String value) {
                    mainProvider.loadItemsFromProfile(profile, search: value);
                  },
                  onClose: () {
                    mainProvider.loadItemsFromProfile(profile);
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Registros', style: Utils.normalStyle30), Text(mainProvider.itemsProfile.length.toString(), style: Utils.normalStyle30)],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        mainProvider.itemsProfile.isNotEmpty
                            ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: mainProvider.itemsProfile.length,
                              itemBuilder: (context, index) {
                                return ItemWidget(item: mainProvider.itemsProfile[index]);
                              },
                            )
                            : _noItems(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noItems() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No hay registros', style: Utils.bigTitleStyle), const SizedBox(height: 20), Icon(Icons.workspaces_filled, size: 150)],
        ),
      ),
    );
  }

  void _save(BuildContext context) {
    profile.icon = icon;
    profile.name = nameController.text;
    mainProvider.updateProfile(profile);
    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Registro modificado'));
  }

  void _delete(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await showMessage(context: context, message: 'Se eliminarán todos los registros. ¿Borrar el perfil?', cancel: true).then((onValue) {
      if (onValue) {
        mainProvider.deleteProfile(profile);
        scaffoldMessenger.showSnackBar(Utils.snackBar('Perfil borrado'));
        navigator.pop();
      }
    });
  }
}
