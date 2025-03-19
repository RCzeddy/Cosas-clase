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

-- si alquila mas de 50 pelis tienes descuento de 15% (-5 por tier menos) pasan cosas y si alquilan mas de 20 tal y mas de 10 cual.

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