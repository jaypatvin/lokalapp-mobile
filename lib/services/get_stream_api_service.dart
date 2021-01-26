import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class GetStreamApiService {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api';
  static const platform = const MethodChannel('io.getstream/backend');

  Future<Map> login(String user) async {
    var authResponse =
        await http.post('$_baseUrl/v1/stream/users', body: {'sender': user});
    var authToken = json.decode(authResponse.body)['authToken'];
    var feedResponse = await http.post(
        '$_baseUrl/v1/stream/stream-feed-credentials',
        headers: {'Authorization': 'Bearer $authToken'});
    var feedToken = json.decode(feedResponse.body)['token'];
    return {'authToken': authToken, 'feedToken': feedToken};
  }

  Future<List> users(Map account) async {
    var response = await http.get('$_baseUrl/v1/stream/users',
        headers: {'Authorization': 'Bearer ${account['authToken']}'});
    return json.decode(response.body)['users'];
  }

  Future<bool> postMessage(Map account, String message) async {
    return await platform.invokeMethod<bool>('postMessage', {
      'user': account['user'],
      'token': account['feedToken'],
      'message': message
    });
  }


  Future<dynamic> postLikes(Map account, String likes)async{
    return await platform.invokeListMethod<bool>('handleLikePost',{
      'user':account['user'],
      'token': account['feedToken'],
      'likes': likes
    });
  }

  Future<dynamic> getActivities(Map account) async {
    var result = await platform.invokeMethod<String>('getActivities',
        {'user': account['user'], 'token': account['feedToken']});
       
    return json.decode(result);
  }

  Future<dynamic> getTimeline(Map account) async {
    var result = await platform.invokeMethod<String>('getTimeline',
        {'user': account['user'], 'token': account['feedToken']});
    return json.decode(result);
  }

  Future<bool> follow(Map account, String userToFollow) async {
    return await platform.invokeMethod<bool>('follow', {
      'user': account['user'],
      'token': account['feedToken'],
      'userToFollow': userToFollow
    });
  }
}
