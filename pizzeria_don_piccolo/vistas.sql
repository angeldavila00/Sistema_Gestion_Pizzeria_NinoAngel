/*Vistas
Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).
Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona).
Vista de stock de ingredientes por debajo del mínimo permitido.*/

-- Vista de resumen de pedidos por cliente

create view resumen_pedidos_cliente as
select
    p.id,
    concat(p.nombre, ' ' , p.apellido) as nombre_cliente,
    count(*) as cantidad_pedidos,
    sum(pe.total) as total_gastado
    from pedido pe left join persona p on pe.cliente_id=p.id
    group by p.id;

select * from resumen_pedidos_cliente;

drop view resumen_pedidos_cliente;

-- Vista de desempeño de repartidores

create view desempeño_repartidores as
select
    p.id,
    concat(p.nombre, ' ' , p.apellido) as nombre_repartidor,
    count(d.id) as numero_entregas,
    z.nombre_zona,
    truncate(avg(timestampdiff(minute, pe.fecha_orden, d.hora_entrega)),0) as tiempo_promedio_minutos
    from persona p
    inner join repartidor r on r.id = p.id
    left join zona z on r.zona_id= z.id
    left join domicilio d on r.id = d.repartidor_id
    left join pedido pe on d.pedido_id=pe.id
    group by r.id;

select * from desempeño_repartidores;

-- Vista de stock de ingredientes por debajo del mínimo permitido. (menos de 5)

create view vista_stock as
select
    i.id,
    i.nombre as nombre_ingrediente,
    i.stock as stock_actual
    from ingrediente i
    where i.stock < 5
    group by i.id;

select * from vista_stock;

