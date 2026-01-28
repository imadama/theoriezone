# TheorieZone

Het moderne theorie-leerplatform voor auto, motor en scooter.
Gebouwd met **Flutter** (App), **Laravel** (Backend API), en **Next.js** (Web Dashboard - *coming soon*).

## 🏗 Architectuur

- **App**: Flutter (iOS & Android) - `app/`
- **Backend**: Laravel 12 API (PHP 8.4) - `backend/`
- **Database**: PostgreSQL 15
- **Cache**: Redis
- **Infra**: Docker Compose (Nginx, PHP-FPM, DB, Redis)

## 🚀 Getting Started

### Vereisten
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (voor de app)
- Git

### 1. Backend Opzetten (Docker)

De backend draait volledig in Docker containers. Je hoeft lokaal geen PHP of Postgres te installeren.

1. Clone de repo:
   ```bash
   git clone git@github.com:imadama/theoriezone.git
   cd theoriezone
   ```

2. Start de containers:
   ```bash
   docker compose up -d
   ```
   *Dit start Nginx (poort 8080), PHP, Postgres en Redis.*

3. Setup Laravel (eenmalig):
   Installeer dependencies, genereer key en vul de database met testdata.
   ```bash
   # Installeer PHP packages
   docker exec theoriezone-api composer install

   # Genereer app key
   docker exec theoriezone-api php artisan key:generate

   # Run database migraties en seed (testdata)
   docker exec theoriezone-api php artisan migrate --seed
   ```

4. Check of het werkt:
   Open [http://localhost:8080/api/exams](http://localhost:8080/api/exams) in je browser. Je zou een JSON-lijst moeten zien met het "Auto Theorie B" examen.

### 2. Mobiele App (Flutter)

1. Ga naar de app map:
   ```bash
   cd app
   ```

2. Installeer dependencies:
   ```bash
   flutter pub get
   ```

3. Start de app (zorg dat je een Android Emulator of iOS Simulator open hebt):
   ```bash
   flutter run
   ```

   *Note: De app is geconfigureerd om verbinding te maken met de backend op `http://10.0.2.2:8080` (speciaal IP voor Android Emulator naar localhost). Als je op iOS draait of een fysiek device, moet je `api.dart` aanpassen naar je lokale LAN IP.*

## 📱 Features (MVP)

- **Login / Auth check**: App checkt bij start of gebruiker toegang heeft.
- **Paywall**: Mock-up betaalscherm (Simulatie: 90 dagen toegang voor €29,99).
- **Entitlements**: Backend houdt bij tot wanneer een gebruiker toegang heeft.
- **Examen Modus**:
  - Lijst van beschikbare examens.
  - Vragen beantwoorden (Multiple choice).
  - Ondersteuning voor afbeeldingen bij vragen.

## 🛠 API Endpoints (Lokaal)

- `GET /api/entitlements/check` - Check toegang status.
- `POST /api/entitlements/grant-demo` - Geef tijdelijk toegang (test knop).
- `GET /api/exams` - Lijst alle actieve examens.
- `GET /api/exams/{id}` - Haal specifiek examen op incl. vragen.

## 📝 Development Notes

- **Database resetten?**
  `docker exec theoriezone-api php artisan migrate:fresh --seed`
- **Nieuwe migration maken?**
  `docker exec theoriezone-api php artisan make:migration create_tabelnaam_table`
