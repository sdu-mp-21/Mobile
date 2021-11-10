import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'home/navigation_drawer_widget.dart';
import 'constants.dart' as AppColors;

import 'dart:collection';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  int _itemCount = 0;
  List<String> titles = [];
  List<String> authors = [];
  var jsonResponse;
  var map = {};

  String _Query;

  Future<void> getQuotes(query) async {
    String url = "http://10.0.2.2:5000/?query=$query";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body);
        _itemCount = jsonResponse.length;
      });
//      jsonResponse[0]["author"]; = author name
//      jsonResponse[0]["quote"]; = quotes text
      for(int i = 0; i< jsonResponse.length; i++)
      {
        titles.add(jsonResponse[i]['author']);
      }
      for(int i = 0; i< jsonResponse.length; i++)
      {
        authors.add(jsonResponse[i]['quote']);
      }
      print("Number of quotes found : $_itemCount.");
      print(titles);
      print(authors);
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  static const historyLength = 5;

  List<String> _searchHistory = [
    'math',
    'physics',
    'astronomy',
    'geometry',
  ];

  List<String> filteredSearchHistory;

  String selectedTerm;

  List<String> filterSearchTerms({
    String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.MAIN_COLOR,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          foregroundColor: const Color(0xFF131315),
          titleTextStyle: TextStyle(
            color: const Color(0xFF131315),
            fontSize: 18,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: const Color(0xFFF3F5F7), // Status bar
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: const Color(0xFFF3F5F7),
          elevation: 0,
          title: Text(
            "Search",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: FloatingSearchBar(
          margins: const EdgeInsets.only(left: 13, right: 13, top: 13),
          padding: const EdgeInsets.fromLTRB(8, 3, 1, 1),
          elevation: 3,
          controller: controller,
          body: FloatingSearchBarScrollNotifier(
            child: SearchResultsListView(
              searchTerm: selectedTerm,
              itemCount: _itemCount,
              titles: titles,
              authors: authors,
              key: null,
            ),
          ),
          transition: CircularFloatingSearchBarTransition(),
          physics: BouncingScrollPhysics(),
          title: Text(
            selectedTerm ?? 'Search...',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
          hint: 'Search and find out...',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 17,
          ),
          actions: [
            FloatingSearchBarAction.searchToClear(),
          ],
          onQueryChanged: (query) {
            _Query = query;
            getQuotes(_Query);
            print(query);
            setState(() {
              _itemCount = 0;
              filteredSearchHistory = filterSearchTerms(filter: query);

            });
          },
          onSubmitted: (query) {
            _Query = query;
            print(query);

            setState(() {
              _itemCount = 0;
              addSearchTerm(query);
              selectedTerm = query;

            });
            controller.close();
          },
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                animationDuration: Duration(milliseconds: 900),
                color: Colors.white,
                elevation: 2,
                child: Builder(
                  builder: (context) {
                    if (filteredSearchHistory.isEmpty &&
                        controller.query.isEmpty) {
                      return Container(
                        height: 56,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Start searching',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    } else if (filteredSearchHistory.isEmpty) {
                      return ListTile(
                        title: Text(controller.query),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          setState(() {
                            addSearchTerm(controller.query);
                            selectedTerm = controller.query;
                          });
                          controller.close();
                        },
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filteredSearchHistory
                            .map(
                              (term) => ListTile(
                                title: Text(
                                  term,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: const Icon(Icons.history),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      deleteSearchTerm(term);
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    putSearchTermFirst(term);
                                    selectedTerm = term;
                                  });
                                  controller.close();
                                },
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchResultsListView extends StatefulWidget {
  final String searchTerm;
  final int itemCount;
  final List<String> titles;
  final List<String> authors;

  SearchResultsListView({
    Key key,
    this.searchTerm,
    this.itemCount,
    this.titles,
    this.authors
  }) : super(key: key);

  @override
  State<SearchResultsListView> createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.searchTerm == null) {
      return Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 80.0, 30.0, 0.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Browse courses",
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }

    final fsb = FloatingSearchBar.of(context);

    return Center(
      child: SingleChildScrollView(
      child: Column(
      children: <Widget>[
      Container(
      height: widget.itemCount == 0 ? 50 : 350,
      child: widget.itemCount == 0
          ? Text("Loading...")
          : ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius:
                BorderRadius.all(Radius.circular(10))),
            padding:
            EdgeInsets.only(left: 20, right: 20, top: 10),
            margin:
            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.titles[index], //quote
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  widget.authors[index], //author name
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        },
        itemCount: widget.itemCount,
      ),
    ),
    ],
    )
    )
    );
  }
}
