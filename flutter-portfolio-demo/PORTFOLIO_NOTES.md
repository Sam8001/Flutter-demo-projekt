# Portfolio Notes

Diese Datei hält fest, wie die öffentliche Portfolio-Version vom ursprünglichen Projekt abgegrenzt ist. Sie ist vor allem als Kontext für mich selbst und für Personen gedacht, die sich das Repo genauer anschauen.

## Ziel der Demo

Die Demo zeigt einen abgeschlossenen Ausschnitt aus der App:

1. Lernmaterialien laden
2. Inhalte im Feed anzeigen
3. nach Text, Kurs, Typ und Tags filtern
4. ein Material in der Detailansicht öffnen

Damit lässt sich der wichtigste UI-Flow ansehen, ohne dass ein privates Backend oder echte Nutzerdaten benötigt werden.

## Übernommene Bereiche

- `lib/screens/home_screen.dart`
  Feed, Ladezustand, Fehlerzustand, Suche und Filterlogik
- `lib/screens/detailed_content_screen.dart`
  Detailansicht, Datumsformatierung und Link-Handling
- `lib/widgets/search.dart`
  Suchfeld mit Filter-Button
- `lib/widgets/fast_search.dart`
  Kurs-Chips und erweiterter Filterdialog
- `lib/widgets/item.dart`
  wiederverwendbare Content-Karte
- `lib/widgets/app_bar.dart`
  einfache AppBar für den Demo-Flow
- `lib/models/content_type.dart`
  Content-Typen für PDF, Bild und Video

## Anpassungen für GitHub

- Paketname auf `flutter_portfolio_demo` geändert
- neuer Einstiegspunkt in `lib/main.dart`
- Supabase-Initialisierung aus der Demo entfernt
- `lib/services/data_service.dart` als lokaler Mock-Service angelegt
- AppBar von Auth- und Settings-Navigation entkoppelt
- ursprünglichen Template-Test durch einen passenden Widget-Test ersetzt
- README, `.gitignore`, `.env.example` und diese Notizen ergänzt

## Nicht enthalten

- echte Supabase-Konfiguration
- Zugangsdaten oder private Keys
- Authentifizierung und Registrierung
- Upload- und Datei-Service
- Profil- und Settings-Flow
- Plattformordner, Build-Artefakte, Caches, IDE-Dateien und alte Git-Historie

## Sicherheitsbereinigung

Im Originalprojekt gab es eine Supabase-URL und einen anon Key im Einstiegspunkt. Diese Werte wurden nicht übernommen. Die Demo arbeitet nur mit lokalen Mock-Daten und enthält in `.env.example` ausschließlich Platzhalter.

## Prüfnotizen

Im Demo-Ordner wurden folgende Befehle verwendet:

```powershell
flutter analyze
flutter test
```

Beide Prüfungen liefen erfolgreich. `flutter pub get` hat die benötigten Paketdateien erzeugt. Dabei trat am Ende ein lokales Flutter-Git/SSL-Problem beim Tag-Fetch der SDK-Installation auf; Analyse und Tests waren danach trotzdem lauffähig.
