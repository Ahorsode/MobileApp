import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/menu_service.dart';
import '../../services/image_upload_service.dart';
import '../../models/menu_item.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../profile/profile_screen.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final MenuService _menuService = MenuService();
  final ImageUploadService _imageService = ImageUploadService();

  Future<void> _showAddEditDialog([MenuItem? existingItem]) async {
    final nameCtrl = TextEditingController(text: existingItem?.name);
    final priceCtrl = TextEditingController(text: existingItem?.price.toString());
    final descCtrl = TextEditingController(text: existingItem?.description);
    final stockCtrl = TextEditingController(text: existingItem?.stock.toString());
    String selectedCategory = existingItem?.category ?? 'Lunch';
    String? uploadedImageUrl = existingItem?.imageUrl;
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existingItem == null ? 'Add New Item' : 'Edit Item',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Image Upload Section
                    Center(
                      child: GestureDetector(
                        onTap: isUploading ? null : () async {
                          final picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                          
                          if (image != null) {
                            setState(() => isUploading = true);
                            final bytes = await image.readAsBytes();
                            final base64Img = base64Encode(bytes);
                            final imgUrl = await _imageService.uploadImageBase64(base64Img);
                            
                            setState(() {
                              if (imgUrl != null) uploadedImageUrl = imgUrl;
                              isUploading = false;
                            });
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade200),
                            image: uploadedImageUrl != null 
                              ? DecorationImage(image: NetworkImage(uploadedImageUrl!), fit: BoxFit.cover)
                              : null,
                          ),
                          child: isUploading 
                            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                            : uploadedImageUrl == null 
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_rounded, color: AppTheme.primary),
                                    SizedBox(height: 4),
                                    Text('Add Image', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
                                  ],
                                )
                              : Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.edit_rounded, size: 16, color: AppTheme.primary),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Item Name', prefixIcon: Icon(Icons.fastfood_rounded)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceCtrl,
                            decoration: const InputDecoration(labelText: 'Price (\$)', prefixIcon: Icon(Icons.attach_money_rounded)),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: stockCtrl,
                            decoration: const InputDecoration(labelText: 'Stock', prefixIcon: Icon(Icons.inventory_2_rounded)),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category_rounded)),
                      items: ['Breakfast', 'Lunch', 'Snacks'].map((String val) {
                        return DropdownMenuItem(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description_rounded)),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isUploading ? null : () async {
                          if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty || stockCtrl.text.isEmpty) return;

                          final newItem = MenuItem(
                            id: existingItem?.id ?? '',
                            name: nameCtrl.text,
                            price: double.tryParse(priceCtrl.text) ?? 0.0,
                            description: descCtrl.text,
                            stock: int.tryParse(stockCtrl.text) ?? 0,
                            category: selectedCategory,
                            imageUrl: uploadedImageUrl ?? 'https://via.placeholder.com/150',
                            averageRating: existingItem?.averageRating ?? 0.0,
                            ratingCount: existingItem?.ratingCount ?? 0,
                          );

                          Navigator.pop(context);
                          if (existingItem == null) {
                            await _menuService.addMenuItem(newItem);
                          } else {
                            await _menuService.updateMenuItem(newItem);
                          }
                        },
                        child: Text(existingItem == null ? 'Create Item' : 'Update Item'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuVM = context.watch<MenuViewModel>();

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
            title: const Text('Manage Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Consumer<AuthViewModel>(
                builder: (context, authVM, child) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Text(
                            (authVM.currentUser?.name.isNotEmpty == true 
                                ? authVM.currentUser!.name[0] 
                                : (authVM.currentUser?.email.isNotEmpty == true ? authVM.currentUser!.email[0] : 'A')).toUpperCase(),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
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
          StreamBuilder<List<MenuItem>>(
            stream: menuVM.menuStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_rounded, size: 64, color: Colors.grey.shade200),
                        const SizedBox(height: 16),
                        Text('Your menu is empty', style: TextStyle(color: Colors.grey.shade400, fontSize: 18)),
                      ],
                    ),
                  ),
                );
              }

              final items = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return _buildAdminMenuCard(item);
                    },
                    childCount: items.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primary,
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildAdminMenuCard(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(item.category, style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Stock: ${item.stock}', style: TextStyle(color: item.stock < 5 ? Colors.red : Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _showAddEditDialog(item),
                  icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
                ),
                IconButton(
                  onPressed: () => _menuService.deleteMenuItem(item.id),
                  icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 20),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().slideX(begin: 0.1),
    );
  }
}
