Gehört zu: [SMTP – Das naivste Protokoll des Internets](https://blog.root42.at/blog/email-spoofing-spf-dkim-dmarc)

# E-Mail-Spoofing lokal nachstellen

Eine MailHog-Instanz als lokaler SMTP-Sink plus drei Testmails, die den
Unterschied zwischen Envelope Sender und From-Header sichtbar machen.

MailHog fängt jede eingehende Mail ab, ohne sie zuzustellen, und prüft dabei
selbst **kein** SPF, DKIM oder DMARC. Genau deshalb eignet es sich, um beide
Absenderfelder isoliert nebeneinander zu betrachten.

## Voraussetzungen

- Docker (unter Windows/macOS Docker Desktop, unter Linux die Docker-Engine)
- Unter Windows zusätzlich WSL2 mit aktivierter Docker-Desktop-Integration,
  weil die Befehle Bash-Syntax nutzen
- Internetzugang für den ersten Image-Download (rund 250 MB)

## Dateien

| Datei | Zweck |
|---|---|
| `docker-compose.yml` | MailHog auf Port 1025 (SMTP) und 8025 (Web-UI) |
| `testmails.sh` | verschickt alle drei Testmails nacheinander |

## Verwendung

```bash
docker compose up -d
./testmails.sh
```

Ergebnis unter `http://localhost:8025` ansehen. Für jede Mail zeigt der Tab
"Source" die Rohheader, dort lassen sich `Return-Path` (aus dem Envelope
Sender erzeugt) und `From` direkt vergleichen.

Eine andere Absenderdomain lässt sich per Umgebungsvariable setzen:

```bash
DOMAIN=meine-testdomain.local ./testmails.sh
```

Die einzelnen `swaks`-Aufrufe stehen ausgeschrieben im Blogbeitrag, falls du
sie lieber Schritt für Schritt einzeln ausführen willst.

## Aufräumen

```bash
docker compose down
```

## Hinweis

Nur eigene Test-Domains verwenden (`.local`, `.test` oder eine Domain, die
dir gehört und nicht produktiv genutzt wird). Echte fremde Domains gehören
auch in einer lokalen Testumgebung nicht in gefälschte Absenderfelder.
