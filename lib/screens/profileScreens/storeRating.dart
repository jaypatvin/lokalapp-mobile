import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';

class StoreRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(13),
                    child: RatingBar(
                      rating: 4,
                      icon: Icon(
                        Icons.star,
                        size: 23,
                        color: Colors.grey.shade300,
                      ),
                      starCount: 5,
                      spacing: 12.0,
                      size: 1,
                      isIndicator: true,
                      allowHalfRating: true,
                      onRatingCallback:
                          (double value, ValueNotifier<bool> isIndicator) {
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
                  );
  }
}