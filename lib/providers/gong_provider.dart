import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app_flutter/common_definitions.dart';

class GongProvider with ChangeNotifier {
  int _currentGongIndex = 0;
  bool _gongEnabled = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _gongData = [];
  List<String> _gongNames = [];
  List<String> _gongUrls = [];
  List<String> _imageUrls = [];
  bool _isAuthenticated = false;
  bool _isRestrictedGongPlayed = false;

  int get currentGongIndex => _currentGongIndex;

  bool get gongEnabled => _gongEnabled;

  List<String> get gongNames => _gongNames;

  bool get isAuthenticated => _isAuthenticated;

  bool get isRestrictedGongPlayed => _isRestrictedGongPlayed;

  List<Map<String, dynamic>> get gongData => _gongData;

  List<String> get gongUrls => _gongUrls;

  List<String> get imageUrls => _imageUrls;

  GongProvider() {
    _checkAuthState();
    init();
  }

  Future<void> init() async {
    await _fetchGongData();
    if (_gongData.isEmpty) {
      print('Gong data is empty.');
      return;
    }

    await loadCurrentGongIndex();
    notifyListeners();
    print('Initialization complete: gongEnabled=$_gongEnabled');
  }

  Future<void> _checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _isAuthenticated = user != null;
      _filterAndConvertGongData();
      notifyListeners();
    });
  }

  Future<void> _filterAndConvertGongData() async {
    _gongNames = _gongData.map((data) => data['name'] as String).toList();
    _gongUrls = await Future.wait(_gongData.map((data) async {
      String soundUrl = data['url'] as String;
      if (soundUrl.startsWith('gs://')) {
        return await getDownloadURL(soundUrl);
      }
      return soundUrl;
    }).toList());
    _imageUrls = await Future.wait(_gongData.map((data) async {
      String imageUrl = data['imageUrl'] as String;
      if (imageUrl.startsWith('gs://')) {
        return await getDownloadURL(imageUrl);
      }
      return imageUrl;
    }).toList());
    notifyListeners(); // Notify listeners after data is fetched and converted
  }

  Future<void> _fetchGongData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('gongs')
        .orderBy('restricted') // Sort by the 'restricted' field
        .get();
    if (snapshot.docs.isEmpty) {
      print('No gong documents found.');
      return;
    }

    _gongData =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    _gongNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
    _gongUrls = await Future.wait(snapshot.docs.map((doc) async {
      final gongdUrl = doc['url'] as String;
      if (gongdUrl.startsWith('gs://')) {
        return await convertGsUrlToHttp(gongdUrl);
      }
      return gongdUrl;
    }).toList());

    _imageUrls = await Future.wait(snapshot.docs.map((doc) async {
      final imageUrl = doc['imageUrl'] as String;
      if (imageUrl.startsWith('gs://')) {
        return await convertGsUrlToHttp(imageUrl);
      }
      return imageUrl;
    }).toList());

    notifyListeners();
    print('Gong data fetched successfully.');
  }

  Future<void> loadCurrentGongIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentGongIndex = prefs.getInt('currentGongIndex') ?? 0;
  }

  Future<void> loadGongEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    _gongEnabled = prefs.getBool('gongEnabled') ?? true;
  }

  void toggleGongEnabled() {
    _gongEnabled = !_gongEnabled;
    if (!_gongEnabled) {
      _audioPlayer.stop();
    }
    saveGongState();
    notifyListeners();
  }

  Future<void> saveGongState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentGongIndex', _currentGongIndex);
    await prefs.setBool('gongEnabled', _gongEnabled);
  }

  Future<void> _setGong(int index) async {
    final String gsUrl = _gongUrls[index];
    final String downloadUrl = await getDownloadURL(gsUrl);
    await _audioPlayer.setSourceUrl(downloadUrl);
    if (_gongData[index]['restricted'] && !_isAuthenticated) {
      _isRestrictedGongPlayed = true;
    }
  }

  void setGong(int index) async {
    _currentGongIndex = index;
    _isRestrictedGongPlayed = gongData[index]['restricted'];
    print('Selected sound index: $index');
    print('Selected sound name: ${gongData[index]['name']}');
    print('Is restricted: ${gongData[index]['restricted']}');

    await _setGong(index);

    final String gongSoundUrl = _gongUrls[index];
    await _audioPlayer.play(UrlSource(gongSoundUrl));

    notifyListeners();
  }

  void _playGongSound(int index) async {
    if (_gongEnabled) {
      final String gongSoundUrl = _gongUrls[index];
      await _audioPlayer.play(UrlSource(gongSoundUrl));
    }
  }
}
