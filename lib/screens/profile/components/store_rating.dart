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
