import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 2,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 15.0 / 26.5,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Card(
                        color: Colors.white,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 200.5,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://i1.wp.com/www.eva-bakes.com/wp-content/uploads/2020/04/camo-brownie2.jpg?w=550&ssl=1'),
                                          fit: BoxFit.fitWidth),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Camouflage Brownies",
                                            softWrap: true,
                                            style: TextStyle(
                                              fontFamily: "GoldplayBold",
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )))
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "525.00",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xffFF7A00),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                          "https://png.pngtree.com/png-clipart/20200720/original/pngtree-bakery-logo-design-polygon-png-image_4774193.jpg"),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Shop Name",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 45,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text("4.54",
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 14)),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
