import 'package:flutter/material.dart';


class DepartmentDetailScreen extends StatefulWidget {
  final String departmentName;
  
  const DepartmentDetailScreen({
    super.key,
    required this.departmentName,
  });


  @override
  State<DepartmentDetailScreen> createState() => _DepartmentDetailScreenState();
}


class _DepartmentDetailScreenState extends State<DepartmentDetailScreen> {
  bool _isExpanded = false;
  int _favoriteCount = 0;


  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }


  void _incrementFavorite() {
    setState(() {
      _favoriteCount++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.departmentName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Department Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.departmentName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Department of Computing Sciences and Engineering',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Expandable Description (Stateful Section)
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Department Description'),
                    trailing: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onTap: _toggleExpansion,
                  ),
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: const Text(
                        'The Computer Science department at Valley View University focuses on software engineering, mobile development, data science, and artificial intelligence. Our faculty are industry experts who provide hands-on training using modern technologies.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Interactive Counter (Stateful)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Interest Counter',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Favorites: $_favoriteCount',
                      style: const TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _incrementFavorite,
                      child: const Text('Add to Favorites'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
