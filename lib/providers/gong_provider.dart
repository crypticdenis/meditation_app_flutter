import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../gongs.dart';

class GongProvider with ChangeNotifier {
  int _currentGongIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int get currentGongIndex => _currentGongIndex;

  void setGong(int index) {
    _currentGongIndex = index;
    notifyListeners();
    _playGongSound(index);
  }

  void _playGongSound(int index) {
    final String filePath = GongSounds.files[index];
    _audioPlayer.play(AssetSource(filePath));
  }
}
