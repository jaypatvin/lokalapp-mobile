import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/lokal_user.dart';
import '../services/api/api.dart';
import '../services/api/user_api_service.dart';
import '../services/database.dart';

// TODO: checking for errors (no authResult etc.)
class Auth extends ChangeNotifier {
  Auth._(this._api, this._apiService);

  factory Auth(API api) {
    final apiService = UserAPIService(api);
    return Auth._(api, apiService);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Database _db = Database.instance;
  final UserAPIService _apiService;
  final API _api;

  StreamSubscription<User?>? _authChangesSubscription;
  StreamSubscription<User?>? _idTokenChangesSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userStreamSubscription;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? _userStream;

  LokalUser? _user;
  LokalUser? get user => _user;

  User? _firebaseUser;
  User? get firebaseUser => _firebaseUser;

  String? _idToken;
  String? get idToken => _idToken;

  String? get authUid => FirebaseAuth.instance.currentUser?.uid;
  String? get authEmail => FirebaseAuth.instance.currentUser?.email;

  @override
  void dispose() {
    _authChangesSubscription?.cancel();
    _idTokenChangesSubscription?.cancel();
    _userStreamSubscription?.cancel();
    super.dispose();
  }

  void _onIdTokenChanges() {
    _idTokenChangesSubscription?.cancel();
    _idTokenChangesSubscription = _auth.idTokenChanges().listen(
      (User? user) async {
        try {
          if (user != null) {
            _idToken = await user.getIdToken();
            _api.setIdToken(_idToken!);
          } else {
            _idToken = null;
          }
          notifyListeners();
        } catch (e) {
          throw (e);
        }
      },
    );
  }

  Future<void> _userChangeListener(User? user) async {
    try {
      _firebaseUser = user;
      if (user != null) {
        _idToken = await user.getIdToken();
        _api.setIdToken(_idToken!);
        _idTokenChangesSubscription?.cancel();
        _onIdTokenChanges();

        final id = await _db.getUserDocId(user.uid);
        if (id.isEmpty) {
          this._user = null;

          notifyListeners();
          return;
        }
        if (_user != null && id == _user!.id) {
          notifyListeners();
          return;
        }

        print('API called by firebaseAuth changes');
        this._user = await _apiService.getById(userId: id);

        _userStreamSubscription?.cancel();
        _userStream = FirebaseFirestore.instance
            .collection("users")
            .doc(_user!.id)
            .snapshots();

        _userStreamSubscription = _userStream!.listen(
          (_) async {
            print('API called by firestore changes');
            this._user = await _apiService.getById(userId: id);
            notifyListeners();
          },
        );
      } else {
        this._user = null;
      }

      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> onStartUp() async {
    try {
      final User? _firebaseUser = _auth.currentUser;
      if (_firebaseUser != null) {
        await _firebaseUser.reload();
        await _userChangeListener(_firebaseUser);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userChangeListener(credential.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userChangeListener(credential.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final _googleSignIn = GoogleSignIn(
        scopes: const [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      final _googleUser = await _googleSignIn.signIn();
      if (_googleUser == null) throw 'Failed to Sign In';
      final _googleAuth = await _googleUser.authentication;
      final _credential = GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken,
      );
      final credential = await _auth.signInWithCredential(_credential);
      await _userChangeListener(credential.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      final _loginResult = await FacebookAuth.i.login();
      final _accessToken = _loginResult.accessToken;
      if (_accessToken == null) throw 'Failed to Sign In';

      final _credential = FacebookAuthProvider.credential(_accessToken.token);
      final credential = await _auth.signInWithCredential(_credential);
      await _userChangeListener(credential.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = _sha256ofString(rawNonce);

    try {
      final _appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: add client ID and URI for sign in
          clientId: '',
          redirectUri: Uri.parse(''),
        ),
        nonce: nonce,
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: _appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.

      final credential = await _auth.signInWithCredential(oAuthCredential);
      final displayName =
          '${_appleCredential.givenName} ${_appleCredential.familyName}';
      final userEmail = '${_appleCredential.email}';

      final firebaseUser = credential.user;
      await firebaseUser?.updateDisplayName(displayName);
      await firebaseUser?.updateEmail(userEmail);
      await _userChangeListener(credential.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logOut() async {
    _authChangesSubscription?.cancel();
    _idTokenChangesSubscription?.cancel();
    _userStreamSubscription?.cancel();

    _userChangeListener(null);
    await _auth.signOut();
  }

  bool checkSignInMethod() {
    final userInfos = _auth.currentUser!.providerData;
    final result = userInfos.any(
      (userInfo) => userInfo.providerId == EmailAuthProvider.PROVIDER_ID,
    );

    if (!result) {
      for (final userInfo in userInfos) {
        if (userInfo.providerId == EmailAuthProvider.PROVIDER_ID) {
          debugPrint('Signed in with Email.');
        } else if (userInfo.providerId == GoogleAuthProvider.PROVIDER_ID) {
          debugPrint('Signed in with Google.');
          throw ('Signed in with Google.');
        } else if (userInfo.providerId == FacebookAuthProvider.PROVIDER_ID) {
          debugPrint('Signed in with Google.');
          throw ('Signed in with Facebook');
        }
      }
    }

    return result;
  }

  Future<void> changeEmail(
    String email,
    String password,
    String newEmail,
  ) async {
    try {
      checkSignInMethod();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(
        userCredential.credential!,
      );
      return await _auth.currentUser!.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> changePassword(
    String email,
    String password,
    String newPassword,
  ) async {
    try {
      checkSignInMethod();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(
        userCredential.credential!,
      );
      return await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    } catch (e) {
      throw (e);
    }
  }

  void manualFetch(User? user) => _userChangeListener(user);

  Future<void> register(Map<String, dynamic> body) async {
    try {
      this._user = await _apiService.create(body: body);
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();

    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
