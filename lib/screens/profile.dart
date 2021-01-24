import 'package:flutter/material.dart';
import 'package:lokalapp/services/get_stream_api_service.dart';

class Profile extends StatefulWidget {
  final Map<String, String> account;
  Profile({Key key, @required this.account}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<List<dynamic>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = _getActivities();
  }

  Future<List<dynamic>> _getActivities() async {
    return await GetStreamApiService().getActivities(widget.account);
  }

  Future _refreshActivities() async {
    setState(() {
      _activities = _getActivities();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _activities,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          child: Center(
            child: RefreshIndicator(
              onRefresh: _refreshActivities,
              child: ListView(
                children: snapshot.data
                    .map((activity) => ListTile(
                          title: Text(activity['message']),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
