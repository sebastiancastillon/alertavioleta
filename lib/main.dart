import 'package:flutter/material.dart';
import 'reporte_screen.dart';
import 'mapa_screen.dart';

void main() => runApp(const MaterialApp(
      // ESTA LÍNEA QUITA EL BOTÓN DE DEBUG
      debugShowCheckedModeBanner: false, 
      home: AlertaVioletaApp(),
    ));

class AlertaVioletaApp extends StatelessWidget {
  const AlertaVioletaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Alerta Violeta Colima",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_moon, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text("Menú Alerta", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_alert, color: Colors.purple),
              title: const Text("Nuevo Reporte"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ReporteScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.purple),
              title: const Text("Ver Mapa de Riesgo"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => MapaScreen())),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ESTADO DE EMERGENCIA",
              style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 30),
            
            // BOTÓN GIGANTE MORADO
            SizedBox(
              width: 280,
              height: 280,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 12,
                  shadowColor: Colors.purpleAccent,
                ),
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (c) => ReporteScreen())
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 80),
                    SizedBox(height: 10),
                    Text(
                      "REPORTAR\nAHORA",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              "Tu reporte será enviado\nde forma anónima.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.purple, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}