# Flutter Portfolio Demo

Dieses Repo enthält eine kleine Portfolio-Version einer Study-Sharing-App, die ich im Rahmen meines App-Development-Projekts gebaut habe. In der App werden Lernmaterialien in einem Feed angezeigt, durchsucht, gefiltert und in einer Detailansicht geöffnet.

Für die Veröffentlichung auf GitHub habe ich den Ausschnitt bewusst kompakt gehalten. Private Backend-Daten, Zugangsdaten und größere Projektteile sind nicht enthalten. Stattdessen nutzt die Demo lokale Mock-Daten, damit sie ohne zusätzliche Einrichtung gestartet werden kann.

## Was die Demo zeigt

- Feed mit Lernmaterialien und Metadaten
- Suche nach Titel und Beschreibung
- Filter nach Kursen, Content-Typen und Tags
- Detailseite für ein ausgewähltes Material
- Lade- und Fehlerzustände in der Oberfläche
- einfacher Widget-Test für Feed und Suche

## Technischer Schwerpunkt

Der Code zeigt vor allem den Aufbau eines kleinen Flutter-Flows mit getrennten Verantwortlichkeiten:

- Screens für Feed und Detailansicht
- wiederverwendbare Widgets für Suche, Filter, AppBar und Content-Karten
- lokaler UI-State mit `setState`
- asynchrones Laden über einen Service
- Mock-Service als Ersatz für die ursprüngliche Backend-Anbindung
- Widget-Test für einen zentralen Nutzerablauf

## Verwendete Technologien

- Flutter
- Dart
- Material Design Widgets
- `intl` für Datumsformatierung
- `url_launcher` für Demo-Links
- `flutter_test`
- `flutter_lints`

## Projektstruktur

```text
lib/
  main.dart                         # Einstiegspunkt der Demo
  models/content_type.dart          # Content-Typen für PDF, Bild und Video
  screens/home_screen.dart          # Feed, Suche und Filter
  screens/detailed_content_screen.dart
  services/data_service.dart        # lokale Mock-Daten
  widgets/app_bar.dart
  widgets/fast_search.dart
  widgets/item.dart
  widgets/search.dart
test/widget_test.dart
PORTFOLIO_NOTES.md                  # Hinweise zur Abgrenzung vom Originalprojekt
.env.example                        # Beispiel für optionale lokale Konfiguration
```

## Projekt starten

Voraussetzung ist eine installierte Flutter-Version mit Dart SDK `^3.5.4`.

```powershell
flutter pub get
flutter run
```

Prüfungen:

```powershell
flutter analyze
flutter test
```

## Interessante Dateien

- `lib/screens/home_screen.dart`: Laden der Daten, Suche, Kursfilter und kombinierte Filterlogik
- `lib/services/data_service.dart`: Demo-Daten und Service-Schnittstelle
- `lib/widgets/item.dart`: wiederverwendbare Karte für Feed-Einträge
- `lib/screens/detailed_content_screen.dart`: Detailansicht mit Datumsformatierung und Link-Handling
- `test/widget_test.dart`: Widget-Test für Feed-Anzeige und Suchfilter

## Hinweis zur Portfolio-Version

Diese Version ist kein vollständiger Produktivstand der ursprünglichen App. Login, Registrierung, Uploads, Profileinstellungen und echte Supabase-Anfragen wurden für das öffentliche Repo entfernt. Dadurch bleibt der Code übersichtlich und kann ohne private Zugangsdaten ausprobiert werden.

Die Datei `PORTFOLIO_NOTES.md` beschreibt genauer, welche Teile übernommen und welche für diese Demo angepasst wurden.
