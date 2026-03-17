import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Riesgo Colima")),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(19.2433, -103.7256), // Coordenadas de Colima Centro
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.alertavioleta', // IMPORTANTE para que se vea el mapa
          ),
          MarkerLayer(
            markers: [
              // Pin de prueba en el Tec de Colima
              Marker(
                point: const LatLng(19.2435, -103.7251),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () => _mostrarDetalle(context),
                  child: const Icon(Icons.location_on, color: Colors.purple, size: 45),
                ),
              ),
              // Pin de prueba en Jardín Libertad
              Marker(
                point: const LatLng(19.2433, -103.7272),
                width: 60,
                height: 60,
                child: const Icon(Icons.location_on, color: Colors.red, size: 45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarDetalle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        width: double.infinity,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Zona: Av. Tecnológico", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Reportes: 5 incidentes hoy"),
            Text("Nivel de Riesgo: Alto", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}