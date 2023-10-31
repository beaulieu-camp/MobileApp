import 'package:flutter/material.dart';
import 'package:myapp/components/card.dart';
import 'package:myapp/modules/fetch_salles.dart';

class SallesPage extends StatefulWidget {
	const SallesPage({super.key, required this.title});
	final String title;


	@override
	State<SallesPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SallesPage> {
	Future<Map<String, dynamic>>? salles;

	@override
	void initState() {
		super.initState();

		// salles = Future(() => "salut");
		salles = FetchSalles.getSalles();
		_salles();
	}

	Future<void> _salles() async {
		var sallesMap = await salles;

		if (sallesMap == null) {
			return;
		}

		for (var item in sallesMap.keys) {
			int time = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
			var temp = await FetchSalles.salleLibres(item, time);
			sallesMap[item]['state'] = temp['state'];
			sallesMap[item]['until'] = temp['until'];
		}

		setState(() {});
	}

	@override
	Widget build(BuildContext context) {
		// This method is rerun every time setState is called, for instance as done
		// by the _incrementCounter method above.
		//
		// The Flutter framework has been optimized to make rerunning build methods
		// fast, so that you can just rebuild anything that needs updating rather
		// than having to individually change instances of widgets.
		return Scaffold(
			appBar: AppBar(
				// TRY THIS: Try changing the color here to a specific color (to
				// Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
				// change color while the other colors stay the same.
				// backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				// Here we take the value from the MyHomePage object that was created by
				// the App.build method, and use it to set our appbar title.
				title: Text(widget.title),
				centerTitle: true,
			),
			body:  FutureBuilder(
				future: salles,
				builder: ( BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot ) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const CircularProgressIndicator();
					} 
					else if (snapshot.hasError) {
						return Text('Error: ${snapshot.error}');
					} 
					else {
						List<Widget> cardList = [];

						var sallesMap = snapshot.data;

						if (sallesMap == null) {
							return Text('Error: ${snapshot.error}');
						}

						var keys = sallesMap.keys;

						for (String el in keys) {
							var color = Colors.white;
							String until = "Loading";
							if (sallesMap[el].keys.contains("until")) {

								color = sallesMap[el]["state"] == "Libre" ? Colors.green : Colors.red;

								var dt = sallesMap[el]["until"] * 1000;
								var now = DateTime.now().millisecondsSinceEpoch;

								final date = DateTime.fromMillisecondsSinceEpoch(dt);
								until = dt - now > 24 * 60 * 60 * 1000 ? "Jusqu'au ${date.day}/${date.month}" : "Jusqu'à ${date.hour}h${date.minute}";
							} else {
								color = Colors.blue;
							}

							cardList.add(createCard(sallesMap, el, color, until));
						}

						var col = GridView(
							gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
								crossAxisCount:(MediaQuery.of(context).size.width ~/ 200).toInt(),
								mainAxisExtent: 150.0,
								// mainAxisSpacing: 20,
							),
							children: cardList
						);

						return col;
					}
				}

			),
			floatingActionButton: FloatingActionButton(
				onPressed: _salles,
				tooltip: 'Actualiser',
				backgroundColor: Colors.blueAccent,
				child: const Icon(Icons.restart_alt),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
