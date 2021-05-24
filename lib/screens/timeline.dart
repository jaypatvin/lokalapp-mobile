import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/activity_feed.dart';
import 'package:lokalapp/utils/shared_preference.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import '../providers/activities.dart';
import '../providers/user.dart';
import '../providers/users.dart';
import 'expanded_card.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> with AfterLayoutMixin<Timeline> {
  int likeCount;
  Map<String, String> likes;
  bool isLiked;
  var _userSharedPreferences = UserSharedPreferences();
  @override
  void initState() {
    super.initState();
    var user = Provider.of<CurrentUser>(context, listen: false);
    Provider.of<Activities>(context, listen: false).fetch(user.idToken);
    _userSharedPreferences = UserSharedPreferences();
    _userSharedPreferences.init();
  }

  Row buildComments(ActivityFeed activityFeed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 230),
          child: IconButton(
            icon: Icon(Icons.messenger_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpandedCard(
                    activity: activityFeed,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Expanded buildHeader(String firstName, String lastName, String imgUrl) {
    return Expanded(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
        ),
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

  Row buildLikes(ActivityFeed activityFeed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
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
        buildComments(activityFeed)
      ],
    );
  }

  showAlert(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22),
        // contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          height: height * 0.3,
          width: width * 0.9,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            width: width * 0.9,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: width * 0.25,
                        child: Icon(
                          Icons.home_outlined,
                          size: 80,
                          color: Color(0xffCC3752),
                        ),
                      ),
                      Text(
                        "Home",
                        style: TextStyle(color: Color(0xffCC3752)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 15, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 30, right: 15, bottom: 5),
                            child: Text(
                              'The Home Tab is where you can',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 15, bottom: 5, top: 1),
                            child: Text(
                              'find posts, photos and updates',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'shared by the people in this' + " ",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 15, bottom: 5, top: 1),
                              child: Text(
                                'community or share some of yours! ',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 43,
                                  width: 180,
                                  child: FlatButton(
                                    color: kTealColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: kTealColor),
                                    ),
                                    textColor: kTealColor,
                                    child: Text(
                                      "Okay!",
                                      style: TextStyle(
                                          fontFamily: "Goldplay",
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    return Consumer2<Activities, Users>(
      builder: (ctx, activities, users, child) {
        return activities.isLoading || users.isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => activities.fetch(user.idToken),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: activities.feed.length,
                  itemBuilder: (context, index) {
                    var activity = activities.feed[index];
                    var communityUser = users.users.firstWhere(
                        (communityUser) => communityUser.id == activity.userId);
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                dense: true,
                                subtitle: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              buildHeader(
                                                communityUser.firstName,
                                                communityUser.lastName,
                                                communityUser.profilePhoto ??
                                                    '',
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 26),
                                              buildMessageBody(
                                                activity.message,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout

    _userSharedPreferences.isHome ? Container() : showAlert(context);
    setState(() {
      _userSharedPreferences.isHome = true;
    });
  }

  @override
  dispose() {
    _userSharedPreferences?.dispose();
    super.dispose();
  }
}
