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
          return Scaffold(
              body: Center(child: Text('Fehler: ${snapshot.error}')));
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
                  item.getImage(),
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
