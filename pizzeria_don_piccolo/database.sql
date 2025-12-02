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

