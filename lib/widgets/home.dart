import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapp/api.dart';
import 'loader.dart';

class Home extends StatefulWidget
{
	createState()
	{
		return HomeState();
	}
}

class HomeState extends State<Home> with WidgetsBindingObserver
{
	final String  prefixUrl = "/news";

	List <dynamic> news = [{"_source":{"title":"abc", "description": "abc", "author": "abc", "publishedAt": "abc", "urlToImage": "https://www.teliacompany.com/Assets/Images/not-available.png"}}];

	void initState()
	{
		super.initState();

		WidgetsBinding.instance.addPostFrameCallback((_)
		{
			fetchNews();			
		});
	}

	Widget build(BuildContext context)
	{
		return 
		(
			Scaffold
			(
				appBar: AppBar
				(
					title: Column
					(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: 
						[
							Text("Headlines", style: TextStyle(color: Colors.red, fontSize: 30, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold)),
							Text("Happening around you!", style: TextStyle(color: Colors.red, fontSize: 10, fontFamily: 'Times New Roman', ))
						],
					),
					backgroundColor: Colors.white,
				),
				body: Container
				(
					padding: EdgeInsets.all(10.0),					
					alignment: Alignment.topCenter,
					child: ListView.builder
					(						
						itemCount: this.news.length,
						itemBuilder: (context, index)
						{							
							return Card
							(
								elevation: 4.0,
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
								child: ListTile
								(
									contentPadding: EdgeInsets.all(10.0),
									leading: Container
									(
										padding: EdgeInsets.all(10.0),
										child: Image.network(this.news[index]["_source"]["urlToImage"])
									),
									title: Text(this.news[index]["_source"]["title"],style: TextStyle(fontFamily: "comic-sans", fontSize: 15.0)),
									isThreeLine: true,
									subtitle: Column
									(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: 
										[
											Container(margin: EdgeInsets.only(top:5.0)),
											Text(this.news[index]["_source"]["description"],style: TextStyle(fontFamily: "comic-sans", fontSize: 14.0,)),
											Container(margin: EdgeInsets.only(top:10.0)),
											Text(this.news[index]["_source"]["publishedAt"],style: TextStyle(fontFamily: "comic-sans", fontSize: 13.0, color: Colors.white, backgroundColor: Colors.red))
										]
									)
								)
							);
						}	
					),
				),
			)
		);
	}

	fetchNews() async
	{
		showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader("Please Wait"));

		Api apiClient = Api();

		String url = this.prefixUrl + "/headlines/fetch";

		Map body = {};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		print(parsedResponse);

		if(parsedResponse["status"] == 200)
		{
			setState(() 
			{
			  this.news = parsedResponse["data"];
			});
		}

		Navigator.pop(context);
	}

}