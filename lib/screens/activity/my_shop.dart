import 'package:flutter/material.dart';

import 'components/transaction_card.dart';

class MyShop extends StatefulWidget {
  @override
  _MyShopState createState() => _MyShopState();
}

class _MyShopState extends State<MyShop> {
  final Map<int, String> shopFilters = {
    0: 'All',
    1: 'For Confirmation',
    2: 'For Payment',
    3: 'For Delivery'
  };
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  tabLogic() {
    switch (selectedIndex) {
      case (0):
        {
          return Column(
            children: [
              TransactionCard(
                transactionState: 'Waiting for Confirmation',
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 'To Pay',
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                enableOtherButton: true,
                otherButtonText: 'Pay Now',
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 'For Devlivery',
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                enableOtherButton: true,
                otherButtonText: 'Pay Now',
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          );
        }
      case (1):
        {
          return TransactionCard(
            transactionState: 'Waiting for Confirmation',
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
          );
        }
        break;
      case (2):
        {
          return TransactionCard(
            transactionState: 'To Pay',
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            enableOtherButton: true,
            otherButtonText: 'Pay Now',
          );
        }
        break;
      case (3):
        {
          return TransactionCard(
            transactionState: 'For Devlivery',
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            enableOtherButton: true,
            otherButtonText: 'Pay Now',
          );
        }
        break;
      default:
        Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          color: Color(0xFF57183F),
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
            itemCount: shopFilters.length,
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
                      child: Text(shopFilters[index]),
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
            child: tabLogic(),
          ),
        ),
      ],
    );
  }
}
