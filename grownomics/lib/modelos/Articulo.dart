class Articulo {
  String seccion;
  String titulo;
  String resumen;
  String contenido;
  String imageUrl; // Enlace de la imagen

  Articulo({
    required this.seccion,
    required this.titulo,
    required this.resumen,
    required this.contenido,
    required this.imageUrl,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      seccion: json['seccion'] ?? '',
      titulo: json['titulo'] ?? '',
      resumen: json['resumen'] ?? '',
      contenido: json['contenido'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
