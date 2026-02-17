import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Portfolio"), centerTitle: true),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: width < 600
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: portfolioContent(),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: portfolioContent(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> portfolioContent() {
    return [
      headerSection(),
      bioSection(),
      skillsSection(),
      educationSection(),
      projectsSection(),
    ];
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget headerSection() {
    return Column(
      children: const [
        CircleAvatar(radius: 50, backgroundImage: AssetImage("profile")),
        SizedBox(height: 10),
        Text(
          "Ahorsode Benjamin Delali",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Text("BSc Information Technology"),
        SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, size: 18),
            SizedBox(width: 5),
            Text("ahorsodebenjamindelali@gmail.com"),
            SizedBox(width: 15),
            Icon(Icons.phone, size: 18),
            SizedBox(width: 5),
            Text("+233 554101675"),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget bioSection() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Me",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "I am an IT student with great interest in mobile and web application development recently. "
              "My goal is to develop solutions that solve real-world problems.",
            ),
          ],
        ),
      ),
    );
  }

  Widget skillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Technical Skills"),
        const Text("Languages"),
        const Wrap(
          spacing: 8,
          children: [
            Chip(label: Text("HTML")),
            Chip(label: Text("PHP")),
            Chip(label: Text("C++")),
          ],
        ),

        const SizedBox(height: 10),
        const Text("Frameworks"),
        const Wrap(
          spacing: 8,
          children: [
            Chip(label: Text("Flutter")),
            Chip(label: Text("Bootstrap")),
          ],
        ),

        const SizedBox(height: 10),
        const Text("Tools"),
        const Wrap(
          spacing: 8,
          children: [
            Chip(label: Text("Git")),
            Chip(label: Text("XAMPP")),
            Chip(label: Text("MySQL")),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget educationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Academic History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),

        ListTile(
          leading: Icon(Icons.school),
          title: Text("Valley View University"),
          subtitle: Text("Level 300 • BSc IT"),
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("Relevant Courses"),
          subtitle: Text("Database Systems, Web Development"),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget projectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Projects & Experience"),

        projectCard(
          "Clinic Booking System",
          "Built using HTML, CSS, PHP, JavaScript and XAMPP for managing appointments.",
        ),
        projectCard(
          "Contact Directory",
          "A system for storing and managing contacts efficiently.",
        ),
        projectCard(
          "Charity Foundation",
          "A web app for a charity foundation using HTML,CSS,PHP,XAMPP",
        ),
      ],
    );
  }

  Widget projectCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(description),
          ],
        ),
      ),
    );
  }
}
