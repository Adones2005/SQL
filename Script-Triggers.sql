-- TRIGGER 1: Realiza en una nueva tabla los reristros de las actualizaciones de los personajes

DELIMITER $$

CREATE TRIGGER after_update_campeon
AFTER UPDATE ON campeones
FOR EACH ROW
BEGIN
    IF OLD.Tipo <> NEW.Tipo THEN
        INSERT INTO cambios_campeones (id_campeon, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_campeon, 'Tipo', OLD.Tipo, NEW.Tipo);
    END IF;

    IF OLD.Rol <> NEW.Rol THEN
        INSERT INTO cambios_campeones (id_campeon, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_campeon, 'Rol', OLD.Rol, NEW.Rol);
    END IF;
END$$

DELIMITER ;


-- Trigger 2: Al anadir un un jugador al equipo, quedara constancia en la tabla equipos de la cantidad de jugadores que pertenecen a cada equipo.

-- Creo la columna
ALTER TABLE equipo ADD COLUMN contador_jugadores INT;

-- La seteo
UPDATE equipo e
JOIN (
    SELECT Equipo, COUNT(*) AS num_jugadores
    FROM jugadores
    GROUP BY Equipo
) j ON e.id_equipo = j.Equipo
SET e.contador_jugadores = j.num_jugadores;




DELIMITER $$

CREATE TRIGGER incrementar_contador_jugadores
AFTER INSERT ON jugadores
FOR EACH ROW
BEGIN
    UPDATE equipo
    SET contador_jugadores = contador_jugadores + 1
    WHERE id_equipo = NEW.Equipo;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER decrementar_contador_jugadores
AFTER DELETE ON jugadores
FOR EACH ROW
BEGIN
    UPDATE equipo
    SET contador_jugadores = contador_jugadores - 1
    WHERE id_equipo = OLD.Equipo;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER actualizar_contador_jugadores
AFTER UPDATE ON jugadores
FOR EACH ROW
BEGIN
    IF OLD.Equipo <> NEW.Equipo THEN
        UPDATE equipo
        SET contador_jugadores = contador_jugadores - 1
        WHERE id_equipo = OLD.Equipo;
        UPDATE equipo
        SET contador_jugadores = contador_jugadores + 1
        WHERE id_equipo = NEW.Equipo;
    END IF;
END $$

DELIMITER ;

-- USUARIO DE PRUEBA
INSERT INTO jugadores (id_jugador, Servidor, Nombre, Apellido, Fecha_nacimiento, Genero, Num_telefono, Posicion, Equipo, nick)
VALUES (160, 'KR', 'User', 'Test', '2000-04-12', 'M', '689353224', 'Mid', 1, 'UserTest');

DELETE FROM jugadores
WHERE id_jugador = 160;

UPDATE jugadores
SET Equipo = 1
WHERE id_jugador = 160;







