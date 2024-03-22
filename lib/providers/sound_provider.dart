import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app_flutter/sounds.dart'; // Adjust the import as necessary

class BackgroundSoundProvider with ChangeNotifier, WidgetsBindingObserver {
  int _currentSoundIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _shouldResume = false; // Flag to track if sound should resume

  int get currentSoundIndex => _currentSoundIndex;

  BackgroundSoundProvider() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in the background
      _shouldResume = _isPlaying; // Remember if we were playing
      stop();
    } else if (state == AppLifecycleState.resumed) {
      // App is back in the foreground
      if (_shouldResume) {
        initializeAndPlayLoop(); // Resume playing only if we were playing before pausing
      }
    }
  }

  void initializeAndPlayLoop() async {
    if (!_isPlaying) {
      await _setSound(_currentSoundIndex);
      play();
    }
  }

  void play() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    _shouldResume = false; // Reset resume flag
    notifyListeners();
  }

  void stop() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void setSound(int index) async {
    _currentSoundIndex = index;
    await _setSound(index);
    if (_isPlaying || _shouldResume) { // Check if we should resume playback
      play();
    }
  }

  Future<void> _setSound(int index) async {
    final String filePath = BackgroundsSounds.files[index];
    await _audioPlayer.setSource(AssetSource(filePath));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}
