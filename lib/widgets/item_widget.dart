import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/pages/_pages.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/utils/utils.dart';

class ItemWidget extends StatefulWidget {
  final ItemModel item;
  const ItemWidget({super.key, required this.item});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late MainProvider mainProvider;

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of(context);
    ProfileModel profile1 = mainProvider.profiles.firstWhere((p) => p.id == widget.item.idProfile1);
    ProfileModel profile2 = mainProvider.profiles.firstWhere((p) => p.id == widget.item.idProfile2);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.pushNamed(context, ItemDetailPage.routeName, arguments: widget.item),
          child: Ink(
            width: double.infinity,
            height: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.item.description, style: Utils.normalStyle20),
                const SizedBox(height: 10),
                Divider(color: Utils.darkColorBackground),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  controller1.reset();
                                  controller1.forward();
                                  _changeCounter(true, 1);
                                },
                                onLongPress: () {
                                  if (ModalRoute.of(context)?.settings.name != ProfileDetailPage.routeName) {
                                    Navigator.pushNamed(context, ProfileDetailPage.routeName, arguments: profile1);
                                  }
                                },
                                child: Icon(profile1.icon, size: 60),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  controller1.reset();
                                  controller1.forward();
                                  _changeCounter(true, -1);
                                },
                                child: Ink(
                                  height: 60,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: ZoomIn(controller: (p0) => controller1 = p0, child: Text(widget.item.counter1.toString(), style: TextStyle(color: Utils.lightColorBackground))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 2, height: 50, decoration: BoxDecoration(color: Utils.lightColorBackground, borderRadius: BorderRadius.circular(20))),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  controller2.reset();
                                  controller2.forward();
                                  _changeCounter(false, 1);
                                },
                                onLongPress: () {
                                  if (ModalRoute.of(context)?.settings.name != ProfileDetailPage.routeName) {
                                    Navigator.pushNamed(context, ProfileDetailPage.routeName, arguments: profile2);
                                  }
                                },
                                child: Icon(profile2.icon, size: 60),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  controller2.reset();
                                  controller2.forward();
                                  _changeCounter(false, -1);
                                },
                                child: Ink(
                                  height: 60,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: ZoomIn(controller: (p0) => controller2 = p0, child: Text(widget.item.counter2.toString(), style: TextStyle(color: Utils.lightColorBackground))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeCounter(bool isFirst, int delta) {
    final profile = isFirst ? widget.item.idProfile1 : widget.item.idProfile2;
    final currentCounter = isFirst ? widget.item.counter1 : widget.item.counter2;

    if (delta > 0 || currentCounter > 0) {
      mainProvider.setCounter(widget.item, profile, delta);
      setState(() {});
    }
  }
}
