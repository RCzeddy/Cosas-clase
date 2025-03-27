use sakila;

-- añadiria un indice en la tabla film, columna title debido que a parte de film_id es la columna que mas deberia consultarse de forma normal, agilizando los procesos de ejecucion.
-- en la tabla payment, añadiria un indice en la columna amount debido a que es con diferencia el dato que más interesa consultar y más amenudo se consulta en esta tabla.

create view pays_per_client as
select c.customer_id, c.first_name, c.last_name, sum(p.amount) as suma, p.last_update, count(p.payment_id) as pagos_realizados, avg(p.amount) as media_de_pagos
from customer c
join payment p on p.customer_id=c.customer_id
Group by c.customer_id, c.first_name,c.last_name,p.last_update;



alter table customer 
add column num_rentals int default 0,
add column sum_payments decimal (10,2) default 00.0,
add column balance decimal(10,2) default 00.0;

delimiter $$

create trigger rental_calculations
after insert
on rental
for each row
begin

declare alquileres int;
declare pagos decimal(10,2);
declare balance_total int;

select sum(amount) into pagos from payment where customer_id=new.customer_id;

select count(rental_id) into alquileres from rental where customer_id=new.customer_id;

set balance_total =(select count(r.rental_id) as rentas, count(p.payment_id) as pagos from rental r
join payment p on r.customer_id=p.payment_id
where customer_id=new.customer_id);


update customer set last_update=now(), num_rentals=alquileres, sum_payments=pagos,balance=balance_total;


end;
$$
delimiter ;

select * from pays_per_client;

