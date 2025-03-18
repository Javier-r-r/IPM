
# Rol de Facilitador-Administrador: Manuel Mosquera(m.mosquera1)

## Diario Semanal: 1ª Semana

Viernes: Aprovechando la clase prácticas decidmos reuinirnos con la intención de comenzar
el proyecto con el que ya íbamos atrasados. En esas dos horas, decidimos que lo mejor era 
repartirse lo antes posible el rol correspondiente a cada individuo para así poder centrarse
lo antes posible en la parte difícil de esta primera tarea.
En esta primera ruenión, además de organizarnos, evaluamos los diseños de cada uno de los miembros
del grupo de la práctica individual anterior y fusionamos ideas con la intención de crear un diseño
lo más completo y sencillo posible. Una vez acabamos con este primer paso, continuamos con el siguiente
apartado selecionando el modelo arquitectónico de MVP, ya que nos ofrece la opción de mantener separado
cada una de las partes del programa.(view:Parte visual de la interfaz. Model:Capa en la que se trabaja con
los datos y, por ende, contiene mecanismos para acceder a la información y actualizar.Presenter:Parte que
tiene como función responder a las acciones que el usuario solicita a la aplicación.).

Sábado: Debido a problemas de agenda, no pudimos organizarnos para comenzar con el apartado tres de la
tarea hasta el sábado por la tarde. Durante esas horas muertas, dividimos el trabajo de forma indivudal
en la que comenzamos a familiarizarnos con el lenguaje de programación, además de hacer una versión a 
papel básica del UML con el que basarnos para comenzar a programar. A las 16:30, nos reunimos con la 
intención de plasmar nuestro diseño en python, dividiendonos el trabajo y repartiendo cada una de las
partes del MVP entre cada uno de los miembros. Al acabar el día, habíamos logrado una verisón inicial 
de la aplicación que era capaz de mostrar los resultados de la búsqueda de forma correcta, además de
hacer divisiones por búsqueda de ingredientes/bebidas y cocteles con/ sin alcohol.

Domingo:El último día volvimos a repartirnos el trabajo. Con el programa de python bien encarrilado, uno
de los miembros comenzó a plasmar el diseño de UML en mermaid mientras que los otros dos continuaban avanzando
en el programa. Logramos que, al clickar en uno de los resultados de la búsqueda, salga la información sobre el
cócktel, su método de preparación, los ingredientes que emplea y una foto suya, además de un botón que sirve
para volver a la página anterior

## Diario Semanal: 2º Semana

Durante esta semana estuvimos arreglando los problemas de la entrega anterior, dedicándonos a perfeccionar la 
interfaz con mejoras como: El tamaño correcto de las imágenes, evitar que las letras de las intrucciones se 
corten a la hora de separarlo, añadir mensajes de error cuando la búsqueda no se realiza correctamente (tanto
por error de conexión como por error de búsqueda) y cambiar el título de los cócteles de botón a una label. Además,
por sugerencia del profesorado, hemos modificado la búsqueda por nombre de cóctel/ ingrediente para hacerla 
más fácil de diferenciar a un usuario que no esté familiarizado con estas plataformas de búsqueda de cócteles.


En cuanto a la segunda tarea, hemos identificado varios de los problemas que obligaban a la intefaz a bloquearse.
Por ejemplo, cuando una búsqueda arrojaba un gran número de resultados, la interfaz no era capaz de procesarlos 
y mostrarlos. Para solucionarlo, hemos añadido una barra de scroll vertical que permite desplazarse entre los 
resultados con gran comodidad, arreglando el problema de paso. Además, también hemos aplicado este principio a las
intruciones de preparación de cada cóctel, de esta forma, evitamos la posibilidad de que aparezcan entrecortadas por
ser demasiado extensas. Añadimos los spinners, aplicamos concurrencia y otros detalles menores.

## Diario Semanal: 3ª Semana
Durante esta última semana, nos pusimos a arreglar los detalles finales antes de presentar la entrega. Lo que incluye
solucionar pequeños errores visuales a la hora de ejecutar la búsqueda(Eliminar las etiquetas de error previas que 
pudieran existir) como verificar que todo funcionara bien.
Realizamos la internalización del programa al español (pasamos todos los label a inglés) y realizamos otras modificaciones
menores en los diseños de casos de uso como en el diseño definitivo, al que tuvimos que añadir nuevas pantallas con los
errores existentes.








