import 'dart:convert';
import 'package:arcainternational/helpers/encryption_helper.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class AppSession {
  static final String _encryptionKey = "olwjbZ0dEmyrX0QnVtcclgFw5LMZHBpz";
  static final String _storeName = 'app_session';

  late Database _db;

  AppSession({required Database db}){
    _db = db;
  }

  static Future<Database> get initialize async {
    IdbFactory? idbFactory = getIdbFactory();

    Database db = await idbFactory!.open(
      "id_warkopwarawiri_challenge.db", 
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
      Database db = event.database;
      db.createObjectStore(_storeName, autoIncrement: true);
      db.createObjectStore("app_settings", autoIncrement: true);
    });

    return db;
  }

  Future<dynamic> getSession({required String key}) async {
    Object? result;
    List<Map<String, dynamic>?> sessions = await _getDataAsList(table: _storeName, encryptionKey: _encryptionKey);

    if(sessions.length < 1)
      return result;

    for(Map<String, dynamic>? session in sessions) {
      if(session!.containsKey(key))
        result = session[key];
    }

    return result;
  }

  Future<void> setSession({required String key, required dynamic value}) async {
    dynamic oldSession = await getSession(key: key);
    if(oldSession != null && oldSession == value) {
      return;
    } else if(oldSession != null && oldSession != value) {
      await unsetSession(key: key);
    }

    await _insertData(table: _storeName, encryptionKey: _encryptionKey, data: {key: value});
  }

  Future<void> unsetSession({required String key}) async {
    await _deleteDataSession(table: _storeName, encryptionKey: _encryptionKey, keyName: key);
  }

  Future<void> _insertData({required String table, required String encryptionKey, required Map<String, Object?> data}) async {
    var txn = _db.transaction(table, 'readwrite');
    var store = txn.objectStore(table);
    String? encryptedData = Encryption.encrypt(key: encryptionKey, plainText: json.encode(data));
    if(encryptedData == null)
      return;

    await store.put(encryptedData);
    await txn.completed;
  }

  Future<void> _deleteDataSession({required String table, required String encryptionKey, required String keyName}) async {
    final Transaction txn = _db.transaction(table, 'readwrite');
    final ObjectStore store = txn.objectStore(table);

    final List<Object> keys = await store.getAllKeys();
    Object? sessionKey;

    for(Object? key in keys) {
      Object? value = await store.getObject(key!);
      value = Encryption.decrypt(key: encryptionKey, encrypted: value.toString());
      final Map<String, dynamic> mapValue = json.decode(value.toString());
      if(mapValue.containsKey(keyName) && sessionKey == null)
        sessionKey = key;
    }

    if(sessionKey != null) {
      await store.delete(sessionKey);
    }

    await txn.completed;
  }

  // ignore: unused_element
  Future<Map<String, dynamic>?> _getData({required String table, required String encryptionKey, Map<String, dynamic>? whereData}) async {
    Map<String, dynamic>? result;
    final Transaction txn = _db.transaction(table, 'readonly');
    final ObjectStore store = txn.objectStore(table);
    final List<Object> value = await store.getAll();
    try {
      String stringValue = value[0].toString();
      stringValue = Encryption.decrypt(key: encryptionKey, encrypted: stringValue)!;
    } catch (e) {}

    return result;
  }

  // ignore: unused_element
  Future<List<Map<String, dynamic>?>> _getDataAsList({required table, required String encryptionKey, Map<String, dynamic>? whereData}) async {
    List<Map<String, dynamic>?> result = [];
    final Transaction txn = _db.transaction(table, 'readonly');
    final ObjectStore store = txn.objectStore(table);
    final List<Object> value = await store.getAll();
    
    try {
      for(Object val in value) {
        val = Encryption.decrypt(key: encryptionKey, encrypted: val.toString())!;
        final Map<String, dynamic> mapData = json.decode(val.toString());
        result.add(mapData);
      }
    } catch (e) {}


    return result;
  }
  
}