### Estadística
Como estadística implemente reglas para calcular la probabilidad de que en la siguiente tirada salga una carta alta, una carta media y una carta baja en función de las cartas jugadas.

De manera resumida, los pasos que se realizan para esto son los siguientes:
1. Dada una lista de cartas jugadas y una lista que representa el mazo inicial (mazo con todas las cartas), se obtiene el mazo (cartas no jugadas).
2. Se cuenta la cantidad de cartas que hay en el mazo.
3. Se cuenta la cantidad de cartas altas, medias y bajas que hay en el mazo.
4. Con los valores obtenidos en los pasos 2 y 3 se calcula la probabilidad de que en la siguiente tirada salga una carta alta, una carta media y una carta baja.

La regla (implementada en el archivo blackjack.pl) para calcular estas probabilidades es la siguiente: play(CartasJugadas) en donde CartasJugadas es una lista de las cartas jugadas (cartas que hay en la mesa).

**Casos de prueba:**  
**1)** play([card(10,c), card(10,p), card(k,t), card(q,d), card(k,d), card(a,c), card(a,t), card(2,t)]).

En este caso hay 8 cartas jugadas, de las cuales 7 son altas y 1 es baja. En consecuencia, en el mazo (cartas no jugadas) hay un total de 44 cartas, de las cuales 13 son altas, 12 son medias y 19 son bajas. La probabilidad de:
- que en la siguiente tirada salga una carta alta es: 13 / 44 * 100 = 29.5454545455 %
- que en la siguiente tirada salga una carta media es: 12 / 44 * 100 = 27.2727272727 %
- que en la siguiente tirada salga una carta baja es: 19 / 44 * 100 = 43.1818181818 %

**2)** play([card(10,c), card(10,p), card(k,t), card(q,d), card(k,d)]).

En este caso hay 5 cartas jugadas, las cuales son todas altas. En consecuencia, en el mazo (cartas no jugadas) hay un total de 47 cartas, de las cuales 15 son altas, 12 son medias y 20 son bajas. La probabilidad de:
- que en la siguiente tirada salga una carta alta es: 15 / 47 * 100 = 31.914893617021278 %
- que en la siguiente tirada salga una carta media es: 12 / 47 * 100 = 25.53191489361702 %
- que en la siguiente tirada salga una carta baja es: 20 / 47 * 100 = 42.5531914893617 %

**3)** play([card(10,c), card(8,p), card(2,t), card(9,d), card(k,d), card(4,d)]).

En este caso hay 6 cartas jugadas, de las cuales 2 son altas, 2 son medias y 2 son bajas. En consecuencia, en el mazo (cartas no jugadas) hay un total de 46 cartas, de las cuales 18 son altas, 10 son medias y 18 son bajas. La probabilidad de:
- que en la siguiente tirada salga una carta alta es: 18 / 46 * 100 = 39.130434782608695 %
- que en la siguiente tirada salga una carta media es: 10 / 46 * 100 = 21.73913043478261 %
- que en la siguiente tirada salga una carta baja es: 18 / 46 * 100 = 39.130434782608695 %