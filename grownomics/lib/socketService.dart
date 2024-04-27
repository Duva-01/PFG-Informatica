import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart'
    as IO; // Importa socket_io_client para la comunicación por socket
import 'package:shared_preferences/shared_preferences.dart'; // Importa shared_preferences para almacenar datos de forma persistente

// Definición de la URL base del servidor
//const String baseUrl = 'http://10.0.2.2:5000';
const String baseUrl = 'http://143.47.44.251:5000';

// Clase para gestionar la conexión y escuchar eventos del socket
class SocketService {
  late IO.Socket socket; // Socket para la comunicación
  
  // Plugin para gestionar las notificaciones locales
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Método para inicializar las notificaciones locales
  Future<void> initNotifications() async {
    // Configuración de inicialización para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Método para cerrar la conexión del socket
  void disconnect() {
    socket.disconnect();
    print("Desconectado del WebSocket");
  }

  // Método para conectar y escuchar eventos del socket
  void connectAndListen(String userEmail) async {
    await initNotifications(); // Inicializa las notificaciones locales

    // Conexión al servidor por WebSocket
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(
              ['websocket']) // Configura el transporte como WebSocket
          .disableAutoConnect() // Deshabilita la conexión automática
          .build(),
    );

    socket.connect(); // Conecta al servidor

    // Evento al establecer conexión con el servidor
    socket.onConnect((_) {
      print('Conectado a WebSocket: me uno a la sala $userEmail');
      socket.emit('join',
          {'email': userEmail}); // Se une a una sala con el email del usuario
    });

    // Evento de alerta de stock
    socket.on('stock_alert', (data) async {
      if (data is Map<String, dynamic>) {
        final title = 'Alerta de Acción';
        final body = data['message']; // Mensaje de la alerta
        await _showNotification(
            title, body ?? 'Detalle no disponible'); // Muestra la notificación
      }
    });

    // Evento de respuesta de prueba
    socket.on('test_response', (data) async {
      final title = 'Respuesta de Test';
      final body = data.toString(); // Cuerpo de la respuesta
      await _showNotification(title, body); // Muestra la notificación
    });
  }

  // Dentro de SocketService

// Método para verificar si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lee el valor de la preferencia, asume true por defecto
    return prefs.getBool('notificationsEnabled') ?? true;
  }

  // Método privado para mostrar una notificación
  Future<void> _showNotification(String title, String body) async {
    if (await areNotificationsEnabled()) {
      // Configuración de la notificación para Android
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your channel id',
        'Notificacion grownomics',
        'Notificacion',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0, 
        title,
        body,
        platformChannelSpecifics,
        payload: 'item x',
      );
    }
  }

  

  // Método para enviar un evento de prueba al servidor
  void sendTestEvent() {
    print("Envío test");
    socket.emit('test', 'Soy el cliente te paso este mensaje');
  }
}

// Método para obtener el email del usuario almacenado en SharedPreferences
Future<String> getUserEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail') ??
      ''; // Devuelve el email del usuario o un string vacío si no está disponible
}
