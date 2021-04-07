import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activities.dart';
import '../providers/user.dart';
import 'expanded_card.dart';

class UserTimeline extends StatefulWidget {
  @override
  _UserTimelineState createState() => _UserTimelineState();
}

class _UserTimelineState extends State<UserTimeline> {
  @override
  void initState() {
    super.initState();
    var user = Provider.of<CurrentUser>(context, listen: false);
    Provider.of<Activities>(context, listen: false).fetch(user.idToken);
  }

  Row buildComments(Map snapshot) {
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
                    activity: snapshot,
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

  Row buildLikes(Map snapshot) {
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
        buildComments(snapshot)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    return Consumer<Activities>(
      builder: (ctx, activities, child) {
        var _activities = activities.findByUser(user.id);
        return activities.isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => activities.fetch(user.idToken),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _activities.length,
                  itemBuilder: (context, index) {
                    var activity = _activities[index];
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
                                                user.firstName,
                                                user.lastName,
                                                user.profilePhoto ?? "",
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
                                          buildLikes(activity.toMap()),
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
}
