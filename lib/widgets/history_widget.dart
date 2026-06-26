import 'package:flutter/material.dart';
import 'package:yoya/dialogs/dialogs.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/providers/main_provider.dart';
import 'package:yoya/utils/utils.dart';

class HistoryWidget extends StatelessWidget {
  final HistoryModel history;
  const HistoryWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of(context);
    ProfileModel profile = mainProvider.profiles.firstWhere((p) => p.id == history.profile);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _changeDate(context),
          child: Ink(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Utils.darkColorSecond,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(profile.icon, size: 25),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: Utils.normalStyle20),
                      Text(
                        Utils.dateEnglishToSpanish(history.date.toString(), showTime: true),
                        style: Utils.normalStyle15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  history.quantity.toString(),
                  style: Utils.normalStyle15.copyWith(color: Utils.lightColorBackground),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeDate(BuildContext context) async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    DateTime? date = await showDate(context, initialDate: history.date);
    if (date == null) return;
    // date ??= history.date;

    if (!context.mounted) return;

    final time = await showTime(context, initialTimeOfDay: TimeOfDay.fromDateTime(history.date));
    if (time != TimeOfDay.fromDateTime(history.date)) {
      history.date = DateTime(date.year, date.month, date.day, time.hour, time.minute, 0);
    } else {
      history.date = DateTime(
        date.year,
        date.month,
        date.day,
        history.date.hour,
        history.date.minute,
        history.date.second,
      );
    }
    mainProvider.updateHistory(history);
    scaffoldMessenger.showSnackBar(Utils.snackBar('Registro actualizado'));
  }
}
