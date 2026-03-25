# ALX-Clima — Plan de Acción / Action Plan

## Resumen del Proyecto
App Flutter (Android + iOS) para un técnico HVAC independiente que permite a sus clientes:
1. Cotizar equipos HVAC/Mini Split con instalación y garantía
2. Cotizar solo instalación (cliente compra su propio equipo, sin garantía)
3. Ver su dashboard de equipos instalados, historial de servicio y agendar mantenimientos
4. Sección futura para servicios adicionales (paneles solares, electricidad, etc.)

**Idioma:** Español | **Tema:** Blanco, moderno, futurista | **Framework:** Flutter

---

## Arquitectura de Alto Nivel

```
lib/
├── main.dart                      # Entry point, theme, routing
├── config/
│   ├── theme.dart                 # White futuristic theme (colors, fonts, etc.)
│   ├── routes.dart                # Named routes / GoRouter config
│   └── constants.dart             # Pricing constants, warranty info, labels
├── models/
│   ├── equipment.dart             # Equipment model (type, brand, BTU, price)
│   ├── installation.dart          # Installation details (floor, compressor loc)
│   ├── quote.dart                 # Generated quote (equipment + install + warranty)
│   ├── customer_equipment.dart    # Customer's installed equipment record
│   ├── service_record.dart        # Service history entry
│   └── appointment.dart           # Scheduled appointment
├── providers/
│   ├── quote_provider.dart        # State management for quoting flow
│   ├── dashboard_provider.dart    # State management for customer dashboard
│   └── appointment_provider.dart  # State management for scheduling
├── screens/
│   ├── home_screen.dart           # Main menu / landing page
│   ├── quote/
│   │   ├── quote_type_screen.dart       # Choose: Full package vs Install-only
│   │   ├── equipment_select_screen.dart # Select equipment (brand, model, BTU)
│   │   ├── installation_details_screen.dart # Floor selection, compressor location
│   │   └── quote_summary_screen.dart    # Final price breakdown + warranty info
│   ├── dashboard/
│   │   ├── dashboard_screen.dart        # Overview: equipment count, next service
│   │   ├── equipment_detail_screen.dart # Single equipment details + service history
│   │   └── schedule_screen.dart         # Schedule maintenance appointment
│   └── future_services/
│       └── future_services_screen.dart  # Placeholder for solar, electrical, etc.
├── widgets/
│   ├── app_card.dart              # Reusable futuristic card component
│   ├── price_row.dart             # Label + price line item
│   ├── floor_selector.dart        # Floor picker widget
│   ├── equipment_tile.dart        # Equipment summary tile for dashboard
│   └── bottom_nav.dart            # Bottom navigation bar
└── data/
    ├── equipment_catalog.dart     # Static catalog of HVAC/Mini Split equipment
    └── pricing_rules.dart         # Pricing logic (floor multipliers, base rates)
```

---

## Pantallas y Flujos Detallados

### 1. Pantalla Principal (Home)
- Logo ALX-Clima + saludo
- 4 tarjetas grandes estilo futurista:
  1. **Cotizar Equipo + Instalación** (icono: AC + herramienta)
  2. **Cotizar Solo Instalación** (icono: herramienta)
  3. **Mi Dashboard** (icono: dashboard/gráfico)
  4. **Próximos Servicios** (icono: rocket/futuro) — placeholder

### 2. Flujo de Cotización — Equipo + Instalación (con garantía)

**Paso 2a: Selección de Equipo**
- Catálogo de Mini Splits / HVAC por marca, modelo y BTU
- Cada equipo muestra: precio aprox. del equipo
- Datos iniciales de ejemplo (ajustables por el técnico después):
  - 12,000 BTU Mini Split — ~$X
  - 18,000 BTU Mini Split — ~$Y
  - 24,000 BTU Mini Split — ~$Z

**Paso 2b: Detalles de Instalación**
- Preguntas al cliente:
  - ¿En qué piso se instalará la unidad interior? (1er piso / 2do piso)
  - ¿El compresor (unidad exterior) estará en el mismo piso o en otro?
- Estas respuestas afectan el costo de instalación:
  - Instalación en 1er piso, compresor mismo piso = base
  - Instalación en 2do piso = +surcharge
  - Compresor en piso diferente = +surcharge (tubería más larga, trabajo adicional)

**Paso 2c: Resumen de Cotización**
- Desglose:
  - Precio del equipo: $X
  - Costo de instalación: $Y (detalla ajustes por piso)
  - **Total aproximado: $X + $Y**
- Información de garantía:
  - **Garantía del técnico (ALX-Clima):** 1 año + 3 meses en electrónicos
  - **Garantía del fabricante:** ~1 año en compresor (varía por marca)
- Botón: "Agendar Instalación" o "Compartir Cotización"

### 3. Flujo de Cotización — Solo Instalación (sin garantía)

**Mismo flujo de Paso 2b y 2c** pero:
- No se muestra precio de equipo (el cliente ya lo tiene)
- Se muestra claramente: **"Sin garantía — equipo proporcionado por el cliente"**
- Solo se cobra la mano de obra de instalación

### 4. Dashboard del Cliente

**Pantalla principal del dashboard:**
- Resumen superior:
  - Total de equipos instalados: N
  - Próximo servicio recomendado: fecha
- Lista de equipos con tarjetas:
  - Tipo + marca + modelo
  - Fecha de instalación
  - Último servicio realizado
  - Próximo servicio recomendado (cada 6 meses aprox.)
  - Estado: ✓ Al día / ⚠ Servicio pendiente

**Detalle de equipo:**
- Información completa del equipo
- Historial de servicios (tabla/timeline)
- Información de garantía (con fechas de vencimiento)
- Botón: "Agendar Mantenimiento"

**Agendar servicio:**
- Selector de fecha preferida
- Selector de horario (mañana/tarde)
- Tipo de servicio: Mantenimiento / Reparación / Otro
- Notas adicionales
- Confirmación → se guarda localmente (MVP) o se envía notificación

### 5. Próximos Servicios (Placeholder)
- Pantalla con tarjetas deshabilitadas/en gris:
  - "Instalación de Paneles Solares — Próximamente"
  - "Trabajo Eléctrico — Próximamente"
  - "Más servicios — Próximamente"
- Mensaje: "Estamos trabajando en nuevos servicios para ti"

---

## Lógica de Precios (pricing_rules.dart)

```
BASE_INSTALLATION_COST = configurable

Multiplicadores:
- Unidad interior en 1er piso + compresor mismo piso  → ×1.0
- Unidad interior en 2do piso + compresor mismo piso  → ×1.3
- Unidad interior en 1er piso + compresor otro piso   → ×1.25
- Unidad interior en 2do piso + compresor otro piso   → ×1.5

Costo final instalación = BASE_INSTALLATION_COST × multiplicador
```

Todos los precios son **aproximados** y se muestran con disclaimer.

---

## Información de Garantías

| Fuente | Cobertura | Duración |
|--------|-----------|----------|
| ALX-Clima (técnico) | General | 1 año |
| ALX-Clima (técnico) | Electrónicos | +3 meses (1 año 3 meses total) |
| Fabricante | Compresor | ~1 año (varía por marca) |
| Fabricante | Otros componentes | Varía |

*Solo aplica cuando el equipo es comprado a través de ALX-Clima.*

---

## Diseño y Tema

- **Color primario:** Blanco (#FFFFFF) con acentos en azul frío (#0A84FF) o cyan (#00D4FF)
- **Fondo:** Blanco con sutil gradiente o textura geométrica
- **Tipografía:** Sans-serif moderna (Poppins o Inter)
- **Tarjetas:** Bordes redondeados, sombras sutiles, efecto glassmorphism ligero
- **Iconos:** Línea delgada, estilo futurista
- **Navegación:** Bottom navigation bar con 4 tabs (Home, Cotizar, Dashboard, Más)
- **Animaciones:** Transiciones suaves, fade-in en tarjetas

---

## Stack Técnico

| Componente | Tecnología |
|------------|------------|
| Framework | Flutter 3.x |
| State Management | Provider (simple, sufficient for MVP) |
| Navigation | GoRouter |
| Storage (MVP) | SharedPreferences / Hive (local) |
| Storage (futuro) | Firebase Firestore o Supabase |
| Fuentes | Google Fonts (Poppins) |
| Iconos | Material Icons + Iconsax o Phosphor |

---

## Fases de Implementación

### Fase 1 — Scaffold y Tema (actual)
- [ ] Crear proyecto Flutter
- [ ] Configurar tema blanco futurista
- [ ] Implementar navegación principal (bottom nav + routes)
- [ ] Pantalla Home con las 4 tarjetas

### Fase 2 — Cotización de Equipos
- [ ] Modelo de datos: Equipment, Installation, Quote
- [ ] Catálogo de equipos (datos estáticos iniciales)
- [ ] Pantalla selección de equipo
- [ ] Pantalla detalles de instalación (piso, ubicación compresor)
- [ ] Pantalla resumen con desglose de precios y garantías
- [ ] Flujo "Solo Instalación" (reutiliza pantallas, sin equipo)

### Fase 3 — Dashboard del Cliente
- [ ] Modelo de datos: CustomerEquipment, ServiceRecord, Appointment
- [ ] Pantalla dashboard con resumen y lista de equipos
- [ ] Pantalla detalle de equipo con historial
- [ ] Funcionalidad de agendar mantenimiento
- [ ] Almacenamiento local (Hive)

### Fase 4 — Servicios Futuros + Pulido
- [ ] Pantalla placeholder de servicios futuros
- [ ] Animaciones y transiciones
- [ ] Pruebas en Android e iOS
- [ ] Preparar para publicación en stores

### Fase 5 (Post-MVP) — Backend y Más
- [ ] Integración con backend (Firebase/Supabase)
- [ ] Autenticación de usuarios
- [ ] Notificaciones push para recordatorios de servicio
- [ ] Panel de administrador para el técnico
- [ ] Activar servicios futuros (solar, eléctrico)

---

## Notas Importantes
- Todos los textos en **español**
- Los precios son **aproximados** — siempre mostrar disclaimer
- MVP usa almacenamiento **local** — no requiere servidor
- La app debe funcionar **offline** para consultar precios
- Diseño debe ser **profesional** para generar confianza en los clientes
