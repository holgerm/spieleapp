import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class InfoPage extends StatelessWidget {
  final String url =
      'https://raw.githubusercontent.com/holgerm/spieleapp_content/main/Changes.md';

  Future<String> fetchMarkdown() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Fehler beim Laden');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Versionshinweise")),
      body: FutureBuilder<String>(
        future: fetchMarkdown(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Fehler beim Laden."));
          } else {
            return Markdown(data: snapshot.data!);
          }
        },
      ),
    );
  }
}