import 'package:flutter/material.dart';

import '../states/current_user.dart';
import 'package:provider/provider.dart';
import 'expanded_card.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  Future<List<dynamic>> _activities;
  int likeCount;
  Map<String, String> likes;
  bool isLiked;

  CurrentUser _user;

  @override
  void initState() {
    super.initState();
    this._user = Provider.of<CurrentUser>(context, listen: false);
    _activities = _user.getTimeline();
  }

  Future<void> _refreshActivities() async {
    setState(() {
      _activities = _user.getTimeline();
    });
  }

  Row buildComments(Map snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 240),
          child: IconButton(
              icon: Icon(Icons.messenger_outline),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpandedCard(
                              activity: snapshot,
                            )));
              }),
        ),
      ],
    );
  }

  Expanded buildHeader(String firstName, String lastName) {
    return Expanded(
      child: ListTile(
        leading: CircleAvatar(),
        title: Text(
          firstName + " " + lastName,
          style: TextStyle(
              fontFamily: "GoldplayAltBoldIt",
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.more_horiz),
      ),
    );
  }

  Expanded buildMessageBody(String message) {
    return Expanded(
      child: Text(
        message,
        style: TextStyle(fontFamily: "GoldplayBold", fontSize: 16),
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  Row buildLikes(Map snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(
              Icons.favorite_border,
              // color: Colors.pink,
            ),
            onPressed: null,
            // handleLikePost()
          ),
        ),
        Text("5"),
        buildComments(snapshot)
      ],
    );
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
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ListTile(
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
                                                    SizedBox(
                                                      height: 10,
                                                      // width: 30,
                                                    ),
                                                    Row(
                                                      children: [
                                                        buildHeader(
                                                            _user.firstName,
                                                            _user.lastName)
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      // mainAxisSize:
                                                      //     MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 26,
                                                        ),
                                                        buildMessageBody(
                                                            activity[
                                                                "message"]),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                      indent: 25,
                                                      endIndent: 25,
                                                    ),
                                                    buildLikes(activity),
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
