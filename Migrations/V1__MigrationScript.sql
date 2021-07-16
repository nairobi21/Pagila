/*
Script created by SQL Examiner 7.1.8.321 at 16/7/2021 09:27:21.
Run this script on localhost:5432.pagila to make it the same as 10.184.100.176:5432.pagila
*/
--step 1: create user type public.mpaa_rating-------------------------------------------------------
CREATE TYPE "public"."mpaa_rating" AS ENUM
('G', 
'PG', 
'PG-13', 
'R', 
'NC-17');

--step 2: create user type public.year--------------------------------------------------------------
CREATE DOMAIN "public"."year" 
AS integer;
ALTER DOMAIN "public"."year" ADD CONSTRAINT "year_check" CHECK (VALUE >= 1901 AND VALUE <= 2155);

--step 3: create sequence public.actor_actor_id_seq-------------------------------------------------
CREATE SEQUENCE "public"."actor_actor_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 4: create table public.actor-----------------------------------------------------------------
CREATE TABLE "public"."actor" (
	"actor_id"			integer					 NOT NULL DEFAULT nextval('actor_actor_id_seq'::regclass),
	"first_name"		text					 NOT NULL,
	"last_name"			text					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "actor_pkey" PRIMARY KEY ("actor_id")
);

--step 5: create index public.actor.idx_actor_last_name---------------------------------------------
CREATE INDEX "idx_actor_last_name" ON "public"."actor" ("last_name");

--step 134: create function public.last_updated-----------------------------------------------------
CREATE OR REPLACE FUNCTION "public"."last_updated"()
RETURNS trigger
AS
$BODY$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;


--step 6: create trigger public.last_updated--------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."actor"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."actor" ENABLE TRIGGER "last_updated";

--step 7: create sequence public.address_address_id_seq---------------------------------------------
CREATE SEQUENCE "public"."address_address_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 8: create table public.address---------------------------------------------------------------
CREATE TABLE "public"."address" (
	"address_id"		integer					 NOT NULL DEFAULT nextval('address_address_id_seq'::regclass),
	"address"			text					 NOT NULL,
	"address2"			text					 NULL,
	"district"			text					 NOT NULL,
	"city_id"			integer					 NOT NULL,
	"postal_code"		text					 NULL,
	"phone"				text					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "address_pkey" PRIMARY KEY ("address_id")
);

--step 9: create index public.address.idx_fk_city_id------------------------------------------------
CREATE INDEX "idx_fk_city_id" ON "public"."address" ("city_id");

--step 10: create sequence public.city_city_id_seq--------------------------------------------------
CREATE SEQUENCE "public"."city_city_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 11: create table public.city-----------------------------------------------------------------
CREATE TABLE "public"."city" (
	"city_id"			integer					 NOT NULL DEFAULT nextval('city_city_id_seq'::regclass),
	"city"				text					 NOT NULL,
	"country_id"		integer					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "city_pkey" PRIMARY KEY ("city_id")
);

--step 12: create index public.city.idx_fk_country_id-----------------------------------------------
CREATE INDEX "idx_fk_country_id" ON "public"."city" ("country_id");

--step 13: create sequence public.country_country_id_seq--------------------------------------------
CREATE SEQUENCE "public"."country_country_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 14: create table public.country--------------------------------------------------------------
CREATE TABLE "public"."country" (
	"country_id"		integer					 NOT NULL DEFAULT nextval('country_country_id_seq'::regclass),
	"country"			text					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "country_pkey" PRIMARY KEY ("country_id")
);

--step 15: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."country"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."country" ENABLE TRIGGER "last_updated";

--step 16: public.city: add foreign key city_country_id_fkey----------------------------------------
ALTER TABLE "public"."city" ADD CONSTRAINT "city_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."country" ("country_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 17: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."city"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."city" ENABLE TRIGGER "last_updated";

--step 18: public.address: add foreign key address_city_id_fkey-------------------------------------
ALTER TABLE "public"."address" ADD CONSTRAINT "address_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "public"."city" ("city_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 19: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."address"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."address" ENABLE TRIGGER "last_updated";

--step 20: create sequence public.category_category_id_seq------------------------------------------
CREATE SEQUENCE "public"."category_category_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 21: create table public.category-------------------------------------------------------------
CREATE TABLE "public"."category" (
	"category_id"		integer					 NOT NULL DEFAULT nextval('category_category_id_seq'::regclass),
	"name"				text					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "category_pkey" PRIMARY KEY ("category_id")
);

--step 22: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."category"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."category" ENABLE TRIGGER "last_updated";

--step 23: create sequence public.customer_customer_id_seq------------------------------------------
CREATE SEQUENCE "public"."customer_customer_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 24: create table public.customer-------------------------------------------------------------
CREATE TABLE "public"."customer" (
	"customer_id"		integer					 NOT NULL DEFAULT nextval('customer_customer_id_seq'::regclass),
	"store_id"			integer					 NOT NULL,
	"first_name"		text					 NOT NULL,
	"last_name"			text					 NOT NULL,
	"email"				text					 NULL,
	"address_id"		integer					 NOT NULL,
	"activebool"		boolean					 NOT NULL DEFAULT true,
	"create_date"		date					 NOT NULL DEFAULT CURRENT_DATE,
	"last_update"		timestamp with time zone NULL DEFAULT now(),
	"active"			integer					 NULL,
	CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id")
);

--step 25: create index public.customer.idx_fk_address_id-------------------------------------------
CREATE INDEX "idx_fk_address_id" ON "public"."customer" ("address_id");

--step 26: create index public.customer.idx_fk_store_id---------------------------------------------
CREATE INDEX "idx_fk_store_id" ON "public"."customer" ("store_id");

--step 27: create index public.customer.idx_last_name-----------------------------------------------
CREATE INDEX "idx_last_name" ON "public"."customer" ("last_name");

--step 28: public.customer: add foreign key customer_address_id_fkey--------------------------------
ALTER TABLE "public"."customer" ADD CONSTRAINT "customer_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address" ("address_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 29: create sequence public.store_store_id_seq------------------------------------------------
CREATE SEQUENCE "public"."store_store_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 30: create table public.store----------------------------------------------------------------
CREATE TABLE "public"."store" (
	"store_id"				integer					 NOT NULL DEFAULT nextval('store_store_id_seq'::regclass),
	"manager_staff_id"		integer					 NOT NULL,
	"address_id"			integer					 NOT NULL,
	"last_update"			timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "store_pkey" PRIMARY KEY ("store_id")
);

--step 31: create index public.store.idx_unq_manager_staff_id---------------------------------------
CREATE UNIQUE INDEX "idx_unq_manager_staff_id" ON "public"."store" ("manager_staff_id");

--step 32: public.store: add foreign key store_address_id_fkey--------------------------------------
ALTER TABLE "public"."store" ADD CONSTRAINT "store_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address" ("address_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 33: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."store"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."store" ENABLE TRIGGER "last_updated";

--step 34: public.customer: add foreign key customer_store_id_fkey----------------------------------
ALTER TABLE "public"."customer" ADD CONSTRAINT "customer_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "public"."store" ("store_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 35: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."customer"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."customer" ENABLE TRIGGER "last_updated";

--step 36: create sequence public.film_film_id_seq--------------------------------------------------
CREATE SEQUENCE "public"."film_film_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 37: create table public.film-----------------------------------------------------------------
CREATE TABLE "public"."film" (
	"film_id"					integer					 NOT NULL DEFAULT nextval('film_film_id_seq'::regclass),
	"title"						text					 NOT NULL,
	"description"				text					 NULL,
	"release_year"				"public"."year"			 NULL,
	"language_id"				integer					 NOT NULL,
	"original_language_id"		integer					 NULL,
	"rental_duration"			smallint				 NOT NULL DEFAULT 3,
	"rental_rate"				numeric(4, 2)			 NOT NULL DEFAULT 4.99,
	"length"					smallint				 NULL,
	"replacement_cost"			numeric(5, 2)			 NOT NULL DEFAULT 19.99,
	"rating"					"public"."mpaa_rating"	 NULL DEFAULT 'G'::mpaa_rating,
	"last_update"				timestamp with time zone NOT NULL DEFAULT now(),
	"special_features"			text[]					 NULL,
	"fulltext"					tsvector				 NOT NULL,
	CONSTRAINT "film_pkey" PRIMARY KEY ("film_id")
);

--step 38: create index public.film.film_fulltext_idx-----------------------------------------------
CREATE INDEX "film_fulltext_idx" ON "public"."film" ("fulltext");

--step 39: create index public.film.idx_fk_language_id----------------------------------------------
CREATE INDEX "idx_fk_language_id" ON "public"."film" ("language_id");

--step 40: create index public.film.idx_fk_original_language_id-------------------------------------
CREATE INDEX "idx_fk_original_language_id" ON "public"."film" ("original_language_id");

--step 41: create index public.film.idx_title-------------------------------------------------------
CREATE INDEX "idx_title" ON "public"."film" ("title");

--step 42: create sequence public.language_language_id_seq------------------------------------------
CREATE SEQUENCE "public"."language_language_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 43: create table public.language-------------------------------------------------------------
CREATE TABLE "public"."language" (
	"language_id"		integer					 NOT NULL DEFAULT nextval('language_language_id_seq'::regclass),
	"name"				character(20)			 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "language_pkey" PRIMARY KEY ("language_id")
);

--step 44: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."language"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."language" ENABLE TRIGGER "last_updated";

--step 45: public.film: add foreign key film_language_id_fkey---------------------------------------
ALTER TABLE "public"."film" ADD CONSTRAINT "film_language_id_fkey" FOREIGN KEY ("language_id") REFERENCES "public"."language" ("language_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 46: public.film: add foreign key film_original_language_id_fkey------------------------------
ALTER TABLE "public"."film" ADD CONSTRAINT "film_original_language_id_fkey" FOREIGN KEY ("original_language_id") REFERENCES "public"."language" ("language_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 47: create trigger public.film_fulltext_trigger----------------------------------------------
CREATE TRIGGER "film_fulltext_trigger"
BEFORE INSERT OR UPDATE ON "public"."film"
FOR EACH ROW
EXECUTE FUNCTION tsvector_update_trigger('fulltext', 'pg_catalog.english', 'title', 'description');
ALTER TABLE "public"."film" ENABLE TRIGGER "film_fulltext_trigger";

--step 48: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."film"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."film" ENABLE TRIGGER "last_updated";

--step 49: create table public.film_actor-----------------------------------------------------------
CREATE TABLE "public"."film_actor" (
	"actor_id"			integer					 NOT NULL,
	"film_id"			integer					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "film_actor_pkey" PRIMARY KEY ("actor_id", "film_id")
);

--step 50: create index public.film_actor.idx_fk_film_id--------------------------------------------
CREATE INDEX "idx_fk_film_id" ON "public"."film_actor" ("film_id");

--step 51: public.film_actor: add foreign key film_actor_actor_id_fkey------------------------------
ALTER TABLE "public"."film_actor" ADD CONSTRAINT "film_actor_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "public"."actor" ("actor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 52: public.film_actor: add foreign key film_actor_film_id_fkey-------------------------------
ALTER TABLE "public"."film_actor" ADD CONSTRAINT "film_actor_film_id_fkey" FOREIGN KEY ("film_id") REFERENCES "public"."film" ("film_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 53: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."film_actor"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."film_actor" ENABLE TRIGGER "last_updated";

--step 54: create table public.film_category--------------------------------------------------------
CREATE TABLE "public"."film_category" (
	"film_id"			integer					 NOT NULL,
	"category_id"		integer					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "film_category_pkey" PRIMARY KEY ("film_id", "category_id")
);

--step 55: public.film_category: add foreign key film_category_category_id_fkey---------------------
ALTER TABLE "public"."film_category" ADD CONSTRAINT "film_category_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."category" ("category_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 56: public.film_category: add foreign key film_category_film_id_fkey-------------------------
ALTER TABLE "public"."film_category" ADD CONSTRAINT "film_category_film_id_fkey" FOREIGN KEY ("film_id") REFERENCES "public"."film" ("film_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 57: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."film_category"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."film_category" ENABLE TRIGGER "last_updated";

--step 58: create sequence public.inventory_inventory_id_seq----------------------------------------
CREATE SEQUENCE "public"."inventory_inventory_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 59: create table public.inventory------------------------------------------------------------
CREATE TABLE "public"."inventory" (
	"inventory_id"		integer					 NOT NULL DEFAULT nextval('inventory_inventory_id_seq'::regclass),
	"film_id"			integer					 NOT NULL,
	"store_id"			integer					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "inventory_pkey" PRIMARY KEY ("inventory_id")
);

--step 60: create index public.inventory.idx_store_id_film_id---------------------------------------
CREATE INDEX "idx_store_id_film_id" ON "public"."inventory" ("store_id", "film_id");

--step 61: public.inventory: add foreign key inventory_film_id_fkey---------------------------------
ALTER TABLE "public"."inventory" ADD CONSTRAINT "inventory_film_id_fkey" FOREIGN KEY ("film_id") REFERENCES "public"."film" ("film_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 62: public.inventory: add foreign key inventory_store_id_fkey--------------------------------
ALTER TABLE "public"."inventory" ADD CONSTRAINT "inventory_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "public"."store" ("store_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 63: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."inventory"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."inventory" ENABLE TRIGGER "last_updated";

--step 64: create sequence public.payment_payment_id_seq--------------------------------------------
CREATE SEQUENCE "public"."payment_payment_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 70: create sequence public.rental_rental_id_seq----------------------------------------------
CREATE SEQUENCE "public"."rental_rental_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 71: create table public.rental---------------------------------------------------------------
CREATE TABLE "public"."rental" (
	"rental_id"			integer					 NOT NULL DEFAULT nextval('rental_rental_id_seq'::regclass),
	"rental_date"		timestamp with time zone NOT NULL,
	"inventory_id"		integer					 NOT NULL,
	"customer_id"		integer					 NOT NULL,
	"return_date"		timestamp with time zone NULL,
	"staff_id"			integer					 NOT NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT "rental_pkey" PRIMARY KEY ("rental_id")
);

--step 72: create index public.rental.idx_fk_inventory_id-------------------------------------------
CREATE INDEX "idx_fk_inventory_id" ON "public"."rental" ("inventory_id");

--step 73: create index public.rental.idx_unq_rental_rental_date_inventory_id_customer_id-----------
CREATE UNIQUE INDEX "idx_unq_rental_rental_date_inventory_id_customer_id" ON "public"."rental" ("rental_date", "inventory_id", "customer_id");

--step 74: public.rental: add foreign key rental_customer_id_fkey-----------------------------------
ALTER TABLE "public"."rental" ADD CONSTRAINT "rental_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customer" ("customer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 75: public.rental: add foreign key rental_inventory_id_fkey----------------------------------
ALTER TABLE "public"."rental" ADD CONSTRAINT "rental_inventory_id_fkey" FOREIGN KEY ("inventory_id") REFERENCES "public"."inventory" ("inventory_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 76: create sequence public.staff_staff_id_seq------------------------------------------------
CREATE SEQUENCE "public"."staff_staff_id_seq"
AS bigint
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO MAXVALUE
NO CYCLE;

--step 77: create table public.staff----------------------------------------------------------------
CREATE TABLE "public"."staff" (
	"staff_id"			integer					 NOT NULL DEFAULT nextval('staff_staff_id_seq'::regclass),
	"first_name"		text					 NOT NULL,
	"last_name"			text					 NOT NULL,
	"address_id"		integer					 NOT NULL,
	"email"				text					 NULL,
	"store_id"			integer					 NOT NULL,
	"active"			boolean					 NOT NULL DEFAULT true,
	"username"			text					 NOT NULL,
	"password"			text					 NULL,
	"last_update"		timestamp with time zone NOT NULL DEFAULT now(),
	"picture"			bytea					 NULL,
	CONSTRAINT "staff_pkey" PRIMARY KEY ("staff_id")
);

--step 78: public.staff: add foreign key staff_address_id_fkey--------------------------------------
ALTER TABLE "public"."staff" ADD CONSTRAINT "staff_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address" ("address_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 79: public.staff: add foreign key staff_store_id_fkey----------------------------------------
ALTER TABLE "public"."staff" ADD CONSTRAINT "staff_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "public"."store" ("store_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

--step 80: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."staff"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."staff" ENABLE TRIGGER "last_updated";

--step 81: public.rental: add foreign key rental_staff_id_fkey--------------------------------------
ALTER TABLE "public"."rental" ADD CONSTRAINT "rental_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "public"."staff" ("staff_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--step 82: create trigger public.last_updated-------------------------------------------------------
CREATE TRIGGER "last_updated"
BEFORE UPDATE ON "public"."rental"
FOR EACH ROW
EXECUTE FUNCTION last_updated();
ALTER TABLE "public"."rental" ENABLE TRIGGER "last_updated";

--step 127: create function public._group_concat----------------------------------------------------
CREATE OR REPLACE FUNCTION "public"."group_concat"(text)
RETURNS text
AS
$BODY$
SELECT CASE
  WHEN $1 IS NULL THEN NULL
  ELSE $1
END
$BODY$
LANGUAGE sql IMMUTABLE
COST 100;


  
--step 121: create view public.customer_list--------------------------------------------------------
CREATE OR REPLACE VIEW "public"."customer_list"  AS
 SELECT cu.customer_id AS id,
    ((cu.first_name || ' '::text) || cu.last_name) AS name,
    a.address,
    a.postal_code AS "zip code",
    a.phone,
    city.city,
    country.country,
        CASE
            WHEN cu.activebool THEN 'active'::text
            ELSE ''::text
        END AS notes,
    cu.store_id AS sid
   FROM (((customer cu
     JOIN address a ON ((cu.address_id = a.address_id)))
     JOIN city ON ((a.city_id = city.city_id)))
     JOIN country ON ((city.country_id = country.country_id)));
--step 122: create view public.film_list------------------------------------------------------------
-- Table: public.payment

-- DROP TABLE public.payment;

CREATE TABLE public.payment
(
    payment_id integer NOT NULL DEFAULT nextval('payment_payment_id_seq'::regclass),
    customer_id integer NOT NULL,
    staff_id integer NOT NULL,
    rental_id integer NOT NULL,
    amount numeric(5,2) NOT NULL,
    payment_date timestamp with time zone NOT NULL
) PARTITION BY RANGE (payment_date);


CREATE INDEX idx_fk_customer_id
    ON public.payment USING btree
    (customer_id ASC NULLS LAST);
-- Index: idx_fk_staff_id

-- DROP INDEX public.idx_fk_staff_id;

CREATE INDEX idx_fk_staff_id
    ON public.payment USING btree
    (staff_id ASC NULLS LAST);

-- Partitions SQL

CREATE TABLE public.payment_p2020_01 PARTITION OF public.payment
    FOR VALUES FROM ('2020-01-01 00:00:00+00') TO ('2020-02-01 00:00:00+00');

ALTER TABLE public.payment_p2020_01
    OWNER to postgres;

CREATE TABLE public.payment_p2020_02 PARTITION OF public.payment
    FOR VALUES FROM ('2020-02-01 00:00:00+00') TO ('2020-03-01 00:00:00+00');

ALTER TABLE public.payment_p2020_02
    OWNER to postgres;

CREATE TABLE public.payment_p2020_03 PARTITION OF public.payment
    FOR VALUES FROM ('2020-03-01 00:00:00+00') TO ('2020-04-01 00:00:00+00');

ALTER TABLE public.payment_p2020_03
    OWNER to postgres;

CREATE TABLE public.payment_p2020_04 PARTITION OF public.payment
    FOR VALUES FROM ('2020-04-01 00:00:00+00') TO ('2020-05-01 00:00:00+00');

ALTER TABLE public.payment_p2020_04
    OWNER to postgres;

CREATE TABLE public.payment_p2020_05 PARTITION OF public.payment
    FOR VALUES FROM ('2020-05-01 00:00:00+00') TO ('2020-06-01 00:00:00+00');

ALTER TABLE public.payment_p2020_05
    OWNER to postgres;

CREATE TABLE public.payment_p2020_06 PARTITION OF public.payment
    FOR VALUES FROM ('2020-06-01 00:00:00+00') TO ('2020-07-01 00:00:00+00');

ALTER TABLE public.payment_p2020_06
    OWNER to postgres;

--step 124: create view public.sales_by_film_category-----------------------------------------------
CREATE OR REPLACE VIEW "public"."sales_by_film_category"  AS
 SELECT c.name AS category,
    sum(p.amount) AS total_sales
   FROM (((((payment p
     JOIN rental r ON ((p.rental_id = r.rental_id)))
     JOIN inventory i ON ((r.inventory_id = i.inventory_id)))
     JOIN film f ON ((i.film_id = f.film_id)))
     JOIN film_category fc ON ((f.film_id = fc.film_id)))
     JOIN category c ON ((fc.category_id = c.category_id)))
  GROUP BY c.name
  ORDER BY (sum(p.amount)) DESC;
--step 125: create view public.sales_by_store-------------------------------------------------------
CREATE OR REPLACE VIEW "public"."sales_by_store"  AS
 SELECT ((c.city || ','::text) || cy.country) AS store,
    ((m.first_name || ' '::text) || m.last_name) AS manager,
    sum(p.amount) AS total_sales
   FROM (((((((payment p
     JOIN rental r ON ((p.rental_id = r.rental_id)))
     JOIN inventory i ON ((r.inventory_id = i.inventory_id)))
     JOIN store s ON ((i.store_id = s.store_id)))
     JOIN address a ON ((s.address_id = a.address_id)))
     JOIN city c ON ((a.city_id = c.city_id)))
     JOIN country cy ON ((c.country_id = cy.country_id)))
     JOIN staff m ON ((s.manager_staff_id = m.staff_id)))
  GROUP BY cy.country, c.city, s.store_id, m.first_name, m.last_name
  ORDER BY cy.country, c.city;
--step 126: create view public.staff_list-----------------------------------------------------------
CREATE OR REPLACE VIEW "public"."staff_list"  AS
 SELECT s.staff_id AS id,
    ((s.first_name || ' '::text) || s.last_name) AS name,
    a.address,
    a.postal_code AS "zip code",
    a.phone,
    city.city,
    country.country,
    s.store_id AS sid
   FROM (((staff s
     JOIN address a ON ((s.address_id = a.address_id)))
     JOIN city ON ((a.city_id = city.city_id)))
     JOIN country ON ((city.country_id = country.country_id)));


--step 132: create function public.inventory_in_stock-----------------------------------------------
CREATE OR REPLACE FUNCTION "public"."inventory_in_stock"("p_inventory_id" integer)
RETURNS boolean
AS
$BODY$
DECLARE
    v_rentals INTEGER;
    v_out     INTEGER;
BEGIN
    -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    -- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT count(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

--step 133: create function public.last_day---------------------------------------------------------
CREATE OR REPLACE FUNCTION "public"."last_day"(timestamp with time zone)
RETURNS date
AS
$BODY$
  SELECT CASE
    WHEN EXTRACT(MONTH FROM $1) = 12 THEN
      (((EXTRACT(YEAR FROM $1) + 1) operator(pg_catalog.||) '-01-01')::date - INTERVAL '1 day')::date
    ELSE
      ((EXTRACT(YEAR FROM $1) operator(pg_catalog.||) '-' operator(pg_catalog.||) (EXTRACT(MONTH FROM $1) + 1) operator(pg_catalog.||) '-01')::date - INTERVAL '1 day')::date
    END
$BODY$
LANGUAGE sql IMMUTABLE
STRICT
COST 100;



--step 128: create function public.film_in_stock----------------------------------------------------
CREATE OR REPLACE FUNCTION "public"."film_in_stock"("p_film_id" integer, "p_store_id" integer, OUT "p_film_count" integer)
RETURNS SETOF integer
AS
$BODY$
     SELECT inventory_id
     FROM inventory
     WHERE film_id = $1
     AND store_id = $2
     AND inventory_in_stock(inventory_id);
$BODY$
LANGUAGE sql VOLATILE
COST 100
ROWS 1000;

--step 129: create function public.film_not_in_stock------------------------------------------------
CREATE OR REPLACE FUNCTION "public"."film_not_in_stock"("p_film_id" integer, "p_store_id" integer, OUT "p_film_count" integer)
RETURNS SETOF integer
AS
$BODY$
    SELECT inventory_id
    FROM inventory
    WHERE film_id = $1
    AND store_id = $2
    AND NOT inventory_in_stock(inventory_id);
$BODY$
LANGUAGE sql VOLATILE
COST 100
ROWS 1000;

--step 130: create function public.get_customer_balance---------------------------------------------
CREATE OR REPLACE FUNCTION "public"."get_customer_balance"("p_customer_id" integer, "p_effective_date" timestamp with time zone)
RETURNS numeric
AS
$BODY$
       --#OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       --#THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       --#   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       --#   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       --#   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       --#   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
DECLARE
    v_rentfees DECIMAL(5,2); --#FEES PAID TO RENT THE VIDEOS INITIALLY
    v_overfees INTEGER;      --#LATE FEES FOR PRIOR RENTALS
    v_payments DECIMAL(5,2); --#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN
    SELECT COALESCE(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(IF((rental.return_date - rental.rental_date) > (film.rental_duration * '1 day'::interval),
        ((rental.return_date - rental.rental_date) - (film.rental_duration * '1 day'::interval)),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(payment.amount),0) INTO v_payments
    FROM payment
    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

    RETURN v_rentfees + v_overfees - v_payments;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

--step 131: create function public.inventory_held_by_customer---------------------------------------
CREATE OR REPLACE FUNCTION "public"."inventory_held_by_customer"("p_inventory_id" integer)
RETURNS integer
AS
$BODY$
DECLARE
    v_customer_id INTEGER;
BEGIN

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

--step 135: create function public.rewards_report---------------------------------------------------
CREATE OR REPLACE FUNCTION "public"."rewards_report"("min_monthly_purchases" integer, "min_dollar_amount_purchased" numeric)
RETURNS SETOF "public"."customer"
AS
$BODY$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
rr RECORD;
tmpSQL TEXT;
BEGIN

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        RAISE EXCEPTION 'Minimum monthly purchases parameter must be > 0';
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        RAISE EXCEPTION 'Minimum monthly dollar amount purchased parameter must be > $0.00';
    END IF;

    last_month_start := CURRENT_DATE - '3 month'::interval;
    last_month_start := to_date((extract(YEAR FROM last_month_start) || '-' || extract(MONTH FROM last_month_start) || '-01'),'YYYY-MM-DD');
    last_month_end := LAST_DAY(last_month_start);

    /*
    Create a temporary storage area for Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id INTEGER NOT NULL PRIMARY KEY);

    /*
    Find all customers meeting the monthly purchase requirements
    */

    tmpSQL := 'INSERT INTO tmpCustomer (customer_id)
        SELECT p.customer_id
        FROM payment AS p
        WHERE DATE(p.payment_date) BETWEEN '||quote_literal(last_month_start) ||' AND '|| quote_literal(last_month_end) || '
        GROUP BY customer_id
        HAVING SUM(p.amount) > '|| min_dollar_amount_purchased || '
        AND COUNT(customer_id) > ' ||min_monthly_purchases ;

    EXECUTE tmpSQL;

    /*
    Output ALL customer information of matching rewardees.
    Customize output as needed.
    */
    FOR rr IN EXECUTE 'SELECT c.* FROM tmpCustomer AS t INNER JOIN customer AS c ON t.customer_id = c.customer_id' LOOP
        RETURN NEXT rr;
    END LOOP;

    /* Clean up */
    tmpSQL := 'DROP TABLE tmpCustomer';
    EXECUTE tmpSQL;

RETURN;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100
ROWS 1000;

