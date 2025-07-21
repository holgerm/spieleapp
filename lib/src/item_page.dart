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
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      'Spiel konnte nicht geladen werden.',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
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
