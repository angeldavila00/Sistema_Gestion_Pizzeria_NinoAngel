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

