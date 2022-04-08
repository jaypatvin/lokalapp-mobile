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
    "message": "Error while verifying Firebase ID token",
    "status": "error",
    "err": {
        "code": "auth/id-token-expired",
        "message": "Firebase ID token has expired. Get a fresh ID token from your client app and try again (auth/id-token-expired). See https://firebase.google.com/docs/auth/admin/verify-id-tokens for details on how to retrieve an ID token."
    },
    "code": "UnauthorizedError"
}
''';
