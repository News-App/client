import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newsapp/Store.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/widgets/helpers/messenger.dart';
import 'package:newsapp/widgets/home.dart';
import 'package:newsapp/widgets/news_details.dart';

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
		fetchNews();
	}

	fetchNews() async
	{
		Api apiClient = Api();
		await Store.init();		

		Messenger();

		String url = "/news/headlines/fetch";

		Map body = {};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		print(parsedResponse);

		if(parsedResponse["status"] == 200)
		{
			print("200");

			var range = new Random();
			randomIndex = range.nextInt(10);
			await Store.store.setString("splashed", "1");

			setState(() 
			{
				print("setting state");

				this.news = parsedResponse["data"];				

				Navigator.pushReplacementNamed
				(
					context, "home",
					arguments: 
					{
						"news": this.news,
						"randomIndex": randomIndex
					}
				);
			});
		}	
	}
}



