const success = '''
{
    "status": "ok",
    "data": {
        "id": "someShopId",
        "updated_at": {
            "_seconds": 1646123578,
            "_nanoseconds": 835000000
        },
        "status": "enabled",
        "name": "Jay's Electronics Shop",
        "payment_options": [
            {
                "account_name": "Jay Jamero",
                "account_number": "1234567890",
                "type": "bank",
                "bank_code": "bdo"
            },
            {
                "account_name": "Jay Jamero",
                "bank_code": "bpi",
                "type": "bank",
                "account_number": "0123456789"
            },
            {
                "type": "wallet",
                "account_name": "Jay Jamero",
                "account_number": "09171234567",
                "bank_code": "gcash"
            },
            {
                "type": "wallet",
                "account_name": "Jay Jamero",
                "bank_code": "paymaya",
                "account_number": "09181234567"
            }
        ],
        "user_id": "someUserId",
        "description": "Shop your electronics here!",
        "is_close": false,
        "community_id": "someCommunityId",
        "updated_by": "someUserId",
        "profile_photo": "somePhotoUrl",
        "delivery_options": {
            "delivery": true,
            "pickup": true
        },
        "operating_hours": {
            "schedule": {
                "mon": {
                    "repeat_type": "week",
                    "start_date": "2022-02-28",
                    "repeat_unit": 1
                },
                "thu": {
                    "start_date": "2022-02-24",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                },
                "custom": {
                    "2022-03-28": {
                        "unavailable": true
                    },
                    "2022-03-29": {
                        "unavailable": true
                    },
                    "2022-03-30": {
                        "unavailable": true
                    },
                    "2022-04-01": {
                        "unavailable": true
                    },
                    "2022-03-31": {
                        "unavailable": true
                    }
                },
                "wed": {
                    "repeat_type": "week",
                    "repeat_unit": 1,
                    "start_date": "2022-03-02"
                },
                "fri": {
                    "start_date": "2022-02-25",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                },
                "tue": {
                    "start_date": "2022-03-01",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                }
            },
            "repeat_type": "week",
            "end_time": "04:00 PM",
            "start_dates": [
                "2022-02-24",
                "2022-02-25",
                "2022-02-28",
                "2022-03-01",
                "2022-03-02"
            ],
            "start_time": "09:00 AM",
            "repeat_unit": 1
        },
        "archived": false,
        "_meta": {
            "product_subscription_plans_count": 6,
            "orders_count": 8,
            "products_count": 5
        },
        "updated_from": "",
        "created_at": {
            "_seconds": 1645686703,
            "_nanoseconds": 614000000
        }
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

const list = '''
{
    "status": "ok",
    "data": [{
        "id": "someShopId",
        "updated_at": {
            "_seconds": 1646123578,
            "_nanoseconds": 835000000
        },
        "status": "enabled",
        "name": "Jay's Electronics Shop",
        "payment_options": [
            {
                "account_name": "Jay Jamero",
                "account_number": "1234567890",
                "type": "bank",
                "bank_code": "bdo"
            },
            {
                "account_name": "Jay Jamero",
                "bank_code": "bpi",
                "type": "bank",
                "account_number": "0123456789"
            },
            {
                "type": "wallet",
                "account_name": "Jay Jamero",
                "account_number": "09171234567",
                "bank_code": "gcash"
            },
            {
                "type": "wallet",
                "account_name": "Jay Jamero",
                "bank_code": "paymaya",
                "account_number": "09181234567"
            }
        ],
        "user_id": "someUserId",
        "description": "Shop your electronics here!",
        "is_close": false,
        "community_id": "someCommunityId",
        "updated_by": "someUserId",
        "profile_photo": "somePhotoUrl",
        "delivery_options": {
            "delivery": true,
            "pickup": true
        },
        "operating_hours": {
            "schedule": {
                "mon": {
                    "repeat_type": "week",
                    "start_date": "2022-02-28",
                    "repeat_unit": 1
                },
                "thu": {
                    "start_date": "2022-02-24",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                },
                "custom": {
                    "2022-03-28": {
                        "unavailable": true
                    },
                    "2022-03-29": {
                        "unavailable": true
                    },
                    "2022-03-30": {
                        "unavailable": true
                    },
                    "2022-04-01": {
                        "unavailable": true
                    },
                    "2022-03-31": {
                        "unavailable": true
                    }
                },
                "wed": {
                    "repeat_type": "week",
                    "repeat_unit": 1,
                    "start_date": "2022-03-02"
                },
                "fri": {
                    "start_date": "2022-02-25",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                },
                "tue": {
                    "start_date": "2022-03-01",
                    "repeat_unit": 1,
                    "repeat_type": "week"
                }
            },
            "repeat_type": "week",
            "end_time": "04:00 PM",
            "start_dates": [
                "2022-02-24",
                "2022-02-25",
                "2022-02-28",
                "2022-03-01",
                "2022-03-02"
            ],
            "start_time": "09:00 AM",
            "repeat_unit": 1
        },
        "archived": false,
        "_meta": {
            "product_subscription_plans_count": 6,
            "orders_count": 8,
            "products_count": 5
        },
        "updated_from": "",
        "created_at": {
            "_seconds": 1645686703,
            "_nanoseconds": 614000000
        }
    }]
}
''';

const missingKeysList = '''
{
    "status": "ok",
    "data": [{}]
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
