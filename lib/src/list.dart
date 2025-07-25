import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'spieleapp.dart';
import 'info_page.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late Future<List<Item>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchIndex();
  }

  Future<List<Item>> fetchIndex() async {
    const url = '${S.dataUrl}/items/index.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Fehler beim Laden der Spieleliste');
    }
    final List data = json.decode(response.body);
    return data.map((item) => Item.fromIndexJson(item)).toList();
  }

  Future<void> reload() async {
    setState(() {
      futureItems = fetchIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.appTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // z. B. in Zukunft Filteroptionen implementieren
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const InfoPage(loadInfo: InfoPage.fetchMarkdown),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Item>>(
          future: futureItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return RefreshIndicator(
                onRefresh: reload,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            'Keine Verbindung zum Server.\nSpieleliste wurde nicht geladen.\nFunktioniert deine Internetverbindung?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Keine Spiele gefunden.'));
            }

            final items = snapshot.data!;
            return RefreshIndicator(
              onRefresh: reload,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemWidget(game: items[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.game,
  });

  final Item game;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(game.name),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ItemPage(loadItem: () => loadItemDetails(game.id)),
            ),
          );
        },
      ),
    );
  }

  Future<Item> loadItemDetails(String id) async {
    final url = '${S.dataUrl}/items/$id/content.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
          'Fehler ${response.statusCode}: ${response.reasonPhrase}');
    }
    final data = json.decode(response.body);
    return Item.fromFullJson(data);
  }
}
