import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/db/database_helper.dart';
import 'package:flutter_application_2/model/movie_table.dart';

class WatchListMovieScreen extends StatefulWidget {
  const WatchListMovieScreen({super.key});

  @override
  State<WatchListMovieScreen> createState() => _WatchListMovieScreenState();
}

class _WatchListMovieScreenState extends State<WatchListMovieScreen> {
  List<MovieTable> _listWatchlistMovie = [];
  void getWatchlist() async {
    _listWatchlistMovie = await DatabaseHelper().getWatchlistMovies();

    setState(() {});
  }

  @override
  void initState() {
    getWatchlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: ListView.builder(
        itemCount: _listWatchlistMovie.length,
        itemBuilder: (context, index) {
          return Text(
            _listWatchlistMovie[index].title ?? "",
          );
        },
      ),
    );
  }
}
