// import 'package:flutter/material.dart';
// import 'package:newsapp/api.dart';
// import 'loader.dart';
// class Login extends StatefulWidget
// {
// 	createState()
// 	{
// 		return LoginState();
// 	}
// }
// class LoginState extends State<Login>
// {
// 	final String prefixUrl = '';

// 	var txtUserNameController = TextEditingController;
// 	var txtpasswordController = TextEditingController;

// 	Widget build(BuildContext context)
// 	{
// 		return Scaffold
// 		(
// 			body: SingleChildScrollView
// 			(
// 				child: Container
// 				(
// 					child: Column
// 					(
// 						children:
// 						[
// 							Padding(padding: EdgeInsets.only(top: 250)),
// 							TextFormField
// 							(
// 								decoration: InputDecoration
// 								(
// 									labelText: "Enter email"
// 								),
// 							),
// 							TextFormField
// 							(
// 								decoration: InputDecoration
// 								(
// 									labelText: "Enter password"
// 								),
// 							),
// 							// RaisedButton
// 							// (
// 							// 	onPressed: () async
// 							// 	{
// 							// 		var success = await this.userLogin(txtUserNameController.text, txtpasswordController.text);

// 							// 		if (success)
// 							// 		{
// 							// 			Navigator.pushReplacementNamed(context, "/home");
// 							// 		}											
// 							// 	},
// 							// 	child: Text("SIGNUP"),
							
// 							// ),
// 						],
// 					),
// 				),
// 			),
// 		);
// 	}

// 	Future <bool> userLogin(String username, String password)
// 	{
// 		showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => Loader('Validating User'));

// 		Api apiClient = Api();

// 		String  url = prefixUrl + '/login';

// 		Map body
// 		{
// 			'username' = username;
// 			'password' = password;
// 		}
// 	}
// }