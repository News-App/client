import 'dart:convert';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import "package:flutter/material.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Store.dart';
import 'package:newsapp/api.dart';
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
	String source = "";
	bool scraping = true;

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
			this.source = Store.store.getString("source") == null? ("NA"): (Store.store.getString("source"));

			print("Hello");
			print(this.title);
			print(this.author);
			print(this.created);
			print(this.pic);
			print(this.description);
			print(this.content);
			print(this.url);

			this.scrape(this.source, this.url);
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
					title: Row
					(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: 
						[
							Text("In Brief", style: TextStyle(color: Colors.red)),
							Visibility
							(
								visible: this.scraping,
								child: SizedBox
								(
									height: 20,
									width: 20,
									child: CircularProgressIndicator
									(									
										strokeWidth: 1,									
										backgroundColor: Colors.redAccent,
									),
								)
							)
						]
					),
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
												child: Html
												(						
													defaultTextStyle: TextStyle(fontSize: 18),							
													renderNewlines: true,
													data: this.description
												)
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

	scrape(String tag, String newsUrl) async
	{
		print("SCRAPING");
		print(tag);
		print(newsUrl);

		Api apiClient = Api();
		await Store.init();		

		String url = "/news/scrape";

		Map body = 
		{
			"url": newsUrl,
			"tag": tag
		};

		print(body);

		var response = await apiClient.post(url, body);
		var parsedResponse = jsonDecode(response);

		print(parsedResponse["data"]);

		if (parsedResponse["data"] != null)
		{
			setState(() 
			{
				this.description = parsedResponse["data"];				
			});
		}

		setState(() 
		{
			this.scraping = false;
		});
	}
}