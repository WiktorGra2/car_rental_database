alter table rentals modify rental_date DEFAULT (sysdate+30);
alter table rentals modify rental_status DEFAULT 'active';
alter table rentals modify rental_status 
CHECK(rental_status 
IN('active', 'completed', 'canceled'));  