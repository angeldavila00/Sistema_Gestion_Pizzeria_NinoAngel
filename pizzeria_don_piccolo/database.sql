create database pizzeria;

use pizzeria;

-- Tabla persona
create table persona (
    id int primary key not null auto_increment,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    correo_electronico varchar(100) not null,
    telefono int not null,
    direccion varchar(100)
);

-- Tabla cliente
create table cliente(
    id int not null,
    fecha_registro datetime not null,
    primary key (id),
    foreign key(id) references persona(id)
);

-- Tabla vendedor
create table vendedor(
    id int not null,
    usuario varchar(45) not null,
    contrasena varchar(45) not null,
    fecha_ingreso datetime not null,
    primary key(id),
    unique(usuario),
    foreign key (id) references persona(id)
);

-- Tabla zona
create table zona (
    id int primary key not null auto_increment,
    nombre_zona varchar(50) not null,
    unique (nombre_zona)
);

--  Tabla repartidor
create table repartidor(
    id int not null,
    estado enum ('Disponible', 'No disponible') not null default 'Disponible',
    zona_id int not null,
    primary key (id),
    foreign key (id) references persona(id),
    foreign key (zona_id) references zona(id)
);

-- Tabla unidad_medida
create table unidad_medida (
    id int primary key not null auto_increment,
    nombre varchar(50) not null
);

-- Tabla ingrediente
create table ingrediente( 
    id int primary key not null auto_increment,
    nombre varchar(50) not null,
    unidad_medida_id int not null,
    gramaje int,
    costo_unidad double not null,
    stock int not null,
    foreign key (unidad_medida_id) references unidad_medida(id)
);

--  Tabla producto
create table producto(
    id int primary key not null auto_increment,
    nombre varchar(50) not null,
    descripcion varchar(200),
    tipo enum ('pizza') not null,
    tamaño enum('Personal','Mediana','Familiar') not null,
    precio_producto double not null,
    stock int not null
);

--  Tabla producto_ingrediente
create table producto_ingrediente(
    producto_id  int not null,
    ingrediente_id int not null,
    cantidad decimal(10,2) not null,
    primary key (producto_id,ingrediente_id),
    foreign key (producto_id) references producto(id),
    foreign key (ingrediente_id) references ingrediente(id)
);

-- Tabla proveedor
create table proveedor(
    id int primary key not null auto_increment,
    nit varchar(50) not null,
    razon_social varchar(50) not null,
    correo varchar(100) not null,
    telefono int not null,
    direccion varchar(100) not null,
    unique(nit)
);

-- Tabla inventario
create table inventario(
    id int not null primary key auto_increment,
    proveedor_id int not null,
    vendedor_id int not null,
    fecha_compra datetime not null default current_timestamp,
    total double not null,
    foreign key(proveedor_id) references proveedor(id),
    foreign key(vendedor_id) references vendedor(id)
);

-- Tabla detalle_inventario
create table detalle_inventario(
    id int primary key not null auto_increment,
    inventario_id int not null,
    ingrediente_id int not null,
    cantidad decimal(10,2) not null,
    costo_unitario double not null,
    subtotal double not null,
    foreign key(inventario_id) references inventario(id),
    foreign key(ingrediente_id) references ingrediente(id)
);

-- Tabla pedido
create table pedido(
    id int primary key not null auto_increment,
    cliente_id int not null,
    vendedor_id int,
    fecha_orden datetime not null default current_timestamp,
    estado enum('Pendiente','En proceso','Enviado','Entregado','Cancelado') not null default 'Pendiente',
    total double not null,
    canal_venta enum('Mostrador', 'Telefono', 'WhatsApp', 'Web', 'Otro') not null default 'Mostrador',
    foreign key(cliente_id) references cliente(id),
    foreign key(vendedor_id) references vendedor(id)
);

-- Tabla detalle_pedido
create table detalle_pedido(
    id int primary key not null auto_increment,
    pedido_id int not null,
    producto_id int not null,
    cantidad int not null,
    precio_unitario double not null,
    subtotal double not null,
    foreign key(pedido_id) references pedido(id),
    foreign key(producto_id) references producto(id)
);

-- Tabla domicilio
create table domicilio(
    id int not null primary key auto_increment,
    pedido_id int not null,
    repartidor_id int not null,
    direccion_entrega varchar(100) not null,
    precio_domicilio double not null,
    descripcion varchar(50),
    hora_entrega datetime,
    foreign key(pedido_id) references pedido(id),
    foreign key(repartidor_id) references repartidor(id)
);

-- Tabla pago
create table pago(
    id int primary key not null auto_increment,
    pedido_id int not null,
    metodo_pago enum('Tarjeta', 'Efectivo', 'Mixto') not null,
    monto double not null,
    fecha_pago datetime not null default current_timestamp,
    descripcion varchar(100),
    foreign key(pedido_id) references pedido(id)
);

-----------------------------------------
    Insersion de datos en las tablas
-----------------------------------------
-- Datos de persona
insert into persona (nombre, apellido, correo_electronico, telefono, direccion) values
('Juan','Pérez','juan.perez@example.com',300123456,'Calle 10 #5-20'),
('María','Gómez','maria.gomez@example.com',301234567,'Carrera 15 #8-30'),
('Carlos','López','carlos.lopez@example.com',302345678,'Av. Siempre Viva 123'),
('Laura','Rodríguez','laura.rod@example.com',303456789,'Calle 45 #20-15'),
('Andrés','Moreno','andres.moreno@example.com',304567890,'Carrera 7 #72-30'),
('Paula','Ramírez','paula.ramirez@example.com',305678901,'Calle 80 #30-40'),
('Diego','Castro','diego.castro@example.com',306789012,'Calle 50 #20-10'),
('Sofía','Martínez','sofia.mtz@example.com',307890123,'Cra 30 #25-60'),
('Felipe','Suárez','felipe.suarez@example.com',308901234,'Calle 100 #15-25'),
('Valeria','Díaz','valeria.diaz@example.com',309012345,'Transversal 20 #10-05');

-- Datos de cliente 
insert into cliente (id, fecha_registro) values
(1,'2025-11-01 10:15:00'),
(2,'2025-11-02 12:30:00'),
(3,'2025-11-03 18:45:00'),
(4,'2025-11-04 09:05:00');

-- Datos de vendedor
insert into vendedor (id, usuario, contrasena, fecha_ingreso) values
(5,'vendedor1','pass123','2025-10-01 08:00:00'),
(6,'vendedor2','pass456','2025-10-10 09:30:00');

-- Datos de zona
insert into zona (nombre_zona) values
('Centro'),
('Norte'),
('Sur');

-- Datos de repartidor
insert into repartidor (id, estado, zona_id) values
(7,'Disponible',1),
(8,'Disponible',2),
(9,'No disponible',3);

-- Datos de unidad_medida
insert into unidad_medida (nombre) values
('gramos'),
('mililitros'),
('unidad'),
('paquete'),
('litro');

-- Datos de ingrediente
insert into ingrediente (nombre, unidad_medida_id, gramaje, costo_unidad, stock) values
('Masa',3,250,2000,200),
('Queso mozzarella',1,1,80,5000),
('Salsa de tomate',1,1,40,3000),
('Pepperoni',1,1,120,2000),
('Jamón',1,1,90,2000),
('Piña',1,1,50,1500),
('Vegetales mixtos',1,1,70,2500);

-- Datos de producto
insert into producto (nombre, descripcion, tipo, tamaño, precio_producto, stock) values
('Pizza Margarita Personal','Masa delgada, salsa de tomate y queso mozzarella','pizza','Personal',15000,50),
('Pizza Margarita Mediana','Masa delgada, salsa de tomate y queso mozzarella','pizza','Mediana',22000,40),
('Pizza Pepperoni Personal','Queso mozzarella y pepperoni','pizza','Personal',17000,45),
('Pizza Pepperoni Familiar','Queso mozzarella y pepperoni extra','pizza','Familiar',32000,30),
('Pizza Hawaiana Mediana','Queso, jamón y piña','pizza','Mediana',24000,35),
('Pizza Vegetariana Familiar','Queso y vegetales frescos','pizza','Familiar',30000,25);

-- Datos de producto_ingrediente
insert into producto_ingrediente (producto_id, ingrediente_id, cantidad) values
(1,1,1.00),
(1,2,80.00),
(1,3,60.00),
(2,1,1.00),
(2,2,120.00),
(2,3,80.00),
(3,1,1.00),
(3,2,80.00),
(3,3,60.00),
(3,4,70.00),
(4,1,1.00),
(4,2,150.00),
(4,3,90.00),
(4,4,140.00),
(5,1,1.00),
(5,2,120.00),
(5,3,80.00),
(5,5,80.00),
(5,6,70.00),
(6,1,1.00),
(6,2,150.00),
(6,3,90.00),
(6,7,140.00);

-- Datos de proveedor
insert into proveedor (nit, razon_social, correo, telefono, direccion) values
('900123001-1','Suministros La Bodega','contacto@labodega.com',601123456,'Zona industrial #1'),
('900123002-2','Lácteos El Buen Queso','ventas@elbuenqueso.com',601234567,'Km 5 vía occidente'),
('900123003-3','Cárnicos y Embutidos S.A.S.','info@carnicos.com',601345678,'Parque industrial #3');

-- Datos de inventario
insert into inventario (proveedor_id, vendedor_id, fecha_compra, total) values
(1,5,'2025-10-20 09:00:00',460000),
(2,5,'2025-10-25 15:30:00',375000),
(3,6,'2025-10-28 11:45:00',220000);

-- Datos de detalle_inventario
insert into detalle_inventario (inventario_id, ingrediente_id, cantidad, costo_unitario, subtotal) values
(1,1,100.00,2000,200000),
(1,2,2000.00,80,160000),
(1,3,2500.00,40,100000),
(2,4,1500.00,120,180000),
(2,5,1500.00,90,135000),
(2,6,1200.00,50,60000),
(3,7,2000.00,70,140000),
(3,2,1000.00,80,80000);

-- Datos de pedido
insert into pedido (cliente_id, vendedor_id, fecha_orden, estado, total, canal_venta) values
(1,5,'2025-11-10 19:30:00','Entregado',56000,'WhatsApp'),
(2,5,'2025-11-11 13:15:00','Entregado',32000,'Mostrador'),
(3,6,'2025-11-12 20:10:00','Enviado',54000,'Web'),
(1,6,'2025-11-13 18:45:00','En proceso',30000,'Telefono'),
(4,5,'2025-11-14 21:00:00','Pendiente',39000,'WhatsApp');

-- Datos de detalle_pedido
insert into detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal) values
(1,2,1,22000,22000),
(1,3,2,17000,34000),
(2,4,1,32000,32000),
(3,1,2,15000,30000),
(3,5,1,24000,24000),
(4,6,1,30000,30000),
(5,3,1,17000,17000),
(5,2,1,22000,22000);

-- Datos de domicilio
insert into domicilio (pedido_id, repartidor_id, direccion_entrega, precio_domicilio, descripcion, hora_entrega) values
(1,7,'Calle 10 #5-20',5000,'Entrega noche','2025-11-10 20:05:00'),
(3,8,'Av. Siempre Viva 123',7000,'Pedido web','2025-11-12 20:50:00'),
(5,9,'Calle 45 #20-15',6000,'Entrega lluviosa','2025-11-14 21:45:00');

-- Datos de pago
insert into pago (pedido_id, metodo_pago, monto, fecha_pago, descripcion) values
(1,'Tarjeta',61000,'2025-11-10 20:10:00','Pago con tarjeta'),
(2,'Efectivo',32000,'2025-11-11 13:20:00','Pago efectivo'),
(3,'Mixto',61000,'2025-11-12 20:55:00','Pago mixto'),
(5,'Efectivo',45000,'2025-11-14 21:50:00','Pago efectivo');