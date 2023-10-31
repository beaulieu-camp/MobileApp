import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



	GestureDetector HomeCard(BuildContext context, int i, cards) {
	  	return GestureDetector(
			onTap: () {
				Navigator.push( 
					context, MaterialPageRoute(builder: (context) => cards[i]["route"]),
				);
			},
			child:Container(
			
			height: 90,
			decoration: BoxDecoration(
				color: Color(cards[i]["color"] as int),
				borderRadius: BorderRadius.circular(24)
			),
			child: Padding( 
					padding: const EdgeInsets.all(8.0), 
					child:Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Row(children: [
								SvgPicture.asset(cards[i]["icon"] as String),
								Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
								child:Column(
									
									children: [
										Text(cards[i]["title"] as String,textAlign: TextAlign.left, style: const TextStyle(color:Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
										// Text(cards[i]["title"] as String,textAlign: TextAlign.left, style: const TextStyle(color:Colors.white,fontSize: 18)),
									],
								) ,
								)
								
								
							],),
							const Icon(Icons.keyboard_arrow_right_rounded,size: 45,color: Colors.white,),
						]
					)
				),
			)
		);
	}
