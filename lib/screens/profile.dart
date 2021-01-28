import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import '../services/get_stream_api_service.dart';
import '../states/current_user.dart';
import 'package:provider/provider.dart';

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

        return SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    Provider.of<CurrentUser>(context, listen: false)
                        .onSignOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                        (route) => false);
                  },
                  child: Text("logout"),
                ),
                Expanded(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
