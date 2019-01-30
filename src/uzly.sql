SELECT pgr_createVerticesTable('trasy','geom','source','target');
ALTER TABLE trasy_vertices_pgr rename column the_geom to geom;
