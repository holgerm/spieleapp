import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class InfoPage extends StatefulWidget {
  final Future<String> Function() loadInfo;
  const InfoPage({super.key, required this.loadInfo});

  @override
  State<InfoPage> createState() => _InfoPageState();

  static Future<String> fetchMarkdown() async {
    String url =
        'https://raw.githubusercontent.com/holgerm/spieleapp_content/main/Changes.md';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Fehler beim Laden');
    }
  }
}

class _InfoPageState extends State<InfoPage> {
  late Future<String> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = widget.loadInfo();
  }

  Future<void> reload() async {
    setState(() {
      futureInfo = widget.loadInfo();
    });
    await futureInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: futureInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: const Text("Versionshinweise")),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Fehler")),
              body: RefreshIndicator(
                onRefresh: reload,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: const [
                    SizedBox(height: 100),
                    Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Keine Verbindung zum Server.\nHinweise können nicht geladen werden.\nFunktioniert deine Internetverbindung?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Erfolgsfall: Markdown anzeigen
          return Scaffold(
            appBar: AppBar(title: const Text("Versionshinweise")),
            body: RefreshIndicator(
              onRefresh: reload,
              child: Markdown(
                data: snapshot.data!,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          );
        });
  }
}
