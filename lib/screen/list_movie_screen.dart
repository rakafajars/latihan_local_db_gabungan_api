import 'package:flutter/material.dart';
import 'package:flutter_application_2/constant/api_url.dart';
import 'package:flutter_application_2/screen/detail_movie_screen.dart';
import 'package:flutter_application_2/screen/watchlist_movie_screen.dart';
import 'package:flutter_application_2/service/movie_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ListMovieScreen extends StatefulWidget {
  const ListMovieScreen({super.key});

  @override
  State<ListMovieScreen> createState() => _ListMovieScreenState();
}

class _ListMovieScreenState extends State<ListMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WatchListMovieScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.movie,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Movie Popular',
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: FutureBuilder(
                      future: MovieService().getListMoviePopular(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data?.results.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var movie = data?.results[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailMovieScreen(
                                        movieId: movie?.id.toString() ?? "",
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 250,
                                  height: 100,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.network(
                                            "$urlImage/${movie?.posterPath ?? "-"}",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          movie?.originalTitle ?? "-",
                                        ),
                                        RatingBarIndicator(
                                          itemSize: 20,
                                          rating:
                                              ((movie?.voteAverage ?? 0) / 2),
                                          direction: Axis.horizontal,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 4,
                                          ),
                                        ),
                                        Text(
                                          movie?.originalLanguage
                                                  ?.toUpperCase() ??
                                              "-",
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
