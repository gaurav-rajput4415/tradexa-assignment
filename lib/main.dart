import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:tradexa/models/movie.dart';
void main() async{
  await DotEnv.load(fileName: ".env");
  runApp(Search());
}
class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Movie> _movies = new List<Movie>();

  @override
  void initState(){
    super.initState();
    _populateAllMovies();
  }
  void _populateAllMovies() async {
    final movies = await _fetchAllMovies();
    setState(() {
      _movies = movies;
    });
  }
  onSearchMovies(String value) async {
    final searchmovies = await _fetchSearhMovies(value);
    List<Movie> searchResult = new List<Movie>();
    searchResult = searchmovies;
    setState(() {
      _movies = searchResult;
    });
  }
  Future<List<Movie>> _fetchAllMovies() async{
    final response = await http.get('https://imdb-api.com/en/API/Top250Movies/'+DotEnv.env['API_KEY']);
    if(response.statusCode == 200){
      final result  = jsonDecode(response.body);
      Iterable list = result["items"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    }
    else{
      throw Exception("Failed to load movie");
    }
  }

  Future<List<Movie>> _fetchSearhMovies(value) async{
    final response = await http.get('https://imdb-api.com/en/API/Search/'+DotEnv.env['API_KEY']+'/'+ value);
    if(response.statusCode == 200){
      final result  = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    }
    else{
      throw Exception("Failed to load movie");
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: Text("Home", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
        ),

        body:
        // MoviesWidget(movies: _movies),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(suffixIcon: Icon(Icons.search),
                  hintText: 'Search for movies',
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                onChanged: onSearchMovies,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _movies.length,
                  itemBuilder: (context, index){
                    final movie = _movies[index];
                    return ListTile(
                      key: UniqueKey(),
                      title: Row(children: [
                        SizedBox(
                            width: 100,
                            child: ClipRRect(
                              child: Image.network(movie.image),
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                        Flexible(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movie.title),
                              movie.imDbRating == null ? Text('No Rating') : Text(movie.imDbRating)
                            ],
                          ),
                        ))
                      ],),
                    );
                  }
              ),
            )],
        )
      ),
    );
  }
}
