import 'package:dio/dio.dart';
import 'package:flutter_application_2/constant/api_url.dart';
import 'package:flutter_application_2/model/detail_movie_response.dart';
import 'package:flutter_application_2/model/list_movie_popular_response.dart';

class MovieService {
  Future<ListMoviePopularResponse> getListMoviePopular() async {
    try {
      final response = await Dio().get(
        '$url/movie/popular?api_key=$apiKey',
      );

      return ListMoviePopularResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed Get Movie Popular $e');
    }
  }

  Future<DetailMovieResponse> getDetailMovie(String movieId) async {
    try {
      final response = await Dio().get('$url/movie/$movieId?api_key=$apiKey');

      return DetailMovieResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed Get Detail Movie  $e');
    }
  }
}
