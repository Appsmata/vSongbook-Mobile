import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vsongbook/models/callbacks/Book.dart';
import 'package:vsongbook/models/callbacks/Song.dart';
import 'package:vsongbook/models/base/event_object.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:http/http.dart' as http;

List<Book> parseBooks(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Book>((json) => Book.fromJson(json)).toList();
}

Future<List<Book>> fetchBooks(String responseBody) async {
  return compute(parseBooks, responseBody);
}

Future<EventObject> getSongbooks() async {
  try {
    final response = await http.get(APIConstants.baseUrl + APIOperations.booksSelect);
    if (response != null) {
      if (response.statusCode == APIResponseCode.scOK && response.body != null) {
        List<Book> books = await fetchBooks(response.body);
        return EventObject(id: EventConstants.requestSuccessful, object: books);
      } 
      else {
        return EventObject(id: EventConstants.requestUnsuccessful);
      }
    } 
    else {
      return EventObject();
    }
  } 
  catch (Exception) {
    return EventObject();
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
  try {
    final response = await http.get(APIConstants.baseUrl + APIOperations.postsSelect + "?books=" + books);

    if (response != null) {
      if (response.statusCode == APIResponseCode.scOK && response.body != null) {
        List<Song> songs = await fetchSongs(response.body);
        return EventObject(id: EventConstants.requestSuccessful, object: songs);
      } 
      else {
        return EventObject(id: EventConstants.requestUnsuccessful);
      }
    } 
    else {
      return EventObject();
    }
  } 
  catch (Exception) {
    return EventObject();
  }
}
