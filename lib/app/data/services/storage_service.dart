import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late SharedPreferences _prefs;

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _usernameKey = 'username';
  static const _emailKey = 'email';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get token => _prefs.getString(_tokenKey);

  Future<void> saveToken(String token) => _prefs.setString(_tokenKey, token);

  int? get userId => _prefs.getInt(_userIdKey);
  String? get username => _prefs.getString(_usernameKey);
  String? get email => _prefs.getString(_emailKey);

  Future<void> saveUser({
    required int id,
    required String username,
    required String email,
  }) async {
    await _prefs.setInt(_userIdKey, id);
    await _prefs.setString(_usernameKey, username);
    await _prefs.setString(_emailKey, email);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
