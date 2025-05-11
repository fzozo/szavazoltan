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
        <h2>Új szavazás létrehozása</h2>
        <form action="/uj" method="post">
            <div class="form-group mb-3 mt-3">
                <label for="kerdes" class="form-label">Kérdés:</label>
                <input type="text" class="form-control" id="kerdes" name="kerdes" maxlength="100" required>
            </div>
            <div class="form-group mb-3 mt-3">
                <label for="valasz1" class="form-label">1. Válasz:</label>
                <input type="text" class="form-control" id="valasz1" name="valasz1" maxlength="100" required>
            </div>
            <div class="form-group mb-3 mt-3">
                <label for="valasz2" class="form-label">2. Válasz:</label>
                <input type="text" class="form-control" id="valasz2" name="valasz2" maxlength="100" required>
            </div>
            <div id="valaszok"></div>
            <button type="button" class="btn btn-primary" id="ujvalaszgomb" onclick="ujvalasz()">Új válasz</button>
            <div class="form-group mb-3 mt-3">
                <label for="lejarat" class="form-label">Határidő:</label>
                <input type="datetime-local" class="form-control" name="lejarat" id="lejarat" min="{{min_ido}}" max="{{max_ido}}" value="{{default_ido}}" required>
            </div>
            <button type="submit" class="btn btn-primary">Szavazás indítása</button>
        </form>
        <a href="/" class="btn btn-secondary mt-3">Vissza</a>
    </div>
    <script>
        let i = 3

        function ujvalasz() {
            const valaszokdiv = document.getElementById('valaszok')
            const ujvalasz = document.createElement('div');
            ujvalasz.className = 'form-group mb-3 mt-3';
            ujvalasz.innerHTML = `
                <label for="valasz${i}" class="form-label">${i}. Válasz:</label>
                <input type="text" class="form-control" id="valasz${i}" name="valasz${i}" maxlength="100">
            `;
            valaszokdiv.appendChild(ujvalasz);
            i++;
            if (i > 10) {
                document.getElementById('ujvalaszgomb').setAttribute('disabled', 'true')
            }
        }
    </script>
</body>
</html>