import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/order_service.dart';
import '../../models/order_model.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();

  void _showRatingDialog(BuildContext context, String orderId) {
    int _selectedRating = 5;
    TextEditingController _reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate Your Order'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(hintText: 'Leave a brief review (optional)'),
                    maxLines: 2,
                  )
                ],
              );
            }
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _orderService.submitOrderRating(orderId, _selectedRating, _reviewController.text);
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rating submitted!')));
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Submit'),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthViewModel>().user?.uid;
    if (userId == null) return const Scaffold(body: Center(child: Text("Not logged in")));

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getUserOrdersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No orders yet.'));

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final isCompleted = order.status == 'completed';
              final isRated = order.rating != null;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('Order: \$${order.totalAmount.toStringAsFixed(2)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items: ${order.items.map((i) => "${i.quantity}x ${i.name}").join(', ')}'),
                      Text('Status: ${order.status.toUpperCase()}'),
                      if (isRated) Text('Rating: ${order.rating} stars - "${order.review ?? ''}"')
                    ],
                  ),
                  trailing: (isCompleted && !isRated) 
                    ? ElevatedButton(
                        onPressed: () => _showRatingDialog(context, order.id),
                        child: const Text('Rate'),
                      )
                    : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
