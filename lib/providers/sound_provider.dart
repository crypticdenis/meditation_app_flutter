import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sounds.dart';

class BackgroundSoundProvider with ChangeNotifier, WidgetsBindingObserver {
  int _currentSoundIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _shouldResume = false;

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
