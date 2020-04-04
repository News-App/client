
import 'package:flutter/material.dart';
import 'package:newsapp/widgets/home.dart';
// import 'package:newsapp/widgets/login.dart';

void main() 
{
	runApp(MaterialApp
	(
		debugShowCheckedModeBanner: false,
		title: "News App",
		initialRoute: "/",
		routes: 
		{
			// "/": (context) => Login(),
			"/": (context) => Home()
		}
	));
}



