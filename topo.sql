ALTER TABLE trasy ADD COLUMN "source" integer;
ALTER TABLE trasy ADD COLUMN "target" integer;
CREATE INDEX ON trasy USING gist(geom);
