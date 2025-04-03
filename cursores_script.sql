use sakila2;

-- crear procedimiento con un cursor que recupere los resultados de una consulta film_id y title de peliculas,
-- entonces recorreremos el cursor. chekeamos stock, si es menor q 3 se guarda en una tabla temporal


delimiter $$
create procedure consulta_pelis()
begin
declare a tinyint;
declare b tinyint;
declare done int default false;
declare c1 cursor for select film_id, title from film; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
open c1;

create temporary table cosas
(id tinyint,
nombre varchar(55)
);

 read_loop: LOOP
    FETCH cur1 INTO a, b;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF !done&&(select film_id from inventory group by 1 having count(*) > 1)<3 
    THEN
		insert into cosas values(a,b);
    END IF;
  END LOOP;
close c1;
end$$
delimiter ;

-- procesar la tabla payment en sakila para detectar transacciones sospechosas (aquellas que superen el 50% del promedio de los pagos anteriores) guardar en una tabla nueva en el procedimiento
-- con payment_id, customer_id, amount, avg_anterior y fecha de deteccion (now()).

delimiter &&
create procedure susge()
begin
declare pid int;
declare cid int;
declare mount decimal(10,2);
declare avg_until_now decimal(10,2);
declare done int default false;
declare c1 cursor for select payment_id, customer_id, amount from payment; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
open c1;

create table if not exists susable(
        payment_id int,
        customer_id int,
        cantidad decimal(10,2),
        avg_anterior decimal(10,2),
        fecha date
        );
     
 read_loop: LOOP
    FETCH c1 INTO pid, cid, mount;
    
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SELECT AVG(amount) 
        INTO avg_until_now
        FROM payment 
        WHERE customer_id = cid AND payment_id < pid; 
        
 IF mount > (avg_until_now * 1.5) 
    THEN
        insert into susable(payment_id, customer_id, cantidad, avg_anterior, fecha
)values
        (pid,cid,mount,avg_until_now, now());
    END IF;
  END LOOP;
close c1;

end &&
delimiter ;

call susge();
select*from susable;

drop procedure susge;