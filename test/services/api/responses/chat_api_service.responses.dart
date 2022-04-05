const successResponse = '''
{
    "status": "ok",
    "data": {
        "id": "751058275337130",
        "created_at": {
            "_seconds": 1647342263,
            "_nanoseconds": 665000000
        },
        "members": [
            "r4KVlWDCvCHKL6MSDxVH",
            "w5TpqMRZT04LGoJ8mdGs"
        ],
        "archived": false,
        "last_message": {
            "ref": {
                "_firestore": {
                    "_settings": {
                        "projectId": "lokal-1baac",
                        "firebaseVersion": "9.4.2",
                        "libName": "gccl",
                        "libVersion": "4.8.1 fire/9.4.2"
                    },
                    "_settingsFrozen": true,
                    "_serializer": {
                        "allowUndefined": false
                    },
                    "_projectId": "lokal-1baac",
                    "registeredListenersCount": 0,
                    "bulkWritersCount": 0,
                    "_backoffSettings": {
                        "initialDelayMs": 100,
                        "maxDelayMs": 60000,
                        "backoffFactor": 1.3
                    },
                    "_clientPool": {
                        "concurrentOperationLimit": 100,
                        "maxIdleClients": 1,
                        "activeClients": {},
                        "failedClients": {},
                        "terminated": false,
                        "terminateDeferred": {
                            "promise": {}
                        }
                    }
                },
                "_path": {
                    "segments": [
                        "chats",
                        "751058275337130",
                        "conversation",
                        "Pw9lfwzXb2BWQbPzBPO0"
                    ]
                },
                "_converter": {}
            },
            "content": "i should not be able to reply to deleted messages",
            "created_at": {
                "_seconds": 1647442904,
                "_nanoseconds": 299000000
            },
            "sender_id": "r4KVlWDCvCHKL6MSDxVH",
            "conversation_id": "Pw9lfwzXb2BWQbPzBPO0",
            "sender": "JPat Jam"
        },
        "chat_type": "user",
        "updated_at": {
            "_seconds": 1647442904,
            "_nanoseconds": 299000000
        },
        "title": "JPat Jam, Vince Jam",
        "community_id": "QHdK73bGFQRmgmPr3enN"
    }
}
''';

const errorResponse = '''
{
   "message":"The requestor is not a member of the chat",
   "status":"error",
   "code":"ChatApiError"
}
''';

const missingKeyResponse = '''
{
    "status": "ok",
    "data": {
        "created_at": {
            "_seconds": 1647342263,
            "_nanoseconds": 665000000
        },
        "members": [
            "r4KVlWDCvCHKL6MSDxVH",
            "w5TpqMRZT04LGoJ8mdGs"
        ],
        "archived": false,
        "chat_type": "user",
        "updated_at": {
            "_seconds": 1647442904,
            "_nanoseconds": 299000000
        },
        "title": "JPat Jam, Vince Jam",
        "community_id": "QHdK73bGFQRmgmPr3enN"
    }
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
    "message": "Error while verifying Firebase ID token",
    "status": "error",
    "err": {
        "code": "auth/id-token-expired",
        "message": "Firebase ID token has expired. Get a fresh ID token from your client app and try again (auth/id-token-expired). See https://firebase.google.com/docs/auth/admin/verify-id-tokens for details on how to retrieve an ID token."
    },
    "code": "UnauthorizedError"
}
''';
