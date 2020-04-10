import "package:flutter/material.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newsapp/widgets/helpers/message.dart';

class Messenger extends StatefulWidget
{
	createState()
	{
		print("MEssger");
		return(MessengerState());
	}
}

class MessengerState extends State<Messenger>
{
	final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
	final List<Message> messages = [];

	void initState()
	{
		super.initState();
		print("MEssger1");

		// firebaseMessaging.subscribeToTopic("news");

		firebaseMessaging.configure
		(
			onMessage: (Map<String, dynamic> message) async
			{
				print("onMessage: $message");

				final notification = message['notification'];

				final snackBar = SnackBar
				(
					content: Text(message["notification"]["title"])
				);

				Scaffold.of(context).showSnackBar(snackBar);

				setState(() 
				{
					messages.add(Message(title: notification["title"], body: notification["body"]));
				});
			},
			onLaunch: (Map<String, dynamic> message) async
			{
				print("onMessage: $message");
			},
			onResume: (Map<String, dynamic> message) async
			{
				print("onMessage: $message");
			}
		);

		firebaseMessaging.requestNotificationPermissions
		(
			const IosNotificationSettings(sound: true, badge: true, alert:true)
		);
		
		print("MEssger2");
	}

	Widget build(BuildContext context)
	{
		return
		(
			ListView
			(
				children: messages.map(buildMessage).toList()
			)
		);
	}

	Widget buildMessage(Message message)
	{
		return
		(
			ListTile
			(
				title: Text(message.title),
				subtitle: Text(message.body),
			)
		);
	}	
}