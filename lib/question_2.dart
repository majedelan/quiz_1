// ignore_for_file: implementation_imports

import 'dart:convert';

import 'package:faker/src/faker.dart';

void main() async {
  final categories = getCategories();
  final venues = getVenues();
  final languages = await getLanguages();



}

List<String> getCategories() {
  List<String> items = [];
  for (int i = 0; i < 1000; i++) {
    items.add(faker.lorem.words(3).join(' '));
  }
  return items;
}

List<String> getVenues() {
  List<String> items = [];
  for (int i = 0; i < 1000; i++) {
    items.add(faker.lorem.words(2).join(' '));
  }
  return items;
}

Future<List<String>> getLanguages() async {
  String jsonString = '''
    [
      "Afrikaans",
      "Albanian",
      "Amharic",
      "Arabic",
      "Armenian",
      "Azerbaijani",
      "Basque",
      "Belarusian",
      "Bengali",
      "Bosnian",
      "Bulgarian",
      "Catalan",
      "Cebuano",
      "Chichewa",
      "Chinese (Simplified)",
      "Chinese (Traditional)",
      "Corsican",
      "Croatian",
      "Czech",
      "Danish",
      "Dutch",
      "English",
      "Esperanto",
      "Estonian",
      "Filipino",
      "Finnish",
      "French",
      "Frisian",
      "Galician",
      "Georgian",
      "German",
      "Greek",
      "Gujarati",
      "Haitian Creole",
      "Hausa",
      "Hawaiian",
      "Hebrew",
      "Hindi",
      "Hmong",
      "Hungarian",
      "Icelandic",
      "Igbo",
      "Indonesian",
      "Irish",
      "Italian",
      "Japanese"
    ]
  ''';

  List<dynamic> languageList = json.decode(jsonString);
  List<String> items = List<String>.from(languageList);
  return items;
}