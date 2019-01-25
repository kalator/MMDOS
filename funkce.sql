--Nalezeni pocatecniho a koncoveho uzlu - nejblizsi zastavky k adresam

--SELECT a.gid, v.id FROM adr a, trasy_vertices_pgr v
--WHERE a.c_domovni = 612 
--AND a.c_orientacni = 79 
--AND a.ulice = 'Evropská' 
--ORDER BY (a.geom)<->(v.geom) asc limit 1;

--SELECT a.gid, v.id FROM adr a, trasy_vertices_pgr v
--WHERE a.c_domovni = 2077 
--AND a.c_orientacni = 7
--AND a.ulice = 'Thákurova' 
--ORDER BY (a.geom)<->(v.geom) asc limit 1;

--SELECT distinct trasy_vertices_pgr.id, zastavky.zast_nazev FROM zastavky join trasy_vertices_pgr on (trasy_vertices_pgr.geom) <-> (zastavky.geom) limit 1; 

--UPDATE trasy_vertices_pgr 
--SET zast_naz = zastavky.zast_nazev from zastavky
--WHERE trasy_vertices_pgr.geom = ST_DWITHIN(zastavky.geom, trasy_vertices_pgr.geom, 0.1);

--SELECT gid AS id, source, target, CAST(shape_leng AS REAL) as cost FROM trasy;

--SELECT * 
--FROM pgr_dijkstra('SELECT gid AS id, source, target, CAST(shape_leng AS REAL) as cost FROM trasy',537,1202); 

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

SELECT * FROM FindVertexID(612, 79, 'Evropská');

--funkce kam zadas id a vyhodi ti nazev zastavky 
--SELECT z.zast_nazev, v.id FROM zastavky z, trasy_vertices_pgr v WHERE v.id = 7 order by v.geom <-> z.geom asc limit 1;

--CREATE OR REPLACE FUNCTION FindStationName(id INTEGER)
--RETURNS VARCHAR AS $name$
--declare 
	--name varchar;
--BEGIN 
	--SELECT z.zast_nazev INTO name FROM zastavky z
	--WHERE z.zast_uzel_ = id LIMIT 1; 
	--RETURN name;
--END;
--$name$ LANGUAGE plpgsql;

--SELECT * FROM FindStationName(6655);


















