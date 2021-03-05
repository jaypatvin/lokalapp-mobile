import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';

class StoreRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          child: RatingBar(
            rating: 4,
            icon: Icon(
              Icons.star,
              size: 20,
              color: Colors.grey.shade300,
            ),
            starCount: 5,
            spacing: 12.0,
            size: 1,
            isIndicator: true,
            allowHalfRating: true,
            onRatingCallback: (double value, ValueNotifier<bool> isIndicator) {
              print('Number of stars-->  $value');
              //change the isIndicator from false  to true ,the RatingBar cannot support touch event;
              isIndicator.value = true;
            },
            clickedCallbackAsIndicator: () {
              // when isIndicator is true ,user click the stars, this callback can be called.
              print('clickedMe');
            },
            color: Colors.amber,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "4.45",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber),
          ),
        )
      ],
    );
  }
}
