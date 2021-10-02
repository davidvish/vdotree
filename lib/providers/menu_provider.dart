import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:IQRA/common/apipath.dart';
import 'package:IQRA/common/global.dart';
import 'package:IQRA/models/menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:IQRA/common/route_paths.dart';

class MenuProvider with ChangeNotifier {
  MenuModel menuModel = new MenuModel();
  List<Menu> menuList = [];

  Future<MenuModel> getMenus(BuildContext context) async {
    final response = await http.get(APIData.topMenu, headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $authToken",
    });
    if (response.statusCode == 200) {
      menuModel = MenuModel.fromJson(json.decode(response.body));
      menuList = List.generate(menuModel.menu.length, (index) {
        return Menu(
          id: menuModel.menu[index].id,
          name: menuModel.menu[index].name,
          slug: menuModel.menu[index].slug,
          position: menuModel.menu[index].position,
          createdAt: menuModel.menu[index].createdAt,
          updatedAt: menuModel.menu[index].updatedAt,
        );
      });
    } else if (response.statusCode == 401) {
      await storage.deleteAll();
      Navigator.pushNamed(context, RoutePaths.introSlider);
      throw "Can't get menus";
    } else {
      throw "Can't get menus";
    }
    notifyListeners();
    return menuModel;
  }
}
