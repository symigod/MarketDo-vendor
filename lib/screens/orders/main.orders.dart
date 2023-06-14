import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/screens/orders/history.dart';
import 'package:marketdo_app_vendor/screens/orders/pending.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class OrderScreen extends StatefulWidget {
  static const String id = 'order-screen';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 0),
      body: const OrderCard());
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
              bottom: TabBar(
                  indicator: DotIndicator(
                      color: Colors.green.shade900,
                      distanceFromCenter: 16,
                      radius: 3,
                      paintingStyle: PaintingStyle.fill),
                  tabs: [
                    Tab(
                        child: Text('Pending',
                            style: TextStyle(color: Colors.green.shade900))),
                    Tab(
                        child: Text('History',
                            style: TextStyle(color: Colors.green.shade900)))
                  ])),
          body: const TabBarView(
              children: [PendingOrdersScreen(), OrderHistoryScreen()])));
}
