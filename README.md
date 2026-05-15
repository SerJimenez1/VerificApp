<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2017+-000000?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/Swift-5.9-FA7343?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/UIKit-Primary-007AFF?style=for-the-badge&logo=uikit&logoColor=white" />
  <img src="https://img.shields.io/badge/SwiftUI-Bonus-06B6D4?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/Xcode-16+-1575F9?style=for-the-badge&logo=xcode&logoColor=white" />
</p>

<h1 align="center">🛡️ VerificApp</h1>
<h3 align="center">Asistente de verificación de noticias para jóvenes votantes peruanos</h3>

<p align="center">
  <em>Mini Hackathon — Desarrollo de Aplicaciones iOS · Práctica Calificada · Semanas 1–7</em>
</p>

---

## 👥 Equipo

| # | Integrante | Rol |
|:-:|:-----------|:----|
| 1 | **Josue Jonas Choquepuma Espinoza** | Desarrollo iOS |
| 2 | **Sergio Jiménez Araoz** | Desarrollo iOS |
| 3 | **Jordy Farlee Gómez Venero** | Desarrollo iOS |
| 4 | **Apaza Quilla Dixson Yonay** | Desarrollo iOS |
| 5 | **Rosas Flores Steven Yeray** | Desarrollo iOS |

---

## 📋 Brief Asignado

**Brief #3 — VerificApp**

> **Contexto noticioso:** Con las Elecciones Generales 2026 en el horizonte, **6 millones de jóvenes** figuran en el padrón electoral, de los cuales **2.5 millones votarán por primera vez**. El JNE reactivó su Comité de Fact-Checking en 2025 ante la proliferación de deepfakes, encuestas falsas y audios manipulados con IA.
>
> *Fuente: [Infobae Perú / JNE Perú — Noviembre 2025](https://www.infobae.com/peru)*

**Cliente:** Jurado Nacional de Elecciones (JNE)

**Misión:** Construir una app companion para jóvenes que les guíe paso a paso en la verificación de una noticia sospechosa mediante un checklist estructurado con criterios de fact-checking.

---

## 🎯 Funcionalidades del MVP

| Funcionalidad | Estado |
|:--------------|:------:|
| Iniciar verificación (pegar titular o URL) | ✅ |
| Checklist de 6 criterios de fact-checking | ✅ |
| Respuestas Sí / No / No aplica + nota del usuario | ✅ |
| Algoritmo de veredicto automático (Verdadero / Dudoso / Falso) | ✅ |
| Historial de verificaciones con badge de resultado | ✅ |
| Estadísticas propias del usuario | ✅ |
| Pantalla de resultado en SwiftUI con indicador animado (Bonus) | ✅ |

---

## 🗺️ Mapa de Navegación

```
┌─────────────────────────────────────────────────────────┐
│                    UITabBarController                     │
│                                                          │
│   ┌──────────────┐              ┌──────────────────┐     │
│   │  🏠 Tab 1    │              │  📋 Tab 2        │     │
│   │    Home      │              │   Historial      │     │
│   │              │              │  (TableView)     │     │
│   └──────┬───────┘              └────────┬─────────┘     │
│          │                               │               │
│          │ push                           │ modal         │
│          ▼                               ▼               │
│   ┌──────────────┐              ┌──────────────────┐     │
│   │  Pantalla 3  │              │  Pantalla 5      │     │
│   │  Flujo de    │              │  Detalle de      │     │
│   │  Verificación│              │  verificación    │     │
│   │  (6 pasos)   │              │  anterior        │     │
│   └──────┬───────┘              └──────────────────┘     │
│          │                                               │
│          │ push                                          │
│          ▼                                               │
│   ┌──────────────┐                                       │
│   │  Pantalla 4  │                                       │
│   │  Resultado   │                                       │
│   │  Final       │                                       │
│   │  (SwiftUI 🎁)│                                       │
│   └──────────────┘                                       │
└─────────────────────────────────────────────────────────┘
```

| Pantalla | Tipo Nav. | Framework | Descripción |
|:---------|:---------:|:---------:|:------------|
| **Home** | Tab | UIKit | Acceso rápido a nueva verificación + resumen de estadísticas |
| **Historial** | Tab | UIKit | Lista de verificaciones previas con badge de resultado (`TableView`) |
| **Flujo de Verificación** | Push | UIKit | 6 criterios en pasos secuenciales con barra de progreso |
| **Resultado Final** | Push | SwiftUI ⭐ | Veredicto con gauge animado de nivel de credibilidad |
| **Detalle Verificación** | Modal | UIKit | Criterios respondidos + notas del usuario |

---

## 🏗️ Arquitectura y Decisiones Técnicas

### Decisión 1 — Separación del algoritmo de veredicto en un `struct` puro

```swift
struct VerdictEngine {
    static func evaluate(responses: [CriteriaResponse]) -> Verdict { ... }
}
```

> **¿Por qué?** El algoritmo que calcula el veredicto (`Probablemente Verdadero` / `Dudoso` / `Probablemente Falso`) vive en un `struct VerdictEngine` **completamente aislado** del `ViewController`. Esto permite:
> - **Testeabilidad:** Se puede escribir unit tests contra `VerdictEngine.evaluate()` sin instanciar ningún ViewController ni simular UI.
> - **Reutilización:** El mismo engine puede invocarse desde UIKit, SwiftUI, o cualquier contexto futuro.
> - **Single Responsibility:** El VC se limita a coordinar la UI; la lógica de negocio no le pertenece.
>
> Se invoca desde el VC simplemente como:
> ```swift
> let verdict = VerdictEngine.evaluate(responses: collectedResponses)
> ```

---

### Decisión 2 — Modelo de datos con `enum` + `struct` para type safety

```swift
enum CriteriaAnswer: String, Codable {
    case yes, no, notApplicable
}

enum Verdict: String, Codable {
    case probablyTrue, doubtful, probablyFalse
}

struct Verification: Codable {
    let id: UUID
    let headline: String
    let date: Date
    let criteria: [CriteriaResponse]
    let verdict: Verdict
}
```

> **¿Por qué?** Usar `enum` en lugar de strings literales elimina errores por typos, habilita pattern matching exhaustivo en `switch`, y al conformar `Codable`, la persistencia con `UserDefaults` o archivos JSON es directa sin mapeos manuales.

---

### Decisión 3 — Navegación con `UITabBarController` + `UINavigationController` embebido

> **¿Por qué?** Se implementan los **3 tipos de navegación** requeridos por la rúbrica:
> - **Tab:** Cambio entre Home y Historial (`UITabBarController`)
> - **Push:** Navegación jerárquica hacia el flujo de verificación y resultado (`UINavigationController`)
> - **Modal:** Presentación del detalle de una verificación anterior (`present(_:animated:)`)
>
> Esta combinación es el patrón estándar de las **Human Interface Guidelines (HIG)** de Apple para apps con secciones independientes + flujos profundos.

---

### Decisión 4 (Bonus) — Pantalla de Resultado rehecha en SwiftUI

> **¿Por qué?** La pantalla de **Resultado Final** fue reimplementada en SwiftUI para demostrar interoperabilidad con UIKit vía `UIHostingController`. Se aprovechan animaciones nativas de SwiftUI (`Gauge`, `withAnimation`) para crear un indicador visual animado del nivel de credibilidad, logrando una experiencia visualmente superior con menos código.

---

## 📐 Boceto de Diseño

> 📎 **Boceto en papel / Mockup Figma:**
>
> 👉 [`
        https://www.figma.com/proto/PWIWcLanZlV9WMNOdytRcA/Untitled?node-id=10-47&p=f&t=xaK7m1OPTFAnlirF-0&scaling=min-zoom&content-scaling=fixed&page-id=0%3A1`](#)

<!-- 
  INSTRUCCIONES: Reemplazar el link de arriba con:
  - Link de Figma: https://www.figma.com/file/XXXXX
  - O ruta a la foto del boceto: ./screenshots/boceto.jpg
-->

---


<!-- 
  INSTRUCCIONES: 
  1. Crear la carpeta /screenshots/ en la raíz del repo
  2. Agregar mínimo 5 capturas PNG de la app
  3. Actualizar los nombres de archivo si es necesario
-->

---


---

## 🔧 Stack Técnico

| Componente | Tecnología |
|:-----------|:-----------|
| **Lenguaje** | Swift 5.9 |
| **UI Principal** | UIKit (Storyboard + Programmatic) |
| **UI Bonus** | SwiftUI (Pantalla de Resultado) |
| **Persistencia** | UserDefaults / Codable JSON |
| **Arquitectura** | MVC con lógica de negocio extraída en structs |
| **IDE** | Xcode 16+ |
| **Target mínimo** | iOS 17.0 |
| **Control de versiones** | Git + GitHub |

---

## 🚀 Cómo ejecutar

```bash
# 1. Clonar el repositorio
git clone https://github.com/SerJimenez1/VerificApp.git

# 2. Abrir el proyecto en Xcode
cd VerificApp
open VerificApp.xcodeproj

# 3. Seleccionar un simulador (iPhone 15 Pro recomendado)
# 4. Presionar ⌘+R para compilar y ejecutar
```

---

## 📁 Estructura del Proyecto

```
VerificApp/
├── README.md
├── screenshots/
│   ├── 01_home.png
│   ├── 02_historial.png
│   ├── 03_verificacion.png
│   ├── 04_resultado.png
│   ├── 05_detalle.png
│   └── boceto.jpg
│
├── VerificApp/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   │
│   ├── Models/
│   │   ├── Verification.swift         # Modelos: Verification, CriteriaResponse
│   │   ├── CriteriaAnswer.swift       # Enum: yes / no / notApplicable
│   │   └── Verdict.swift              # Enum: probablyTrue / doubtful / probablyFalse
│   │
│   ├── Engine/
│   │   └── VerdictEngine.swift        # 🧠 Función pura del algoritmo de veredicto
│   │
│   ├── Services/
│   │   └── VerificationStore.swift    # Persistencia con UserDefaults + Codable
│   │
│   ├── Controllers/
│   │   ├── HomeViewController.swift
│   │   ├── HistoryViewController.swift
│   │   ├── VerificationFlowVC.swift
│   │   ├── ResultViewController.swift
│   │   └── DetailViewController.swift
│   │
│   ├── Views/
│   │   ├── VerificationCell.swift     # Celda custom del TableView
│   │   └── StatsSummaryView.swift     # Vista de estadísticas
│   │
│   ├── SwiftUI/
│   │   └── ResultSwiftUIView.swift    # ⭐ Bonus: Resultado con Gauge animado
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   └── LaunchScreen.storyboard
│   │
│   └── Info.plist
│
└── VerificApp.xcodeproj/
```

---

## 🧪 Reto Técnico — Separación del Motor de Veredicto

```
┌──────────────────────┐         ┌─────────────────────────┐
│   ViewController     │         │    VerdictEngine         │
│                      │         │    (struct puro)         │
│  ┌────────────────┐  │  call   │                         │
│  │ Recopilar      │──┼────────▶│  evaluate(responses:)   │
│  │ respuestas UI  │  │         │  → Verdict              │
│  └────────────────┘  │         │                         │
│                      │◀────────│  Retorna enum Verdict   │
│  ┌────────────────┐  │ return  │                         │
│  │ Mostrar        │  │         └─────────────────────────┘
│  │ resultado      │  │
│  └────────────────┘  │              ✅ Testeable
│                      │              ✅ Sin dependencia de UI
└──────────────────────┘              ✅ Función pura
```

> **Pregunta de sustento:** *"¿Dónde vive el algoritmo que calcula el veredicto y cómo lo invocas desde el ViewController? ¿Por qué lo separaste?"*
>
> **Respuesta:** El algoritmo vive en `Engine/VerdictEngine.swift`, un `struct` con un método estático `evaluate(responses:)` que es una **función pura** — recibe un array de `CriteriaResponse` y devuelve un `Verdict` sin efectos secundarios. Se invoca desde el ViewController con una sola línea. La separación se hizo para cumplir el **Principio de Responsabilidad Única (SRP)**: el VC gestiona la UI, el Engine la lógica. Esto mejora la **testeabilidad** (se puede probar sin UI), la **reutilización** (se usa igual en UIKit y SwiftUI), y la **mantenibilidad** (cambiar el algoritmo no toca la vista).

---

## 📄 Licencia

Proyecto académico desarrollado como parte del curso **Desarrollo de Aplicaciones iOS** — TECSUP 2026.

---

<p align="center">
  <strong>🇵🇪 Hecho con 💻 por el equipo VerificApp</strong><br/>
  <em>Combatiendo la desinformación, una verificación a la vez.</em>
</p>
