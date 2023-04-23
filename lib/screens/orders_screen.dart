import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnaphot) {
          if (dataSnaphot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnaphot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (context, index) =>
                            OrderItem(orderData.orders[index]),
                        itemCount: orderData.orders.length,
                      ));
          }
        },
      ),
    );
  }
}
