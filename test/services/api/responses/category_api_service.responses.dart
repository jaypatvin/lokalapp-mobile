const successResponse = '''
{
    "status": "ok",
    "data": {
        "id": "dessert_pastries",
        "icon_url": "",
        "cover_url": "",
        "created_at": {
            "_seconds": 1634140800,
            "_nanoseconds": 0
        },
        "archived": false,
        "description": "sweets",
        "updated_at": {
            "_seconds": 1634140800,
            "_nanoseconds": 0
        },
        "name": "Desserts & Pastries",
        "status": "enabled"
    }
}
''';

const errorResponse = '''
{
   "message":"Category with id "dessert_pastry" not found",
   "status":"error",
   "code":"CategoryApiError"
}
''';

const successMissingResponse = '''
{
    "status": "ok",
    "data": {
        "icon_url": "",
        "cover_url": "",
        "archived": false,
        "description": "sweets",
        "name": "Desserts & Pastries",
        "status": "enabled"
    }
}
''';

const successListResponse = '''
{
    "status": "ok",
    "data": [
        {
            "id": "dessert_pastries",
            "cover_url": "",
            "description": "sweets",
            "icon_url": "",
            "name": "Desserts & Pastries",
            "updated_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "status": "enabled",
            "created_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "archived": false
        },
        {
            "id": "drinks",
            "status": "enabled",
            "name": "Drinks",
            "cover_url": "",
            "icon_url": "",
            "archived": false,
            "udated_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "description": "description of the drinks",
            "created_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            }
        },
        {
            "id": "fashion",
            "created_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "status": "enabled",
            "description": "clothes",
            "updated_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "name": "Fashion",
            "icon_url": "",
            "archived": false,
            "cover_url": ""
        },
        {
            "id": "food",
            "cover_url": "",
            "updated_at": {
                "_seconds": 1616342400,
                "_nanoseconds": 0
            },
            "created_at": {
                "_seconds": 1616342400,
                "_nanoseconds": 0
            },
            "icon_url": "",
            "name": "Food",
            "status": "enabled",
            "description": "Food",
            "archived": false
        },
        {
            "id": "home_goods",
            "icon_url": "",
            "name": "Home Goods",
            "archived": false,
            "updated_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "created_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "status": "enabled",
            "cover_url": "",
            "description": "beds and things"
        },
        {
            "id": "meals_snacks",
            "updated_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "name": "Meals & Snacks",
            "icon_url": "",
            "status": "enabled",
            "created_at": {
                "_seconds": 1634140800,
                "_nanoseconds": 0
            },
            "archived": false,
            "description": "lunch foods",
            "cover_url": ""
        }
    ]
}
''';

const successMissingListResponse = '''
{
    "status": "ok",
    "data": [
        {
            "cover_url": "",
            "description": "sweets",
            "icon_url": "",
            "name": "Desserts & Pastries",
            "status": "enabled",
            "archived": false
        }
    ]
}
''';
