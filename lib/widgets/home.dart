import 'dart:convert';
// import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Store.dart';
import 'package:newsapp/api.dart';
import 'package:toast/toast.dart';
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
	
	List<dynamic> health = [];
	List<dynamic> business = [];
	List<dynamic> headlines = [];
	List<dynamic> entertainment = [];
	List<dynamic> technology = [];
	List<dynamic> science = [];
	List<dynamic> sports = [];

	bool isSearching = false;
	
	void initState()
	{
		super.initState();		

		WidgetsBinding.instance.addPostFrameCallback((_)
		{
			firebaseInitialize();	
			fetchNews();		
		});

	}

	Widget build(BuildContext context)
	{
		final Map arguments = ModalRoute.of(context).settings.arguments as Map;
		TextEditingController searchController = TextEditingController();
		
		setState(() 
		{			
			this.news = arguments["news"];
			this.randomIndex = arguments["randomIndex"];

			this.headlines = arguments["headlines"];
			this.business = arguments["business"];
			this.health = arguments["health"];
			this.entertainment = arguments["entertainment"];
			this.technology = arguments["technology"];
			this.science = arguments["science"];
			this.sports = arguments["sports"];

			this.firstTitle = this.news[randomIndex]["_source"]["title"];
			this.firstDate = this.news[randomIndex]["_source"]["publishedAt"];
			this.firstPic = this.news[randomIndex]["_source"]["urlToImage"] == null? "https://www.teliacompany.com/Assets/Images/not-available.png": this.news[randomIndex]["_source"]["urlToImage"];
		});

		return MaterialApp
		(		
			debugShowCheckedModeBanner: false,		
			home: DefaultTabController
			(
				length: 7,				
				child: Scaffold
				(					
					appBar: AppBar
						(
							titleSpacing: 0,							
							title: Container
							(								
								height: 80,								
								child: Row
								(
									children:
									[ 										
										Container
										(											
											margin: EdgeInsets.only(left: 10),
											child: Text("Minutes", style: TextStyle(color: Colors.red)),
										),
										Expanded
										(											
											child: Container
											(	
												color: Colors.grey[100],	
												margin: EdgeInsets.only(left:8),																			
												child: TextField
												(
													controller: searchController,
													decoration: InputDecoration
													(
														contentPadding: EdgeInsets.only(left:10),
														hintText: "Search Topics",
														border: InputBorder.none,
													),
													
												),
											)
										), 		
										Container
										(
											margin: EdgeInsets.only(right: 10),
											color: Colors.grey[100],
											width: 40,
											child: IconButton
											(												
												splashColor: Colors.white,
												icon: Icon(Icons.search, color: Colors.red),
												onPressed: () 
												{
													this.search(searchController.text.trim(), context);
												}
											),
										)
									]
								)
							),														
							bottom: TabBar
							(	
								indicatorColor: Colors.redAccent,	
								indicatorWeight: 4,					
								indicatorSize: TabBarIndicatorSize.tab,
								unselectedLabelColor: Colors.grey,
								labelColor: Colors.red,
								isScrollable: true,
								tabs: 
								[
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Headlines"),
									),
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Health"),
									),
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Business"),
									),
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Sports"),
									),
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Technology"),
									),
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Science"),
									),
									Container
									(
										padding: EdgeInsets.only(bottom: 10, top:10),
										child: Text("Entertainment"),
									)
								]
							),
							backgroundColor: Colors.white,
						),					
					body: TabBarView
					(
						children: 
						[			
							this.tabSection(this.headlines, context),
							this.tabSection(this.health, context),
							this.tabSection(this.business, context),
							this.tabSection(this.sports, context),
							this.tabSection(this.technology, context),
							this.tabSection(this.science, context),
							this.tabSection(this.entertainment, context)
						],
					),	
					floatingActionButton: FloatingActionButton
					(
						backgroundColor: Colors.redAccent,
						onPressed: () 
						{
							Navigator.pushNamed(context, "search");
						},
						child: Icon(Icons.search),
					),
				),
			),		
		);
	}

 	search(String searchText, BuildContext context) async
	{
		// If the user hasn't typed anything or has pressed spaces a couple of times.
		if (searchText == "")
		{
			print("Empty Search");
			return(0);
		}

		showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader("Searching news"));

		Api apiClient = Api();

		String url = this.prefixUrl + "/search/";

		Map body = 
		{
			"search": searchText
		};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);
	
		var news = parsedResponse["data"];

		print(parsedResponse);

		Navigator.pop(context);

		if (parsedResponse["status"] == 200)
		{
			print(news);

			Navigator.pushNamed
			(
				context, 
				"result",
				arguments: 
				{
					"results": news, 
					"searchedText": searchText
				}
			);
		}
	}
	
	fetchNews({bool showLoader = true}) async
	{
		print("Fetch news");

		if (Store.store.getString("splashed") == "1")
		{
			print("Returned");
			await Store.store.setString("splashed", "0");
			return(0);
		}

		if (showLoader)
		{
			showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader("Fetching latest news"));
		}

		Api apiClient = Api();
		await Store.init();		

		String url = this.prefixUrl + "/headlines/fetch";

		Map body = {};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		// print(parsedResponse);

		if(parsedResponse["status"] == 200)
		{
			// var range = new Random();
			// randomIndex = range.nextInt(10);

			setState(() 
			{
				this.news = parsedResponse["data"];

				this.firstTitle = parsedResponse["data"][randomIndex]["_source"]["title"];
				this.firstDate = parsedResponse["data"][randomIndex]["_source"]["publishedAt"];
				this.firstPic = parsedResponse["data"][randomIndex]["_source"]["urlToImage"] == null? "https://www.teliacompany.com/Assets/Images/not-available.png": parsedResponse["data"][randomIndex]["_source"]["urlToImage"];		

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
			});
		}

		print(this.headlines);

		if (showLoader)
		{
			Navigator.pop(context);
		}
	}

	firebaseInitialize()
	{
		print("Firebase initialized");

		final FirebaseMessaging firebaseMessaging = FirebaseMessaging();		

		firebaseMessaging.configure
		(
			onMessage: (Map<String, dynamic> message) async
			{
				print("onMessage: $message");				
				
				Toast.show("Refreshing News", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

				this.fetchNews(showLoader: false);
			},
			onLaunch: (Map<String, dynamic> message) async // Called when app is terminated
			{
				print("onLaunch: $message");

				var data = message["data"];

				print(data);				

				await Store.store.setString("title", data["title"]);
				await Store.store.setString("description", data["description"]);
				await Store.store.setString("pic", data["urlToImage"]);				
				await Store.store.setString("created", data["publishedAt"]);				
				await Store.store.setString("author", data["author"]);
				await Store.store.setString("content", data["content"]);
				await Store.store.setString("url", data["url"]);

				Navigator.pushNamed(context, "details");
			},
			onResume: (Map<String, dynamic> message) async
			{
				print("onResume: $message");


				var data = message["data"];

				print(data);				

				await Store.store.setString("title", data["title"]);
				await Store.store.setString("description", data["description"]);
				await Store.store.setString("pic", data["urlToImage"]);				
				await Store.store.setString("created", data["publishedAt"]);				
				await Store.store.setString("author", data["author"]);
				await Store.store.setString("content", data["content"]);
				await Store.store.setString("url", data["url"]);

				Navigator.pushNamed(context, "details");
			}			
		);

		firebaseMessaging.subscribeToTopic("news");
	}	

	Widget tabSection(List<dynamic> data, BuildContext bcontext)
	{
		int randomIndex = 0;

		if (data.length != 0)
		{
			return 
			(
				Container
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
													image: NetworkImage(data[randomIndex]["urlToImage"] != null? (data[randomIndex]["urlToImage"]):("https://www.publicdomainpictures.net/pictures/280000/nahled/not-found-image-15383864787lu.jpg")),
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
														data[randomIndex]["title"], style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),													
													),
													Container(margin: EdgeInsets.only(top:5)),
													Text(" " + DateFormat("dd-MMM-y").format(DateTime.parse(data[randomIndex]["publishedAt"])) + " ", style: TextStyle(color: Colors.white, backgroundColor: Colors.redAccent))
												]
											)
										)
									)
								),
								onTap: () async
								{
									await Store.store.setString("title", data[randomIndex]["title"]);
									await Store.store.setString("description", data[randomIndex]["description"]);
									await Store.store.setString("created", data[randomIndex]["publishedAt"]);
									await Store.store.setString("pic", data[randomIndex]["urlToImage"]);
									await Store.store.setString("author", data[randomIndex]["author"]);
									await Store.store.setString("content", data[randomIndex]["content"]);
									await Store.store.setString("url", data[randomIndex]["url"]);

									Navigator.pushNamed(bcontext, "details");
								},
							),
							Expanded
							(
								child: Container
								(																											
									child: ListView.builder
									(
										itemCount: data.length,
										itemBuilder: (context, index)
										{	
											if (index != 0)										
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
																backgroundImage: NetworkImage(data[index]["urlToImage"]!=null?data[index]["urlToImage"]:"https://www.publicdomainpictures.net/pictures/280000/nahled/not-found-image-15383864787lu.jpg"),

																radius: 25,
															) ,
															title: Text(data[index]["title"],style: TextStyle(fontFamily: "comic-sans", fontSize: 15.0)),
															isThreeLine: true,
															subtitle: Column
															(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: 
																[
																	Container(margin: EdgeInsets.only(top:5.0)),														
																	Text(DateFormat("dd-MMM-y H:m").format(DateTime.parse(data[index]["publishedAt"])),style: TextStyle(fontSize: 12.0))
																]
															),
															onTap: () async
															{
																await Store.store.setString("title", data[index]["title"]);
																await Store.store.setString("description", data[index]["description"]);
																await Store.store.setString("created", data[index]["publishedAt"]);
																await Store.store.setString("pic", data[index]["urlToImage"]);
																await Store.store.setString("author", data[index]["author"]);
																await Store.store.setString("content", data[index]["content"]);
																await Store.store.setString("url", data[index]["url"]);

																Navigator.pushNamed(bcontext, "details");
															},
														),
														Divider(color: Colors.grey)
													],
												);
											}
											else 
											{
												return Column
												(

												);
											}
										}	
									),
								)
							)					
						],
					)								
				)
			);
		}
		else 
		{
			return
			(
				Container()
			);
		}		
	}
	
}
