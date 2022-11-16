import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  static final LocalStorage storage = LocalStorage('favorites_list');

  factory LocalStorageService() {
    return LocalStorageService();
  }

  get ready {
    return storage.ready;
  }

  getItem(String key) {
    storage.getItem(key);
  }

  setItem(String key, List<dynamic> list) {
    storage.setItem(key, list);
  }
}
