import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefsService {
//   static const String ANONYMOUS_ID_KEY = 'anonymous_user_id';

//   static Future<String?> getAnonymousId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(ANONYMOUS_ID_KEY);
//   }

//   static Future<void> setAnonymousId(String id) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(ANONYMOUS_ID_KEY, id);
//   }

//   static Future<void> clearAnonymousId() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(ANONYMOUS_ID_KEY);
//   }
// }
