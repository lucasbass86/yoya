import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yoya/models/_models.dart';
import 'package:yoya/utils/utils.dart';
export 'package:provider/provider.dart';

class MainProvider with ChangeNotifier {
  List<ProfileModel> profiles = [];
  List<ProfileModel> filterProfiles = [];
  List<ItemModel> items = [];
  List<ItemModel> filterItems = [];
  List<HistoryModel> history = [];

  MainProvider() {
    loadProfiles();
    loadItems();
  }

  void updateProvider() {
    notifyListeners();
  }

  void loadProfiles({String search = ''}) {
    if (search.isNotEmpty) {
      filterProfiles = profiles.where((p) => p.name.toUpperCase().contains(search.toUpperCase())).toList();
    } else {
      filterProfiles = profiles;
    }
    filterProfiles.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void addProfile(ProfileModel profile) async {
    profiles.add(profile);
    filterProfiles = profiles;
    filterProfiles.sort((a, b) => a.name.compareTo(b.name));
    await Utils.boxProfiles.put(profile.id, profile.toJson());
    notifyListeners();
  }

  void updateProfile(ProfileModel profile) async {
    profiles.firstWhere((p) => p.id == profile.id).updateFromProfile(profile);
    filterProfiles = profiles;
    filterProfiles.sort((a, b) => a.name.compareTo(b.name));
    await Utils.boxProfiles.put(profile.id, profile.toJson());
    notifyListeners();
  }

  void deleteProfile(ProfileModel profile) async {
    profiles.remove(profile);
    filterProfiles = profiles;
    filterProfiles.sort((a, b) => a.name.compareTo(b.name));
    await Utils.boxProfiles.delete(profile.id);

    List<ItemModel> itemsToDelete = items.where((h) => h.idProfile1 == profile.id || h.idProfile2 == profile.id).toList();
    final futuresItems = itemsToDelete.map((h) => Utils.boxItems.delete(h.id));
    await Future.wait(futuresItems);
    items.removeWhere((i) => i.idProfile1 == profile.id || i.idProfile2 == profile.id);
    filterItems = items;

    final futuresHistory = history.where((h) => itemsToDelete.map((i) => i.id).toList().contains(h.item.id)).map((h) => Utils.boxHistory.delete(h.id));
    await Future.wait(futuresHistory);
    history.removeWhere((h) => h.item.id == profile.id);

    notifyListeners();
  }

  void loadItems({String search = ''}) {
    if (search.isNotEmpty) {
      filterItems = items.where((i) => i.description.toUpperCase().contains(search.toUpperCase())).toList();
    } else {
      filterItems = items;
    }
    filterItems.sort((a, b) => a.description.compareTo(b.description));
    notifyListeners();
  }

  void addItem(ItemModel item) async {
    items.add(item);
    filterItems = items;
    await Utils.boxItems.put(item.id, item.toJson());
    notifyListeners();
  }

  void updateItem(ItemModel item) async {
    items.firstWhere((i) => i.id == item.id).description = item.description;
    filterItems = items;
    Utils.boxItems.put(item.id, item.toJson());
    notifyListeners();
  }

  void deleteItem(ItemModel item) async {
    items.remove(item);
    filterItems = items;
    await Utils.boxItems.delete(item.id);
    final futuresHistory = history.where((h) => h.item.id == item.id).map((h) => Utils.boxHistory.delete(h.id));
    await Future.wait(futuresHistory);
    history.removeWhere((h) => h.item.id == item.id);
    notifyListeners();
  }

  void setCounter(ItemModel item, String profileId, int counter) async {
    ItemModel mod = items.firstWhere((i) => i.id == item.id);
    if (mod.idProfile1 == profileId) {
      if (counter > 0) {
        mod.counter1++;
      } else {
        mod.counter1--;
      }
    } else {
      if (counter > 0) {
        mod.counter2++;
      } else {
        mod.counter2--;
      }
    }
    filterItems = items;
    HistoryModel historyModel = HistoryModel(Uuid().v1(), mod, profileId, counter, DateTime.now());
    history.add(historyModel);
    await Utils.boxItems.put(mod.id, mod.toJson());
    await Utils.boxHistory.put(historyModel.id, historyModel.toJson());
    notifyListeners();
  }

  List<HistoryModel> loadHistory(ItemModel item, {String search = ''}) {
    List<HistoryModel> res = history.where((h) => h.item.id == item.id).toList();
    if (search.isNotEmpty) {
      res =
          res.where((h) {
            {
              ProfileModel profile = profiles.firstWhere((p) => p.id == h.profile);
              return profile.name.toUpperCase().contains(search.toUpperCase());
            }
          }).toList();
    }
    res.sort((a, b) => b.date.compareTo(a.date));
    return res;
  }

  List<ItemModel> itemsProfile = [];
  void loadItemsFromProfile(ProfileModel profile, {String search = ''}) {
    itemsProfile = items.where((i) => i.idProfile1 == profile.id || i.idProfile2 == profile.id).toList();
    if (search.isNotEmpty) {
      itemsProfile = itemsProfile.where((i) => i.description.toUpperCase().contains(search.toUpperCase())).toList();
    }
    notifyListeners();
  }

  void updateHistory(HistoryModel historyModel) async {
    await Utils.boxHistory.put(historyModel.id, historyModel.toJson());
    notifyListeners();
  }
}
