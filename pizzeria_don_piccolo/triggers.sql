/*Triggers
-Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.
-Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.
-Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.*/

-- Trigger para actualizar el stock de ingredientes después de insertar un nuevo pedido
delimiter $$
create trigger descuento_stock_ingredientes
after insert on detalle_pedido
for each row
begin
    update ingrediente i
    join producto_ingrediente pi
        on pi.ingrediente_id = i.id
    set i.stock = i.stock - (pi.cantidad * NEW.cantidad)
    where pi.producto_id = NEW.producto_id;
end$$
delimiter ;

-- Trigger para registrar cambios de precio en la tabla historial_precios
delimiter $$
create trigger registrar_cambio_precio_pizza
after update on producto
for each row
begin
    if old.precio_producto <> new.precio_producto then
        insert into historial_precios(producto_id, precio_anterior, precio_nuevo,fecha_cambio)
        values (new.id, old.precio_producto,new.precio_producto,now());

    end if;
end$$
delimiter ;

update producto set precio_producto = 3000 where id=1;

-- Trigger para marcar repartidor como disponible después de completar un domicilio
select * from pedido;
select * from domicilio;
select * from repartidor;

delimiter $$
create trigger marcar_repartidor_disponible
after update on pedido
for each row
begin
    if new.estado = 'Entregado' then
    update repartidor r
    left join domicilio d on r.id= d.repartidor_id
    set estado = 'Disponible' where d.pedido_id = new.id;
    end if;
end$$
delimiter ;

update pedido set estado = 'Entregado' where id=5;

