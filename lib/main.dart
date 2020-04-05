import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsapp/widgets/home.dart';
import 'package:newsapp/widgets/news_details.dart';

void main() 
{
	runApp(MaterialApp
	(
		debugShowCheckedModeBanner: false,
		theme: ThemeData(primaryColor: Colors.red, accentColor: Colors.white),
		home: Splash(),
		title: "News App",		
		routes: 
		{
			"home": (context) => Home(),
			"details": (context) => NewsDetails(),
		}		
	));
}

class Splash extends StatefulWidget
{
	createState()
	{
		return(SplashState());
	}
}

class SplashState extends State<Splash>
{
	Widget build(BuildContext context)
	{
		return
		(
			Container
			(
				color: Colors.redAccent,
			)
		);
	}

	initState()
	{
		super.initState();
		Timer(Duration(seconds:5), ()
		{
			Navigator.pushReplacementNamed(context, "home");
		});
	}
}



