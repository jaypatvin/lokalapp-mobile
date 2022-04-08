const success = '''
{
    "status": "ok",
    "data": {
        "id": "someId",
        "community_id": "someCommunityId",
        "keywords": [],
        "created_at": {
            "_seconds": 1648196085,
            "_nanoseconds": 89000000
        },
        "inviter": "someUserId",
        "updated_by": "someUserId",
        "expire_by": 1648282485089,
        "archived": false,
        "status": "enabled",
        "code": "someCode",
        "claimed": false,
        "invitee_email": "someInviteeEmail",
        "updated_from": ""
    }
}
''';

const error = '''
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
                        "missingProperty": "email"
                    },
                    "message": "should have required property 'message'"
                }
            ]
        }
    },
    "error_fields": {
        "email": "missing required property",
    },
    "code": "ValidationError"
}
''';

const missingRequiredKey = '''
{
    "status": "ok",
    "data": {
        "community_id": "someCommunityId",
        "keywords": [],
        "created_at": {
            "_seconds": 1648196085,
            "_nanoseconds": 89000000
        },
        "inviter": "someUserId",
        "updated_by": "someUserId",
        "expire_by": 1648282485089,
        "archived": false,
        "status": "enabled",
        "code": "someCode",
        "claimed": false,
        "invitee_email": "someInviteeEmail",
        "updated_from": ""
    }
}
''';

const check = '''
{
    "status": "ok",
    "data": {
        "id": "someId",
        "community_id": "someCommunityId"
    }
}
''';

const checkError = '''
{
    "message": "Invite with code "someId" was already claimed",
    "status": "error",
    "code": "ActivityApiError"
}
''';

// Response with missing [community_id]
const checkMissingKey = '''
{
    "status": "ok",
    "data": {
        "id": "someId"
    }
}
''';

const claimOk = '''
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

const claimError = '''
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
