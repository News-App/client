import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:newsapp/Store.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget
{
	createState() 
	{
		return(NewsDetailsState());
	}
}

class NewsDetailsState extends State<NewsDetails>
{
	String title = "";
	String author = "";
	String created = "";
	String pic = "";
	String description = "";
	String content = "";
	String url = "";

	void initState()
	{
		super.initState();

		try
		{
			this.title = Store.store.getString("title") == null? ("NA"): (Store.store.getString("title"));
			this.author = Store.store.getString("author") == null? ("NA"): (Store.store.getString("author"));
			this.created = Store.store.getString("created") == null? ("NA"): (DateFormat("dd-MMM-y").format(DateTime.parse(Store.store.getString("created"))));
			this.pic = Store.store.getString("pic") == null? ("NA"): (Store.store.getString("pic"));
			this.description = Store.store.getString("description") == null? ("NA"): (Store.store.getString("description"));
			this.content = Store.store.getString("content") == null? ("NA"): (Store.store.getString("content"));
			this.url = Store.store.getString("url") == null? ("NA"): (Store.store.getString("url"));

			print(this);
		}
		catch(e)
		{
			print(e);
		}
	}

	Widget build(BuildContext context)
	{
		return
		(
			Scaffold
			(
				appBar: AppBar
				(
					backgroundColor: Colors.white,
				),
				body: SingleChildScrollView
				(
					child: Container
					(					
						child: Column
						(
							crossAxisAlignment: CrossAxisAlignment.start,
							children:
							[
								Container
								(
									child: Image.network(this.pic),
								),
								Container
								(
									padding: EdgeInsets.all(15.0),
									child: Column
									(
										children: 
										[
											Text(this.title, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
											Container(margin:EdgeInsets.only(bottom:5.0)),
											Row
											(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: 
												[
													Row
													(
														children: 
														[
															Icon(Icons.face, color: Colors.green,),
															Text(" " + this.author)
														]
													),
													Text(this.created)
												],
											),					
											Divider
											(
												color: Colors.red,
											),
											Container
											(																						
												child: Text(this.description+ "\n\n" + this.content.substring(0,260), style: TextStyle(fontSize: 17.0)),
											)										
										]
									)
								)							
							],
						),
					)
				),
				bottomNavigationBar: BottomNavigationBar
				(
					currentIndex: 1,
					items: 
					[
						BottomNavigationBarItem
						(							
							title: Text("Share"),
							icon: Icon(Icons.message)
						),						
						BottomNavigationBarItem
						(
							title: Text("Read More"),
							icon: IconButton
							(
								onPressed: () async
								{
									await this.openLink(this.url);
								},
								icon: Icon(Icons.more),
							)
						),
						BottomNavigationBarItem
						(
							title: Text("Bookmark"),
							icon: Icon(Icons.bookmark)
						)
					]
				)
			)
		);
	}

	openLink(String url) async
	{
		if (await canLaunch(url))
		{
			await launch(url);
		}
		else 
		{
			throw "Could Not Open" + url;
		}
	}
}