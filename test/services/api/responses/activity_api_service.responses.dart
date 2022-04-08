const error404 = '''
{
    "status": "error",
    "message": "Post does not exist!"
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
   "message":"Activity with id "4dgYg0LcDw9MYn1QC8Yy" is currently archived",
   "status":"error",
   "code":"LikeApiError"
}
''';

const successResponse = '''
{
  "status": "ok",
  "data": {
      "id": "123456",
      "updated_by": "aUserId",
      "images": [],
      "updated_from": "",
      "archived": false,
      "message": "This is a test post",
      "community_id": "aCommunityId",
      "created_at": {
          "_seconds": 1645754899,
          "_nanoseconds": 522000000
      },
      "updated_at": {
          "_seconds": 1645754922,
          "_nanoseconds": 893000000
      },
      "status": "enabled",
      "user_id": "aUserId",
      "liked": false
    }
}
''';

const successMissingResponse = '''
{
  "status": "ok",
  "data": {
      "updated_by": "aUserId",
      "images": [],
      "updated_from": "",
      "archived": false,
      "message": "This is a test post",
      "community_id": "aCommunityId",
      "updated_at": {
          "_seconds": 1645754922,
          "_nanoseconds": 893000000
      },
      "status": "enabled",
      "user_id": "aUserId",
      "liked": false
    }
}
''';

const successListResponse = '''
{
  "status": "ok",
  "data": [
    {
      "id": "123456",
      "updated_by": "aUserId",
      "images": [],
      "updated_from": "",
      "archived": false,
      "message": "This is a test post",
      "community_id": "aCommunityId",
      "created_at": {
          "_seconds": 1645754899,
          "_nanoseconds": 522000000
      },
      "updated_at": {
          "_seconds": 1645754922,
          "_nanoseconds": 893000000
      },
      "status": "enabled",
      "user_id": "aUserId",
      "liked": false
    },
    {
      "id": "1234567",
      "updated_by": "aUserId",
      "images": [],
      "updated_from": "",
      "archived": false,
      "message": "This is a test post",
      "community_id": "aCommunityId",
      "created_at": {
          "_seconds": 1645754899,
          "_nanoseconds": 522000000
      },
      "updated_at": {
          "_seconds": 1645754922,
          "_nanoseconds": 893000000
      },
      "status": "enabled",
      "user_id": "aUserId",
      "liked": false
    },
    {
      "id": "1234568",
      "updated_by": "aUserId",
      "images": [],
      "updated_from": "",
      "archived": false,
      "message": "This is a test post",
      "community_id": "aCommunityId",
      "created_at": {
          "_seconds": 1645754899,
          "_nanoseconds": 522000000
      },
      "updated_at": {
          "_seconds": 1645754922,
          "_nanoseconds": 893000000
      },
      "status": "enabled",
      "user_id": "aUserId",
      "liked": false
    }
  ]
}
''';

const successListMissingResponse = '''
{
  "status": "ok",
  "data": [{
      "updated_by": "aUserId",
      "images": [],
      "updated_from": "",
      "archived": false,
      "message": "This is a test post",
      "community_id": "aCommunityId",
      "updated_at": {
          "_seconds": 1645754922,
          "_nanoseconds": 893000000
      },
      "status": "enabled",
      "user_id": "aUserId",
      "liked": false
    }]
}
''';
