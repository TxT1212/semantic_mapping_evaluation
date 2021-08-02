import argparse
import numpy as np
import sqlite3

import sys, os
sys.path.append('/home/ezxr/Downloads/hfnet/colmap-helpers/')
from internal.db_handling import array_to_blob, blob_to_array

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--database', required=True)
    args = parser.parse_args()
    return args


def update_target_db(database_file):
    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    names = []
    cursor.execute('SELECT name FROM images;')
    for name in cursor:
        names.append(name)

    for name in names:
        print(name[0])
        name = name[0]
        new_name = name.replace("png", "jpg")
        cursor.execute('UPDATE images SET name = ? WHERE name = ?;',
            [new_name, name])
    cursor.close()
    connection.commit()
    connection.close()



def main():
    args = parse_args()

    print('Reading the input DB')
    

    print('Updating the target DB')
    update_target_db(args.database)

    print('Done!')


if __name__ == '__main__':
    main()

