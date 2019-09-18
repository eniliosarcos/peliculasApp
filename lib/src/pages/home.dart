import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas.dart';

import 'package:peliculas/src/widgets/cardSwiper.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      ) 
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getInCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if(snapshot.hasData)
        {
          return CardSwiper(peliculas: snapshot.data);
        }
        else
        {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
              )
          );
        }
      },
    );


  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text('populares',style: Theme.of(context).textTheme.subhead,),
          FutureBuilder(
            future: peliculasProvider.getPopulares(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              return Container();
            },
          ),
        ],
      ),
    );
  }
}