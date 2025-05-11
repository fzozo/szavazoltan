<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <title>SzavaZoltán</title>
</head>
<body class="bg-light">
    <div class="container-fluid bg-primary text-white p-3 d-grid shadow">
        <a href="/" class="btn btn-block text-white"><h1 class="display-5">SzavaZoltán</h1></a>
    </div>
    <div class="container mt-3 p-3 shadow bg-white rounded">
            <div class="text-center mt-2 mb-4">
                <a href="/uj" class="btn btn-primary btn-lg">Új szavazás indítása</a>
            </div>
        <button type="button" class="btn btn-outline-success w-100 mb-3" data-bs-toggle="collapse" data-bs-target="#aktiv">
            <h2 class="m-0"><span class="spinner-grow text-success"></span> Aktív szavazások</h2>
        </button>
        <div class="list-group collapse show" id="aktiv">
            % if aktiv_szavazasok:
                % for szav_id, kerdes, lejarat, szavazatok in aktiv_szavazasok:
                        <a href="/szavazas/{{szav_id}}" class="list-group-item list-group-item-action text-break">{{kerdes}} <span class="text-secondary small">• {{szavazatok}} szavazat</span><span class="badge bg-primary float-end" id="ido{{szav_id}}" data-lejarat="{{lejarat}}">NaN</span></a>
                % end
            % else:
                <p class="m-0">Nincsenek aktív szavazások.</p>
            % end
        </div>
        <button type="button" class="btn btn-outline-danger w-100 my-3" data-bs-toggle="collapse" data-bs-target="#lejart">
            <h2 class="m-0">Lejárt szavazások</h2>
        </button>
        <div class="list-group collapse show" id="lejart">
            % if lejart_szavazasok:
                % for szav_id, kerdes, lejarat, szavazatok in lejart_szavazasok:
                        <a href="/szavazas/{{szav_id}}" class="list-group-item list-group-item-action text-break">{{kerdes}} <span class="text-secondary small">• {{szavazatok}} szavazat</span><span class="badge bg-primary float-end" id="ido{{szav_id}}" data-lejarat="{{lejarat}}">NaN</span></a>
                % end
            % else:
                <p class="m-0">Nincsenek lejárt szavazások.</p>
            % end
        </div>
    </div>
    <script>
        const hataridok = document.querySelectorAll('[id^="ido"]');

        hataridok.forEach(szavazas => {
            const hatarido = new Date(szavazas.dataset.lejarat).getTime();

            function updateIdo() {
                const most = new Date().getTime();
                const kulonbseg = hatarido - most;

                if (kulonbseg < 0) {
                    szavazas.textContent = "Vége"
                    szavazas.className = "badge bg-danger float-end"
                    return;
                }

                const nap = Math.floor(kulonbseg / (1000 * 60 * 60 * 24));
                const ora = Math.floor((kulonbseg % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const perc = Math.floor((kulonbseg % (1000 * 60 * 60)) / (1000 * 60));
                const masodperc = Math.floor((kulonbseg % (1000 * 60)) / 1000);

                if (nap >= 1) {
                    szavazas.textContent = `${nap} nap`;
                } else {
                    const o = ora.toString().padStart(2, '0');
                    const p = perc.toString().padStart(2, '0');
                    const mp = masodperc.toString().padStart(2, '0');
                    szavazas.textContent = `${o}:${p}:${mp}`;
                }
            }

            updateIdo();
            setInterval(updateIdo, 1000);
        })
    </script>
</body>
</html>