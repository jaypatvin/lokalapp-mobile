const dates = '''
{
    "status": "ok",
    "data": [
        "2022-04-04",
        "2022-04-11",
        "2022-04-18",
        "2022-04-25",
        "2022-05-02",
        "2022-05-09",
        "2022-05-16"
    ]
}
''';

const emptyDate = '''
{
    "status": "ok",
    "data": []
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

const plan = '''
{
    "status": "ok",
    "data": {
        "buyer_id": "someUserId",
        "shop": {
            "description": "Shop your electronics here!",
            "image": "someUrl",
            "name": "Jay's Electronics Shop"
        },
        "payment_method": "cod",
        "community_id": "someCommunityId",
        "created_at": {
            "_seconds": 1649063706,
            "_nanoseconds": 77000000
        },
        "plan": {
            "repeat_unit": 1,
            "last_date": "",
            "repeat_type": "week",
            "start_dates": [
                "2022-04-11"
            ],
            "auto_reschedule": false,
            "schedule": {
                "mon": {
                    "start_date": "2022-04-11"
                }
            }
        },
        "status": "disabled",
        "archived": false,
        "product_id": "someProductId",
        "shop_id": "someShopId",
        "instruction": "",
        "quantity": 1,
        "seller_id": "someSellerId",
        "product": {
            "image": "someUrl",
            "price": 5,
            "description": "Light emitting diode.",
            "name": "LEDs"
        },
        "id": "someOrderId"
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
