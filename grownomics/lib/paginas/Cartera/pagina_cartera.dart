import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PaginaCartera extends StatelessWidget {

  final Function? toggle;

  PaginaCartera({this.toggle});

  @override
  Widget build(BuildContext context) {

    final controller = ZoomDrawer.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartera'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: Center(
        child: Text('Detalles de la cartera aquí'),
      ),
    );
  }
}
