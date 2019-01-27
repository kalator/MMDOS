CREATE TABLE adr(
gid serial NOT NULL,
ulice VARCHAR(50),
c_domovni INTEGER,
c_orientacni INTEGER,
co_znak VARCHAR(2),
y REAL,
x REAL,
geom geometry
);


\copy adr(ulice, c_domovni, c_orientacni, co_znak, y, x) FROM '/mnt/c/linux/ruian_adr.csv' DELIMITER ';' CSV HEADER encoding 'windows-1250';

UPDATE adr
SET geom = ST_GeomFromText('POINT(-'||y||' -'||x||')',5514);

DELETE FROM adr WHERE geom IS NULL;