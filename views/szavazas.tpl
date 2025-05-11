<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <title>SzavaZoltán</title>
</head>
<body class="bg-light">
    <div class="container-fluid bg-primary text-white p-3 d-grid shadow">
        <a href="/" class="btn btn-block text-white"><h1 class="display-5">SzavaZoltán</h1></a>
    </div>
    <div class="container mt-3 p-3 shadow bg-white rounded">
        <h1 class="text-break">{{szavazas}} <span class="badge bg-primary" id="lejarat" data-lejarat="{{lejarat[0]}}">NaN</span></h1>
        <hr>
        <form action="/szavazas/{{szav_id}}" method="post">
            % for valasz in valaszok:
                <div class="form-check">
                    <input type="radio" class="form-check-input" id="{{valasz[0]}}" name="valasz_id" value="{{valasz[0]}}" required>
                    <label class="form-check-label" for="{{valasz[0]}}">{{valasz[1]}}</label>
                </div>
            % end
            <button type="submit" class="btn btn-primary mt-2" id="szavazas-gomb">Szavazás</button>
            <p class="text-danger mt-2" id="uzenet"></p>
        </form>
        <hr>
        <a href="/" class="btn btn-secondary">Vissza</a>
        <a href="/szavazas/{{szav_id}}/eredmeny" class="btn btn-success">Eredmény megtekintése</a>
    </div>
    <script>
            const gomb = document.getElementById('szavazas-gomb');
            const uzenet = document.getElementById('uzenet');
            const idomero = document.getElementById('lejarat')
        
            const hatarido = new Date(idomero.dataset.lejarat).getTime();

            function updateIdo() {
                const most = new Date().getTime();

                const kulonbseg = hatarido - most;

                if (kulonbseg < 0) {
                    gomb.className = "btn btn-primary mt-2 disabled";
                    uzenet.textContent = "Ez a szavazás lejárt. Nem lehet már szavazni.";
                    idomero.textContent = "Vége"
                    idomero.className = "badge bg-danger"
                    return;
                }

                const nap = Math.floor(kulonbseg / (1000 * 60 * 60 * 24));
                const ora = Math.floor((kulonbseg % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const perc = Math.floor((kulonbseg % (1000 * 60 * 60)) / (1000 * 60));
                const masodperc = Math.floor((kulonbseg % (1000 * 60)) / 1000);

                if (nap >= 1) {
                    idomero.textContent = `${nap} nap`;
                } else {
                    const o = ora.toString().padStart(2, '0');
                    const p = perc.toString().padStart(2, '0');
                    const mp = masodperc.toString().padStart(2, '0');
                    idomero.textContent = `Hátralévő idő: ${o}:${p}:${mp}`;
                }
            }
            updateIdo();
            setInterval(updateIdo, 1000);
    </script>
</body>
</html>