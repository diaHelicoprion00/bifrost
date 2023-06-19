import 'package:flutter/widgets.dart';
import 'package:bifrost/app/app.dart';
import 'package:bifrost/home/view/home_page.dart';
import 'package:bifrost/login/login.dart';

/// Returns a page route depending on the AppStatus state.
List<Page<dynamic>> onGenerateAppViews(
AppStatus state,
    List<Page<dynamic>> pages
){
  switch(state){
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}