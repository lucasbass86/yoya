import 'dart:convert';

class ItemModel {
  String id;
  String description;
  String observations;
  String idProfile1;
  String idProfile2;
  int counter1;
  int counter2;

  @override
  String toString() => description;

  ItemModel(this.id, this.description, this.observations, this.idProfile1, this.idProfile2, this.counter1, this.counter2);

  Map<String, dynamic> toMap() {
    return {'id': id, 'description': description, 'observations': observations, 'profile1': idProfile1, 'profile2': idProfile2, 'counter1': counter1, 'counter2': counter2};
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(map['id'] ?? '', map['description'] ?? '', map['observations'] ?? '', map['profile1'], map['profile2'], map['counter1']?.toInt() ?? 0, map['counter2']?.toInt() ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) => ItemModel.fromMap(json.decode(source));
}
