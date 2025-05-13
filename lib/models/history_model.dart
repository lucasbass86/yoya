import 'dart:convert';

import 'package:yoya/models/_models.dart';
import 'package:yoya/utils/utils.dart';

class HistoryModel {
  String id;
  ItemModel item;
  String profile;
  int quantity;
  DateTime date;

  @override
  String toString() => '${item.description} - ${Utils.dateEnglishToSpanish(date.toString())} - $quantity';

  HistoryModel(this.id, this.item, this.profile, this.quantity, this.date);

  Map<String, dynamic> toMap() {
    return {'id': id, 'item': item.toMap(), 'profile': profile, 'quantity': quantity, 'date': date.millisecondsSinceEpoch};
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(map['id'] ?? '', ItemModel.fromMap(map['item']), map['profile'], map['quantity']?.toInt() ?? 0, DateTime.fromMillisecondsSinceEpoch(map['date']));
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) => HistoryModel.fromMap(json.decode(source));
}
