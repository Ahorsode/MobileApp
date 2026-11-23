import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../services/order_service.dart';
import '../../models/order_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../theme/app_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();

  void _showRatingDialog(BuildContext context, String orderId) {
    int selectedRating = 5;
    TextEditingController reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 24),
                  Text('Rate Your Experience', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text('How was your food and service?', style: TextStyle(color: Colors.grey.shade500)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 40,
                        icon: Icon(
                          index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: index < selectedRating ? AppTheme.secondary : Colors.grey.shade300,
                        ),
                        onPressed: () => setState(() => selectedRating = index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: reviewController,
                    decoration: const InputDecoration(
                      hintText: 'Share your thoughts (optional)',
                      prefixIcon: Icon(Icons.rate_review_rounded),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          await _orderService.submitOrderRating(orderId, selectedRating, reviewController.text);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Thank you for your rating!'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      },
                      child: const Text('Submit Rating'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = context.read<AuthViewModel>().currentUser?.uid;
    if (userId == null) return const Scaffold(body: Center(child: Text("Not logged in")));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.primary,
            title: const Text('Order History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<List<OrderModel>>(
            stream: _orderService.getUserOrdersStream(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error loading orders', style: TextStyle(color: Colors.grey.shade400))),
                );
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey.shade200),
                        const SizedBox(height: 16),
                        Text('No orders yet', style: TextStyle(color: Colors.grey.shade400, fontSize: 18)),
                      ],
                    ),
                  ),
                );
              }

              final orders = snapshot.data!;

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = orders[index];
                      return _buildOrderCard(context, order, theme);
                    },
                    childCount: orders.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, ThemeData theme) {
    final isCompleted = order.status == 'completed';
    final isRated = order.rating != null;
    final dateStr = DateFormat('MMM dd, yyyy • hh:mm a').format(order.timestamp ?? DateTime.now());

    Color statusColor = Colors.orange;
    if (order.status == 'completed') statusColor = Colors.green;
    if (order.status == 'cancelled') statusColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateStr, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.quantity}x ${item.name}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                )).toList(),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.primary)),
                  ],
                ),
                if (isRated) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppTheme.secondary, size: 18),
                        const SizedBox(width: 8),
                        Text('${order.rating} stars', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (order.review != null && order.review!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Expanded(child: Text('"${order.review}"', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontSize: 13))),
                        ],
                      ],
                    ),
                  ),
                ],
                if (isCompleted && !isRated) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _showRatingDialog(context, order.id),
                      icon: const Icon(Icons.star_outline_rounded, size: 20),
                      label: const Text('Rate this order', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.secondary,
                        backgroundColor: AppTheme.secondary.withOpacity(0.05),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
