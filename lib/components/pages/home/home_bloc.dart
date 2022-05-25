import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier {  

  int currentPage = 1;
  late PageController pageController;

  void init() {
    pageController = PageController(initialPage: currentPage);
  }

  void changePage(int page) {
    currentPage = page;
    pageController.jumpToPage(page);
    notifyListeners();
  }

}