import 'dart:convert';

import 'package:flutter/services.dart';

class Item {
  String name;
  String ingredients;
  String diet;

  String flavorProfile;
  String course;
  String state;
  String region;
  String comment;
  String ingredients1;
  String recipe1;
  String recipe2;
  String recipe3;
  String nutritions;

  Item(
      {this.name,
      this.ingredients,
      this.diet,
      this.flavorProfile,
      this.course,
      this.state,
      this.region,
      this.comment,
      this.ingredients1,
      this.recipe1,
      this.recipe2,
      this.recipe3,
      this.nutritions});

  Item.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ingredients = json['ingredients'];
    diet = json['diet'];

    flavorProfile = json['flavor_profile'];
    course = json['course'];
    state = json['state'];
    region = json['region'];
    comment = json['comment'];
    ingredients1 = json['ingredients__1'];
    recipe1 = json['recipe1'];
    recipe2 = json['recipe2'];
    recipe3 = json['recipe3'];
    nutritions = json['Nutritions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ingredients'] = this.ingredients;
    data['diet'] = this.diet;

    data['flavor_profile'] = this.flavorProfile;
    data['course'] = this.course;
    data['state'] = this.state;
    data['region'] = this.region;
    data['comment'] = this.comment;
    data['ingredients__1'] = this.ingredients1;
    data['recipe1'] = this.recipe1;
    data['recipe2'] = this.recipe2;
    data['recipe3'] = this.recipe3;
    data['Nutritions'] = this.nutritions;
    return data;
  }
}
