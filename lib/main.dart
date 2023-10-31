import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:myapp/routes/home.dart';



void main() {


	runApp(const MyApp());
}

class MyApp extends StatefulWidget {

		const MyApp({super.key});

  @override
  _MyApp createState() => _MyApp();
}



class _MyApp extends State<MyApp> {
	Future<void> refresh() async{
		await FlutterDisplayMode.setHighRefreshRate();

	}

	@override
	void initState()  {
		refresh();
	}
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {

		return MaterialApp(
			title: 'Flutter Demo',

			theme: ThemeData(
				fontFamily: 'Urbanist',
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
				useMaterial3: true,
			),
			home: HomePage(title: 'Beaulieu\'Camp'),
		);
	}
}

