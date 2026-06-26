import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yoya/dialogs/dialogs.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

class ItemDetailPage extends StatefulWidget {
  static const String routeName = 'ItemDetailPage';
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late MainProvider mainProvider;
  TextEditingController nameController = TextEditingController();
  TextEditingController observController = TextEditingController();
  ProfileModel? profile1;
  ProfileModel? profile2;
  ItemModel? item;
  List<HistoryModel> history = [];
  late AnimationController controller1;
  late AnimationController controller2;
  bool counting = false;
  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of(context, listen: false);
    if (ModalRoute.of(context)!.settings.arguments != null && !counting) {
      item = ModalRoute.of(context)!.settings.arguments as ItemModel;
      nameController = TextEditingController(text: item!.description);
      observController = TextEditingController(text: item!.observations);
      profile1 = mainProvider.profiles.firstWhere((p) => p.id == item!.idProfile1);
      profile2 = mainProvider.profiles.firstWhere((p) => p.id == item!.idProfile2);
      history = mainProvider.loadHistory(item!);
      counting = true;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(context),
        child: Icon(Icons.save),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _top(context),
                    _descriptions(),
                    Divider(color: Utils.lightColorSecond),
                    const SizedBox(height: 10),
                    Text('Perfil 1', style: Utils.normalStyle20),
                    _profile1(),
                    const SizedBox(height: 10),
                    Text('Perfil 2', style: Utils.normalStyle20),
                    _profile2(),
                    const SizedBox(height: 10),
                    if (item != null) Divider(color: Utils.lightColorSecond),
                    const SizedBox(height: 10),
                    _progressBar(),
                    const SizedBox(height: 10),
                    if (item != null) Divider(color: Utils.lightColorSecond),
                    const SizedBox(height: 10),
                    _history(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _top(BuildContext context) {
    return TopWidget(
      title: 'Detalle Registro',
      showDelete: item != null,
      onDelete: () => _delete(context),
    );
  }

  Widget _descriptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ZoomIn(
          child: TextField(
            controller: nameController,
            maxLength: 75,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'Descripción', counterText: ''),
          ),
        ),
        const SizedBox(height: 20),
        ZoomIn(
          child: TextField(
            controller: observController,
            maxLength: 500,
            maxLines: 10,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'Observaciones', counterText: ''),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _progressBar() {
    if (item != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ProgressBarWidget(
            width: constraints.maxWidth,
            currentValue: item!.counter1,
            maxValue: item!.counter1 + item!.counter2,
            backgroundColor: Utils.darkColorSecond,
            progressColor: Utils.lightColorSecond,
          );
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _history() {
    if (item != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SearchWidget(
            onChange: (value) {
              history = mainProvider.loadHistory(item!, search: value);
              setState(() {});
            },
            onClose: () {
              history = mainProvider.loadHistory(item!);
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Histórico', style: Utils.normalStyle30),
              Text(history.length.toString(), style: Utils.normalStyle30),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(history[index].id),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  final resp = await showMessage(
                    context: context,
                    message: '¿Borrar el historial?',
                    cancel: true,
                  );
                  if (resp) {
                    await mainProvider.deleteHistory(history[index].id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(Utils.snackBar('Registro borrado'));
                      setState(() {
                        counting = false;
                      });
                    }
                    return true;
                  } else {
                    return false;
                  }
                },
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(Icons.delete_outline_rounded, color: Utils.lightColorSecond)],
                ),
                child: BounceInLeft(
                  delay: Duration(milliseconds: 100 * index),
                  child: HistoryWidget(history: history[index]),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _profile1() {
    return Row(
      children: [
        Expanded(
          child: DropdownButton(
            borderRadius: BorderRadius.circular(20),
            dropdownColor: Utils.lightColorBackground,
            underline: Container(),
            isExpanded: true,
            value: profile1,
            enableFeedback: item == null,
            items:
                mainProvider.profiles.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        Icon(p.icon, color: Utils.darkColorSecond),
                        const SizedBox(width: 10),
                        Text(
                          p.name,
                          style: Utils.normalStyle20.copyWith(color: Utils.darkColorSecond),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (context) {
              return mainProvider.profiles.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Row(
                    children: [
                      Icon(p.icon),
                      const SizedBox(width: 10),
                      Text(p.name, style: Utils.normalStyle20),
                    ],
                  ),
                );
              }).toList();
            },
            onChanged: (value) {
              if (item == null) {
                setState(() {
                  profile1 = value;
                  if (profile1 == profile2) profile2 = null;
                });
              }
            },
          ),
        ),
        if (item != null)
          ElasticInDown(
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Utils.darkColorSecond,
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller1.reset();
                        controller1.forward();
                        _changeCounter(true, 1);
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: ZoomIn(
                          controller: (p0) => controller1 = p0,
                          child: Text(
                            item!.counter1.toString(),
                            style: TextStyle(color: Utils.lightColorBackground),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller1.reset();
                        controller1.forward();
                        _changeCounter(true, -1);
                      },
                      child: Icon(Icons.remove),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _profile2() {
    return Row(
      children: [
        Expanded(
          child: DropdownButton(
            borderRadius: BorderRadius.circular(20),
            dropdownColor: Utils.lightColorBackground,
            underline: Container(),
            isExpanded: true,
            value:
                mainProvider.profiles.where((p) => p != profile1).contains(profile2)
                    ? profile2
                    : null,
            enableFeedback: item == null,
            items:
                mainProvider.profiles.where((value) => value != profile1).map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        Icon(p.icon, color: Utils.darkColorSecond),
                        const SizedBox(width: 10),
                        Text(
                          p.name,
                          style: Utils.normalStyle20.copyWith(color: Utils.darkColorSecond),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (context) {
              return mainProvider.profiles.where((value) => value != profile1).map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Row(
                    children: [
                      Icon(p.icon),
                      const SizedBox(width: 10),
                      Text(p.name, style: Utils.normalStyle20),
                    ],
                  ),
                );
              }).toList();
            },
            onChanged: (value) {
              if (item == null) {
                setState(() {
                  profile2 = value;
                });
              }
            },
          ),
        ),
        if (item != null)
          ElasticInUp(
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Utils.darkColorSecond,
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller2.reset();
                        controller2.forward();
                        _changeCounter(false, 1);
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: ZoomIn(
                          controller: (p0) => controller2 = p0,
                          child: Text(
                            item!.counter2.toString(),
                            style: TextStyle(color: Utils.lightColorBackground),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller2.reset();
                        controller2.forward();
                        _changeCounter(false, -1);
                      },
                      child: Icon(Icons.remove),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _save(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Indica la descripción'));
      return;
    }
    if (profile1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Indica el primer perfil'));
      return;
    }
    if (profile2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Indica el segundo perfil'));
      return;
    }
    if (item == null) {
      item = ItemModel(
        Uuid().v4(),
        nameController.text.trim(),
        observController.text.trim(),
        profile1!.id,
        profile2!.id,
        0,
        0,
      );
      mainProvider.addItem(item!);
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Registro guardado'));
    } else {
      item!.description = nameController.text;
      mainProvider.updateItem(item!);
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Registro modificado'));
    }
    counting = true;
    setState(() {});
    //Navigator.pop(context);
  }

  void _changeCounter(bool isFirst, int delta) {
    final profile = isFirst ? item!.idProfile1 : item!.idProfile2;
    final currentCounter = isFirst ? item!.counter1 : item!.counter2;

    if (delta > 0 || currentCounter > 0) {
      mainProvider.setCounter(item!, profile, delta);
    }
    history = mainProvider.loadHistory(item!);
    setState(() {});
  }

  void _delete(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await showMessage(context: context, message: '¿Borrar el registro?', cancel: true).then((
      onValue,
    ) {
      if (onValue) {
        mainProvider.deleteItem(item!);
        scaffoldMessenger.showSnackBar(Utils.snackBar('Registro borrado'));
        navigator.pop();
      }
    });
  }
}
