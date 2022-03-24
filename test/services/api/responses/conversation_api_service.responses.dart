const success = '''
{
  "status": "ok",
  "data": {
    "id": "activityId",
    "status": "enabled",
    "archived": false,
    "created_at": {
      "_seconds": 1646370763,
      "_nanoseconds": 231000000
    },
    "user_id": "someUserId",
    "message": "Whoa",
    "liked": false
  }
}
''';

const error = '''
{
    "status": "error",
    "data": {
        "_writeTime": {
            "_seconds": 1647934187,
            "_nanoseconds": 531935000
        }
    }
}
''';
