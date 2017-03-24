## Elevator pitch - equinox spring 17

### Objetivo principal
Optimizar en real time los tiempos de espera de un sistema de ascensores para un edificio X a través de un sistema inteligente.

### Metodología
Se ha creado una estructura basada en tres módulos principales: 
  1. Sistema de simulación
  2. Sistema de optimización
  3. Sistema de visualización
  
El sistema se inicializa para un edificio X con 9 plantas, 6 ascensores y 150 empleados por planta aproximadamente. Se estiman los tiempos medios de tránsito, movilidad del ascensor entre planta y planta y apertura/cierre de puertas y se supone un tiempo de llegada con distribución Normal con media 9:00. Con el sistema de simulación aleatoria se generan los datasets iniciales con los que se entrena posteriormente el sistema de optimización. El algoritmo elige de forma eficiente el ascensor óptimo en tiempo real de manera que se minimicen los tiempos de espera. Por último, se ha desarrollado una visualización con los resultados de los módulos anteriores, donde se muestra la ruta de cada ascensor, el ascensor asignado por cada tiempo de llegada, la distribución de las mismas y la tabla de datos resultante con todos los movimientos. Además, se añade un slider que el usuario podrá regular para simular el funcionamiento del sistema en tiempo real.

### Software utilizado
R version 3.3.2 (2016-10-31)
  - Librerías específicas de R: lubridate, dplyr, shiny, ggplot2

