CREATE DATABASE pizzeria;
USE pizzeria;

CREATE TABLE persona (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL,
    telefono INT NOT NULL,
    direccion VARCHAR(100)
);

CREATE TABLE cliente(
    id INT NOT NULL,
    fecha_registro DATETIME NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY(id) REFERENCES persona(id)
);

CREATE TABLE vendedor(
    id INT NOT NULL,
    usuario VARCHAR(45) NOT NULL,
    contrasena VARCHAR(45) NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(usuario),
    FOREIGN KEY (id) REFERENCES persona(id)
);

CREATE TABLE zona (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre_zona VARCHAR(50) NOT NULL,
    UNIQUE (nombre_zona)
);

CREATE TABLE repartidor(
    id INT NOT NULL,
    estado ENUM ('Disponible', 'No disponible') NOT NULL DEFAULT 'Disponible',
    zona_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES persona(id),
    FOREIGN KEY (zona_id) REFERENCES zona(id)
);

CREATE TABLE unidad_medida (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE ingrediente( 
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    unidad_medida_id INT NOT NULL,
    gramaje INT,
    costo_unidad DOUBLE NOT NULL,
    stock INT NOT NULL,
    FOREIGN KEY (unidad_medida_id) REFERENCES unidad_medida(id)
);

CREATE TABLE producto(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    tipo ENUM ('pizza') NOT NULL,
    tamaño ENUM('Personal','Mediana','Familiar') NOT NULL,
    precio_producto DOUBLE NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE producto_ingrediente(
    producto_id  INT NOT NULL,
    ingrediente_id INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (producto_id,ingrediente_id),
    FOREIGN KEY (producto_id) REFERENCES producto(id),
    FOREIGN KEY (ingrediente_id) REFERENCES ingrediente(id)
);

CREATE TABLE proveedor(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nit VARCHAR(50) NOT NULL,
    razon_social VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    UNIQUE(nit)
);

CREATE TABLE inventario(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    fecha_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DOUBLE NOT NULL,
    FOREIGN KEY(proveedor_id) REFERENCES proveedor(id),
    FOREIGN KEY(vendedor_id) REFERENCES vendedor(id)
);

CREATE TABLE detalle_inventario(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    inventario_id INT NOT NULL,
    ingrediente_id INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    costo_unitario DOUBLE NOT NULL,
    subtotal DOUBLE NOT NULL,
    FOREIGN KEY(inventario_id) REFERENCES inventario(id),
    FOREIGN KEY(ingrediente_id) REFERENCES ingrediente(id)
);

CREATE TABLE pedido(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    vendedor_id INT,
    fecha_orden DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente','En proceso','Enviado','Entregado','Cancelado') NOT NULL DEFAULT 'Pendiente',
    total DOUBLE NOT NULL,
    canal_venta ENUM('Mostrador', 'Telefono', 'WhatsApp', 'Web', 'Otro') NOT NULL DEFAULT 'Mostrador',
    FOREIGN KEY(cliente_id) REFERENCES cliente(id),
    FOREIGN KEY(vendedor_id) REFERENCES vendedor(id)
);

CREATE TABLE detalle_pedido(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DOUBLE NOT NULL,
    subtotal DOUBLE NOT NULL,
    FOREIGN KEY(pedido_id) REFERENCES pedido(id),
    FOREIGN KEY(producto_id) REFERENCES producto(id)
);

CREATE TABLE domicilio(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    repartidor_id INT NOT NULL,
    direccion_entrega VARCHAR(100) NOT NULL,
    precio_domicilio DOUBLE NOT NULL,
    descripcion VARCHAR(50),
    hora_entrega DATETIME,
    FOREIGN KEY(pedido_id) REFERENCES pedido(id),
    FOREIGN KEY(repartidor_id) REFERENCES repartidor(id)
);

CREATE TABLE pago(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    metodo_pago ENUM('Tarjeta', 'Efectivo', 'Mixto') NOT NULL,
    monto DOUBLE NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(100),
    FOREIGN KEY(pedido_id) REFERENCES pedido(id)
);

CREATE TABLE historial_precios (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    producto_id INT NOT NULL,
    precio_anterior DOUBLE,
    precio_nuevo DOUBLE,
    fecha_cambio DATETIME,
    FOREIGN KEY (producto_id) REFERENCES producto(id)
);

INSERT INTO persona (nombre, apellido, correo_electronico, telefono, direccion) VALUES
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

INSERT INTO cliente (id, fecha_registro) VALUES
(1,'2025-11-01 10:15:00'),
(2,'2025-11-02 12:30:00'),
(3,'2025-11-03 18:45:00'),
(4,'2025-11-04 09:05:00');

INSERT INTO vendedor (id, usuario, contrasena, fecha_ingreso) VALUES
(5,'vendedor1','pass123','2025-10-01 08:00:00'),
(6,'vendedor2','pass456','2025-10-10 09:30:00');

INSERT INTO zona (nombre_zona) VALUES
('Centro'),
('Norte'),
('Sur');

INSERT INTO repartidor (id, estado, zona_id) VALUES
(7,'Disponible',1),
(8,'Disponible',2),
(9,'No disponible',3);

INSERT INTO unidad_medida (nombre) VALUES
('gramos'),
('mililitros'),
('unidad'),
('paquete'),
('litro');

INSERT INTO ingrediente (nombre, unidad_medida_id, gramaje, costo_unidad, stock) VALUES
('Masa',3,250,2000,200),
('Queso mozzarella',1,1,80,5000),
('Salsa de tomate',1,1,40,3000),
('Pepperoni',1,1,120,2000),
('Jamón',1,1,90,2000),
('Piña',1,1,50,1500),
('Vegetales mixtos',1,1,70,2500);

INSERT INTO producto (nombre, descripcion, tipo, tamaño, precio_producto, stock) VALUES
('Pizza Margarita Personal','Masa delgada, salsa de tomate y queso mozzarella','pizza','Personal',15000,50),
('Pizza Margarita Mediana','Masa delgada, salsa de tomate y queso mozzarella','pizza','Mediana',22000,40),
('Pizza Pepperoni Personal','Queso mozzarella y pepperoni','pizza','Personal',17000,45),
('Pizza Pepperoni Familiar','Queso mozzarella y pepperoni extra','pizza','Familiar',32000,30),
('Pizza Hawaiana Mediana','Queso, jamón y piña','pizza','Mediana',24000,35),
('Pizza Vegetariana Familiar','Queso y vegetales frescos','pizza','Familiar',30000,25);

INSERT INTO producto_ingrediente (producto_id, ingrediente_id, cantidad) VALUES
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

INSERT INTO proveedor (nit, razon_social, correo, telefono, direccion) VALUES
('900123001-1','Suministros La Bodega','contacto@labodega.com',601123456,'Zona industrial #1'),
('900123002-2','Lácteos El Buen Queso','ventas@elbuenqueso.com',601234567,'Km 5 vía occidente'),
('900123003-3','Cárnicos y Embutidos S.A.S.','info@carnicos.com',601345678,'Parque industrial #3');

INSERT INTO inventario (proveedor_id, vendedor_id, fecha_compra, total) VALUES
(1,5,'2025-10-20 09:00:00',460000),
(2,5,'2025-10-25 15:30:00',375000),
(3,6,'2025-10-28 11:45:00',220000);

INSERT INTO detalle_inventario (inventario_id, ingrediente_id, cantidad, costo_unitario, subtotal) VALUES
(1,1,100.00,2000,200000),
(1,2,2000.00,80,160000),
(1,3,2500.00,40,100000),
(2,4,1500.00,120,180000),
(2,5,1500.00,90,135000),
(2,6,1200.00,50,60000),
(3,7,2000.00,70,140000),
(3,2,1000.00,80,80000);

INSERT INTO pedido (cliente_id, vendedor_id, fecha_orden, estado, total, canal_venta) VALUES
(1,5,'2025-11-10 19:30:00','Entregado',56000,'WhatsApp'),
(2,5,'2025-11-11 13:15:00','Entregado',32000,'Mostrador'),
(3,6,'2025-11-12 20:10:00','Enviado',54000,'Web'),
(1,6,'2025-11-13 18:45:00','En proceso',30000,'Telefono'),
(4,5,'2025-11-14 21:00:00','Pendiente',39000,'WhatsApp');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1,2,1,22000,22000),
(1,3,2,17000,34000),
(2,4,1,32000,32000),
(3,1,2,15000,30000),
(3,5,1,24000,24000),
(4,6,1,30000,30000),
(5,3,1,17000,17000),
(5,2,1,22000,22000);

INSERT INTO domicilio (pedido_id, repartidor_id, direccion_entrega, precio_domicilio, descripcion, hora_entrega) VALUES
(1,7,'Calle 10 #5-20',5000,'Entrega noche','2025-11-10 20:05:00'),
(3,8,'Av. Siempre Viva 123',7000,'Pedido web','2025-11-12 20:50:00'),
(5,9,'Calle 45 #20-15',6000,'Entrega lluviosa','2025-11-14 21:45:00');

INSERT INTO pago (pedido_id, metodo_pago, monto, fecha_pago, descripcion) VALUES
(1,'Tarjeta',61000,'2025-11-10 20:10:00','Pago con tarjeta'),
(2,'Efectivo',32000,'2025-11-11 13:20:00','Pago efectivo'),
(3,'Mixto',61000,'2025-11-12 20:55:00','Pago mixto'),
(5,'Efectivo',45000,'2025-11-14 21:50:00','Pago efectivo');
