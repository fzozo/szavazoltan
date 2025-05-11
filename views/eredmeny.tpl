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
        <h1 class="text-break">Eredmény: {{szavazas[0]}} <span class="badge bg-primary" id="lejarat" data-lejarat="{{lejarat[0]}}">NaN</span></h1>
        <hr>
        % for valasz in valaszok:
            % szazalek = (valasz[2] / osszes_szavazat * 100) if osszes_szavazat else 0
            <p class="mt-2 mb-1"><strong>{{valasz[1]}}</strong>: {{valasz[2]}} szavazat</p>
            <div class="progress" style="height:20px">
                <div class="progress-bar progress-bar-striped progress-bar-animated" style="width:{{szazalek}}%">{{'%.2f' % szazalek}}%</div>
            </div>
        % end
        <hr>
        <a href="/szavazas/{{szav_id}}" class="btn btn-secondary">Vissza</a>
    </div>
    <script>
        const idomero = document.getElementById('lejarat')
        
        const hatarido = new Date(idomero.dataset.lejarat).getTime();

        function updateIdo() {
            const most = new Date().getTime();

            const kulonbseg = hatarido - most;

            if (kulonbseg < 0) {
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