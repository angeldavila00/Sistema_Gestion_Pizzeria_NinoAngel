--------------------
-- Consulta de entregas realizadas por cada repartidor.
-- Mostrar el nombre del repartidor, cantidad de entregas realizadas 
-- (estado='entregado'), y total acumulado de pedidos entregados.
----------------------
drop procedure pedidos_por_repartidor;
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

-------------------------------------------
/*Consulta de pedidos demorados
Mostrar los pedidos cuya entrega tomó más de 40 minutos entre hora_salida 
y hora_entrega
(Usa TIMESTAMPDIFF(MINUTE, hora_salida, hora_entrega) > 40).*/

 ----------------------------------------------
drop procedure promedio_entrega;

delimiter $$
create procedure promedio_entrega()
begin
    select 
        z.id,
        truncate(avg(timestampdiff(minute,pe.fecha_orden,d.hora_entrega)),0) as tiempo_promedio_minutos
        from zona z
        left join repartidor r on z.id = r.zona_id
        left join domicilio d on r.id = d.repartidor_id
        left join pedido pe on d.pedido_id =pe.id
        group by z.id
        having tiempo_promedio_minutos >= 40;
        
end; $$
delimiter ;

call promedio_entrega;

----------------------------------------
/*Vista resumen de desempeño
Crear una vista vista_desempeno_repartidor que muestre:
nombre_repartidor
entregas_totales
promedio_minutos_entrega*/
----------------------------------------

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