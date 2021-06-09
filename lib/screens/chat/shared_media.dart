import 'package:flutter/material.dart';

class SharedMedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("Shared Media",
              style: TextStyle(
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white30,
            child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: <String>[
                  //dummy data
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.8JupcLPN_V7YSuIiPM58KwHaFK%26pid%3DApi&f=1',
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.3WZEfqTHJv3UAA9F0ZpfrwHaD5%26pid%3DApi&f=1',
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.8JupcLPN_V7YSuIiPM58KwHaFK%26pid%3DApi&f=1',
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.3WZEfqTHJv3UAA9F0ZpfrwHaD5%26pid%3DApi&f=1'
                ].map((String url) {
                  return GridTile(child: Image.network(url, fit: BoxFit.cover));
                }).toList()),
          )
        ])));
  }
}
