import 'package:shared_preferences/shared_preferences.dart';

class Store
{
	static SharedPreferences store;	

	static Future init() async
	{
		store = await SharedPreferences.getInstance();		
	}
}