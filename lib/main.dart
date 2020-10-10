import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newsapp/Store.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/config.dart';
import 'package:newsapp/widgets/categories.dart';
import 'package:newsapp/widgets/home.dart';
import 'package:newsapp/widgets/news_details.dart';
import 'package:newsapp/widgets/result.dart';
import 'package:newsapp/widgets/search_page.dart';

void main()
{
	runApp(MaterialApp
	(
		debugShowCheckedModeBanner: false,
		theme: ThemeData(primaryColor: Colors.red, accentColor: Colors.white),
		home: Splash(),
		title: "News App",
		routes:
		{
			"home": (context) => Home(),
			"details": (context) => NewsDetails(),
			"categories": (context) => Categories(),
			"result": (context) => Result(),
			"search": (context) => SearchPage()
		}
	));
}

class Splash extends StatefulWidget
{
	createState()
	{
		return(SplashState());
	}
}

class SplashState extends State<Splash>
{
	int randomIndex;
	List <dynamic> news;

	List<dynamic> health = [];
	List<dynamic> business = [];
	List<dynamic> headlines = [];
	List<dynamic> entertainment = [];
	List<dynamic> technology = [];
	List<dynamic> science = [];
	List<dynamic> sports = [];

	Widget build(BuildContext context)
	{
		return
		(
			Container
			(
				color: Colors.redAccent,
				child: Stack
				(
					children:
					[
						Align
						(
							alignment: FractionalOffset.bottomCenter,
							child: Container
							(
								margin: EdgeInsets.only(bottom:50),
								height: 40,
								width: 40,
								child: CircularProgressIndicator(backgroundColor: Colors.red)
							)
						),
						Align
						(
							alignment: FractionalOffset.center,
							child: Container
							(
								margin: EdgeInsets.only(bottom:220),
								child: Icon(Icons.av_timer, size: 90, color: Colors.white,)
							)
						),
						Align
						(
							alignment: FractionalOffset.center,
							child: Container
							(
								margin: EdgeInsets.only(bottom:50),
								child: Text("Minutes", style: TextStyle(color: Colors.white, decoration: TextDecoration.none, decorationColor: Colors.grey, fontSize: 50.0, fontWeight: FontWeight.normal))
							)
						),
						Align
						(
							alignment: FractionalOffset.center,
							child: Container
							(
								margin: EdgeInsets.only(top:20),
								child: Text("headlines in a minute", style: TextStyle(color: Colors.white, fontSize: 12.0, decoration: TextDecoration.none))
							)
						)
					]
				),
			)
		);
	}

	initState()
	{
		super.initState();
		fetchBaseUrl();
	}

	fetchBaseUrl() async
	{
		Api apiClient = Api();

		var response = await apiClient.get("/news/base");
		var parsedResponse = jsonDecode(response);

		baseUrl = parsedResponse["url"];
		logoColor = parsedResponse["color"];

		print(baseUrl);

		fetchNews();
	}

	fetchNews() async
	{
		print("firebased");

		Api apiClient = Api();
		await Store.init();

		await Store.store.setString("showLoader", "1");
		await Store.store.setString("categories", '[{"_source":{"name":""}}]');

		String url = "/news/headlines/fetch";

		Map body = {};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		print(parsedResponse);

		if(parsedResponse["status"] == 200)
		{
			int randomIndex = 0;
			await Store.store.setString("splashed", "1");

			setState(()
			{
				this.news = parsedResponse["data"];

				this.news.forEach((article)
				{
					print(article["_source"]["category"]);

					switch(article["_source"]["category"])
					{
						case "health":
							this.health.add(article["_source"]);break;
						case "business":
							this.business.add(article["_source"]);break;
						case "entertainment":
							this.entertainment.add(article["_source"]);break;
						case "sports":
							this.sports.add(article["_source"]);break;
						case "headlines":
							this.headlines.add(article["_source"]);break;
						case "technology":
							this.technology.add(article["_source"]);break;
						case "science":
							this.science.add(article["_source"]);break;
					}
				});

				Navigator.pushReplacementNamed
				(
					context, "home",
					arguments:
					{
						"news": this.news,
						"headlines": this.headlines,
						"health": this.health,
						"business": this.business,
						"sports": this.sports,
						"technology": this.technology,
						"science": this.science,
						"entertainment": this.entertainment,
						"randomIndex": randomIndex
					}
				);
			});
		}
	}
}



