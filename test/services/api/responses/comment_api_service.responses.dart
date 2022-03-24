const successResponse = '''
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

const successListResponse = '''
{
  "status": "ok",
  "data": [
    {
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
  ]
}
''';

// no id
const missingKeyResponse = '''
{
  "status": "ok",
  "data": {
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

const missingKeyListResponse = '''
{
  "status": "ok",
  "data": [
    {
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
  ]
}
''';

const error404 = '''
{
  "status": "error",
  "message": "Comment does not exist!"
}
''';

const errorCreate = '''
{
    "status": "error",
    "err": {
        "name": "JsonSchemaValidationError",
        "validationErrors": {
            "body": [
                {
                    "keyword": "required",
                    "dataPath": "",
                    "schemaPath": "#/anyOf/0/required",
                    "params": {
                        "missingProperty": "message"
                    },
                    "message": "should have required property 'message'"
                },
                {
                    "keyword": "required",
                    "dataPath": "",
                    "schemaPath": "#/anyOf/1/required",
                    "params": {
                        "missingProperty": "images"
                    },
                    "message": "should have required property 'images'"
                },
                {
                    "keyword": "anyOf",
                    "dataPath": "",
                    "schemaPath": "#/anyOf",
                    "params": {},
                    "message": "should match some schema in anyOf"
                }
            ]
        }
    },
    "error_fields": {
        "message": "missing required property",
        "images": "missing required property"
    },
    "code": "ValidationError"
}
''';

const okStatus = '''
{
    "status": "ok",
    "data": {
        "_writeTime": {
            "_seconds": 1647934187,
            "_nanoseconds": 531935000
        }
    }
}
''';

const errorStatus = '''
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
