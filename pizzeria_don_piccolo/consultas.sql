/*Consultas SQL requeridas.
-Clientes con pedidos entre dos fechas (BETWEEN).
-Pizzas más vendidas (GROUP BY y COUNT).
-Pedidos por repartidor (JOIN).
-Promedio de entrega por zona (AVG y JOIN).
-Clientes que gastaron más de un monto (HAVING).
-Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
-Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).*/

-- Clientes con pedidos entre dos fechas (BETWEEN).
delimiter $$
create procedure clientes_pedidos_entre_fechas(
    in fecha_inicio date,
    in fecha_fin date
)
begin
    select
        p.id,
        concat(p.nombre, ' ', p.apellido) as nombre_cliente
    from persona p
    left join pedido pe on p.id = pe.cliente_id
    where pe.fecha_orden between fecha_inicio and fecha_fin;
end$$
delimiter ;

call clientes_pedidos_entre_fechas("2000-10-10", "2026-10-10");

-- Pizzas más vendidas (GROUP BY y COUNT).
delimiter $$
create procedure pizzas_mas_vendidas()
begin
    select
        pi.id,
        pi.nombre as nombre_pizza,
        sum(dp.cantidad) as cantidad_vendida
    from producto pi
    left join detalle_pedido dp on pi.id = dp.producto_id
    group by pi.id
    order by cantidad_vendida desc;
end$$
delimiter ;

call pizzas_mas_vendidas();

-- Pedidos por repartidor (JOIN).
delimiter $$
create procedure pedidos_por_repartidor()
begin
    select
        p.id,
        concat(p.nombre, ' ', p.apellido) as nombre_repartidor,
        count(d.pedido_id) as pedidos_entregados
    from persona p
    inner join repartidor r on p.id = r.id
    left join domicilio d on r.id = d.repartidor_id
    group by p.id;
end$$
delimiter ;

call pedidos_por_repartidor();

-- Promedio de entrega por zona (AVG y JOIN).
delimiter $$
create procedure promedio_entrega_por_zona()
begin
    select 
        z.id,
        z.nombre_zona,
        truncate(avg(timestampdiff(minute,pe.fecha_orden,d.hora_entrega)),0) as tiempo_promedio_minutos
        from zona z
        left join repartidor r on z.id = r.zona_id
        left join domicilio d on r.id = d.repartidor_id
        left join pedido pe on d.pedido_id =pe.id
        group by z.id;
end$$
delimiter ;

call promedio_entrega_por_zona;

-- Clientes que gastaron más de un monto (HAVING).
delimiter $$
create procedure clientes_que_gastaron_mas_de(
    in monto_minimo double
)
begin 
    select
    pe.id,
    concat(pe.nombre, ' ' , pe.apellido) as nombre_cliente,
    sum(p.total) as monto_gastado
    from persona pe 
    left join pedido p on pe.id = p.cliente_id
    HAVING monto_gastado >= monto_minimo
    group by pe.id;
end$$
delimiter ;

call clientes_que_gastaron_mas_de(50000);

-- Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
delimiter $$
create procedure busqueda_pizza_por_nombre(
    in nombre_parcial varchar(100)
)
begin
    select 
        p.id,
        p.nombre as nombre_pizza,
        p.precio_producto
        from producto p
        where p.nombre like concat('%', nombre_parcial, '%');
end$$
delimiter ;

call busqueda_pizza_por_nombre('M');

-- Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
delimiter $$
create procedure clientes_frecuentes()
begin
    select 
        pe.id,
        concat(pe.nombre, ' ' , pe.apellido) as nombre_cliente,
        count(p.id) as cantidad_pedidos
        from persona pe
        left join pedido p on pe.id = p.cliente_id 
        group by pe.id
        having cantidad_pedidos > 5;
end$$
delimiter ;

call clientes_frecuentes();

-----------------------------
--- EJERCICIOS APARTE ---
-----------------------------

-- -- Clientes con pedidos entre fechas (JOIN y BETWEEN).
drop procedure clientes_entre_fechas;

DELIMITER $$
create procedure clientes_entre_fechas( 
    in p_fecha_inicio date,
    in p_fecha_final date
)

begin
    select 
    c.id as cliente_id,
    concat(per.nombre, ' ',per.apellido) as nombre_cliente,
    count(ped.id) as cantidad_pedidos,
    count(ped.total) as total_gastado
    from cliente c
    inner join persona per on per.id=c.id
    left join pedido ped on ped.cliente_id = c.id
    where ped.fecha_orden between p_fecha_inicio and p_fecha_final
    group by c.id, nombre_cliente
    order by total_gastado desc;
end$$
delimiter ;



CALL clientes_entre_fechas('2025-11-10 00:00:00', '2025-11-14 23:59:59');
