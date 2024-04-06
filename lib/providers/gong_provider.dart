import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gong/gongs.dart';

class GongProvider with ChangeNotifier {
  int _currentGongIndex = 0;
  bool _gongEnabled = true; // Default to true, but will be loaded from SharedPreferences
  final AudioPlayer _audioPlayer = AudioPlayer();

  GongProvider() {
    init(); // Call init() instead of loadCurrentGongIndex() directly
  }

  int get currentGongIndex => _currentGongIndex;
  bool get gongEnabled => _gongEnabled;

  Future<void> init() async {
    await loadCurrentGongIndex();
    await loadGongEnabledState(); // Load the gong enabled state
    // Optionally, play the gong sound on load if required and enabled.
  }

  Future<void> loadCurrentGongIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentGongIndex = prefs.getInt('currentGongIndex') ?? 0; // Default to 0 if not found
  }

  // New method to load the gong enabled state
  Future<void> loadGongEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    _gongEnabled = prefs.getBool('gongEnabled') ?? true; // Default to true if not found
  }

  void toggleGongEnabled() {
    _gongEnabled = !_gongEnabled;
    if (!_gongEnabled) {
      _audioPlayer.stop(); // Stop playing the sound if the gong is disabled
    }
    saveGongState(); // Save the new state
    notifyListeners();
  }

  // Modify this method to also save the gong enabled state
  Future<void> saveGongState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentGongIndex', _currentGongIndex);
    await prefs.setBool('gongEnabled', _gongEnabled); // Also save the gong enabled state
  }

  void setGong(int index) {
    _currentGongIndex = index;
    saveGongState(); // Save the current gong index and enabled state whenever it's changed
    notifyListeners();
    _playGongSound(index);
  }

  void _playGongSound(int index) {
    if (_gongEnabled) { // Only play sound if gongs are enabled
      final String filePath = GongSounds.files[index];
      _audioPlayer.play(AssetSource(filePath));
    }
  }
}
