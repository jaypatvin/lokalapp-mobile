import 'package:flutter/material.dart';

import 'package:lokalapp/services/database.dart';

class Timeline extends StatefulWidget {
  Timeline({Key key, @required this.account}) : super(key: key);

  final Map account;

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
    return await Database().getTimeline(widget.account);
  }

  Future _refreshActivities() async {
    setState(() {
      _activities = _getTimeline();
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
                          subtitle: Text(activity['actor']),
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