import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../services/menu_service.dart';
import '../../services/image_upload_service.dart';
import '../../models/menu_item.dart';
import '../../viewmodels/menu_viewmodel.dart';

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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                    TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                    TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
                    TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCategory,
                      items: ['Breakfast', 'Lunch', 'Snacks'].map((String val) {
                        return DropdownMenuItem(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) {
                        setState(() => selectedCategory = val!);
                      },
                    ),
                    const SizedBox(height: 10),
                    if (uploadedImageUrl != null)
                      Image.network(uploadedImageUrl!, height: 80, width: 80, fit: BoxFit.cover),
                    
                    isUploading 
                        ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.image),
                            label: const Text('Pick Image'),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                              
                              if (image != null) {
                                setState(() => isUploading = true);
                                // Read bytes and convert to Base64
                                final bytes = await image.readAsBytes();
                                final base64Img = base64Encode(bytes);
                                
                                // Directly use ImgBB REST API
                                final imgUrl = await _imageService.uploadImageBase64(base64Img);
                                
                                setState(() {
                                  if (imgUrl != null) uploadedImageUrl = imgUrl;
                                  isUploading = false;
                                });
                                if (imgUrl == null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image upload failed.')));
                                }
                              }
                            },
                          )
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: isUploading ? null : () async {
                    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty || stockCtrl.text.isEmpty) return;

                    final newItem = MenuItem(
                      id: existingItem?.id ?? '', // empty if new
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
                  child: const Text('Save'),
                )
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuVM = context.watch<MenuViewModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: menuVM.menuStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No items found."));

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.fastfood)),
                title: Text(item.name),
                subtitle: Text('\$${item.price.toStringAsFixed(2)} | Stock: ${item.stock}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showAddEditDialog(item)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _menuService.deleteMenuItem(item.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
