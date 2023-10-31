import 'package:flutter/material.dart';
import 'package:myapp/components/home_card.dart';

import 'package:myapp/routes/agenda.dart';
import 'package:myapp/routes/salles.dart';
import 'package:myapp/routes/map.dart';


class HomePage extends StatelessWidget {
	HomePage({super.key, required this.title});
	final String title;

	final cards = [
		{"color":0xffE97D7D,"title":"Mon Agenda","icon":'assets/icons/agenda.svg','route':AgendaPage(title: "Agenda")},
		{"color":0xffE4A255,"title":"Mes Salles","icon":'assets/icons/door.svg','route':SallesPage(title: "Salles")},
		{"color":0xff67AC65,"title":"Ma Carte","icon":'assets/icons/map.svg','route':MapPage(title: "Map")}
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Center(child: 
					Text(
						title,
						style: const TextStyle(
							fontSize: 26,
							fontWeight: FontWeight.bold
						),
					)
				),
				centerTitle: true,
			),
			body:  Padding(
				padding:const EdgeInsets.all(16.0),
				child: ListView.separated(
					itemBuilder: (ctx,i) {
						return HomeCard(context, i, cards);
					}, 
					separatorBuilder: (ctx,i) {
						return const SizedBox(height: 25);
					}, 
					itemCount: 3
				)
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () => {},
				tooltip: 'Actualiser',
				backgroundColor: Colors.blueAccent,
				child: const Icon(Icons.restart_alt),
			),
		);
	}
}
