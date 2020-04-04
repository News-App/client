import 'package:flutter/material.dart';
import 'package:newsapp/widgets/home.dart';
import 'package:newsapp/widgets/news_details.dart';

import 'widgets/home.dart';

void main() 
{
	runApp(MaterialApp
	(
		debugShowCheckedModeBanner: false,
		title: "News App",
		initialRoute: "/",
		routes: 
		{
			"/": (context) => Home(),
			"details": (context) => NewsDetails(),
		}
	));
}



