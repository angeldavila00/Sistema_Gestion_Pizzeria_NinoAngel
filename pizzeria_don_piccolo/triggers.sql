/*Triggers
-Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.
-Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.
-Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.*/

-- Trigger para actualizar el stock de ingredientes después de insertar un nuevo pedido
/*
delimiter //
create trigger calcular_preciocompra_iva
before insert on producto
for each row
begin
    set NEW.precio_compra_iva=NEW.precio_compra(1+(NEW.iva/100));
end; //
delimiter ;

insert into producto (nombre, descripcion, precio_compra, stock, iva, precio_compra_iva) values ('PRUEBA','N/A',90000, 15, 19,0);

-------------------------------------------------

delimiter // 
create trigger validar_stock_producto_al_vender
before insert on detalle_venta
for each row
begin 
    declare v_stock int default -1;
    declare v_precio int default 0;

    if NEW.tipo_venta = 'producto' THEN
        select stock,precio_compra into v_stock,v_precio from producto where id=NEW.codigo;
        if v_stock = -1 then
            signal sqlstate '45000' set message_text='producto no existe';
            elseif NEW.cantidad>v_stock then
                signal sqlstate '45000' set message_text='stock insuficiente';
        else 
            set NEW.subtotal=v_precioNEW.cantidad;
            update producto set stock=stock-NEW.cantidad where id=NEW.codigo;
            end if;
    end if;
end; //
    delimiter ;
*/

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

update pedido set estado = 'Entregado' where id=5;

