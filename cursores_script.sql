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

