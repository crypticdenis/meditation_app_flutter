import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app_flutter/common_definitions.dart';

class BackgroundSoundProvider with ChangeNotifier, WidgetsBindingObserver {
  int _currentSoundIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _shouldResume = false;
  bool _soundEnabled = false; // Initialize to false
  List<Map<String, dynamic>> _soundData = [];
  List<String> _soundNames = [];
  List<String> _soundUrls = [];
  List<String> _imageUrls = [];
  bool _isAuthenticated = false;
  bool _isRestrictedSoundPlayed = false;

  int get currentSoundIndex => _currentSoundIndex;

  bool get soundEnabled => _soundEnabled;

  List<String> get soundNames => _soundNames;

  List<String> get imageUrls => _imageUrls;

  int get lengthOfSoundList => soundNames.length;

  bool get isAuthenticated => _isAuthenticated;

  bool get isRestrictedSoundPlayed => _isRestrictedSoundPlayed;

  List<Map<String, dynamic>> get soundData => _soundData;

  BackgroundSoundProvider() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addObserver(this);
    _checkAuthState();
    init();
  }

  Future<void> _checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _isAuthenticated = user != null;
      _filterAndConvertSoundData();
      notifyListeners();
    });
  }

  Future<void> init() async {
    await _fetchSoundData();
    if (_soundData.isEmpty) {
      print('Sound data is empty.');
      return;
    }

    await loadCurrentSoundIndex();

    // Always disable sound on initialization
    _soundEnabled = false;
    notifyListeners();
    print('Initialization complete: soundEnabled=$_soundEnabled');
  }

  Future<void> _fetchSoundData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sounds')
        .orderBy('restricted') // Sort by the 'restricted' field
        .get();
    if (snapshot.docs.isEmpty) {
      print('No sound documents found.');
      return;
    }

    _soundData =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    _soundNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
    _soundUrls = await Future.wait(snapshot.docs.map((doc) async {
      final soundUrl = doc['url'] as String;
      if (soundUrl.startsWith('gs://')) {
        return await convertGsUrlToHttp(soundUrl);
      }
      return soundUrl;
    }).toList());

    _imageUrls = await Future.wait(snapshot.docs.map((doc) async {
      final imageUrl = doc['imageUrl'] as String;
      if (imageUrl.startsWith('gs://')) {
        return await convertGsUrlToHttp(imageUrl);
      }
      return imageUrl;
    }).toList());

    notifyListeners();
    print('Sound data fetched successfully.');
  }


  Future<void> _filterAndConvertSoundData() async {
    _soundNames = _soundData.map((data) => data['name'] as String).toList();
    _soundUrls = await Future.wait(_soundData.map((data) async {
      String soundUrl = data['url'] as String;
      if (soundUrl.startsWith('gs://')) {
        return await getDownloadURL(soundUrl);
      }
      return soundUrl;
    }).toList());
    _imageUrls = await Future.wait(_soundData.map((data) async {
      String imageUrl = data['imageUrl'] as String;
      if (imageUrl.startsWith('gs://')) {
        return await getDownloadURL(imageUrl);
      }
      return imageUrl;
    }).toList());
    notifyListeners(); // Notify listeners after data is fetched and converted
  }

  Future<void> _setSound(int index) async {
    final String gsUrl = _soundUrls[index];
    final String downloadUrl = await getDownloadURL(gsUrl);
    await _audioPlayer.setSourceUrl(downloadUrl);
    if (_soundData[index]['restricted'] && !_isAuthenticated) {
      _isRestrictedSoundPlayed = true;
    }
  }

  Future<void> loadCurrentSoundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentSoundIndex = prefs.getInt('currentSoundIndex') ?? 0;
  }

  Future<void> loadSoundEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? false;
    notifyListeners();
    print('Sound enabled state loaded: $_soundEnabled');
  }

  Future<void> saveSoundEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', _soundEnabled);
    print('Sound enabled state saved: $_soundEnabled');
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
    print('Sound enabled toggled: $_soundEnabled');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _shouldResume = _isPlaying;
      stop();
      _soundEnabled = false;
      saveSoundEnabledState();
    } else if (state == AppLifecycleState.resumed) {
      _soundEnabled = false;
      if (_shouldResume) {
        initializeAndPlayLoop();
      }
      saveSoundEnabledState();
    }
  }

  void initializeAndPlayLoop() async {
    if (!_isPlaying && _soundEnabled) {
      await _setSound(_currentSoundIndex);
      play();
    }
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
    _isRestrictedSoundPlayed = soundData[index]['restricted'];
    print('Selected sound index: $index');
    print('Selected sound name: ${soundData[index]['name']}');
    print('Is restricted: ${soundData[index]['restricted']}');

    await _setSound(index);
    if (_soundEnabled) {
      play();
    }
    notifyListeners();
  }


  void stopPlayingRestrictedSound() {
    if (_isRestrictedSoundPlayed) {
      stop();
      //_isRestrictedSoundPlayed = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}

