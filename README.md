# 💜 Alerta Violeta Colima

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Status](https://img.shields.io/badge/Status-Prototipo_Funcional-blueviolet?style=for-the-badge)

**Alerta Violeta Colima** es una aplicación móvil híbrida desarrollada en Flutter para combatir el acoso callejero en nuestro estado. Diseñada para víctimas y testigos, esta herramienta permite generar reportes anónimos con evidencia sólida para visibilizar zonas de riesgo y presionar por soluciones reales en Colima.

---

## 📸 Vista Previa (Screenshots)

| Inicio (Botón de Pánico) | Formulario de Reporte | Mapa de Calor |
|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Reporte](screenshots/reporte.png) | ![Mapa](screenshots/mapa.png) |

| Evidencia (Cámara/SS) | Descripción Visual | Escáner de Transporte |
|:---:|:---:|:---:|
| ![Evidencia](screenshots/evidencia.png) | ![Canvas](screenshots/dibujo.png) | ![QR](screenshots/qr.png) |

---

## 🎯 El Reto en Colima
Colima presenta índices críticos de violencia de género. Esta app busca eliminar las barreras de reporte:
1. **Miedo:** Reportes 100% anónimos.
2. **Falta de Evidencia:** Captura de fotos y screenshots.
3. **Ubicación:** Registro automático del lugar del incidente para mapas de calor.

---

## 🛠️ Arquitectura y Hitos (A-H)

### 📍 Módulo C: GPS Automático (Hito 3)
Captura inmediata de coordenadas `latitud` y `longitud` al abrir el formulario mediante `geolocator`, garantizando la precisión del mapa de riesgo sin fricción para el usuario.

### 📸 Módulo D: Evidencia Multimedia (Hito 2)
Integración de cámara y selección de galería. Permite adjuntar fotos del agresor/lugar o **screenshots** de mensajes de acoso, procesándolos en Base64 para su envío.

### ✍️ Módulo E: Canvas de Dibujo (Signature)
Lienzo interactivo para realizar descripciones visuales rápidas (vestimenta, rasgos, señas particulares) en situaciones donde no es seguro tomar una fotografía.

### 🚌 Módulo F: Escáner QR de Transporte
Identificación de rutas y unidades de transporte público mediante la lectura de códigos QR, vinculando automáticamente el reporte a la unidad específica.

### 🗺️ Módulo G: Visualización en Mapa (Hito 4)
Renderizado de pines interactivos en el estado de Colima utilizando `flutter_map`. Los reportes alimentan un mapa de calor para identificar zonas de alta incidencia.

### 🛡️ Módulo H: Seguridad y Token UUID
Para evitar reportes falsos o spam, se implementó un sistema de **identidad anónima basada en tokens UUID** únicos por dispositivo (`shared_preferences`). Esto permite validar la autenticidad del emisor sin recolectar datos personales.

---

## 📦 Tecnologías
- **Framework:** Flutter (Dart)
- **Mapas:** OpenStreetMap & flutter_map
- **Escáner:** Mobile Scanner
- **Persistencia:** Shared Preferences (Security Tokens)

---

## 🎓 Créditos
Desarrollado para el **TecNM Campus Colima** - Departamento de Sistemas y Computación.
Asignatura: **Desarrollo de Aplicaciones Híbridas.**

---
*"No es un halago, es violencia. Recuperemos la seguridad en las calles de Colima."* 💜
