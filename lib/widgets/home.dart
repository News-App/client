import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Store.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/widgets/helpers/messenger.dart';
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

	String firstTitle = "";
	String firstPic = "";
	String firstDate = "";

	int randomIndex = 0;

	List <dynamic> news = [{"_source":{"title":"abc", "description": "abc", "author": "abc", "publishedAt": "2020-04-04T22:25:05Z", "urlToImage": "https://www.teliacompany.com/Assets/Images/not-available.png"}}];

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
					title: Row
					(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: 
						[							
							Text("Headlines", style: TextStyle(color: Colors.red)),
							FlatButton
							(
								child: Icon(Icons.refresh, color: Colors.red),
								onPressed: () async
								{
									await fetchNews();
								}
							)
						],
					),
					backgroundColor: Colors.white,
					
				),
				body: Container
				(
					padding: EdgeInsets.all(10),
					child: Column
					(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: 
						[
							GestureDetector
							(
								child: Container
								(										
									height: 250.0,			
									margin: EdgeInsets.only(bottom: 10.0),					
									child: Card
									(									
										semanticContainer: true,																							
										child: Container
										(										
											decoration: BoxDecoration
											(
												image: DecorationImage
												(
													image: NetworkImage(this.firstPic),
													fit: BoxFit.cover
												),
											),
											padding: EdgeInsets.all(10),
											child: Column
											(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: 
												[																				
													Text
													(
														this.firstTitle, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),													
													),
													Container(margin: EdgeInsets.only(top:5)),
													Text(" " + DateFormat("dd-MMM-y").format(DateTime.parse(this.firstDate)) + " ", style: TextStyle(color: Colors.white, backgroundColor: Colors.redAccent))
												]
											)
										)
									)
								),
								onTap: () async
								{
									await Store.store.setString("title", this.news[randomIndex]["_source"]["title"]);
									await Store.store.setString("description", this.news[randomIndex]["_source"]["description"]);
									await Store.store.setString("created", this.news[randomIndex]["_source"]["publishedAt"]);
									await Store.store.setString("pic", this.news[randomIndex]["_source"]["urlToImage"]);
									await Store.store.setString("author", this.news[randomIndex]["_source"]["author"]);
									await Store.store.setString("content", this.news[randomIndex]["_source"]["content"]);
									await Store.store.setString("url", this.news[randomIndex]["_source"]["url"]);

									Navigator.pushNamed(context, "details");
								},
							),
							Expanded
							(							
								child: Container
								(																											
									child: ListView.builder
									(									
										itemCount: this.news.length,										
										itemBuilder: (context, index)
										{							
											return Column
											(
												children: 
												[
													ListTile
													(												
														dense: true,
														contentPadding: EdgeInsets.only(right:5.0, bottom: 5.0, top: 5.0),
														leading: CircleAvatar
														(
															backgroundImage: NetworkImage(this.news[index]["_source"]["urlToImage"]),
															radius: 25,
														) ,
														title: Text(this.news[index]["_source"]["title"],style: TextStyle(fontFamily: "comic-sans", fontSize: 15.0)),
														isThreeLine: true,
														subtitle: Column
														(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: 
															[
																Container(margin: EdgeInsets.only(top:5.0)),														
																Text(DateFormat("dd-MMM-y H:m").format(DateTime.parse(this.news[index]["_source"]["publishedAt"])),style: TextStyle(fontSize: 12.0))
															]
														),
														onTap: () async
														{
															await Store.store.setString("title", this.news[index]["_source"]["title"]);
															await Store.store.setString("description", this.news[index]["_source"]["description"]);
															await Store.store.setString("created", this.news[index]["_source"]["publishedAt"]);
															await Store.store.setString("pic", this.news[index]["_source"]["urlToImage"]);
															await Store.store.setString("author", this.news[index]["_source"]["author"]);
															await Store.store.setString("content", this.news[index]["_source"]["content"]);
															await Store.store.setString("url", this.news[index]["_source"]["url"]);

															Navigator.pushNamed(context, "details");
														},
													),
													Divider(color: Colors.grey)
												],
											);											
										}	
									),
								)
							)					
						],
					)
				)				
			)
		);
	}

	fetchNews() async
	{
		showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader("Fetching latest news"));

		Api apiClient = Api();
		await Store.init();

		Messenger();

		String url = this.prefixUrl + "/headlines/fetch";

		Map body = {};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		print(parsedResponse);

		if(parsedResponse["status"] == 200)
		{
			var range = new Random();
			randomIndex = range.nextInt(10);

			setState(() 
			{
				this.news = parsedResponse["data"];

				this.firstTitle = parsedResponse["data"][randomIndex]["_source"]["title"];
				this.firstDate = parsedResponse["data"][randomIndex]["_source"]["publishedAt"];
				this.firstPic = parsedResponse["data"][randomIndex]["_source"]["urlToImage"];
			});
		}

		Navigator.pop(context);
	}

}