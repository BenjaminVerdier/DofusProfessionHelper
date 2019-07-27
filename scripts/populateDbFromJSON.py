import sqlite3
import json
import os

JSONName = "weapons.json"
JSONFolder = "../resources/"

dbName = "dofus.db"
dbFolder = "../db/"


curPath = str(os.path.dirname(os.path.realpath(__file__)))

def parseJSON():
    entries = []
    with open(curPath + "/" + JSONFolder + JSONName,encoding="utf8") as json_file:
        equipments = json.load(json_file)
        for e in equipments:
            if e['type'] == "Objet d'apparat" or len(e['recipe']) == 0:
                continue
            recipe = ""
            for ingredient in e['recipe']:
                recipe += next(iter(ingredient)) + ":" + ingredient[next(iter(ingredient))]["quantity"] + ","
            recipe = recipe[:-1]
            entries.append((e['_id'], e['name'], int(e['lvl']), e['type'], recipe))
    return entries

def populateDb(listOfEntries):
    #Connect to database
    conn = sqlite3.connect(curPath + "/" + dbFolder + dbName)
    c = conn.cursor()

    c.executemany('INSERT INTO equipments VALUES (?,?,?,?,?)', listOfEntries)
    conn.commit()
    conn.close()
    pass


def main():
    entries = parseJSON()
    populateDb(entries)


if __name__ == '__main__':
    main()
