import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Store.dart';
import 'package:newsapp/api.dart';


 class Categories extends StatefulWidget
 {
	 createState()
	 {
		 return CatergoryState();
	 }
 }

 class CatergoryState extends State<Categories>
 {
	 final String  prefixUrl = "/news";

  	List<dynamic> categories = [{"_source":{"name":""}}];
  
  

  	void initState()
  	{
  		super.initState();

  		var savedCategory = Store.store.getString("categories");

  		if (savedCategory != null)
  		{
  			this.categories = jsonDecode(savedCategory);
  		}

  		WidgetsBinding.instance.addPostFrameCallback((_) async
  		{
  			await fetchCategories();
  		});
  	}
	Widget build(BuildContext context)
	{
		return MaterialApp
		(
			debugShowCheckedModeBanner: false,
			home: Scaffold
			(
				appBar: AppBar
				(
					title: Text("Categories"),
				),
				body: GridView.builder
				(
					itemCount: categories.length,
					gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
					itemBuilder: (BuildContext context, int index)
					{
						return GestureDetector
						(
							child: Card
							(
								elevation: 5.0,
								child: Column
								(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: 
									[
									 	Text(this.categories[index]["_source"]["name"],),
									]
								)
							),
							onTap: ()
							{
								
							},
						 );
					 },
				 ),

			 ),
		 );
	 }

	fetchCategories() async
  	{
  		print("Categories");

  		Api apiClient = Api();   
  		String url = this.prefixUrl + "/category/fetch";


  		var response = await apiClient.get(url);
  		var parsedResponse = jsonDecode(response);	

		print(parsedResponse);	

		setState(() 
  		{
  			this.categories = parsedResponse["data"];
  		});
	  

  		await Store.store.setString("categories", jsonEncode(this.categories));
  	}
 }