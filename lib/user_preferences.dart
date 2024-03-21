import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String selectedGradientKey = 'selectedGradient';

  static Future<int> getSelectedGradientIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(selectedGradientKey) ?? 0; // Default to first gradient
  }

  static Future<void> setSelectedGradientIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(selectedGradientKey, index);
  }
}
