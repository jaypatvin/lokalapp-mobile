import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StoreRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          // child: RatingBar(
          //   rating: 4,
          //   icon: Icon(
          //     Icons.star,
          //     size: 20,
          //     color: Colors.grey.shade300,
          //   ),
          //   starCount: 5,
          //   spacing: 12.0,
          //   size: 1,
          //   isIndicator: true,
          //   allowHalfRating: true,
          //   onRatingCallback: (double value, ValueNotifier<bool> isIndicator) {
          //     print('Number of stars-->  $value');
          //     //change the isIndicator from false  to true ,the RatingBar cannot support touch event;
          //     isIndicator.value = true;
          //   },
          //   clickedCallbackAsIndicator: () {
          //     // when isIndicator is true ,user click the stars, this callback can be called.
          //     print('clickedMe');
          //   },
          //   color: Colors.amber,
          // ),
          child: RatingBar.builder(
            initialRating: 4.5,
            minRating: 1,
            maxRating: 5,
            allowHalfRating: true,
            unratedColor: Colors.grey.shade300,
            itemBuilder: (ctx, _) {
              return Icon(
                Icons.star,
                color: Colors.amber,
              );
            },
            onRatingUpdate: (rating) {
              debugPrint(rating.toString());
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "4.5",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber),
          ),
        )
      ],
    );
  }
}
