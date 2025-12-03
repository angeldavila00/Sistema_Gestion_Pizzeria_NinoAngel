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

-- Función para calcular la ganancia neta diaria
delimiter $$
create function ganancia_neta_diaria(
    v_fecha_diaria date
)
returns double
not deterministic
reads sql data
begin 
    declare venta_total double;
    declare costo_ingredientes double;

    select sum(total) into venta_total
    from pedido
    where date(fecha_orden) = v_fecha_diaria;

    select sum(pi.cantidad* dp.cantidad*i.precio_compra) into costo_ingredientes
    from detalle_pedido dp
    left join producto_ingrediente pi on dp.producto_id = pi.producto_id
    left join ingrediente i on pi.ingrediente_id = i.id
    left join pedido p on dp.pedido_id = p.id
    where date(p.fecha_orden) = v_fecha_diaria;
    
    


