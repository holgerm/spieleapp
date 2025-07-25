import 'package:flutter/material.dart';
import 'spieleapp.dart';

class ItemPage extends StatelessWidget {
  final Future<Item> futureItem;

  const ItemPage({
    super.key,
    required this.futureItem,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Item>(
      future: futureItem,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(title: const Text('Fehler')),
              body: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'Keine Verbindung zum Server.\nSpiel wurde nicht geladen.\nFunktioniert deine Internetverbindung?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Keine Daten')));
        }

        final item = snapshot.data!;

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Text(item.name)),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.getImage() != null) item.getImage()!,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: item.createIcons(),
                  ),
                  Text(item.description, style: const TextStyle(fontSize: 17)),
                  const Divider(),
                  Text(
                    'Material: ${item.material}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
