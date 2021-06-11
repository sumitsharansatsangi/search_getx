import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:search_getx/controller.dart';

class Home extends GetView<Controller> {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(Controller());
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller.floatingSearchBarController,
        body: FloatingSearchBarScrollNotifier(
            child: Obx(
                () => SearchResultsListView(controller.selectedTerm.value))),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          controller.selectedTerm.value == "" ? "" : "The Search App",
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: "Search and Find Out...",
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          controller.filteredSearchHistory =
              controller.filterSearchTerms(query);
        },
        onSubmitted: (query) {
          controller.addSearchTerm(query);
          controller.selectedTerm.value = query;
          controller.floatingSearchBarController.close();
        },
        builder: (context, transition) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                  color: Colors.white,
                  elevation: 4,
                  child: Obx(
                    () {
                      if (controller.filteredSearchHistory.isEmpty &&
                          controller
                              .floatingSearchBarController.query.isEmpty) {
                        return Container(
                          height: 56,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "Start searching",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        );
                      } else if (controller.filteredSearchHistory.isEmpty) {
                        return ListTile(
                          title: Text(
                              controller.floatingSearchBarController.query),
                          leading: const Icon(Icons.search),
                          onTap: () {
                            controller.addSearchTerm(
                                controller.floatingSearchBarController.query);
                            controller.selectedTerm.value =
                                controller.floatingSearchBarController.query;
                            controller.floatingSearchBarController.close();
                          },
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: controller.filteredSearchHistory
                              .map((term) => ListTile(
                                    title: Text(
                                      term,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: const Icon(Icons.history),
                                    trailing: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        controller.deleteSearchTerm(term);
                                      },
                                    ),
                                    onTap: () {
                                      controller.putSearchTermFirst(term);
                                      controller.selectedTerm.value = term;
                                      controller.floatingSearchBarController
                                          .close();
                                    },
                                  ))
                              .toList(),
                        );
                      }
                    },
                  )));
        },
      ),
    );
  }
}

class SearchResultsListView extends GetView {
  final String searchTerm;

  const SearchResultsListView(this.searchTerm);

  @override
  Widget build(BuildContext context) {
    if (searchTerm == "") {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context);

    return ListView(
      padding: EdgeInsets.only(top: fsb!.value.height + fsb.value.margins.top),
      children: List.generate(
        50,
        (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
        ),
      ),
    );
  }
}
