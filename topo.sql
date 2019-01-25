ALTER TABLE trasy ADD COLUMN "source" integer;
ALTER TABLE trasy ADD COLUMN "target" integer;
CREATE INDEX ON trasy USING gist(geom);

--SELECT pgr_createTopology(
--'trasy', 
--100,
--the_geom:='geom', 
--id:='gid',
--source:='source',
--target:='target',
--rows_where:='true', 
--clean:='true');