import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';

class SearchWidget extends StatefulWidget {
  final Function onChange;
  final Function onClose;
  const SearchWidget({super.key, required this.onChange, required this.onClose});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: isExpanded ? constraints.maxWidth : 65,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isExpanded ? Utils.lightColorBackground : Utils.darkColorSecond, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: searchController,
              maxLength: 20,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Utils.darkColorBackground,
                hintText: 'Buscar',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      if (!isExpanded) {
                        searchController.text = '';
                        FocusScope.of(context).unfocus();
                      }
                    });
                    widget.onClose.call();
                  },
                  child: Icon(isExpanded ? Icons.arrow_back_ios_new : Icons.search),
                ),
                counterText: '',
              ),
              onChanged: (value) => widget.onChange.call(value),
            ),
          );
        },
      ),
    );
  }
}
