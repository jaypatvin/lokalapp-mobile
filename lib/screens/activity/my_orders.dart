import 'package:flutter/material.dart';

import '../../utils/themes.dart';
import 'components/transaction_card.dart';

const Map<int, String> orderFilters = {
  0: 'All',
  1: 'For Confirmation',
  2: 'To Pay',
  3: 'For Delivery'
};

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          color: kTealColor,
          child: Text(
            'These are the products you ordered from other stores.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.03,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: orderFilters.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      selectedIndex = index;
                    }),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: selectedIndex == index
                            ? const Color(0xFFFFC700)
                            : const Color(0xFFEFEFEF),
                      ),
                      child: Text(orderFilters[index]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 10.0),
        // TODO: ADD LOGIC FOR selectedIndex
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TransactionCard(
                  transactionState: 1,
                  date: 'Mar 30',
                  dealer: 'Bakey Bakey',
                  transasctions: transactions,
                  isBuyer: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TransactionCard(
                  transactionState: 2,
                  date: 'Mar 30',
                  dealer: 'Bakey Bakey',
                  transasctions: transactions,
                  isBuyer: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TransactionCard(
                  transactionState: 3,
                  date: 'Mar 30',
                  dealer: 'Bakey Bakey',
                  transasctions: transactions,
                  isBuyer: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
