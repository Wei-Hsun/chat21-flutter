import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  var url =
      Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var itemCount = jsonResponse['totalItems'];
    print('Number of books about http: $itemCount.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> sendMessage(
    String firebaseIdToken,
    String senderId,
    String senderFullname,
    String recipientId,
    String recipientFullname,
    String messageText,
    String channelType,
    String type,
    String attributes,
    String metadata) async {
  String uriString =
      "https://us-central1-crm-flutter-denovortho.cloudfunctions.net/api/tilechat/messages";
  Uri uri = Uri.parse(uriString);
  var response = await http.post(uri,
      headers: {
        // 'Content-type': 'application/json; charset=UTF-8',
        'Content-type': 'application/json',
        "Authorization": "Bearer " + firebaseIdToken,
      },
      // body: utf8.encode(jsonEncode({
      body: jsonEncode({
        "sender_fullname": senderFullname,
        "recipient_id": recipientId,
        "recipient_fullname": recipientFullname,
        "text": messageText,
        "channel_type": channelType,
        "type": type,
        "attributes": attributes,
        "metadata": metadata
      }));

  var responseBody = response.body;
}

Future<void> updateName(
    String firebaseIdToken, String firstName, String lastName, String email) async {
  String uriString =
      "https://us-central1-crm-flutter-denovortho.cloudfunctions.net/api/tilechat/contacts";
  Uri uri = Uri.parse(uriString);
  var response = await http.post(uri,
      headers: {
        // 'Content-type': 'application/json; charset=UTF-8',
        'Content-type': 'application/json',
        "Authorization": "Bearer " + firebaseIdToken,
      },
      // body: utf8.encode(jsonEncode({
      body: jsonEncode({
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
      }));

  var responseBody = response.body;
}

Future<void> creatGroup(
    String firebaseIdToken, String groupName, String surgery) async {
  String uriString =
      "https://us-central1-crm-flutter-denovortho.cloudfunctions.net/api/tilechat/groups";
  Uri uri = Uri.parse(uriString);
  var response = await http.post(uri,
      headers: {
        // 'Content-type': 'application/json; charset=UTF-8',
        'Content-type': 'application/json',
        "Authorization": "Bearer " + firebaseIdToken,
      },
      // body: utf8.encode(jsonEncode({
      body: jsonEncode({
        "group_name": groupName+" 手術："+surgery,
        "group_members": {"ETB4ONSnLScqpDpJ4y6GokXZsDs2":1},
      }));

  var responseBody = response.body;
}
