-- Nalezeni nazvu zastavky podle ID 

CREATE OR REPLACE FUNCTION FindStationName(id INTEGER)
RETURNS VARCHAR AS $name$
declare 
	name varchar;
BEGIN 
	SELECT z.zast_nazev INTO name FROM zastavky z
	WHERE z.zast_uzel_ = id LIMIT 1; 
	RETURN name;
END;
$name$ LANGUAGE plpgsql;


--Nalezeni pocatecniho a koncoveho uzlu - nejblizsi zastavky k adresam

CREATE OR REPLACE FUNCTION FindVertexID(cd INTEGER, co INTEGER, u VARCHAR)
RETURNS INTEGER AS $id$
declare 
	id integer;
BEGIN 
	SELECT v.id INTO id FROM adr a, trasy_vertices_pgr v 
	WHERE a.c_domovni = cd 
	AND a.c_orientacni = co 
	AND a.ulice = u
	ORDER BY (a.geom)<->(v.geom) asc limit 1;
	RETURN id;
END;
$id$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION FindVertexIDcd(cd INTEGER, u VARCHAR)
RETURNS INTEGER AS $id$
declare 
	id integer;
BEGIN 
	SELECT v.id INTO id FROM adr a, trasy_vertices_pgr v 
	WHERE a.c_domovni = cd 
	AND a.ulice = u
	ORDER BY (a.geom)<->(v.geom) asc limit 1;
	RETURN id;
END;
$id$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION FindVertexIDori(co INTEGER, u VARCHAR)
RETURNS INTEGER AS $id$
declare 
	id integer;
BEGIN 
	SELECT v.id INTO id FROM adr a, trasy_vertices_pgr v 
	WHERE a.c_orientacni = co
	AND a.ulice = u
	ORDER BY (a.geom)<->(v.geom) asc limit 1;
	RETURN id;
END;
$id$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION FindVertexIDst(u VARCHAR)
RETURNS TABLE(
id BIGINT,
ul VARCHAR,
cp INTEGER,
co INTEGER
	) as $$
BEGIN 
	RETURN QUERY SELECT v.id, a.ulice, a.c_domovni, a.c_orientacni FROM adr a, trasy_vertices_pgr v 
	WHERE a.ulice = u
	ORDER BY (a.geom)<->(v.geom) asc limit 1;
 END; 
$$
LANGUAGE plpgsql;
