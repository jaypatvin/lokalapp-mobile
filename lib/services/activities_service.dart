import 'package:collection/collection.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../models/activity_feed.dart';
import '../providers/auth.dart';
import 'api/api.dart';
import 'database/database.dart';

class ActivitiesService with ReactiveServiceMixin {
  ActivitiesService() {
    listenToReactiveValues([_feed, _isLoading]);
  }

  final ReactiveList<ActivityFeed> _feed = ReactiveList();
  UnmodifiableListView<ActivityFeed> get feed =>
      UnmodifiableListView(_feed.toList());

  final ReactiveValue<bool> _isLoading = ReactiveValue(false);
  bool get isLoading => _isLoading.value;

  final _auth = locator<Auth>();
  final _activityService = locator<ActivityAPI>();
  final _commentService = locator<CommentsAPI>();
  final _db = locator<Database>().activities;
}
