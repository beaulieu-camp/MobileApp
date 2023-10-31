import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';


class MapPage extends StatelessWidget {
	const MapPage({super.key, required this.title});

	final String title;

	@override
	Widget build(BuildContext context) {
		
		return Scaffold(
			appBar: AppBar(
				title: 
					Text(
						title,
						style: const TextStyle(
							fontSize: 26,
							fontWeight: FontWeight.bold
						),
					),
				centerTitle: true,

			),
			body: FlutterMap(
				options: const MapOptions(
					initialCenter: LatLng(48.119,-1.638),
					initialZoom: 15,
				),
				children: [
				TileLayer(
					urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/light_nolabels/{z}/{x}/{y}.png',
					userAgentPackageName: 'com.example.app',
					tileProvider: CancellableNetworkTileProvider(),

				),
				const RichAttributionWidget(
					attributions: [
						TextSourceAttribution(
							'OpenStreetMap contributors',
							// onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
						),
					],
				),
				],
			)
		);
	}
}