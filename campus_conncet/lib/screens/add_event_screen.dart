import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'dart:io';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _image;
  Position? _currentLocation;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context, listen: false);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Add New Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Date: ${_formatDate(_selectedDate)}'),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      child: Text('Select'),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text(_image == null ? 'Take a Photo' : 'Image Captured'),
                    trailing: _image == null
                        ? IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: _pickImage,
                          )
                        : IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => setState(() => _image = null),
                          ),
                  ),
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(_image!, height: 150, fit: BoxFit.cover),
                    ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(_currentLocation == null 
                        ? 'Tag Location' 
                        : 'Location: ${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveEvent,
                child: _isSaving 
                    ? CircularProgressIndicator(color: Colors.white) 
                    : Text('Publish Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentLocation = position);
    }
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a title')));
      return;
    }

    setState(() => _isSaving = true);
    final eventVm = Provider.of<EventViewModel>(context, listen: false);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';

    // In a real app, you would upload _image to Firebase Storage here.
    // For this project, we'll store a placeholder URL if an image was taken.
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      imageUrl: _image != null ? 'https://via.placeholder.com/400' : '',
      latitude: _currentLocation?.latitude,
      longitude: _currentLocation?.longitude,
      createdBy: userId,
    );

    await eventVm.addEvent(newEvent);
    if (mounted) Navigator.pop(context);
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
