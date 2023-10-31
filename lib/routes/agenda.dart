import 'package:flutter/material.dart';
import 'package:myapp/modules/fetch_salles.dart';

List<Widget> createPages(events) {
	
	List<Widget> widgets = [];


	var lastDate = DateTime.now();

	var d = lastDate.day;
	var m = lastDate.month;
	var y = lastDate.year;

	lastDate = DateTime.parse("$y-$m-$d");
	List<Widget> dayEvents = [];

	for ( var event in events ) {
		var date = DateTime.fromMillisecondsSinceEpoch(event["start"] as int);

		if (date.millisecondsSinceEpoch < lastDate.millisecondsSinceEpoch) { continue; }

		if ( date.day != lastDate.day || date.month != lastDate.month || date.year != lastDate.year ){

			if (dayEvents.isNotEmpty) {			
				var cont = Column(children: dayEvents);

				widgets.add(cont);
				dayEvents = [];
			}

		}

		lastDate = date;

		var dateStart = DateTime.fromMillisecondsSinceEpoch(event["start"] as int);
		var dateEnd = DateTime.fromMillisecondsSinceEpoch(event["end"] as int);

		var todayEvent = SizedBox( width: double.infinity, child:Card(color:const Color(0xffE97D7D),child:Column(children:[Text(event["summary"] as String),Text(event["location"] as String),Text('${dateStart.hour}:${dateStart.minute} - ${dateEnd.hour}:${dateEnd.minute}' )])));
		dayEvents.add(todayEvent);

	}

	return widgets;
}

class AgendaPage extends StatefulWidget {
	const AgendaPage({super.key, required this.title});
	final String title;


	@override
	State<AgendaPage> createState() => _AgendaPage();
}


class _AgendaPage extends State<AgendaPage> {
	final controller = PageController(
		initialPage: 0,
	);

	Future<List<Map<String, Object>>>? events;

	@override
	void initState() {
		super.initState();

		// salles = Future(() => "salut");
		events = FetchSalles.getAgendaEvents("https://planning.univ-rennes1.fr/jsp/custom/modules/plannings/E3pXo53A.shu");
	}

	@override
	Widget build(BuildContext context) {
		String dayTitle = "day";
		return Scaffold(
			appBar: AppBar(
				title: 
					Text(
						widget.title,
						style: const TextStyle(
							fontSize: 26,
							fontWeight: FontWeight.bold
						),
					),
				centerTitle: true,
				bottom:  PreferredSize(
					preferredSize:  const Size.fromHeight(80.0),
					
					child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,

						children: [
							IconButton(onPressed: () {controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);}, icon: const Icon( Icons.keyboard_arrow_left_rounded, size: 50, )),
							Text(dayTitle, style: const TextStyle(fontSize: 25),),
							IconButton(onPressed: () {controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);}, icon: const Icon( Icons.keyboard_arrow_right_rounded, size: 50, )),
						]
					)
				),
			),
			
			body:  Padding(
				padding:const EdgeInsets.all(16.0),
				child: 	FutureBuilder(
					future: events,
					builder: ( BuildContext context, AsyncSnapshot<List<Map<String, Object>>> snapshot ) {
						

						if ( snapshot.data == null ){
							return PageView();
						}

						var pages = createPages(snapshot.data);

						return PageView(
							controller: controller,
							onPageChanged: (page) => {setState(() {dayTitle="test";})},
							pageSnapping: true,
							scrollDirection: Axis.horizontal,
							children: pages
						);
					}
					
				)
			)	
		);
	}
}

/*return GestureDetector(
			onTap: () {
				Navigator.pop(context);
			},*/