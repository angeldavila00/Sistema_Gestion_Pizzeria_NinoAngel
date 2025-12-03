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
end;

call pizzas_mas_vendidas();

-- Pedidos por repartidor (JOIN).
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
end;

call pedidos_por_repartidor();

-- Promedio de entrega por zona (AVG y JOIN).
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
end;

call promedio_entrega_por_zona;

-- Clientes que gastaron más de un monto (HAVING).
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
end;

call clientes_que_gastaron_mas_de(50000);

-- Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
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
end;

call busqueda_pizza_por_nombre('M');

-- Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
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
end;

call clientes_frecuentes();
