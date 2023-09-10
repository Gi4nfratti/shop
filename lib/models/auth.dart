import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../auth/keysSecret.dart';
import '../data/store.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expirydate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expirydate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=$AUTHENTICATION";

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final body = jsonDecode(response.body);

    _token = body['idToken'];
    _email = body['email'];
    _userId = body['localId'];

    _expirydate = DateTime.now().add(Duration(
      seconds: int.parse(body['expiresIn']),
    ));

    Store.saveMap('userData', {
      'token': _token,
      'email': _email,
      'userId': _userId,
      'expiryDate': _expirydate!.toIso8601String(),
    });

    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expirydate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expirydate = null;
    _clearAutoLogoutTimer();
    Store.remove('userData').then((value) => notifyListeners());
  }

  void _clearAutoLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();
    final timeToLogout = _expirydate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
