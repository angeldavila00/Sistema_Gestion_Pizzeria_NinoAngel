create database pizzeria;

use pizzeria;

-- Tabla Persona
create table persona (
    id int primary key not null auto_increment,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    correo_electronico varchar(100) not null,
    telefono int not null,
    direccion varchar(100)
);

-- tabla Cliente
create table cliente(
    id int not null,
    fecha_registro datetime not null,
    primary key (id),
    constraint cliente_id foreign key(id)
        references persona(id)
);

--Tabla vendedor
create table vendedor(
    id int not null,
    usuario varchar(45) not null,
    contrasena varchar(45)not null,
    fecha_ingreso datetime not null,
    primary key(id),
    unique(usuario),
    constraint vendedor_id
        foreign key (id)
        references persona(id)
);

-- Tabla Zona
create table zona (
    id int primary key not null auto_increment,
    nombre_zona varchar(50) not null,
    unique (nombre_zona)
);

-- Tabla repartidor

create table repartidor(
    id int not null,
    estado enum ('Disponible', 'No disponible') not null default 'Disponible',
    zona_id int not null,
    primary key (id),
    constraint repartidor_id
        foreign key (id)
        references persona(id),
    constraint repartidor_zona 
        foreign key (zona_id) 
        references zona(id)
);

-- Tabla producto
create table producto(
    id int primary key not null auto_increment,
    nombre varchar(50) not null,
    descripcion varchar(200),
    tipo enum ('pizza') not null,
    tamaño enum('Personal','Mediana','Familiar')not null,
    precio_producto double not null,
    stock int not null
);

-- Tabla Ingrediente
create table ingrediente( 
    id int primary key not null auto_increment,
    nombre varchar(50) not null,
    unidad_medida varchar(50)not null,
    costo_unidad double not null,
    stock int not null
);

-- tabla producto_ingrediente
create table producto_ingrediente(
    producto_id  int not null,
    ingrediente_id int not null,
    cantidad decimal(10,2)not null,
    primary key (producto_id,ingrediente_id),
    constraint producto_ingredeinte_id
        foreign key (producto_id)
        references producto(id),
    constraint ingrediente_producto_id
        foreign key (ingrediente_id)
        references ingrediente(id)
);

-- Tabla pedido
create table pedido(
    id int primary key not null auto_increment,
    cliente_id int not null,
    vendedor_id int,
    fecha_orden datetime not null default current_timestamp,
    estado enum('Pendiente','En proceso','Enviado','Entregado','Cancelado')not null default 'Pendiente',
    total double not null,
    canal_venta enum('Mostrador', 'Telefono', 'WhatsApp', 'Web', 'Otro')not null default 'Mostrador',
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
    producto_id int not null,
    cantidad int not null,
    costo_unitario double not null,
    subtotal double not null,
    foreign key(inventario_id) references inventario(id),
    foreign key(producto_id) references producto(id)
);