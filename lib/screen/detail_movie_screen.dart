import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/constant/api_url.dart';
import 'package:flutter_application_2/db/database_helper.dart';
import 'package:flutter_application_2/model/movie_table.dart';
import 'package:flutter_application_2/service/movie_service.dart';

class DetailMovieScreen extends StatefulWidget {
  final String movieId;
  const DetailMovieScreen({super.key, required this.movieId});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  late MovieTable? _movieTable;
  bool _isInsert = false;

  Future<void> insertWatchList(MovieTable movie) async {
    await DatabaseHelper().insertWatchlist(movie);
    setState(() {});
  }

  Future<void> removeWatchList(MovieTable movie) async {
    await DatabaseHelper().removeWatchlist(movie);
    setState(() {});
  }

  void getMovieById(int id) async {
    _movieTable = await DatabaseHelper().getMovieById(id);
    if (_movieTable != null) {
      _isInsert = true;
    } else {
      _isInsert = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    _movieTable = MovieTable(
      id: -1,
      title: 'title',
      posterPath: '',
      overview: '',
    );
    getMovieById(int.parse(widget.movieId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Movie'),
      ),
      body: FutureBuilder(
        future: MovieService().getDetailMovie(
          widget.movieId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var detailMovie = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.network(
                    "$urlImage/${detailMovie?.posterPath ?? "-"}",
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (_isInsert == false) {
                              _isInsert = true;

                              await insertWatchList(
                                MovieTable(
                                  id: detailMovie?.id ?? -1,
                                  title: detailMovie?.title ?? "",
                                  overview: detailMovie?.overview ?? "",
                                  posterPath: detailMovie?.posterPath ?? "",
                                ),
                              );
                            } else {
                              _isInsert = false;

                              await removeWatchList(
                                MovieTable(
                                  id: detailMovie?.id ?? -1,
                                  title: detailMovie?.title ?? "",
                                  overview: detailMovie?.overview ?? "",
                                  posterPath: detailMovie?.posterPath ?? "",
                                ),
                              );
                            }
                            setState(() {});
                          },
                          icon: _isInsert == true
                              ? const Icon(
                                  Icons.delete,
                                )
                              : const Icon(
                                  Icons.add,
                                ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(detailMovie?.title ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(detailMovie?.overview ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      detailMovie?.originalLanguage.toUpperCase() ?? "",
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            Text(
              snapshot.error.toString(),
            );
          }
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
