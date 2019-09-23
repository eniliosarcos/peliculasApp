import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/peliculas.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider
{
  String _apiKey = '428282617d08952c4a3ca4d28f4ce30b';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();


  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getInCines() async
  {
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key' : _apiKey,
      'language': _lenguage
    });

    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);
    
    final pelicula = new Peliculas.fromJsonList(decodedData['results']);

    return pelicula.items;

  }

  Future<List<Pelicula>> getPopulares() async
  {
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key' : _apiKey,
      'language': _lenguage,
      'page'  : _popularesPage.toString()
    });

    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);
    
    final pelicula = new Peliculas.fromJsonList(decodedData['results']);
    
    final resp = pelicula.items;

    _populares.addAll(resp);
    popularesSink(_populares);

    return resp;
  }
}