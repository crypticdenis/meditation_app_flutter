import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this import for Firebase Storage

class BackgroundSoundProvider with ChangeNotifier, WidgetsBindingObserver {
  int _currentSoundIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _shouldResume = false;
  bool _soundEnabled = true;
  List<String> _soundNames = [];
  List<String> _soundUrls = [];

  int get currentSoundIndex => _currentSoundIndex;
  bool get soundEnabled => _soundEnabled;
  List<String> get soundNames => _soundNames;
  int get lengthOfSoundList => soundNames.length;

  BackgroundSoundProvider() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  Future<void> init() async {
    await _fetchSoundData();
    await loadCurrentSoundIndex();
    await loadSoundEnabledState();
    initializeAndPlayLoop();
  }

  Future<void> _fetchSoundData() async {
    final snapshot = await FirebaseFirestore.instance.collection('sounds').get();
    _soundNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
    _soundUrls = snapshot.docs.map((doc) => doc['url'] as String).toList();
    notifyListeners();
  }

  Future<void> loadCurrentSoundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentSoundIndex = prefs.getInt('currentSoundIndex') ?? 0;
  }

  Future<void> loadSoundEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
  }

  Future<void> saveSoundEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', _soundEnabled);
  }

  Future<void> saveCurrentSoundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentSoundIndex', _currentSoundIndex);
  }

  void toggleSoundEnabled() {
    _soundEnabled = !_soundEnabled;
    saveSoundEnabledState();
    if (_soundEnabled) {
      initializeAndPlayLoop();
    } else {
      stop();
    }
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
    if (!_isPlaying) {
      await _setSound(_currentSoundIndex);
      play();
    }
  }

  Future<String> getDownloadURL(String gsUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(gsUrl);
    return await ref.getDownloadURL();
  }

  Future<void> _setSound(int index) async {
    final String gsUrl = _soundUrls[index];
    final String downloadUrl = await getDownloadURL(gsUrl);
    await _audioPlayer.setSourceUrl(downloadUrl);
  }

  void play() async {
    if (!_soundEnabled) return;
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
    await saveCurrentSoundIndex();
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
