import 'package:flutter/material.dart';
// import 'package:lokalapp/models/user.dart';
// import 'package:lokalapp/screens/activity.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/services/database.dart';
// import 'package:lokalapp/states/currentUser.dart';
// import 'package:provider/provider.dart';
// import 'package:velocity_x/velocity_x.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  final Map<String, String> account;
  Timeline({Key key, this.account}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  Future<List<dynamic>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = _getTimeline();
  }

  Future<List<dynamic>> _getTimeline() async {
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    var stream = await _user.getStreamSignin();
    return await Database().getTimeline(stream);
  }

  Future _refreshActivities() async {
    setState(() {
      _activities = _getTimeline();
    });
    return null;
  }

  buildPostName() {
    CurrentUser _user = Provider.of<CurrentUser>(context);
    final userId = _user.getCurrentUser.userUids;
    String ownerId = userId.elementAt(0);
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Users user = Users.fromDocument(snapshot.data);
        return Text(user.firstName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _user = Provider.of<CurrentUser>(context);
    return FutureBuilder<List<dynamic>>(
      future: _activities,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: RefreshIndicator(
                  onRefresh: _refreshActivities,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data
                              .map(
                                (activity) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          //  title: Text(activity["message"]),
                                          subtitle: Column(
                                            children: [
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: ListTile(
                                                            leading:
                                                                CircleAvatar(),
                                                            // title: buildPostName(),
                                                            title: Text(_user
                                                                    .getCurrentUser
                                                                    .firstName +
                                                                "" +
                                                                _user
                                                                    .getCurrentUser
                                                                    .lastName),
                                                            trailing: Icon(Icons
                                                                .more_horiz),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                        mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            activity["message"])
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                // ),
                                // ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ))),
        );
      },
    );
  }
}
