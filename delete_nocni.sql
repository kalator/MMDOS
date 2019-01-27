 DELETE FROM trasy 
 WHERE (l_metro_n IS NULL
OR l_tram_n IS NOT NULL
OR l_bus_n IS NOT NULL
OR l_lan_n IS NOT NULL
OR l_vlak_n IS NOT NULL
OR l_lod_n IS NOT NULL)
AND l_metro IS NULL
 AND l_tram IS NULL
 AND l_bus IS NULL
 AND l_lan IS NULL 
 AND l_vlak IS NULL 
 AND l_lod IS NULL;
 
DELETE FROM zastavky 
WHERE zast_denno = 2;