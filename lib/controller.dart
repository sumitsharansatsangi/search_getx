import "package:get/get.dart";
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Controller extends GetxController {
  static const historyLength = 6;

  List<String> searchHistory = [
    "fuschia",
    "flutter",
    "widgets",
    "search",
    "getx",
  ].obs;
  FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();
  List<String> filteredSearchHistory = [""].obs;
  final selectedTerm = "".obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<String> filterSearchTerms(String filter) {
    if (filter.isNotEmpty) {
      return searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    } else {
      searchHistory.add(term);
      if (searchHistory.length > historyLength) {
        searchHistory.removeRange(0, searchHistory.length - historyLength);
      }
      filteredSearchHistory = filterSearchTerms("");
    }
  }

  void deleteSearchTerm(String term) {
    searchHistory.remove(term);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }
}
