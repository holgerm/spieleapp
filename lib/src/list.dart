import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'spieleapp.dart';
import 'info_page.dart';

PageRouteBuilder _slideFromLeft(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  Future<List<Item>> fetchIndex() async {
    const url = '${S.dataUrl}/items/index.json';
    final response = await http.get(Uri.parse(url));
    final List data = json.decode(response.body);
    return data.map((item) => Item.fromIndexJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.introTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(_slideFromLeft(InfoPage()));
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Spiel Zurücksetzen',
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    'Wirklich alles Löschen?',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Abbrechen'),
                      child: const Text('Abbrechen'),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<StateModel>(context, listen: false).reset();
                        Navigator.pop(context, 'Abbrechen');
                      },
                      child: const Text('Ja, alles Löschen!'),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Item>>(
          future: fetchIndex(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Padding(
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
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Keine Spiele gefunden.'));
            }

            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemWidget(game: items[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Item>> loadItemsFromServer() async {
    const url = '${S.dataUrl}/items/index.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Index konnte nicht geladen werden');
    }

    final List<dynamic> indexList = json.decode(response.body);
    return Future.wait(indexList.map((entry) async {
      final id = entry['id'];
      final itemUrl = '${S.dataUrl}/items/$id/content.json';
      final itemResponse = await http.get(Uri.parse(itemUrl));
      if (itemResponse.statusCode != 200) {
        throw Exception('Item $id konnte nicht geladen werden');
      }
      final itemData = json.decode(itemResponse.body);
      return Item.fromFullJson(itemData);
    }));
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
          subtitle: Text(game.id),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ItemPage(futureItem: loadItemDetails(game.id))),
            );
          }),
    );
  }

  Future<Item> loadItemDetails(String id) async {
    final url = '${S.dataUrl}/items/$id/content.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
          'Fehler ${response.statusCode}: ${response.reasonPhrase}');
    }

    try {
      final data = json.decode(response.body);
      return Item.fromFullJson(data);
    } catch (e) {
      throw Exception('Fehler beim Parsen der Spiel-Daten');
    }
  }
}
