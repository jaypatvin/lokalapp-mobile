import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import 'api/api.dart';
import 'api_service.dart';
import 'database/database.dart';

class AuthService with ReactiveServiceMixin {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _usersCollection = locator<Database>().users;
  final _apiService = locator<UserAPI>();
  final _api = locator<APIService>();
}
