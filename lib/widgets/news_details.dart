
// import 'dart:io';
// import 'dart:typed_data';

// import 'dart:io';
// import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
// import 'package:flutter/services.dart';
import 'package:http/http.dart';
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
			this.pic = Store.store.getString("pic") == null? ("https://www.publicdomainpictures.net/pictures/280000/nahled/not-found-image-15383864787lu.jpg"): (Store.store.getString("pic"));
			this.description = Store.store.getString("description") == null? ("NA"): (Store.store.getString("description"));
			this.content = Store.store.getString("content") == null? ("NA"): (Store.store.getString("content"));
			this.url = Store.store.getString("url") == null? ("NA"): (Store.store.getString("url"));

			print("Hello");
			print(this.title);
			print(this.author);
			print(this.created);
			print(this.pic);
			print(this.description);
			print(this.content);
			print(this.url);
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
					title: Text("In Brief", style: TextStyle(color: Colors.red)),										
					iconTheme: IconThemeData
					(
						color: Colors.red
					),
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
															Icon(Icons.face, color: Colors.red,),
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
												child: Text(this.description+ "\n\n" + this.content, style: TextStyle(fontSize: 17.0)),
											)										
										]
									)
								)							
							],
						),
					)
				),
				bottomNavigationBar: BottomAppBar
				(					
					child: Row
					(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: 
						[
							FlatButton
							(							
								child: Column
								(
									mainAxisSize: MainAxisSize.min,
									children: 
									[
										Icon(Icons.share, color: Colors.red),
										Text("Share", style: TextStyle(fontSize: 10)),
									],
								),
								onPressed: () async
								{
									var resp = await get(this.pic);										
									await Share.file(this.title, this.title, resp.bodyBytes, 'image/jpeg', text: this.title);
								},
							),
							FlatButton
							(								
								child: Column
								(
									mainAxisSize: MainAxisSize.min,
									children: 
									[
										Icon(Icons.more, color: Colors.red),
										Text("Read More", style: TextStyle(fontSize: 10)),
									],
								),
								onPressed: () async
								{
									await this.openLink(this.url);
								}
							),
						]
					)
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