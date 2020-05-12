import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget
{
	createState()
	{
		return(SearchPageState());
	}
}

class SearchPageState extends State<SearchPage>
{
	List<Map<String, dynamic>> trendingSearches = [];

	void initState()
	{
		super.initState();		

		WidgetsBinding.instance.addPostFrameCallback((_)
		{				
			fetchTrending();		
		});
	}
	
	Widget build(BuildContext context)
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
						margin: EdgeInsets.only(top:10),
						child: ListView.builder
						(
							itemCount: 10,
							itemBuilder: (context, index) 
							{
								return Column
								(
									children: 								
									[
										ListTile
										(
											dense: true,
											title: Text('Corona Bengal', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 16)),
											subtitle: Text("234 searches"),
										),
										Divider()
									]
								);
							}
						)
					)
				)
			)
		);
	}

	fetchTrending()
	{
		// Make an api call.
		print("I was called!");
	}
}