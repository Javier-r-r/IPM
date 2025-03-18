# Diseño software

## Diagrama de Clases

```mermaid
classDiagram
    class DrinkObject {
        - _name: str
        + __init__(name: str)
        + name(): str
        + __repr__(): str
    }

    class View {
        - handler
        - button
        - error_label
        - scrolled_window
        - switch
        - search_bar
        - spinner
        - spinnerI
        + set_handler(handler)
        + on_activate(app)
        + build(app)
        + update(text: list)
        + updateInfo(result)
        + return_to_original_content(button, current_content)
        + sinAlcohol(button)
        + cadena(switch, state)
        + ingrediente(button)
    }

    class Model {
        + __init__()
        + sinAlcoholic(data)
        + do_search(ingredient: bool, sin_alcohol: bool, searchDrink: str)
        + getImage(drink)
    }

    class Presenter {
        - model
        - view
        + __init__(model: Model, view: View)
        + run(application_id: str)
        + on_search_clicked(sin_alcohol: bool, searchIngredient: bool, name: str)
        + do_work(sin_alcohol: bool, searchIngredient: bool, name: str)
        + _waiting()
        + info(drink)
        + do_workInfo(drink)
    }

    class Drink {
        - error: any
        - strDrink: str
        - Instructions: any
        - strDrinkImage: any
        - strIngredients: list
        - strCant: list
        + set_strDrink(drink: str): void
        + set_Instructions(Instructions: any): void
        + set_strDrinkImage(strDrinkImage: any): void
        + set_strIngredients(Ingre: any): void
        + set_strCant(cant: any): void
        + set_error(error: any): void
        + get_error(): any
        + get_strDrink(): str
        + get_Instructions(): any
        + get_strDrinkImage(): any
        + get_strIngredients(): list
        + get_strCant(): list
    }

    DrinkObject --> Drink
    View --> Presenter
    Model --> Presenter
    Model --> Drink
    Presenter --> Model
    Presenter --> View

```

## Inicio de la aplicación
```mermaid
sequenceDiagram

    User ->> App: Inicia la aplicación
    App ->> View: Inicializa la vista
    App ->> Presenter: Inicializa el presentador
    App ->> Model: Inicializa el modelo

    View ->> Presenter: Notifica que está lista
    Presenter ->> View: Establece el controlador
    View ->> User: Muestra la interfaz de usuario

    User ->> View: Interactúa con la interfaz de usuario
    View ->> Presenter: Notifica acciones del usuario
    Presenter ->> Model: Inicia operaciones del modelo
    Presenter ->> Model: Threads que realizan peticiones
    Model ->> Server: Realiza requests
    Model ->> Server: Realiza requests threads
    Server -->> Model: Devuelve resultados
    Server -->> Model: Devuelve resultados threads
    Model -->> Presenter: Devuelve resultados
    Presenter -->> View: Actualiza la vista

```
## Caso de Uso 1: Búsqueda de un cocktel
```mermaid
sequenceDiagram
    User->>View: Introduce el cocktel
    User->>View: Pulsa el botón "Search"
    View->>Presenter: on_search_clicked
    Presenter->>Model: thread do_work
    Presenter->>Model: do_search mientras está spinner
    Model ->> Server: Realiza peticiones
    Server -->> Model: Devuelve resultados
    Model-->>Presenter: Resultados de búsqueda
    Model-->>Presenter: Para el spinner 
    Presenter->>View: update
    View-->>User: Actualizar interfaz
```
## Caso de Uso 2: Filtrar la búsqueda en función de con o sin alcohol
```mermaid
sequenceDiagram
    User->>View: Pulsar botón "Sin Alcohol"
    User ->>View: Introduce el cocktel
    User->>View: Pulsa el botón "Search"
    View->>Presenter: on_search_clicked(sin_alcohol=true)
    Presenter->>Model: thread do_work
    Presenter->>Model: do_search(ingredient=false, sin_alcohol=true) mientras está spinner
    Model ->> Server: Realiza peticiones
    Server -->> Model: Devuelve resultados
    Model-->>Presenter: Resultados de búsqueda filtrados
    Model-->>Presenter: Para el spinner 
    Presenter->>View: update()
    View-->>User: Actualizar interfaz
```

## Caso de uso 3: Búsqueda de cockteles por ingrediente
```mermaid
sequenceDiagram
    User->>View: Selecciona la opción "Busqueda por ingrediente"
    User->>View: Introduce el ingrediente
    User->>View: Pulsa el botón "Search"
    View->>Presenter: on_search_clicked(searchIngredient=true, name="Ingrediente")    
    Presenter->>Model: thread do_work
    Presenter->>Model: do_search(ingredient=true, sin_alcohol=false, searchDrink="Ingrediente")
    Model ->> Server: Realiza peticiones
    Server -->> Model: Devuelve resultados
    Model-->>Presenter: Resultados de búsqueda filtrados
    Model-->>Presenter: Para el spinner 
    Model-->>Presenter: Resultados de búsqueda
    Presenter->>View: update()
    View-->>User: Actualizar interfaz
```
