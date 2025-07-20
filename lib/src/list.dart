import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'spieleapp.dart';

class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.introTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog.fullscreen(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      S.imprint,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Schliessen',
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createItems(),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> createItems() {
    const items = 14;
    List<Item> games = List.generate(
        items,
        (index) => Item(
              name: 'Spiel Nr. $index',
              id: 'Spiel $index',
            ));
    return List.generate(
        games.length,
        (index) => ItemWidget(
              game: games[index],
            ));
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
                  builder: (context) => ItemPage(
                        item: Item.hotPotato(),
                      )),
            );
          }),
    );
  }
}
