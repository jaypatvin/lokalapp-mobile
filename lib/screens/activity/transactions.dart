import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/database.dart';
import '../../utils/themes.dart';
import 'components/grouped_orders.dart';

class Transactions extends StatefulWidget {
  final Map<int, String> statuses;
  final bool isBuyer;
  const Transactions(this.statuses, this.isBuyer);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int selectedIndex;
  final statuses = <int, String>{};
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    this.initializeStatuses();
    this.selectedIndex = this.statuses.keys.toList().first;
    final currentUser = Provider.of<CurrentUser>(context, listen: false);

    // We can probably get all the streams for all statuses here in initState
    // to avoid rebuilding and reconnecting to Firestore.
    // The all streams approach will also help in the notification for each
    // new order progress of order.

    // Another way is to already filter the current stream of ALL
    // and add a listener for every new entry in the stream, add a logic
    // to determine which status it is

    if (widget.isBuyer) {
      _stream = Database.instance.getUserOrders(currentUser.id);
    } else {
      final shop = Provider.of<Shops>(context, listen: false)
          .findByUser(currentUser.id)
          .first;
      _stream = Database.instance.getShopOrders(shop.id);
    }
  }

  void initializeStatuses() {
    final _statusCodes = widget.statuses.keys.toList().map((key) {
      if (key == 10 || key == 20) {
        // We're multiplying statuses 10 and 20 (cancelled & declined orders)
        // by 100 to put them in the bottom of the list (after sorting).
        // This will make it easier to display each statuses as filters on top
        // from the most urgent to the least
        key *= 100;
      }
      return key;
    }).toList()
      ..sort();

    this.statuses[0] = "All";
    _statusCodes.forEach((code) {
      // Reverse the multiplication from above to get the correct string value
      // from the firestore collection of statuses
      final _key = (code == 1000 || code == 2000) ? code ~/ 100 : code;
      this.statuses[code] = widget.statuses[_key];
    });
  }

  void changeIndex(int key) {
    if (key == this.selectedIndex) return;

    final userId = Provider.of<CurrentUser>(context, listen: false).id;
    // Revert the multiplication
    final statusCode = (key == 1000 || key == 2000) ? key ~/ 100 : key;

    setState(() {
      // As stated in the initState(), we can probably load all streams
      // and change the display to the corresponding stream.

      this.selectedIndex = key;
      if (widget.isBuyer) {
        _stream = Database.instance.getUserOrders(
          userId,
          statusCode: statusCode == 0 ? null : statusCode,
        );
      } else {
        final shop =
            Provider.of<Shops>(context, listen: false).findByUser(userId).first;
        _stream = Database.instance.getShopOrders(
          shop.id,
          statusCode: statusCode == 0 ? null : statusCode,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          color: widget.isBuyer ? kTealColor : Color(0xFF57183F),
          child: Text(
            widget.isBuyer
                ? 'These are the products you ordered from other stores.'
                : 'These are the products other people ordered from your stores.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.04,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: this.statuses.length,
            itemBuilder: (context, index) {
              final key = this.statuses.keys.elementAt(index);
              return GestureDetector(
                onTap: () => changeIndex(key),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: selectedIndex == key
                        ? const Color(0xFFFFC700)
                        : const Color(0xFFEFEFEF),
                  ),
                  child: Text(this.statuses[key]),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GroupedOrders(
              this._stream,
              widget.statuses,
              widget.isBuyer,
            ),
          ),
        ),
      ],
    );
  }
}
