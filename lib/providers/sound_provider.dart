import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sounds.dart';

class BackgroundSoundProvider with ChangeNotifier, WidgetsBindingObserver {
  int _currentSoundIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _shouldResume = false;
  bool _soundEnabled = true;


  int get currentSoundIndex => _currentSoundIndex;
  bool get soundEnabled => _soundEnabled;

  BackgroundSoundProvider() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addObserver(this);
  }

  void toggleSoundEnabled() {
    _soundEnabled = !_soundEnabled;
    if (_soundEnabled) {
      // Resume sound if it was playing before being disabled
      initializeAndPlayLoop();
    } else {
      // Stop sound if sound is being disabled
      stop();
    }
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in the background
      _shouldResume = _isPlaying;
      stop();
    } else if (state == AppLifecycleState.resumed) {
      if (_shouldResume) {
        initializeAndPlayLoop();
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
    if (!_soundEnabled) return; // Do not play if sound is disabled
    await _audioPlayer.resume();
    _isPlaying = true;
    _shouldResume = false;
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
    if (_isPlaying || _shouldResume) {
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
