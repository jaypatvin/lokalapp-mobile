import 'package:flutter/material.dart';

import '../components/transaction_card.dart';

class MyShopSeller extends StatefulWidget {
  @override
  _MyShopSellerState createState() => _MyShopSellerState();
}

class _MyShopSellerState extends State<MyShopSeller> {
  final Map<int, String> shopFilters = {
    0: 'Past Order',
    1: 'Waiting for Payment',
    2: 'To Confirm',
    3: 'Payment Received',
    4: 'To Ship',
    5: 'Shipped Out',
    6: 'Declined Order'
  };
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  tabLogic() {
    switch (selectedIndex) {
      case 0:
        {
          return Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 0,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                // enableSecondButton: true,
                isBuyer: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 1,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                isBuyer: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 2,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                isBuyer: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 3,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                isBuyer: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 4,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                isBuyer: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 5,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                isBuyer: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TransactionCard(
                transactionState: 6,
                date: 'Mar 30',
                dealer: 'Bakey Bakey',
                transasctions: transactions,
                isBuyer: false,
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          );
        }
      case 1:
        {
          return TransactionCard(
            transactionState: 1,
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            isBuyer: false,
          );
        }
        break;
      case 2:
        {
          return TransactionCard(
            transactionState: 2,
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            isBuyer: false,
          );
        }
        break;
      case 3:
        {
          return TransactionCard(
            transactionState: 3,
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            isBuyer: false,
          );
        }
        break;
      case 4:
        {
          return TransactionCard(
            transactionState: 4,
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            isBuyer: false,
          );
        }
        break;
      case 5:
        {
          return TransactionCard(
            transactionState: 5,
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            isBuyer: false,
          );
        }
        break;
      case 6:
        {
          return TransactionCard(
            transactionState: 6,
            date: 'Mar 30',
            dealer: 'Bakey Bakey',
            transasctions: transactions,
            isBuyer: false,
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
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF57183F),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'These are the products you ordered from other stores.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Earnings",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "16,980,00.00",
                  style: TextStyle(color: Color(0XFFFF7A00)),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Items Sold",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "127",
                  style: TextStyle(color: Color(0XFFFF7A00)),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Most Popular",
                  style: TextStyle(color: Colors.white),
                ),
                // SizedBox(
                //   width: 15,
                // ),
                Text(
                  "Cheesecake Bars",
                  style: TextStyle(color: Color(0XFFFF7A00)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      SizedBox(
        height: 12,
      ),
      Container(
          height: 40,
          width: size.width,
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
          )),
      // SizedBox(height: 5.0),
      Container(
          height: size.height * 0.45,
          width: size.width,
          child: ListView(shrinkWrap: true, children: [
            SizedBox(
              height: 30,
            ),
            tabLogic()
          ])),
    ]));
  }
}
