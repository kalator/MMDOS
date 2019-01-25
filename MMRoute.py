import psycopg2
import logging
import sys


logging.basicConfig(stream=sys.stdout, level=logging.DEBUG, format="%(message)s")
log = logging.getLogger()


def run():
    cur = connect_database("geo102.fsv.cvut.cz", "pgis_uzpd", "uzpd18_a", "a_uzpd18")
    print_logo()

    # user input
    id_from, id_to = get_itinerary(cur)  # returns 2 arrays

    stops, lines = compute_route(id_from, id_to, cur)

    write_output(stops, lines)


def connect_database(host, database, user, password):
    # connect to database
    log.info("Connecting to database {} on {}...".format(database, host))
    conn = psycopg2.connect(host=host,
                            database=database,
                            user=user,
                            password=password)
    if conn is not None:
        log.info("Connected!")

        # create cursor
        cur = conn.cursor()
        return cur
    else:
        raise ConnectionError('Database did not connect, terminating...')


def print_logo():
    print("")
    print("""
-------------------------------------------
      __  __ __  __ _____   ____   _____  
     |  \/  |  \/  |  __ \ / __ \ / ____| ©
     | \  / | \  / | |  | | |  | | (___  
     | |\/| | |\/| | |  | | |  | |\___ \ 
     | |  | | |  | | |__| | |__| |____) |
     |_|  |_|_|  |_|_____/ \____/|_____/ 

      Created by: Maru & Michael 2019                       
-------------------------------------------""")


def get_itinerary(cur):
    print("Start with typing from where you want to travel:")
    street_from = input("Street: ")
    hn_from = input("House number: ")
    hon_from = input("House orientation number: ")

    print("\nWhere do you want to go?")
    street_to = input("Street: ")
    hn_to = input("House number: ")
    hon_to = input("House orientation number: ")

    id_from = []
    id_to = []

    cur.execute("SELECT * FROM findvertexid(%s, %s, %s)", (hn_from, hon_from, street_from))
    it = cur.fetchone()

    while it is not None:
        id_from.append(it[0])
        it = cur.fetchone()

    cur.execute("SELECT * FROM findvertexid(%s, %s, %s)", (hn_to, hon_to, street_to))
    it = cur.fetchone()

    while it is not None:
        id_to.append(it[0])
        it = cur.fetchone()

    return id_from, id_to


def compute_route(id_from, id_to, cur):

    # dijkstra algorithm
    cur.execute(
        "SELECT z.zast_nazev, trasy.l_metro, trasy.l_tram, trasy.l_bus, trasy.l_lan, trasy.l_vlak, trasy.l_lod, node "
        "FROM pgr_dijkstra('SELECT gid as id, source, target, CAST(shape_leng as REAL) as cost FROM trasy', %s, %s) "
        "LEFT JOIN (SELECT DISTINCT(zastavky.zast_uzel_), zastavky.zast_nazev FROM zastavky) AS z ON node = z.zast_uzel_ "
        "LEFT JOIN trasy ON edge = trasy.gid ORDER BY seq;", (id_from, id_to))

    all_lines = []
    all_stops = []
    all_nodes = []
    stop = cur.fetchone()
    while stop is not None:
        all_stops.append(stop[0])
        all_nodes.append(stop[7])
        got_line = False
        line = ''
        for i in range(1, 6):
            if stop[i] is not None:
                if got_line:
                    line = line + ", " + stop[i]
                else:
                    line = stop[i]
                    got_line = True

        all_lines.append(line.split(', '))
    #    print("{:^30s}|{:^30s}".format(segment[0], str(line)))
        stop = cur.fetchone()

    i = 0
    lns = []
    while i < len(all_lines) - 1:

        max_reach = [0, -1]  # [line, reach]

        for stop in all_lines[i]:
            reach = 0
            for j in range(i + 1, len(all_lines)):
                if stop in all_lines[j]:
                    reach += 1
                elif max_reach[1] < reach:
                        max_reach = [stop, reach]
                        break
                else:
                    break

        if i == 0:
            lns.append("Get on: " + max_reach[0])
            lns.extend([max_reach[0]]*(max_reach[1]))
        else:
            lns.append("Transfer to: " + max_reach[0])
            lns.extend([max_reach[0]]*(max_reach[1]))

        if max_reach[1] == 0:
            i += 1
        else:
            i += max_reach[1] + 1

    lns.append("Get off here!")

    return all_stops, lns


def write_output(stops, lines):
    print("\nYour trasa:")
    print("{:^30s}|{:^30s}".format("Stop", "Line"))
    print("--------------------------------------------------------------")

    for stop, line in zip(stops, lines):
        print("{:^30s}|{:^30s}".format(str(stop), str(line)))


if __name__ == '__main__':
    run()
