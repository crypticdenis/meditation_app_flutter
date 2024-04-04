import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sounds.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> init() async {
    await loadCurrentSoundIndex();
    await loadSoundEnabledState(); // Load the sound enabled state
    initializeAndPlayLoop(); // Call this conditionally based on the loaded state
  }


  Future<void> saveSoundEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', _soundEnabled);
  }

  Future<void> loadSoundEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? true; // Provide a default value
  }



  Future<void> loadCurrentSoundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentSoundIndex = prefs.getInt('currentSoundIndex') ?? 0;
    print("Loaded sound index: $_currentSoundIndex"); // Debug line
  }

  Future<void> saveCurrentSoundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentSoundIndex', _currentSoundIndex);
  }

  void toggleSoundEnabled() {
    _soundEnabled = !_soundEnabled;
    saveSoundEnabledState(); // Save the new state
    if (_soundEnabled) {
      initializeAndPlayLoop();
    } else {
      stop();
    }
    notifyListeners();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _shouldResume = _isPlaying;
      stop();
    } else if (state == AppLifecycleState.resumed) {
      if (_shouldResume) {
        initializeAndPlayLoop();
      }
    }
  }

  void initializeAndPlayLoop() async {
    print("Initializing and playing loop with index $_currentSoundIndex");
    if (!_isPlaying) {
      await _setSound(_currentSoundIndex);
      play();
    }
  }

  Future<void> _setSound(int index) async {
    print("Setting sound for index $index");
    final String filePath = BackgroundsSounds.files[index];
    await _audioPlayer.setSource(AssetSource(filePath));
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
    await saveCurrentSoundIndex(); // Save the current sound index whenever it's changed
    if (_isPlaying || _shouldResume) {
      play();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}
