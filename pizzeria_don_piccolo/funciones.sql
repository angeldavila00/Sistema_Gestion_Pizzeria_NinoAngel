/*Funciones y Procedimientos
-Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
-Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
-Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.*/

-- Función para calcular el total de un pedido
delimiter $$
create function calcular_total_pedido(
    v_id_pedido int
)
returns double
not deterministic
reads sql data
begin
    declare total_pedido double;
    declare subtotal double;

    select
        coalesce(sum(d.precio_domicilio),0)+sum(dp.subtotal) into subtotal
    from detalle_pedido dp left join domicilio d on dp.pedido_id = d.pedido_id
    where dp.pedido_id = v_id_pedido;

    set total_pedido = subtotal * 1.21;

    return total_pedido;
end$$
delimiter ;

select calcular_total_pedido(2);

-- Función para calcular la ganancia neta diaria (PENDIENTE...)
delimiter $$
create function ganancia_neta_diaria(
    v_fecha_diaria date
)
returns double
not deterministic
reads sql data
begin 
end;$$
delimiter ;

-- Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega
delimiter $$
create procedure pedido_entregado(
    in v_id_pedido int
)
begin
    declare v_hora_entrega datetime;
    select
    hora_entrega into v_hora_entrega
    from domicilio d
    where d.pedido_id = v_id_pedido;


    if v_hora_entrega <= now() then
        update pedido p
        set p.estado = 'Entregado'
        where p.id = v_id_pedido;
    end if;
end$$
delimiter ;

call pedido_entregado(3);

drop procedure pedido_entregado;
update pedido set estado = 'Pendiente' where id= 3;
select * from pedido;
select * from domicilio;

-----------------------------
--- EJERCICIOS APARTE ---
-----------------------------

-- Pizzas más vendidas (SUM y JOIN).
    
delimiter $$
create function pizza_mas_vandida()
returns int
not deterministic
reads sql data
begin
    declare v_id int;
    select 
    p.id
    into v_id 
    from detalle_pedido dp
    inner join producto p on dp.producto_id = p.id
    group by p.id
    order by sum(dp.cantidad) desc
    limit 1;

    return v_id;
end$$
delimiter ;



    


