const success = '''
{
    "status": "ok",
    "data": {
        "products": [
            {
                "gallery": [
                    {
                        "order": 0,
                        "url": "some_url"
                    }
                ],
                "updated_at": {
                    "_seconds": 1645701137,
                    "_nanoseconds": 382000000
                },
                "can_subscribe": false,
                "archived": false,
                "quantity": 127,
                "community_id": "someCommunityId",
                "description": "An all-in-one programmable device running on Debian distro.",
                "base_price": 4000,
                "name": "Pocket C.H.I.P.",
                "created_at": {
                    "_seconds": 1645687013,
                    "_nanoseconds": 743000000
                },
                "updated_from": "",
                "availability": {
                    "repeat_unit": 1,
                    "repeat_type": "week",
                    "start_time": "09:00 AM",
                    "start_dates": [
                        "2022-02-24",
                        "2022-02-25",
                        "2022-02-28",
                        "2022-03-01",
                        "2022-03-02"
                    ],
                    "schedule": {
                        "fri": {
                            "repeat_type": "week",
                            "repeat_unit": 1,
                            "start_date": "2022-02-25"
                        },
                        "thu": {
                            "start_date": "2022-02-24",
                            "repeat_type": "week",
                            "repeat_unit": 1
                        },
                        "wed": {
                            "repeat_type": "week",
                            "start_date": "2022-03-02",
                            "repeat_unit": 1
                        },
                        "tue": {
                            "repeat_type": "week",
                            "repeat_unit": 1,
                            "start_date": "2022-03-01"
                        },
                        "custom": {
                            "2022-03-31": {
                                "unavailable": true
                            },
                            "2022-03-28": {
                                "unavailable": true
                            },
                            "2022-03-29": {
                                "unavailable": true
                            },
                            "2022-04-01": {
                                "unavailable": true
                            },
                            "2022-03-30": {
                                "unavailable": true
                            }
                        },
                        "mon": {
                            "start_date": "2022-02-28",
                            "repeat_unit": 1,
                            "repeat_type": "week"
                        }
                    },
                    "end_time": "04:00 PM"
                },
                "user_id": "someUserId",
                "product_category": "home_goods",
                "shop_id": "someShopId",
                "status": "enabled",
                "_meta": {
                    "average_rating": 2.5,
                    "reviews_count": 1,
                    "likes_count": 2
                },
                "updated_by": "someUserId",
                "id": "someProductId"
            }
        ]
    }
}
''';

const emptyResult = '''
{
    "status": "ok"
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
