import 'package:flutter/material.dart';
import 'package:top_movies/models/genres.dart';
import 'package:top_movies/models/genres_api_response.dart';

class DropDownWidget extends StatefulWidget {
  final GenresApiResponse genresList;
  final ValueChanged<int> onChanged;

  DropDownWidget({
    required this.genresList,
    required this.onChanged,
  });

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDownWidget> {
  int dropdownValue = 0;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.genresList.genres!.first.id!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<int>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.red, fontSize: 18),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (int? data) {
            setState(() {
              dropdownValue = data!;
            });
          },
          items: widget.genresList.genres!
              .map<DropdownMenuItem<int>>((Genres genre) {
            return DropdownMenuItem<int>(
              value: genre.id,
              child: Text(genre.name!),
            );
          }).toList(),
        ),
        Text('Selected Item = ' + '$dropdownValue',
            style: TextStyle(fontSize: 22, color: Colors.black)),
      ],
    );
  }
}
