import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:vsongbook/models/callbacks/Book.dart';
import 'package:vsongbook/models/callbacks/Song.dart';
import 'package:vsongbook/models/callbacks/UserRequest.dart';
import 'package:vsongbook/models/callbacks/UserResponse.dart';
import 'package:vsongbook/models/callbacks/User.dart';
import 'package:vsongbook/models/base/EventObject.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:http/http.dart' as http;

Future<EventObject> signinUser(User user) async {
  String currentUrl = APIConstants.BaseUrl + APIOperations.UserSignin;
  UserRequest userRequest = new UserRequest();
  userRequest.user = user;

  try {
    final encoding = APIConstants.OctetStream;
    final response = await http.post(currentUrl, body: json.encode(userRequest.toJson()), encoding: Encoding.getByName(encoding));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK && response.body != null) {
        final responseJson = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.Success) {
          return new EventObject(id: EventConstants.User_Signin_Successful, object: apiResponse.user);
        } 
        else if (apiResponse.result == APIOperations.Missing) {
          return new EventObject(id: EventConstants.User_Not_Found);
        } 
        else {
          return new EventObject(id: EventConstants.User_Signin_Unsuccessful);
        }
      } 
      else {
        return new EventObject(id: EventConstants.User_Signin_Unsuccessful);
      }
    } 
    else {
      return new EventObject();
    }
  } 
  catch (Exception) {
    return EventObject();
  }
}

Future<EventObject> signupUser(User user) async {
  String currentUrl = APIConstants.BaseUrl + APIOperations.UserSignup;
  UserRequest userRequest = new UserRequest();
  userRequest.user = user;

  try {
    final encoding = APIConstants.OctetStream;
    final response = await http.post(currentUrl, body: json.encode(userRequest.toJson()), encoding: Encoding.getByName(encoding));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK && response.body != null) {
        final responseJson = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.Success) {
          return new EventObject(id: EventConstants.User_Signup_Successful, object: apiResponse.user);
        }
        else if (apiResponse.result == APIOperations.Failure) {
          return new EventObject(id: EventConstants.User_Signup_Unsuccessful);
        }
        else if (apiResponse.result == APIOperations.Already) {
          return new EventObject(id: EventConstants.User_Already_Registered);
        }
        else {
          return new EventObject(id: EventConstants.User_Signup_Unsuccessful);
        }
      } 
      else {
        return new EventObject(id: EventConstants.User_Signup_Unsuccessful);
      }
    } 
    else {
      return new EventObject();
    }
  } 
  catch (Exception) {
    return EventObject();
  }
}

List<Book> parseBooks(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Book>((json) => Book.fromJson(json)).toList();
}

Future<List<Book>> fetchBooks(String responseBody) async {
  return compute(parseBooks, responseBody);
}

Future<EventObject> getSongbooks() async {
  try {
    final response = await http.get(APIConstants.BaseUrl + APIOperations.BooksSelect);
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK && response.body != null) {
        List<Book> books = await fetchBooks(response.body);
        return new EventObject(id: EventConstants.Request_Successful, object: books);
      } 
      else {
        return new EventObject(id: EventConstants.Request_Unsuccessful);
      }
    } 
    else {
      return new EventObject();
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
    final response = await http.get(APIConstants.BaseUrl + APIOperations.PostsSelect + "?books=" + books);
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK && response.body != null) {
        List<Song> songs = await fetchSongs(response.body);
        return new EventObject(id: EventConstants.Request_Successful, object: songs);
      } 
      else {
        return new EventObject(id: EventConstants.Request_Unsuccessful);
      }
    } 
    else {
      return new EventObject();
    }
  } 
  catch (Exception) {
    return EventObject();
  }
}

Future<EventObject> changePassword(
    String emailId, String oldPassword, String newPassword) async {
  UserRequest apiRequest = new UserRequest();
  User user = new User( firstname: emailId, lastname: oldPassword, mobile: newPassword);

  //apiRequest.operation = APIOperations.Change_Password;
  apiRequest.user = user;

  try {
    final encoding = APIConstants.OctetStream;
    final response = await http.post(APIConstants.BaseUrl, body: json.encode(apiRequest.toJson()), encoding: Encoding.getByName(encoding));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK && response.body != null) {
        final responseJson = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.Success) {
          return new EventObject(
              id: EventConstants.Change_Password_Successful, object: null);
        } else if (apiResponse.result == APIOperations.Failure) {
          return new EventObject(id: EventConstants.Invalid_Old_Password);
        } else {
          return new EventObject(
              id: EventConstants.Change_Password_Successful);
        }
      } else {
        return new EventObject(
            id: EventConstants.Change_Password_Successful);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}
