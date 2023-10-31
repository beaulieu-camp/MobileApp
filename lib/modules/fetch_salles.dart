import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetch(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.body;
}

class FetchSalles {
  static const baseUrl = "https://beaulieu-camp.github.io/salles";

  static Future<Map<String, dynamic>> getSalles() async {
    String url = '$baseUrl/salles.json';
    String resp = await fetch(url);

    return jsonDecode(resp);
  }

	static int to_date(char){
		var date =  DateTime.parse(char);
		return date.millisecondsSinceEpoch;
	}


	static List<Map<String,Object>> parse(data) {
		data = data.split("\r\n");

		List<Map<String,Object>> obj =  [];
		Map<String,Object> nlist = {};
		for (var cle in data) {
			var split = cle.split(':');
			var nkey = split[0];
			if (nkey == "DTSTART" ){
				nlist["start"] = to_date(split[1]);
			}
			else if (nkey == "DTEND"){
				nlist["end"] = to_date(split[1]);
			}
			else if (nkey == "DESCRIPTION"){
				nlist["description"] = split[1];
			}
			else if (nkey == "SUMMARY"){
				nlist["summary"] = split[1];
			}
			else if (nkey == "LOCATION"){
				nlist["location"] = split[1];
			}
			if (nlist.keys.length == 5){
				obj.add(nlist);
				nlist = {};
			}

		}
		
		obj.sort(
			(a, b) => ( a["start"] as int).compareTo( (b["start"] as int) )
		);

		return obj;
	}





	static int checkafter(liste, int i) {
		var b = i + 1;
		while (liste[b] != null && liste[i][1] == liste[b][0]) {
			i += 1;
			b = i + 1;
		}
		return i;
	}

	static Future<List<List<Object>>> getEvents(String salle) async {
		String url = '$baseUrl/$salle.json';
		String resp = await fetch(url);

		List<dynamic> temp = jsonDecode(resp);
		List<List<Object>> events =
			temp.map((item) => List<Object>.from(item)).toList();
		return events;
	}

	static Future<List<Map<String, Object>>> getAgendaEvents(String url) async {
		String resp = await fetch(url);

		List<Map<String, Object>> events = parse(resp);

		return events;
	}

  static Future salleLibres(String salle, num date) async {
    /*
						Retourne si la salle est libre (true) ou non (false) sur 

						date est par défaut Date.now()

						Args : 
								- salle : string
								- date : int (UNIX time) en secondes
						Return :
								- return.state : booléen : état de la salle ( libre : true , occupé : false )
								- return.until : int : date de fin de l'état (UNIX time)
				*/

    var cal = await getEvents(salle);

    var req = dichotomie(cal, date, 0, cal.length - 1);
    bool state = req[0] as bool;
    int i = req[1] as int;
    if (i == -1) {
      return {"error": "Calendrier pas à jour"};
    }

    if (state) {
      i = checkafter(cal, i); // vérification des évenements collés
      return {"state": "Occupé", "until": cal[i][1]};
    } else {
      return {"state": "Libre", "until": cal[i][0]};
    }
  }

	static Future salleEvents(String salle, num date) async{
		/*
			Retourne les horaires des cours/events d'une journée donnée dans une salle donnée
			
			Args:
				- salle : string
				- date : int (UNIX time) en secondes
			return :
				- liste des events d'une journée
		*/
    	var cal = await getEvents(salle);

		var req = dichotomie(cal, date, 0, cal.length - 1);
		int i = req[1] as int;
		var liste = [];
		while ((cal[i][1] as int) < date + 24 * 60 * 60) {
			liste.add(cal[i]);
			i += 1;
		}
		return liste;
	}


  	static List<Object> dichotomie(
      List<List<Object>> liste, num datetime, int a, int b) {
    /*

				Renvoie [x,y] 
				
				x : booléen -> si la salle est prise true, sinon false
				y : number -> date a laquelle la salle ce statut change
			
		*/

    if (b - a <= 1) {
      var test0 = datetime < (liste[a][0] as num);
      var test1 = (liste[a][1] as num) < datetime;
      var test2 = datetime < (liste[b][0] as num);
      var test3 = (liste[b][1] as num) < datetime; // cas out of bound1

      if (test0) {
        return [false, a];
      } else if (test1 && test2) {
        return [false, b];
      } else if (test3) {
        return [true, -1];
      } else {
        return [true, a];
      }
    }
    var m = ((b + a) / 2).floor();
    if (datetime < (liste[m][1] as num)) {
      return dichotomie(liste, datetime, a, m);
    } else {
      return dichotomie(liste, datetime, m, b);
    }
  }
}
