import "package:flutter/material.dart";

class Loader extends StatelessWidget
{
	final String message;

	Loader(this.message);

	Widget build(BuildContext context)
	{
		return AlertDialog
		(
			content: Container
			(
				padding: EdgeInsets.only(top: 20.0),
				height: 100.0,
				width: 100.0,
				child: Column
				(																							
					children: 
					[
						CircularProgressIndicator
						(
							backgroundColor: Colors.green,
						),
						Container(child: Text(this.message), margin: EdgeInsets.only(top:20.0))
					]
				)
			)
		);
	}
}