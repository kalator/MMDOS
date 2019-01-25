drop table trasy_vertices_pgr;
SELECT pgr_createTopology(
'trasy', 
10,
the_geom:='geom', 
id:='gid',
source:='source',
target:='target',
rows_where:='true', 
clean:='true');
--pak pust mmdos.py plz a pak nasledujici radky:
--SELECT pgr_createVerticesTable('trasy','geom','source','target');
--ALTER TABLE trasy_vertices_pgr rename column the_geom to geom;
--tada! ted by mely fungovat mmroutes!