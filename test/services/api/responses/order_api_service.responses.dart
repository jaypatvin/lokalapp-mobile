const success = '''
{
    "status": "ok",
    "data": {
        "id": "orderId",
        "buyer_id": "buyerId",
        "delivery_option": "delivery",
        "community_id": "communityId",
        "status_code": 100,
        "seller_id": "sellerId",
        "product_ids": [
            "someProductId"
        ],
        "delivery_address": {
            "barangay": "",
            "state": "NCR",
            "zip_code": "1800",
            "city": "city",
            "subdivision": "some subdivision",
            "country": "ph",
            "street": "some street"
        },
        "shop_id": "shop id",
        "delivery_date": {
            "_seconds": 1648286455,
            "_nanoseconds": 940000000
        },
        "is_paid": false,
        "shop": {
            "name": "Shop Name",
            "description": "Some shop description",
            "image": "someImage"
        },
        "instruction": "",
        "created_at": {
            "_seconds": 1648198200,
            "_nanoseconds": 402000000
        },
        "products": [
            {
                "quantity": 2,
                "name": "LEDs",
                "image": "anotherImage",
                "description": "Light emitting diode.",
                "price": 5,
                "category": "home_goods",
                "id": "someProductId",
                "instruction": ""
            }
        ],
        "status_history": {
            "updated_at": {
                "_seconds": 1648198200,
                "_nanoseconds": 833000000
            },
            "after": 100,
            "before": 0
        }
    }
}
''';

const failure = '''
{
    "message": "Shop with id "E0cj7uzPtJoq9B3sHUSFF" not found",
    "status": "error",
    "code": "OrderApiError"
}
''';

const missingKey = '''
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

const error = '''
{
    "status": "error",
    "message": "some message",
    "data": {
        "_writeTime": {
            "_seconds": 1647934187,
            "_nanoseconds": 531935000
        }
    }
}
''';
