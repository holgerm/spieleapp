import 'package:flutter/material.dart';
import 'spieleapp.dart';

class ItemPage extends StatefulWidget {
  final Future<Item> Function() loadItem;
  const ItemPage({super.key, required this.loadItem});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<Item> futureItem;

  @override
  void initState() {
    super.initState();
    futureItem = widget.loadItem();
  }

  Future<void> reload() async {
    setState(() {
      futureItem = widget.loadItem();
    });
    await futureItem;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Item>(
      future: futureItem,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Spiel")),
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
                      'Keine Verbindung zum Server.\nSpiel konnte nicht geladen werden.\nFunktioniert deine Internetverbindung?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final item = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(item.name)),
          body: RefreshIndicator(
            onRefresh: reload,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (item.getImage() != null)
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: item.getImage(),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: item.createIcons(),
                ),
                const SizedBox(height: 20),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 17),
                ),
                const Divider(height: 40),
                Text(
                  'Material: ${item.material}',
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
