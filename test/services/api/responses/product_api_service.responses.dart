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

const product = '''
{
    "status": "ok",
    "data": {
        "id": "someProductId",
        "product_category": "home_goods",
        "community_id": "someCommunityId",
        "gallery": [
            {
                "order": 0,
                "url": "someImageUrl"
            }
        ],
        "updated_from": "",
        "shop_id": "someShopId",
        "archived": false,
        "quantity": 127,
        "description": "An all-in-one programmable device running on Debian distro.",
        "can_subscribe": false,
        "created_at": {
            "_seconds": 1645687013,
            "_nanoseconds": 743000000
        },
        "_meta": {
            "likes_count": 2,
            "reviews_count": 1,
            "average_rating": 2.5
        },
        "updated_at": {
            "_seconds": 1645701137,
            "_nanoseconds": 382000000
        },
        "updated_by": "someUserId",
        "status": "enabled",
        "availability": {
            "end_time": "04:00 PM",
            "start_time": "09:00 AM",
            "start_dates": [
                "2022-02-24",
                "2022-02-25",
                "2022-02-28",
                "2022-03-01",
                "2022-03-02"
            ],
            "repeat_unit": 1,
            "schedule": {
                "wed": {
                    "start_date": "2022-03-02",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                },
                "fri": {
                    "repeat_unit": 1,
                    "repeat_type": "week",
                    "start_date": "2022-02-25"
                },
                "thu": {
                    "start_date": "2022-02-24",
                    "repeat_type": "week",
                    "repeat_unit": 1
                },
                "custom": {
                    "2022-04-01": {
                        "unavailable": true
                    },
                    "2022-03-31": {
                        "unavailable": true
                    },
                    "2022-03-28": {
                        "unavailable": true
                    },
                    "2022-03-29": {
                        "unavailable": true
                    },
                    "2022-03-30": {
                        "unavailable": true
                    }
                },
                "mon": {
                    "repeat_unit": 1,
                    "start_date": "2022-02-28",
                    "repeat_type": "week"
                },
                "tue": {
                    "start_date": "2022-03-01",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                }
            },
            "repeat_type": "week"
        },
        "name": "Pocket C.H.I.P.",
        "user_id": "someUserId",
        "base_price": 4000
    }
}
''';

const list = '''
{
    "status": "ok",
    "data": [{
        "id": "someProductId",
        "product_category": "home_goods",
        "community_id": "someCommunityId",
        "gallery": [
            {
                "order": 0,
                "url": "someImageUrl"
            }
        ],
        "updated_from": "",
        "shop_id": "someShopId",
        "archived": false,
        "quantity": 127,
        "description": "An all-in-one programmable device running on Debian distro.",
        "can_subscribe": false,
        "created_at": {
            "_seconds": 1645687013,
            "_nanoseconds": 743000000
        },
        "_meta": {
            "likes_count": 2,
            "reviews_count": 1,
            "average_rating": 2.5
        },
        "updated_at": {
            "_seconds": 1645701137,
            "_nanoseconds": 382000000
        },
        "updated_by": "someUserId",
        "status": "enabled",
        "availability": {
            "end_time": "04:00 PM",
            "start_time": "09:00 AM",
            "start_dates": [
                "2022-02-24",
                "2022-02-25",
                "2022-02-28",
                "2022-03-01",
                "2022-03-02"
            ],
            "repeat_unit": 1,
            "schedule": {
                "wed": {
                    "start_date": "2022-03-02",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                },
                "fri": {
                    "repeat_unit": 1,
                    "repeat_type": "week",
                    "start_date": "2022-02-25"
                },
                "thu": {
                    "start_date": "2022-02-24",
                    "repeat_type": "week",
                    "repeat_unit": 1
                },
                "custom": {
                    "2022-04-01": {
                        "unavailable": true
                    },
                    "2022-03-31": {
                        "unavailable": true
                    },
                    "2022-03-28": {
                        "unavailable": true
                    },
                    "2022-03-29": {
                        "unavailable": true
                    },
                    "2022-03-30": {
                        "unavailable": true
                    }
                },
                "mon": {
                    "repeat_unit": 1,
                    "start_date": "2022-02-28",
                    "repeat_type": "week"
                },
                "tue": {
                    "start_date": "2022-03-01",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                }
            },
            "repeat_type": "week"
        },
        "name": "Pocket C.H.I.P.",
        "user_id": "someUserId",
        "base_price": 4000
    }]
}
''';

const missingKeysList = '''
{
    "status": "ok",
    "data": [{}]
}
''';

const missingKeys = '''
{
    "status": "ok",
    "data": {}
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

const operatingHours = '''
{
    "status": "ok",
    "data": {
        "start_time": "09:00 AM",
        "end_time": "04:00 PM",
        "repeat_type": "week",
        "repeat_unit": 1,
        "start_dates": [
            "2022-02-24",
            "2022-02-25",
            "2022-02-28",
            "2022-03-01",
            "2022-03-02"
        ],
        "schedule": {
            "custom": {
                "2022-03-28": {
                    "unavailable": true
                },
                "2022-03-31": {
                    "unavailable": true
                },
                "2022-03-30": {
                    "unavailable": true
                },
                "2022-03-29": {
                    "unavailable": true
                },
                "2022-04-01": {
                    "unavailable": true
                }
            },
            "mon": {
                "repeat_unit": 1,
                "repeat_type": "week",
                "start_date": "2022-02-28"
            },
            "wed": {
                "repeat_unit": 1,
                "repeat_type": "week",
                "start_date": "2022-03-02"
            },
            "tue": {
                "repeat_type": "week",
                "repeat_unit": 1,
                "start_date": "2022-03-01"
            },
            "thu": {
                "repeat_unit": 1,
                "start_date": "2022-02-24",
                "repeat_type": "week"
            },
            "fri": {
                "start_date": "2022-02-25",
                "repeat_type": "week",
                "repeat_unit": 1
            }
        },
        "unavailable_dates": [
            "2022-03-28",
            "2022-03-31",
            "2022-03-30",
            "2022-03-29",
            "2022-04-01"
        ]
    }
}
''';

const missingKeysOperatingHours = '''
{
    "status": "ok",
    "data": {}
}
''';
