import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../providers/cart.dart';
import '../../providers/pull_up_cart_state.dart';
import '../../utils/themes.dart';
import 'cart_action_detector.dart';
import 'pull_up_panel.dart';
import 'pull_up_panel_header.dart';

class SlidingUpCart extends StatefulWidget {
  final Widget child;

  SlidingUpCart({
    @required this.child,
  });

  @override
  _SlidingUpCartState createState() => _SlidingUpCartState();
}

class _SlidingUpCartState extends State<SlidingUpCart> {
  final PanelController _panelController = PanelController();
  bool isPanelClosed = true;

  void hidePanel() async {
    if (isPanelClosed) {
      Provider.of<PullUpCartState>(context, listen: false)
          .setPanelVisibility(false);
    }
  }

  void showPanel() async {
    if (isPanelClosed) {
      Provider.of<PullUpCartState>(context, listen: false)
          .setPanelVisibility(true);
      _panelController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ShoppingCart, PullUpCartState>(
        builder: (context, cart, cartState, _) {
      bool renderLongPanel = cart.items.length >= 5;
      bool isPanelVisible = cartState.isPanelVisible;
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            controller: _panelController,
            renderPanelSheet: renderLongPanel ? false : true,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            border:
                renderLongPanel ? null : Border.all(color: Color(0xFFFF7A00)),
            maxHeight: MediaQuery.of(context).size.height * .80,
            minHeight: cart.items.length > 0 && isPanelVisible ? 100.0 : 0.0,
            // we use header to have a consistent Cart Action Detection
            header: Visibility(
              visible: isPanelClosed,
              child: CartActionDetector(
                child: PullUpPanelHeader(),
                onTap: showPanel,
                onDoubleTap: hidePanel,
                onSwipeDown: hidePanel,
                onSwipeUp: () {},
              ),
            ),
            panelBuilder: (sc) => PullUpPanel(
              scrollController: sc,
              renderBorder: renderLongPanel,
            ),
            backdropEnabled: true,
            borderRadius: renderLongPanel
                ? null
                : BorderRadius.only(
                    topLeft: Radius.circular(38.0),
                    topRight: Radius.circular(38.0),
                  ),
            onPanelOpened: () => setState(() {
              isPanelClosed = false;
            }),
            onPanelClosed: () => setState(() {
              isPanelClosed = true;
            }),
            body: widget.child,
          ),
          Visibility(
            visible: !isPanelVisible,
            child: Positioned(
              right: 20.0,
              bottom: 20.0,
              child: FloatingActionButton(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: kTealColor,
                ),
                backgroundColor: Color(0xFFFF7A00),
                onPressed: () {
                  showPanel();
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
