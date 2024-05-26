-- Consulta de Detalles de Partidas, Equipos y Campeones en Últimos Torneos
SELECT 
    t.Nombre,
    t.Edicion,
    t.fecha_inicio,
    t.fecha_fin,
    p.id_partida,
    e1.servidor AS Equipo_Azul_Server,
    e2.servidor AS Equipo_Rojo_Server,
    (SELECT GROUP_CONCAT(o.Nombre_objeto)
     FROM objetos o
     JOIN build b ON o.id_objetos = b.id_objetos_1 OR o.id_objetos = b.id_objetos_2 OR o.id_objetos = b.id_objetos_3 OR o.id_objetos = b.id_objetos_4 OR o.id_objetos = b.id_objetos_5 OR o.id_objetos = b.id_objetos_6
     JOIN build_has_campeones bhc ON b.id_build = bhc.Build_id_build
     WHERE bhc.Partida_id_partida = p.id_partida
    ) AS Objetos_Utilizados
FROM 
    partida p
JOIN equipo e1 ON p.Equipo_azul = e1.id_equipo
JOIN equipo e2 ON p.Equipo_rojo = e2.id_equipo
JOIN torneo t ON p.Torneo = t.id_torneo
ORDER BY t.fecha_fin DESC;



-- que junglas fueron jugados en entre los anos 2011 y 2013
SELECT DISTINCT c.Nombre AS Campeon
FROM campeones c
JOIN campeones_has_jugadores cj ON c.id_campeon = cj.id_campeon
JOIN jugadores j ON cj.id_jugador = j.id_jugador
JOIN partida p ON cj.id_partida = p.id_partida
JOIN torneo t ON p.Torneo = t.id_torneo
WHERE YEAR(t.Fecha_inicio) BETWEEN 2011 AND 2013
AND c.Rol = 'Jungla';


-- Consulta para obtener el nombre y el precio de los objetos que han sido utilizados en más de 100 builds.

SELECT o.Nombre_objeto, o.Precio
FROM objetos o
JOIN build b ON o.id_objetos = b.id_objetos_1
   OR o.id_objetos = b.id_objetos_2
   OR o.id_objetos = b.id_objetos_3
   OR o.id_objetos = b.id_objetos_4
   OR o.id_objetos = b.id_objetos_5
   OR o.id_objetos = b.id_objetos_6
GROUP BY o.id_objetos
HAVING COUNT(*) > 25;


-- Consulta para encontrar los jugadores que jugaron partidas en un torneo específico.

SELECT DISTINCT j.Nombre, j.Apellido
FROM jugadores j
JOIN campeones_has_jugadores cj ON j.id_jugador = cj.id_jugador
JOIN partida p ON cj.id_partida = p.id_partida
WHERE p.Torneo = (SELECT id_torneo FROM torneo WHERE Nombre = 'MSI Play-In');

-- Consulta para obtener el nombre de los campeónes más utilizado en el último torneo registrado en la base de datos.

SELECT c.Nombre, COUNT(cj.id_campeon) AS Apariciones
FROM campeones c
JOIN campeones_has_jugadores cj ON c.id_campeon = cj.id_campeon
JOIN partida p ON cj.id_partida = p.id_partida
JOIN torneo t ON p.Torneo = t.id_torneo
WHERE t.id_torneo = (
    SELECT t2.id_torneo
    FROM torneo t2
    ORDER BY t2.Fecha_fin DESC
    LIMIT 1
)
GROUP BY c.Nombre
ORDER BY Apariciones DESC
LIMIT 3;

-- Vista de la informacion de de partidas etc sobre un torneo.
CREATE VIEW Detalles_Partidas AS
SELECT 
    t.Nombre,
    t.Edicion,
    t.fecha_inicio,
    t.fecha_fin,
    p.id_partida,
    e1.servidor AS Equipo_Azul_Server,
    e2.servidor AS Equipo_Rojo_Server,
    (SELECT GROUP_CONCAT(o.Nombre_objeto)
     FROM objetos o
     JOIN build b ON o.id_objetos = b.id_objetos_1 OR o.id_objetos = b.id_objetos_2 OR o.id_objetos = b.id_objetos_3 OR o.id_objetos = b.id_objetos_4 OR o.id_objetos = b.id_objetos_5 OR o.id_objetos = b.id_objetos_6
     JOIN build_has_campeones bhc ON b.id_build = bhc.Build_id_build
     WHERE bhc.Partida_id_partida = p.id_partida
    ) AS Objetos_Utilizados
FROM 
    partida p
JOIN equipo e1 ON p.Equipo_azul = e1.id_equipo
JOIN equipo e2 ON p.Equipo_rojo = e2.id_equipo
JOIN torneo t ON p.Torneo = t.id_torneo
ORDER BY t.fecha_fin DESC;


-- Vista de la Junglas mas jugados 2011-2013.


CREATE VIEW Campeones_Jungla_2011_2013 AS
SELECT DISTINCT c.Nombre AS Campeon
FROM campeones c
JOIN campeones_has_jugadores cj ON c.id_campeon = cj.id_campeon
JOIN jugadores j ON cj.id_jugador = j.id_jugador
JOIN partida p ON cj.id_partida = p.id_partida
JOIN torneo t ON p.Torneo = t.id_torneo
WHERE YEAR(t.Fecha_inicio) BETWEEN 2011 AND 2013
AND c.Rol = 'Jungla';






