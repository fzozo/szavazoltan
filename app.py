from bottle import Bottle, template, request, redirect, TEMPLATE_PATH
import sqlite3
import datetime
import os

app_dir_path = os.path.dirname(os.path.realpath(__file__))
db_path = os.path.join(app_dir_path, 'szavazo.db')
views_path = os.path.join(app_dir_path, 'views')
TEMPLATE_PATH.insert(0, views_path )

app = Bottle()
DB = db_path

def init_db():
    with sqlite3.connect(DB) as db:
        db.execute('''
            CREATE TABLE IF NOT EXISTS szavazasok (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                kerdes TEXT NOT NULL,
                lejarat TEXT
            );
        ''')
        db.execute('''
            CREATE TABLE IF NOT EXISTS valaszok (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                szavazas_id INTEGER NOT NULL,
                valasz TEXT NOT NULL,
                szavazatok INTEGER NOT NULL DEFAULT 0,
                FOREIGN KEY (szavazas_id) REFERENCES szavazasok (id) ON DELETE CASCADE
            );
        ''')

def get_szavazas(szav_id):
    with sqlite3.connect(DB) as db:
        szavazas = db.execute('SELECT kerdes FROM szavazasok WHERE id = ?', (szav_id,)).fetchone()
        lejarat = db.execute('SELECT lejarat FROM szavazasok WHERE id = ?', (szav_id,)).fetchone()
        valaszok = db.execute('SELECT id, valasz, szavazatok FROM valaszok WHERE szavazas_id = ?', (szav_id,)).fetchall()
    return szavazas, valaszok, lejarat

def add_szavazas(kerdes, valaszok, lejarat):
    with sqlite3.connect(DB) as db:
        cur = db.cursor()
        cur.execute('INSERT INTO szavazasok (kerdes, lejarat) VALUES (?, ?)', (kerdes, lejarat))
        szav_id = cur.lastrowid     # legutóbb hozzáadott id
        for valasz in valaszok:
            cur.execute('INSERT INTO valaszok (szavazas_id, valasz) VALUES (?, ?)', (szav_id, valasz.strip()))
        db.commit()
        return szav_id

def del_lejart_szavazasok():
    most = datetime.datetime.now()
    torles_hatar = (most - datetime.timedelta(days=3)).isoformat(timespec='minutes')
    with sqlite3.connect(DB) as db:
        db.execute('PRAGMA foreign_keys = ON;')
        db.execute('DELETE FROM szavazasok WHERE lejarat IS NOT NULL AND lejarat < ?', (torles_hatar,))
        db.commit()

@app.route('/')
def index():
    del_lejart_szavazasok()

    most = datetime.datetime.now()

    with sqlite3.connect(DB) as db:
        szavazasok = db.execute('''
            SELECT szavazasok.id, kerdes, lejarat, SUM(szavazatok) AS osszes_szavazat
            FROM szavazasok
            INNER JOIN valaszok ON szavazasok.id = valaszok.szavazas_id
            GROUP BY szavazasok.id
            ORDER BY osszes_szavazat DESC
            ''').fetchall()
        
    aktiv_szavazasok = []
    lejart_szavazasok = []

    for szavazas in szavazasok:
        lejarat = datetime.datetime.fromisoformat(szavazas[2]) if szavazas[2] else None

        if lejarat and lejarat < most:
            lejart_szavazasok.append(szavazas)
        else:
            aktiv_szavazasok.append(szavazas)

    return template('index', aktiv_szavazasok=aktiv_szavazasok, lejart_szavazasok=lejart_szavazasok)

@app.route('/uj')
def uj_szavazas():
    most = datetime.datetime.now()
    min_ido = most.strftime('%Y-%m-%dT%H:%M')
    max_ido = (most + datetime.timedelta(days=365)).strftime('%Y-%m-%dT%H:%M')
    default_ido = (most + datetime.timedelta(hours=1)).strftime('%Y-%m-%dT%H:%M')
    return template('uj_szavazas', min_ido=min_ido, max_ido=max_ido, default_ido=default_ido)

@app.post('/uj')
def szav_keszit():
    kerdes = request.forms.kerdes
    lejarat = request.forms.lejarat
    print(lejarat)
    valaszok = [request.forms.getunicode(f'valasz{i}') for i in range(1, 11)]
    valaszok = [valasz for valasz in valaszok if valasz and valasz.strip()]     # üres válasz kiszedése
    if kerdes and valaszok:         # egyik sem üres
        szav_id = add_szavazas(kerdes, valaszok, lejarat)
        redirect(f'/szavazas/{szav_id}')

@app.route('/szavazas/<szav_id:int>')
def szav_mutat(szav_id):
    szavazas, valaszok, lejarat = get_szavazas(szav_id)
    return template('szavazas', szav_id=szav_id, szavazas=szavazas[0], valaszok=valaszok, lejarat=lejarat)

@app.post('/szavazas/<szav_id:int>')
def szavaz(szav_id):
    valasz_id = request.forms.valasz_id
    with sqlite3.connect(DB) as db:
        lejarat = db.execute('SELECT lejarat FROM szavazasok WHERE id = ?', (szav_id,)).fetchone()
        deadline = datetime.datetime.fromisoformat(lejarat[0])
        now = datetime.datetime.now()
        if now > deadline:
            return "Ez a szavazás lejárt. Nem lehet már szavazni."
        db.execute('UPDATE valaszok SET szavazatok = szavazatok + 1 WHERE id = ?', (valasz_id,))
        db.commit()
    redirect(f'/szavazas/{szav_id}/eredmeny')

@app.route('/szavazas/<szav_id:int>/eredmeny')
def eredmeny(szav_id):
    szavazas, valaszok, lejarat = get_szavazas(szav_id)
    osszes_szavazat = sum(valasz[2] for valasz in valaszok)
    return template('eredmeny', szavazas=szavazas, valaszok=valaszok, osszes_szavazat=osszes_szavazat, szav_id=szav_id, lejarat=lejarat)

init_db()

if __name__ == '__main__':
    app.run(host='localhost', port=8080, debug=True, reloader=True)