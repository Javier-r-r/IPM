# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:
-->

# Diagrama de Clases
```mermaid
classDiagram
  class MyApp {
    - BuildContext context
    + Widget build(BuildContext context)
  }

  class MyHomePage {
    - int selectedIndex
    + void cambiarPagina(int index)
  }

  class _MyHomePageState {
    - int selectedIndex
    + void cambiarPagina(int index)
    + Widget build(BuildContext context)
  }

  class FavoritesPage {
    - Function(int) cambiarPaginaFunc
    + FavoritesPage(required this.cambiarPaginaFunc)
    + Widget build(BuildContext context)
    + void _eliminarFavorito(int index)
    + void _eliminarTodosFavoritos()
  }

  class _FavoritesPageState {
    - var appState
    + Widget build(BuildContext context)
    + void _eliminarFavorito(int index)
    + void _eliminarTodosFavoritos()
  }

  class HistoryPage {
    - var appState
    + Widget build(BuildContext context)
    + void _eliminarElemento(int index)
    + void _eliminarTodosElementos()
  }

  class _HistoryPageState {
    - var appState
    + Widget build(BuildContext context)
    + void _eliminarElemento(int index)
    + void _eliminarTodosElementos()
  }

  class ProviderApi {
    - double _convertRatio
    - String _comp
    - List<String> items
    - String _favoriteMessage
    + String comp
    + double convertRatio
    + String favoriteMessage
    + Future<void> convertRatioApiCall(String pair, String money)
  }

  class Responsive {
    - Widget mobileV
    - Widget mobileH
    - Widget tabletV
    - Widget tabletH
    + Responsive(
      Key? key,
      required this.mobileV,
      required this.mobileH,
      required this.tabletV,
      required this.tabletH,
    )
    + bool isMobile(BuildContext context)
    + bool isTablet(BuildContext context)
  }

  class MyAppState {
    - var favorites
    + void buttonState()
    + void toggleFavorite(String item)
  }

  class GeneratorPage {
    + Widget build(BuildContext context)
  }

  class CalcularButton {
    - bool _isLoading
    + CalcularButton(
      Key? key,
      required this.appState,
      required this.card1,
      required this.fild,
      required this.fontSize,
    )
    + Widget build(BuildContext context)
    + void _handleButtonPress()
  }

  class _CalcularButtonState {
    - bool _isLoading
    + Widget build(BuildContext context)
    + Widget _buildButtonChild()
    + void _handleButtonPress()
  }

  class DropdownButtonExample {
    + int instances
    + List<String> divisas
    + List<String> getDivisas()
    + String getPair()
  }

  class _DropdownButtonExampleState {
    - static List <String> list
    - String dropdownValue
    - int instance Number
    + Widget build(BuildContext context)
  }

  class MyInputField {
    + TextEditingController controller()
    + void setHasInput(bool toSet)
  }

  class _MyInputFieldState {
    - TextEditingController _myController
    - bool hasError
    - bool hasInput
    + Widget build(BuildContext context)
    + TextEditingController controller()
    + bool isNumeric(String value)
  }

  MyApp --> MyHomePage
  MyHomePage --> _MyHomePageState
  MyHomePage --> GeneratorPage
  MyHomePage --> HistoryPage
  MyHomePage --> Responsive
  MyHomePage --> FavoritesPage
  GeneratorPage --> MyInputField
  FavoritesPage --> _FavoritesPageState
  _FavoritesPageState --> MyAppState
  HistoryPage --> _HistoryPageState
  _HistoryPageState --> ProviderApi
  _FavoritesPageState --> ProviderApi
  GeneratorPage --> ProviderApi
  GeneratorPage --> DropdownButtonExample
  GeneratorPage --> CalcularButton
  CalcularButton --> MyAppState
  CalcularButton --> DropdownButtonExample
  CalcularButton --> _CalcularButtonState
  DropdownButtonExample --> _DropdownButtonExampleState
  MyInputField --> _MyInputFieldState


```
# Diagramas Dinámicos
## Caso de Uso: Convertir cantidad
```mermaid
sequenceDiagram
    User->>Responsive: El usuario usa su dispositivo
    Responsive-->>User: El responsive devuelve la interfaz segun el dispositivo
    User->>GeneratorPage: Interactúa con la interfaz de usuario
    activate GeneratorPage

    GeneratorPage->>DropdownButtonExample: Obtiene lista de divisas
    activate DropdownButtonExample
    DropdownButtonExample-->>GeneratorPage: Devuelve divisas

    User->>GeneratorPage: Selecciona divisa
    User->>GeneratorPage: Introduce cantidad
    User->>GeneratorPage: Pulsa botón

    GeneratorPage->>ProviderApi: Llama a convertRatioApiCall(pair, money)
    activate ProviderApi
    ProviderApi-->>ProviderApi: Valida la entrada
    ProviderApi-->>ProviderApi: Realiza la conversión de divisas
    ProviderApi-->>GeneratorPage: Devuelve el resultado
    deactivate ProviderApi

    GeneratorPage-->>User: Muestra el resultado en la interfaz de usuario
    deactivate GeneratorPage
```
## Caso de Uso: Mirar/Añadir/Eliminar de favoritos
```mermaid
sequenceDiagram

    User->>Responsive: El usuario usa su dispositivo
    Responsive-->>User: El responsive devuelve la interfaz segun el dispositivo
    User->>GeneratorPage: Interactúa con la interfaz de usuario
    activate GeneratorPage

    GeneratorPage->>ProviderApi: Llama a convertRatioApiCall(pair, money)
    activate ProviderApi
    ProviderApi-->>ProviderApi: Valida la entrada
    ProviderApi-->>ProviderApi: Realiza la conversión de divisas
    ProviderApi-->>GeneratorPage: Devuelve el resultado
    deactivate ProviderApi

    GeneratorPage-->>User: Muestra el resultado en la interfaz de usuario

    User->>GeneratorPage: Selecciona una conversión para agregar a favoritos
    GeneratorPage->>FavoritesPage: Agrega la conversión a la lista de favoritos

    deactivate GeneratorPage

    User->>FavoritesPage: Accede a la página de Favoritos
    activate FavoritesPage
    FavoritesPage->>FavoritesPage: Muestra la lista de favoritos
    FavoritesPage->>User: Muestra la lista de favoritos en la interfaz de usuario

    User->>FavoritesPage: Elimina un elemento de favoritos
    FavoritesPage->>FavoritesPage: Actualiza la lista de favoritos
    FavoritesPage->>User: Muestra la lista de favoritos actualizada
    deactivate FavoritesPage
```
## Caso de Uso: Mirar/Borrar el historial
```mermaid
sequenceDiagram

    User->>Responsive: El usuario usa su dispositivo
    Responsive-->>User: El responsive devuelve la interfaz segun el dispositivo
    User->>GeneratorPage: Interactúa con la interfaz de usuario
    activate GeneratorPage

    GeneratorPage->>ProviderApi: Llama a convertRatioApiCall(pair, money)
    activate ProviderApi
    ProviderApi-->>ProviderApi: Valida la entrada
    ProviderApi-->>ProviderApi: Realiza la conversión de divisas
    ProviderApi-->>GeneratorPage: Devuelve el resultado
    deactivate ProviderApi

    GeneratorPage-->>User: Muestra el resultado en la interfaz de usuario
    deactivate GeneratorPage

    User->>HistoryPage: Accede a la página de historial
    activate HistoryPage

    HistoryPage->>User: Muestra la lista de historial en la interfaz de usuario

    User->>HistoryPage: Selecciona una conversión para borrar del historial
    HistoryPage->>HistoryPage: Borra la conversión del historial
    HistoryPage-->>User: Muestra el historial actualizado
    deactivate HistoryPage

    User->>HistoryPage: Borrar todo el historial
    activate HistoryPage
    HistoryPage->>HistoryPage: Borra todo el historial
    HistoryPage->>User: Muestra el historial vacío
    deactivate HistoryPage
```
