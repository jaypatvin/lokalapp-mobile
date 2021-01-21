import 'package:flutter/material.dart';
// import 'package:lokalapp/models/user.dart';
// import 'package:lokalapp/screens/activity.dart';

import 'package:lokalapp/services/database.dart';
// import 'package:lokalapp/states/currentUser.dart';
// import 'package:provider/provider.dart';
// import 'package:velocity_x/velocity_x.dart';

class Timeline extends StatefulWidget {
  final Map<String, String> account;
  Timeline({Key key,  this.account});

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
    // return await Database().getTimeline(widget.account);
  }

  Future _refreshActivities() async {
    setState(() {
      _activities = _getTimeline();
    });
    return null;
  }

// buildPostName(){
//     CurrentUser _user = Provider.of<CurrentUser>(context);
//      final userId = _user.getCurrentUser.userUids;
//      String ownerId = userId.elementAt(0);
//   return FutureBuilder(
//     future: usersRef.doc(ownerId).get(),
//     builder: (context, snapshot){
//       if(!snapshot.hasData){
//         return CircularProgressIndicator();
//       }
//       Users user = Users.fromDocument(snapshot.data);
//       return Text(user.firstName);
//     },
//   );
// }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _activities,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: RefreshIndicator(
                  onRefresh: _refreshActivities,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        children: snapshot.data
                            .map((activity) => Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    subtitle: Container(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        //  margin: EdgeInsets.all(20.0),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 16),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  leading: CircleAvatar(),
                                                  // title:
                                                  // buildPostName(),
                                                  trailing:
                                                      Icon(Icons.more_horiz),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          top: 10,
                                                          right: 16),
                                                      child: Column(
                                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                                activity[
                                                                    "message"]),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Divider(
                                                            color: Colors.grey,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .favorite)
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList()),
                  ),
                ),
              )),
        );
      },
    );
  }
}
