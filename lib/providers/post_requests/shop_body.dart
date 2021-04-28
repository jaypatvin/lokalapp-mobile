import 'package:flutter/foundation.dart';

class ShopBody extends ChangeNotifier {
  Map<String, dynamic> _shopBody = Map();

  Map get data => _shopBody;

  void update({
    String name,
    String userId,
    String communityId,
    String description,
    String profilePhoto,
    String coverPhoto,
    bool isClosed,
    String opening,
    String closing,
    bool useCustomHours,
    Map<String, String> operatingHours,
    String status,
  }) {
    _shopBody['name'] = name ?? _shopBody['name'];
    _shopBody['user_id'] = userId ?? _shopBody['user_id'];
    _shopBody['community_id'] = communityId ?? _shopBody['community_id'];
    _shopBody['description'] = description ?? _shopBody['description'];
    _shopBody['profile_photo'] = profilePhoto ?? _shopBody['profile_photo'];
    _shopBody['cover_photo'] = coverPhoto ?? _shopBody['cover_photo'];
    _shopBody['is_close'] = isClosed ?? _shopBody['isClose'];
    _shopBody['opening'] = opening ?? _shopBody['opening'];
    _shopBody['closing'] = closing ?? _shopBody['closing'];
    //TODO: CHECK THIS
    _shopBody['use_custom_hours'] =
        useCustomHours ?? _shopBody['use_custom_hours'];
    _shopBody['status'] = status ?? _shopBody['status'];
    _shopBody['operating_hours'] =
        operatingHours ?? _shopBody['operating_hours'];

    notifyListeners();
  }
}
