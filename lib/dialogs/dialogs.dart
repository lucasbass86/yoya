import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';

Future<dynamic> showDialogNewProfile(BuildContext scaffoldContext) {
  TextEditingController nameController = TextEditingController();
  IconData icon = Utils.profileIcons[0];
  final formKey = GlobalKey<FormState>();
  return showDialog(
    context: scaffoldContext,
    barrierDismissible: false,
    builder: (context) {
      return BounceInDown(
        child: AlertDialog(
          backgroundColor: Utils.darkColorBackground,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text('Indica los datos', style: Utils.bigTitleStyle),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ZoomIn(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Rellena el nombre';
                            }
                            return null;
                          },
                          controller: nameController,
                          maxLength: 75,
                          decoration: InputDecoration(labelText: 'Nombre', counterText: ''),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Icono', style: Utils.normalStyle20),
                          const SizedBox(width: 20),
                          DropdownButton<IconData>(
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            OutlinedButton(onPressed: () => Navigator.of(context).pop([false]), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop([true, nameController.text, icon]);
                } else {
                  return;
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> showMessage({required BuildContext context, required String message, String secondMessage = '', bool cancel = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BounceInDown(
        child: AlertDialog(
          backgroundColor: Utils.darkColorBackground,
          title: Text("Información", style: Utils.normalStyle30),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(message, style: Utils.normalStyle20), if (secondMessage.isNotEmpty) Text(secondMessage, style: Utils.normalStyle20)],
            ),
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            if (cancel) OutlinedButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Aceptar')),
          ],
        ),
      );
    },
  ).then((onValue) => onValue ?? false);
}

Future<bool> showSlideToUnlock(
  BuildContext context, {
  Color backColor = const Color.fromRGBO(224, 224, 224, 1),
  Color slideColor = Colors.blue,
  String text = 'Desliza para confirmar',
  Color textColor = Colors.white,
  IconData iconData = Icons.arrow_forward,
}) async {
  final unlocked = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      double offset = 0.0;
      bool unlocked0 = false;
      return StatefulBuilder(
        builder: (context, setState) {
          final width = MediaQuery.of(context).size.width - 32;
          final maxOffset = width - 80;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 60,
                decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(30)),
                child: Stack(
                  children: [
                    Center(child: Opacity(opacity: 1.0 - (offset / maxOffset), child: Text(text, style: TextStyle(color: textColor)))),
                    Positioned(
                      left: offset,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            offset += details.delta.dx;
                            if (offset < 0) offset = 0;
                            if (offset > maxOffset) offset = maxOffset;
                          });
                        },
                        onHorizontalDragEnd: (_) {
                          if (offset > maxOffset * 0.9) {
                            setState(() {
                              unlocked0 = true;
                              offset = maxOffset;
                            });
                            Navigator.of(context).pop(true);
                          } else {
                            setState(() {
                              offset = 0;
                            });
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(color: unlocked0 ? Colors.green : slideColor, borderRadius: BorderRadius.circular(30)),
                          alignment: Alignment.center,
                          child: unlocked0 ? Icon(Icons.check_rounded, color: Colors.green[900]) : Icon(iconData, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return unlocked == true;
}

Future<dynamic> password(BuildContext context, {String title = 'Introduce el password'}) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return BounceInDown(
        child: AlertDialog(
          backgroundColor: Utils.darkColorBackground,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(title, style: Utils.normalStyle30),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextFormField(
                onChanged: (value) {},
                controller: edPassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: 'Password'),
              );
            },
          ),
          actions: [
            OutlinedButton(onPressed: () => Navigator.of(context).pop([false]), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop([true, edPassword.text]);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<DateTime?> showDate(BuildContext context, {DateTime? initialDate}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(initialDate?.year ?? DateTime.now().year, 1, 1),
    lastDate: DateTime(DateTime.now().year, 12, 31),
    cancelText: 'Cancelar',
    confirmText: 'Aceptar',
    helpText: 'Indica la fecha',
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) => BounceInDown(child: child!),
  );
}

Future<TimeOfDay> showTime(BuildContext context, {TimeOfDay? initialTimeOfDay}) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTimeOfDay ?? TimeOfDay.now(),
    helpText: 'Indica la hora',
    cancelText: 'Cancelar',
    confirmText: 'Aceptar',
    hourLabelText: 'Horas',
    minuteLabelText: 'Minutos',
    initialEntryMode: TimePickerEntryMode.dialOnly,
    builder: (BuildContext context, Widget? child) {
      return BounceInDown(child: MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!));
    },
  );
  if (pickedTime != null && pickedTime != initialTimeOfDay) {
    return pickedTime;
  } else {
    return initialTimeOfDay ?? TimeOfDay.now();
  }
}

Future<dynamic> showDialogInput(BuildContext scaffoldContext, {TextInputType? inputType, String subtitle = '', String label = '', int maxLength = 75}) {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog(
    context: scaffoldContext,
    barrierDismissible: false,
    builder: (context) {
      return BounceInDown(
        child: AlertDialog(
          backgroundColor: Utils.darkColorBackground,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Column(children: [Text('Indica el $label', style: Utils.bigTitleStyle), if (subtitle.isNotEmpty) Text(subtitle, style: Utils.normalStyle15)]),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ZoomIn(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Rellena el $label';
                            }
                            return null;
                          },
                          controller: controller,
                          maxLength: maxLength,
                          decoration: InputDecoration(labelText: label, counterText: ''),
                          keyboardType: inputType ?? TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            OutlinedButton(onPressed: () => Navigator.of(context).pop([false]), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop([true, controller.text]);
                } else {
                  return;
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}
