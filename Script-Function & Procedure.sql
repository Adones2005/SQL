-- Funcion 1: Calcula el promedio de experencia de los Entrenadores de un equipo

DELIMITER $$

CREATE FUNCTION Calcular_Promedio_Experiencia(equipo_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(`Experiencia(years)`) INTO promedio FROM entrenadores WHERE Equipo = equipo_id;
    RETURN promedio;
END $$

DELIMITER ;

-- Prueba
SELECT Calcular_Promedio_Experiencia(1);


-- Funcion 2: Calcula la edad del jugador en funcion de la fecha de nacimiento, comprobando si los ha complido ya o no.
DELIMITER $$

CREATE FUNCTION Calcular_Edad(Fecha_nacimiento DATE) RETURNS INT
BEGIN
    DECLARE edad INT;
    SET edad = YEAR(CURRENT_DATE()) - YEAR(Fecha_nacimiento);
    IF MONTH(CURRENT_DATE()) < MONTH(Fecha_nacimiento) 
    OR (MONTH(CURRENT_DATE()) = MONTH(Fecha_nacimiento) 
    AND DAY(CURRENT_DATE()) < DAY(Fecha_nacimiento)) THEN
        SET edad = edad - 1;
    END IF;
    RETURN edad;
END $$
DELIMITER ;

-- Prueba

SELECT Calcular_Edad('1997-05-21');



-- Procedure 1: Lista todos los jugadores de una Posicion

DELIMITER $$

CREATE PROCEDURE Listar_Jugadores_Por_Posicion(posicion_param VARCHAR(45))
BEGIN
    DECLARE posicion_var VARCHAR(45);
    SET posicion_var = posicion_param;
    SELECT Nombre, Apellido, Posicion FROM jugadores WHERE Posicion = posicion_var;
END $$

DELIMITER ;

-- Prueba
CALL Listar_Jugadores_Por_Posicion('Top');







-- Procedure 2: Calcula la edad promedio de un equipo
DELIMITER $$

CREATE PROCEDURE Calcular_Edad_Promedio_Jugadores(equipo_id INT)
BEGIN
    DECLARE total_edad INT;
    DECLARE num_jugadores INT;
    DECLARE edad_promedio FLOAT;

    -- Calculamos la suma de las edades de los jugadores en el equipo
    SELECT SUM(Calcular_Edad(Fecha_nacimiento)) INTO total_edad
    FROM jugadores
    WHERE Equipo = equipo_id;

    -- Contamos el número de jugadores en el equipo
    SELECT contador_jugadores INTO num_jugadores
    FROM equipo e 
    WHERE e.id_equipo  = equipo_id;

    -- Calculamos la edad promedio
    IF num_jugadores > 0 THEN
        SET edad_promedio = total_edad / num_jugadores;
        SELECT CONCAT('La edad promedio de los jugadores en el equipo ', equipo_id, ' es ', edad_promedio) AS Info;
    END IF;
END $$
DELIMITER ;

-- Prueba
CALL Calcular_Edad_Promedio_Jugadores(1);


-- Procedure 3: Muestra los distinots entrenadores de un euqpo junto a sus anios de experiencia

DELIMITER $$

CREATE PROCEDURE Mostrar_Entrenadores_Y_Experiencia(equipo_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nombre_entrenador VARCHAR(100);
    DECLARE experiencia_entrenador INT;
    DECLARE c1 CURSOR FOR SELECT Nombre, `Experiencia(years)` FROM entrenadores WHERE Equipo = equipo_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN c1;

    read_loop: LOOP
        FETCH c1 INTO nombre_entrenador, experiencia_entrenador;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT(nombre_entrenador, ' tiene ', experiencia_entrenador, ' años de experiencia.') AS Info;
    END LOOP;

    CLOSE c1;
END $$

DELIMITER ;

-- Prueba
CALL Mostrar_Entrenadores_Y_Experiencia(1);







