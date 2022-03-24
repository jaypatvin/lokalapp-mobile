const successResponse = '''
{
    "status": "ok",
    "data": {
        "id": "some_community_id",
        "name": "some_community_name",
        "profile_photo": "some_profile_photo",
        "_meta": {
            "orders_count": 15,
            "products_count": 17,
            "product_subscription_plans_count": 8,
            "users_count": 7,
            "shops_count": 6
        },
        "archived": false,
        "updated_at": {
            "_seconds": 1614179772,
            "_nanoseconds": 598000000
        },
        "admin": [
            "user_id_1",
            "user_id_2"
        ],
        "created_at": {
            "_seconds": 1612108800,
            "_nanoseconds": 0
        },
        "cover_photo": "",
        "address": {
            "state": "NCR",
            "zip_code": "1234",
            "city": "Marikina",
            "subdivision": "Some Subd.",
            "barangay": "",
            "country": "ph"
        }
    }
}
''';

const missingKeyResponse = '''
{
    "status": "ok",
    "data": {
        "name": "some_community_name",
        "profile_photo": "some_profile_photo",
        "_meta": {
            "orders_count": 15,
            "products_count": 17,
            "product_subscription_plans_count": 8,
            "users_count": 7,
            "shops_count": 6
        },
        "archived": false,
        "updated_at": {
            "_seconds": 1614179772,
            "_nanoseconds": 598000000
        },
        "admin": [
            "user_id_1",
            "user_id_2"
        ],
        "created_at": {
            "_seconds": 1612108800,
            "_nanoseconds": 0
        },
        "cover_photo": "",
        "address": {
            "state": "NCR",
            "zip_code": "1234",
            "city": "Marikina",
            "subdivision": "Some Subd.",
            "barangay": "",
            "country": "ph"
        }
    }
}
''';

const error404 = '''
{
  "status": "error",
  "message": "Community does not exist!"
}
''';
