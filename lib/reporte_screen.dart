import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class ReporteScreen extends StatefulWidget {
  @override
  _ReporteScreenState createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  // Variables de datos
  Position? _posicion;
  File? _image;
  String _datosTransporte = "No escaneado (Usa el QR)";
  bool _estaEnviando = false; // Control para reportes falsos/spam
  
  // Controlador para el Módulo E (Dibujo del agresor)
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.deepPurple,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionAutomatica(); // Hito 3
  }

  @override
  void dispose() {
    _sigController.dispose(); // Limpieza de memoria
    super.dispose();
  }

  // FUNCIÓN PARA SEGURIDAD (TOKEN UUID)
  Future<String> _obtenerTokenUnico() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token_violeta');
    if (token == null) {
      token = const Uuid().v4(); 
      await prefs.setString('user_token_violeta', token);
    }
    return token;
  }

  // Módulo C: GPS Automático
  Future<void> _obtenerUbicacionAutomatica() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() => _posicion = position);
    }
  }

  // Módulo D: Cámara
  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  // Módulo F: Escáner QR (Transporte Público)
  void _abrirScannerQR() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Escanea el QR de la Unidad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    setState(() {
                      _datosTransporte = barcode.rawValue ?? "Código ilegible";
                    });
                    Navigator.pop(context);
                    break;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            )
          ],
        ),
      ),
    );
  }

  // Módulo H: Envío de Datos a API con TOKEN
  Future<void> _enviarReporteFinal() async {
    if (_estaEnviando) return; // Evita spam

    setState(() => _estaEnviando = true);

    try {
      // 1. Obtener Token de Seguridad
      String tokenDispositivo = await _obtenerTokenUnico();

      // 2. Procesar Dibujo
      final Uint8List? dibujoBytes = await _sigController.toPngBytes();
      String dibujoBase64 = dibujoBytes != null ? base64Encode(dibujoBytes) : "";

      // 3. Procesar Foto
      String fotoBase64 = "";
      if (_image != null) {
        List<int> imageBytes = await _image!.readAsBytes();
        fotoBase64 = base64Encode(imageBytes);
      }

      // JSON Final para la API
      Map<String, dynamic> reporteJson = {
        "token_verificacion": tokenDispositivo, // Opción 1 de seguridad
        "fecha": DateTime.now().toIso8601String(),
        "latitud": _posicion?.latitude ?? 0.0,
        "longitud": _posicion?.longitude ?? 0.0,
        "evidencia_foto": fotoBase64,
        "dibujo_agresor": dibujoBase64,
        "transporte_qr": _datosTransporte,
        "estado": "Colima"
      };

      // Simulación de envío
      print("JSON listo con Token: $tokenDispositivo");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reporte verificado y enviado..."), backgroundColor: Colors.green),
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context); // Regresar al Home
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al enviar: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _estaEnviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Reporte"), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("1. Ubicación Actual (Automática)"),
            Card(
              color: Colors.purple[50],
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.purple),
                title: Text(_posicion == null ? "Localizando..." : "${_posicion!.latitude}, ${_posicion!.longitude}"),
              ),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("2. Evidencia con Cámara"),
            Center(
              child: _image == null
                  ? Container(height: 120, width: double.infinity, color: Colors.grey[200], child: const Icon(Icons.image_not_supported))
                  : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_image!, height: 150)),
            ),
            Center(
              child: TextButton.icon(onPressed: _tomarFoto, icon: const Icon(Icons.camera_alt), label: const Text("Capturar Foto")),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("3. Identificar Transporte (QR)"),
            ListTile(
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              leading: const Icon(Icons.directions_bus, color: Colors.purple),
              title: Text(_datosTransporte),
              trailing: IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: _abrirScannerQR),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("4. Descripción del Agresor (Dibujo)"),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              child: Signature(controller: _sigController, height: 150, backgroundColor: Colors.white),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => _sigController.clear(), child: const Text("Borrar Dibujo", style: TextStyle(color: Colors.red))),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _estaEnviando ? Colors.grey : Colors.purple,
                ),
                onPressed: _estaEnviando ? null : _enviarReporteFinal,
                child: _estaEnviando 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("ENVIAR REPORTE SEGURO", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
    );
  }
}