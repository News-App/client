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
						margin: EdgeInsets.only(top:13),
						child: ListView.builder
						(
							itemCount: news.length,
							itemBuilder: (context, index)
							{
								return
								(
									Container
									(
										// padding: EdgeInsets.only(top:18),
										// height: 65,
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