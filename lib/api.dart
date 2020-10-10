import 'dart:convert';
import 'dart:io';

import 'package:newsapp/config.dart';

class Api
{
	Future<String> post(String url, Map body) async
	{
		HttpClient httpClient = new HttpClient();
		String contentType = "application/json";

		HttpClientRequest request = await httpClient.postUrl(Uri.parse(baseUrl + url));
		request.headers.set('content-type', contentType);
		request.add(utf8.encode(json.encode(body)));

		HttpClientResponse response = await request.close();

		String reply = await response.transform(utf8.decoder).join();
		httpClient.close();

		return reply;
	}

	Future<String> get(String url) async
	{
		HttpClient httpClient = new HttpClient();
		String contentType = "application/json";

		HttpClientRequest request = await httpClient.getUrl(Uri.parse(baseUrl + url));
		request.headers.set('content-type', contentType);

		HttpClientResponse response = await request.close();

		String reply = await response.transform(utf8.decoder).join();
		httpClient.close();

		return reply;
	}
}