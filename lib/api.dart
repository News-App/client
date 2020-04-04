import 'dart:convert';
import 'dart:io';

class Api 
{
	final String baseUrl = "https://the-news-app-1.herokuapp.com";

	Future<String> post(String url, Map body) async 
	{
		HttpClient httpClient = new HttpClient();
		String contentType = "application/json";

		HttpClientRequest request = await httpClient.postUrl(Uri.parse(this.baseUrl + url));
		request.headers.set('content-type', contentType);
		request.add(utf8.encode(json.encode(body)));
		
		HttpClientResponse response = await request.close();
		
		String reply = await response.transform(utf8.decoder).join();
		httpClient.close();
		
		return reply;
	}
}