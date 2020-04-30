import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Store.dart';

class Result extends StatelessWidget
{
	Widget build(BuildContext bcontext)
	{
		final Map arguments = ModalRoute.of(bcontext).settings.arguments as Map;
		var news = arguments["results"];
		var searchedText = arguments["searchedText"];

		return
		(
			MaterialApp
			(
				debugShowCheckedModeBanner: false,
				home: Scaffold
				(
					appBar: AppBar
					(
						backgroundColor: Colors.white70,
						title: Text("Results: " + searchedText, style: TextStyle(color: Colors.red),),
					),
					body: Container
					(
						color: Colors.white,
						margin: EdgeInsets.only(top:13),
						child: 
						news.length == 0 ? 
						Container
						(														
							padding: EdgeInsets.all(80),
							child: Column
							(			
								crossAxisAlignment: CrossAxisAlignment.center,					
								children:
								[
									Icon(Icons.search, size: 150, color: Colors.grey[300]),
									Text("Opps we couldn't find anything related to that. Please refine and try again!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.grey[500])),
								]
							)
						): 
						ListView.builder
						(
							itemCount: news.length,
							itemBuilder: (context, index)
							{
								return
								(
									Container
									(										
										child:Column
										(
											children:
											[ 
												ListTile
												(
													leading: CircleAvatar
													(
														backgroundImage: NetworkImage(news[index]["_source"]["urlToImage"]!=null? news[index]["_source"]["urlToImage"]:"https://www.publicdomainpictures.net/pictures/280000/nahled/not-found-image-15383864787lu.jpg"),
														radius: 25,
													),
													title: Text(news[index]["_source"]["title"]),
													subtitle: Text(" " + DateFormat("dd-MMM-y hh:mm").format(DateTime.parse(news[index]["_source"]["publishedAt"]))),
													onTap: () async
													{
														await Store.store.setString("title", news[index]["_source"]["title"]);
														await Store.store.setString("description", news[index]["_source"]["description"]);
														await Store.store.setString("created", news[index]["_source"]["publishedAt"]);
														await Store.store.setString("pic", news[index]["_source"]["urlToImage"]);
														await Store.store.setString("author", news[index]["_source"]["author"]);
														await Store.store.setString("content", news[index]["_source"]["content"]);
														await Store.store.setString("url", news[index]["_source"]["url"]);

														Navigator.pushNamed(bcontext, "details");
													},
													
												),
												Divider()
											]
										)

									)
									
								);
							}
						)									
					)
				)
			)
		);
	}
}