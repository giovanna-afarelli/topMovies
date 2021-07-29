import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_movies/pages/search/search_controller.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/strings.dart';
import 'package:top_movies/widgets/movie_item_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text(Strings.searchHint);
  int _maxPage = 1;
  int _currentPage = 1;

  SearchController controller = SearchController();

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          controller.searchMovies(_filter.text, 1);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.searchMovies("a", _currentPage);
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: Strings.searchHint),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(Strings.searchHint);

        _filter.clear();
      }
    });
  }

  Widget _createMoviesList() {
    return Observer(
      builder: (_) {
        if (controller.searchResponseIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.searchResponseHasResults) {
          _maxPage = controller.searchResponse!.value!.totalPages!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.searchResponse!.value!.results!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return MovieItemWidget(
                movie:
                    controller.searchResponse!.value!.results!.elementAt(index),
              );
            },
          );
        } else if (controller.searchResponseHasError) {
          return Center(
            child: Text("Erro"),
          );
        } else
          return Container();
      },
    );
  }

  List<Widget> _createFooterButtons() {
    if (_currentPage > 1 && _currentPage < _maxPage) {
      return <Widget>[
        ElevatedButton.icon(
          onPressed: _getPreviousPage,
          icon: Icon(Icons.arrow_back),
          label: Text("${_currentPage - 1}"),
        ),
        ElevatedButton.icon(
          onPressed: _getNextPage,
          icon: Icon(Icons.arrow_forward),
          label: Text("${_currentPage + 1}"),
        ),
      ];
    } else if (_currentPage == 1) {
      if (_maxPage > 1) {
        return <Widget>[
          ElevatedButton.icon(
            onPressed: _getNextPage,
            icon: Icon(Icons.arrow_forward),
            label: Text("${_currentPage + 1}"),
          ),
        ];
      } else {
        return <Widget>[
          SizedBox(
            height: 0,
          )
        ];
      }
    } else {
      return <Widget>[
        ElevatedButton.icon(
          onPressed: _getPreviousPage,
          icon: Icon(Icons.arrow_back),
          label: Text("${_currentPage - 1}"),
        ),
      ];
    }
  }

  void _getNextPage() {
    _currentPage++;
    if (_currentPage < _maxPage) {
      setState(() {
        controller.searchMovies(_searchText, _currentPage);
      });
    }
  }

  void _getPreviousPage() {
    _currentPage--;
    if (_currentPage >= 1) {
      setState(() {
        controller.searchMovies(_searchText, _currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
        leading: new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: Container(
        child: _createMoviesList(),
      ),
      persistentFooterButtons: _createFooterButtons(),
    );
  }
}
