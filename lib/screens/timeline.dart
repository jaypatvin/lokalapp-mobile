import 'package:flutter/material.dart';

import 'package:lokalapp/services/get_stream_api_service.dart';

import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';
import 'expandedCard.dart';

class Timeline extends StatefulWidget {
  final Map<String, String> account;
  final Map <dynamic, dynamic> snapshot;
  Timeline({Key key, this.account, this.snapshot}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  Future<List<dynamic>> _activities;
  Future<List> _users;
  int likeCount;
  Map <String, String>likes;
  bool isLiked;

  @override
  void initState() {
    super.initState();
    _activities = _getTimeline();
    // _users = GetStreamApiService().users(widget.account);
  }

  Future<List<dynamic>> _getTimeline() async {
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    var stream = _user.getStreamAccount;

    return await GetStreamApiService().getTimeline(stream);
  }

// Future<int>  handleLikePost()async{
//     bool _isLiked = false;

//     if (_isLiked) {

//       setState(() {
//         likeCount -= 1;
//         isLiked = false;

//       String user =  likes[widget.account["user"]];
//       if(user != null){
        
//       }
//       });
//       await  GetStreamApiService().postLikes(widget.account, likeCount.toString());
//     } else if (!_isLiked) {

//       setState(() {
//         likeCount += 1;
//         isLiked = true;

//         likes[widget.account["user"]] = true;
//       });
//       await  GetStreamApiService().postLikes(widget.account, likeCount.toString() ) ;
//     }

//   }

  Future _refreshActivities() async {
    setState(() {
      _activities = _getTimeline();
    });
    return null;
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
                              account: widget.account,
                              snapshot:snapshot,
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
    CurrentUser _user = Provider.of<CurrentUser>(context);
    // var stream =  _user.getStreamAccount;
  

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
                                                      BorderRadius.circular(16.0),
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
                                                            _user.getCurrentUser
                                                                .firstName,
                                                            _user.getCurrentUser
                                                                .lastName)
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      // mainAxisSize:
                                                      //     MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 26,
                                                        ),
                                                        buildMessageBody(
                                                            activity["message"]),
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
//  FutureBuilder<List>(
//                                           future: _users,
//                                           builder: (BuildContext context,
//                                               AsyncSnapshot<List> snapshot) {

//                                             return ListView(
//                                                 scrollDirection: Axis.vertical,
//                                                 shrinkWrap: true,
//                                                 children: snapshot.data
//                                                     .where((u) =>
//                                                         u !=
//                                                         widget.account['user'])
//                                                     .map((u) => ListTile(
//                                                           title: (u),
//                                                           subtitle: getFollowers(),
//                                                         ))
//                                                     .toList());
//                                           })
