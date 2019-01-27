import psycopg2


# connect to database
conn = psycopg2.connect(host="geo102.fsv.cvut.cz",
						database="pgis_uzpd",
						user="uzpd18_a",
						password="a_uzpd18")

if conn is not None:
	print("Connected!")

cur = conn.cursor()
cur_s = conn.cursor()
cur_e = conn.cursor()

# cur_s.execute("SELECT z.gid, z.zast_nazev, t.gid FROM trasy t, zastavky z WHERE ST_Intersects(ST_Buffer(ST_StartPoint(ST_LineMerge(t.geom)),200, 2), z.geom) limit 200")
# cur_e.execute("SELECT z.gid, z.zast_nazev, t.gid FROM trasy t, zastavky z WHERE ST_Intersects(ST_Buffer(ST_EndPoint(ST_LineMerge(t.geom)),200, 2), z.geom) limit 200")

# Select starting points
cur_s.execute("SELECT DISTINCT ON(t.gid) t.gid, z.zast_uzel_ FROM trasy t, zastavky z WHERE ST_DWithin(ST_StartPoint(ST_LineMerge(t.geom)), z.geom, 500) AND t.zast_id_od = z.zast_id")

# Select end points
cur_e.execute("SELECT DISTINCT ON(t.gid) t.gid, z.zast_uzel_ FROM trasy t, zastavky z WHERE ST_DWithin(ST_EndPoint(ST_LineMerge(t.geom)), z.geom, 500) AND t.zast_id_ka = z.zast_id")

sp = cur_s.fetchone()
ep = cur_e.fetchone()
i = 0

# loop through starting and ending points, update source and target
while sp is not None or ep is not None:
	if sp is not None:
		cur.execute("UPDATE trasy SET source = {} WHERE gid = {}".format(sp[1],sp[0]))
	if ep is not None:
		cur.execute("UPDATE trasy SET target = {} WHERE gid = {}".format(ep[1],ep[0]))
	sp = cur_s.fetchone()
	ep = cur_e.fetchone()		

conn.commit()

cur_s.close()
cur_e.close()
cur.close()

if conn is not None:
	conn.close()
