-- funcion q devuelva el numero de peliculas asociadas a una categoria q damos nosotros.
use sakila;


DELIMITER $$
CREATE FUNCTION contar_categorias(categoria VARCHAR(50))
RETURNS INT UNSIGNED
reads sql data
deterministic
BEGIN
declare total int;

select count(fc.film_id) into total 
from film_category fc
join category c on fc.category_id=c.category_id
where c.name=categoria;

RETURN total;
END
$$

select contar_categorias("Music");

select name from category;

-- si alquila mas de 50 pelis tienes descuento de 15% (-5 por tier menos), si alquilan mas de 20 tal y mas de 10 cual.

DELIMITER $$
CREATE FUNCTION aplicar_descuento(cliente int)
RETURNS INT UNSIGNED
reads sql data
BEGIN
declare total int;
declare discount int;

select count(rental_id) into total 
from rental
where customer_id=cliente
group by customer_id;

set discount = case
when total>=50 then 15
when total>=20 then 10
when total>=10 then 5
else 0
end;
RETURN discount;
END
$$

select aplicar_descuento(7);



select count(rental_id) 
from rental
where customer_id=7
group by customer_id;

DELIMITER $$
DROP FUNCTION IF EXISTS sum100;
CREATE FUNCTION sum100 ()
RETURNS INT UNSIGNED
reads sql data
BEGIN
declare hundred int default 101;
declare res int default 0;
declare sumador int default 0;

repeat 
set res = res + sumador;
set sumador = sumador + 1;
until sumador = hundred
end repeat;

RETURN res;
END
$$

select sum100();

-- Crear el Trigger after_payment_insert (7pts):

-- Crea una tabla que contenga como columnas el staff_id y un staff_revenue.

-- Crea un trigger llamado after_payment_insert que se active después de cada inserción en la tabla payment.
-- El trigger debe actualizar la tabla staff_revenue_table de la siguiente manera:
-- Si no existe un registro para el staff_id en staff_revenue, se debe insertar uno nuevo con el amount del nuevo pago.
-- Si existe un registro, se debe actualizar el staff_revenue sumando el amount del nuevo pago.

create table staff_table (
staff_id tinyint foreign key,
staff_revenue double
);

create trigger after_payment_insert
after insert
for each row
begin
declare total_revenue decimal;

-- create error handler 
create error handler()
begin
declare continue handler for
sqlexception
begin 
select'ocurrio un error'as message rollback 
end
declare continue handler for sql warnings
begin
select 'espabila manin' as message
end
start transaction;
insert into actor(actor_id, first_name, last_name, lat_update) values
(1,'roberto','cogolludo',now());
insert into actor(actor_id, first_name, last_name, lat_update) values
('laura','delgado',now());
commit
end