import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/login_response_model/login_response_model.dart';

class SessionController {
  static final SessionController _instance = SessionController._internal();
  factory SessionController() => _instance;
  SessionController._internal();

  UserDataModel userDataModel = const UserDataModel();
  bool isLogin = false;
  bool isRedirectingToLogin = false;

  /// Loads token and user data from SharedPreferences.
  /// Call this ONCE during app initialization (e.g. Splash Screen)
  Future<void> getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    
    String? dataString = prefs.getString('user_data');
    if (dataString != null && dataString.isNotEmpty) {
      Map<String, dynamic> dataMap = jsonDecode(dataString);
      userDataModel = UserDataModel.fromJson(dataMap);
      isLogin = userDataModel.token != null && userDataModel.token!.isNotEmpty;
    } else {
      isLogin = false;
      userDataModel = const UserDataModel();
    }
  }

  /// Saves the user data model alongside its token into SharedPreferences.
  Future<void> saveUserPreference(UserDataModel user) async {
    final prefs = await SharedPreferences.getInstance();
    
    userDataModel = user;
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    isLogin = true;
  }
  
  /// Clears the session entirely.
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove('user_data');
    userDataModel = const UserDataModel();
    isLogin = false;
  }
}
