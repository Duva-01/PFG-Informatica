import 'package:flutter/material.dart';

class PaginaCartera extends StatelessWidget {

  final Function? toggle;

  PaginaCartera({this.toggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartera'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => toggle!() ?? {}, 
        ),
      ),
      body: Center(
        child: Text('Detalles de la cartera aquí'),
      ),
    );
  }
}
