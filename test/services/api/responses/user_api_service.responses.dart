const user = '''
{
    "status": "ok",
    "data": {
        "id": "someUserId",
        "_meta": {
            "product_subscription_plans_as_buyer_count": 1,
            "shops_count": 1,
            "activities_likes_count": 2,
            "orders_as_buyer_count": 2,
            "products_count": 1
        },
        "roles": {
            "admin": false,
            "member": true
        },
        "display_name": "Vince Jam",
        "chat_settings": {
            "show_read_receipts": false
        },
        "email": "someEmail",
        "user_uids": [
            "someUserUid"
        ],
        "notification_settings": {
            "tags": false,
            "order_status": true
        },
        "last_name": "Jam",
        "archived": false,
        "status": "pending",
        "first_name": "Vince",
        "created_at": {
            "_seconds": 1646389251,
            "_nanoseconds": 61000000
        },
        "updated_from": "",
        "birthdate": "",
        "updated_at": {
            "_seconds": 1646392939,
            "_nanoseconds": 101000000
        },
        "updated_by": "someUserId",
        "address": {
            "city": "Some City",
            "state": "NCR",
            "barangay": "",
            "zip_code": "1800",
            "subdivision": "Subdivision",
            "country": "ph",
            "street": "Scorpio"
        },
        "registration": {
            "step": 1,
            "notes": "",
            "id_photo": "somePhotoUrl",
            "verified": true,
            "id_type": "Driver's License"
        },
        "community_id": "someCommunityId"
    }
}
''';

const ok = '''
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

const missingKeys = '''
{
    "status": "ok",
    "data": {}
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

const list = '''
{
    "status": "ok",
    "data": [{
        "id": "someUserId",
        "_meta": {
            "product_subscription_plans_as_buyer_count": 1,
            "shops_count": 1,
            "activities_likes_count": 2,
            "orders_as_buyer_count": 2,
            "products_count": 1
        },
        "roles": {
            "admin": false,
            "member": true
        },
        "display_name": "Vince Jam",
        "chat_settings": {
            "show_read_receipts": false
        },
        "email": "someEmail",
        "user_uids": [
            "someUserUid"
        ],
        "notification_settings": {
            "tags": false,
            "order_status": true
        },
        "last_name": "Jam",
        "archived": false,
        "status": "pending",
        "first_name": "Vince",
        "created_at": {
            "_seconds": 1646389251,
            "_nanoseconds": 61000000
        },
        "updated_from": "",
        "birthdate": "",
        "updated_at": {
            "_seconds": 1646392939,
            "_nanoseconds": 101000000
        },
        "updated_by": "someUserId",
        "address": {
            "city": "Some City",
            "state": "NCR",
            "barangay": "",
            "zip_code": "1800",
            "subdivision": "Subdivision",
            "country": "ph",
            "street": "Scorpio"
        },
        "registration": {
            "step": 1,
            "notes": "",
            "id_photo": "somePhotoUrl",
            "verified": true,
            "id_type": "Driver's License"
        },
        "community_id": "someCommunityId"
    }]
}
''';

const missingKeysList = '''
{
    "status": "ok",
    "data": [{}]
}
''';
