import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Object?> searchTerms; // Possible terms to be searched.

  CustomSearchDelegate(this.searchTerms); // Constructor.
  // TODO: Style the searchbar

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for search bar.
    return [
      // Clear the search query
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // To leave and close the search bar.
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      String itemString = item.toString(); // TODO: Make this nicer.
      if (itemString.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(itemString);
      }
    }
    print(matchQuery);
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];

        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Search suggestions
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      String itemString = item.toString();
      if (itemString.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(itemString);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            Navigator.pop(context, result);
          },
        );
      },
    );
  }
}
