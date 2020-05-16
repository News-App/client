import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/widgets/loader.dart';

class SearchPage extends StatefulWidget
{
	createState()
	{
		return(SearchPageState());
	}
}

class SearchPageState extends State<SearchPage>
{
	List<dynamic> trendingSearches = [];
	
	final prefixUrl = "/news";
	
	var message = "Here are the top 2 searches at the moment. Go ahead and click them to see some interesting results that popped up";

	void initState()
	{
		super.initState();		

		WidgetsBinding.instance.addPostFrameCallback((_)
		{				
			fetchTrending();		
		});
	}
	
	Widget build(BuildContext bcontext)
	{
		return 
		(
			MaterialApp
			(
				debugShowCheckedModeBanner: false,
				home: Scaffold
				(
					appBar: AppBar
					(
						backgroundColor: Colors.white,
						title: Text("Trending Searches", style: TextStyle(color: Colors.redAccent)),						
					),
					body: Container
					(										
						child: Column
						(
							children: 
							[
								Container
								(
									padding: EdgeInsets.all(14),
									width: double.infinity,									
									height: 80,
									child: Text(message, style: TextStyle(fontSize: 15)),
								),
								Expanded
								(
									child: ListView.builder
									(
										itemCount: this.trendingSearches.length,
										itemBuilder: (context, index) 
										{
											return Column
											(
												children: 								
												[										
													ListTile
													(
														onTap: () 
														{
															this.search(this.trendingSearches[index]["_source"]["searched"], bcontext);
														},
														dense: true,
														leading: Icon(Icons.wifi_tethering, color: Colors.redAccent),
														title: Text(this.trendingSearches[index]["_source"]["searched"], style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 16)),
														subtitle: Text("Searches: " + this.trendingSearches[index]["_source"]["counter"].toString()),
													),
													Divider()
												]
											);
										}
									)
								)
							],
						)
						
					)
				)
			)
		);
	}

	fetchTrending() async
	{
		showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader("Fetching Trending Searches"));

		// Make an api call.
		print("I was called!");

		Api apiClient = Api();

		String url = this.prefixUrl + "/trending";

		var response = await apiClient.get(url);
		var parsedResponse = jsonDecode(response);

		print(parsedResponse);

		Navigator.pop(context);

		setState(() 
		{
			message = parsedResponse["message"];	
			this.trendingSearches = parsedResponse["data"];				
		});
	}

	search(String searchText, BuildContext context) async
	{		
		showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader("Fetching results for search"));

		Api apiClient = Api();

		String url = this.prefixUrl + "/search/";

		Map body = 
		{
			"search": searchText
		};

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		Navigator.pop(context);
	
		var news = parsedResponse["data"];		

		if (parsedResponse["status"] == 200)
		{
			print("pushing");

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
}