# VerificApp

App iOS para jóvenes votantes peruanos que guía una verificación manual de noticias sospechosas durante las Elecciones 2026.

## Alineación con la práctica

La rúbrica pide que la capa principal sea UIKit y que SwiftUI se use solo como bonus. Esta versión queda organizada así:

- UIKit obligatorio:
  - `UITabBarController` en `MainTabBarController`: tabs de Inicio e Historial.
  - `UINavigationController`: push desde Inicio hacia el flujo de verificación y luego Resultado.
  - `UITableViewController`: Historial de verificaciones con badge de veredicto.
  - Modal UIKit: Detalle de una verificación anterior desde Historial.
  - Flujo de 6 criterios hecho con `UIViewController`, `UISegmentedControl`, `UITextView` y `UIProgressView`.
- SwiftUI bonus:
  - Pantalla Resultado rehecha en SwiftUI y presentada desde UIKit con `UIHostingController`.
  - Incluye `Gauge` y `ProgressView` animados para el nivel de credibilidad.

## Requerimientos del caso 3

Implementado:

- Pegar titular o URL sospechosa.
- Checklist de 6 criterios:
  - Fuente original.
  - Historial confiable.
  - Confirmación por otras fuentes.
  - Fecha reciente.
  - Imagen real o verificable.
  - Lenguaje neutral.
- Cada criterio tiene `Sí / No / N/A` y nota personal.
- Resultado automático: Probablemente verdadero, Dudoso o Probablemente falso.
- Historial local de verificaciones.
- Estadísticas propias en Home.

No implementado, como pide el brief:

- No hay APIs externas.
- No hay conexión con bases de datos del JNE.
- No hay login.
- No hay compartir en redes.
- No hay cámara ni galería.

## Estructura

```text
VerificApp/
  VerificApp.xcodeproj/
  VerificApp/
    App/
      VerificAppApp.swift              # AppDelegate UIKit
    Models/
    Logic/
      VerdictCalculator.swift          # algoritmo puro
    Storage/
      VerificationStore.swift          # persistencia local
    ViewModels/
    UIKit/
      DesignSystem/
      Home/
      History/
      Verification/
      MainTabBarController.swift
    Views/
      Result/
        ResultView.swift               # bonus SwiftUI
  VerificAppTests/
    VerdictCalculatorTests.swift
```

## Algoritmo

El algoritmo vive en `VerificApp/VerificApp/Logic/VerdictCalculator.swift`.

Regla:

- 5 o 6 respuestas `Sí`: `Probablemente verdadero`
- 3 o 4 respuestas `Sí`: `Dudoso`
- 0 a 2 respuestas `Sí`: `Probablemente falso`

`No` y `N/A` no cuentan como afirmativas.

## Sustento técnico

Si preguntan "¿Dónde vive el algoritmo que calcula el veredicto y cómo lo invocas desde el ViewController? ¿Por qué lo separaste?", responde:

> El algoritmo vive en el struct `VerdictCalculator`, dentro de la carpeta `Logic`. Lo invoco desde `VerificationFlowViewModel.makeRecord()`, que recibe las respuestas del flujo UIKit y llama a `VerdictCalculator.calculate(from:)` para obtener el veredicto y a `VerdictCalculator.credibilityScore(from:)` para el indicador visual. Lo separé porque es una función pura: no depende de UIKit, SwiftUI, navegación ni almacenamiento. Eso mejora la testeabilidad porque puedo probar todos los casos con XCTest enviando arrays de respuestas, sin levantar pantallas ni simular interacción de usuario.

## Decisiones de arquitectura

- `struct`: modelos de datos (`VerificationRecord`, `CriterionResponse`, `VerificationStats`) y algoritmo puro.
- `enum`: respuestas (`VerificationAnswer`), criterios (`CriterionID`) y veredictos (`Verdict`).
- `class`: controladores UIKit, store observable y view model del flujo.
- Separación:
  - `Models`: datos.
  - `Logic`: cálculo del resultado.
  - `Storage`: guardado local.
  - `ViewModels`: estado del flujo.
  - `UIKit`: pantallas obligatorias.
  - `Views/Result`: bonus SwiftUI.

## Entregables sugeridos para GitHub

Incluye en el repo:

- README con decisiones justificadas: este archivo.
- Screenshots: Home, Historial, Flujo, Resultado y Detalle.
- Video/GIF corto: crear verificación completa y abrir historial.
- Boceto: puedes usar `Docs/boceto-verificapp.md`.

En este entorno no se pudo ejecutar `xcodebuild test` ni capturar screenshots reales porque no hay runtimes de iOS Simulator disponibles, pero el proyecto sí compila para dispositivo genérico.

## Validación

Comandos usados:

```bash
xcodebuild -list -project VerificApp/VerificApp.xcodeproj
xcodebuild -project VerificApp/VerificApp.xcodeproj -scheme VerificApp -configuration Debug -sdk iphoneos -destination generic/platform=iOS -derivedDataPath VerificApp/DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -project VerificApp/VerificApp.xcodeproj -scheme VerificApp -configuration Debug -sdk iphoneos -destination generic/platform=iOS -derivedDataPath VerificApp/DerivedData CODE_SIGNING_ALLOWED=NO build-for-testing
```

## Contexto revisado

- JNE, Fact-checking electoral: https://www.gob.pe/institucion/jne/campa%C3%B1as/139974-fact-checking-electoral-del-jne
- JNE, reporte de más de 700 alertas: https://www.gob.pe/institucion/jne/noticias/1361970-jne-advierte-mas-de-700-casos-de-alertas-de-desinformacion
- Infobae, IA y fake news en Elecciones 2026: https://www.infobae.com/america/inhouse/2025/11/04/ia-en-fake-news-elecciones-2026-expertos-y-autoridades-proponen-acciones-para-enfrentar-la-desinformacion-durante-el-proceso-electoral/
