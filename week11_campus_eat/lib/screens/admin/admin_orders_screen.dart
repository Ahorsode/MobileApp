import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../models/order_model.dart';

class AdminOrdersScreen extends StatelessWidget {
  AdminOrdersScreen({super.key});
  
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderModel>>(
      stream: _orderService.getAllOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No orders found.'));

        final orders = snapshot.data!;
        
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final itemsStr = order.items.map((i) => "${i.quantity}x ${i.name}").join(', ');

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                    Text('Items: $itemsStr'),
                  ],
                ),
                trailing: DropdownButton<String>(
                  value: order.status.toLowerCase(),
                  items: <String>['pending', 'preparing', 'ready', 'completed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != order.status) {
                      _orderService.updateOrderStatus(order.id, newValue);
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
