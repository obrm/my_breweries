import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  LocalStorage? storage;

  LocalStorageService() {
    storage = LocalStorage('favorites_list');
  }

  get ready {
    return storage!.ready;
  }

  getItem(String key) {
    storage!.getItem(key);
  }

  setItem(String key, List<dynamic> list) {
    storage!.setItem(key, list);
  }
}
