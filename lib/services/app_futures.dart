import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/callbacks/Book.dart';
import '../data/callbacks/Song.dart';
import '../data/base/event_object.dart';
import '../utils/api_utils.dart';

List<Book> parseBooks(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Book>((json) => Book.fromJson(json)).toList();
}

Future<List<Book>> fetchBooks(String responseBody) async {
  return compute(parseBooks, responseBody);
}

Future<EventObject> getSongbooks() async {
  String apiUrl = APIConstants.baseUrl + APIOperations.booksSelect;
  var request = http.Request('GET', Uri.parse(apiUrl));
  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == APIResponseCode.scOK) {
      String apiResponse = await response.stream.bytesToString();

      List<Map<String, dynamic>> books =
          List<Map<String, dynamic>>.from(json.decode(apiResponse)["results"]);
      return EventObject(id: EventConstants.requestSuccessful, object: books);
    } else {
      return EventObject(id: EventConstants.requestUnsuccessful);
    }
  } catch (Exception) {
    return EventObject();
  } on TimeoutException catch (_) {
    return EventObject(id: EventConstants.requestUnsuccessful);
  }
}

List<Song> parseSongs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Song>((json) => Song.fromJson(json)).toList();
}

Future<List<Song>> fetchSongs(String responseBody) async {
  return compute(parseSongs, responseBody);
}

Future<EventObject> getSongs(String books) async {
  String apiUrl =
      APIConstants.baseUrl + APIOperations.postsSelect + "?books=" + books;
  var request = http.Request('GET', Uri.parse(apiUrl));
  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String apiResponse = await response.stream.bytesToString();

      List<Map<String, dynamic>> songs =
          List<Map<String, dynamic>>.from(json.decode(apiResponse)["results"]);
      return EventObject(id: EventConstants.requestSuccessful, object: songs);
    } else {
      return EventObject(id: EventConstants.requestUnsuccessful);
    }
  } catch (Exception) {
    return EventObject();
  } on TimeoutException catch (_) {
    return EventObject(id: EventConstants.requestUnsuccessful);
  }
}
