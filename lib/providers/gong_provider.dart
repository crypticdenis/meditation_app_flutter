import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gong_feature/gongs.dart';

class GongProvider with ChangeNotifier {
  int _currentGongIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  GongProvider() {
    loadCurrentGongIndex();
  }

  int get currentGongIndex => _currentGongIndex;

  Future<void> init() async {
    await loadCurrentGongIndex();
  }

  Future<void> loadCurrentGongIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentGongIndex = prefs.getInt('currentGongIndex') ?? 0; // Default to 0 if not found
    // Optionally, play the gong sound on load if required.
  }

  Future<void> saveCurrentGongIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentGongIndex', _currentGongIndex);
  }

  void setGong(int index) {
    _currentGongIndex = index;
    saveCurrentGongIndex(); // Save the current gong index whenever it's changed
    notifyListeners();
    _playGongSound(index);
  }

  void _playGongSound(int index) {
    final String filePath = GongSounds.files[index];
    _audioPlayer.play(AssetSource(filePath));
  }
}
