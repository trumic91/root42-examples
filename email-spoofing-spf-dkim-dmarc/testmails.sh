#!/usr/bin/env bash
#
# Verschickt die drei Testmails aus dem Blogbeitrag an die lokale
# MailHog-Instanz. Voraussetzung: "docker compose up -d" laeuft bereits.
#
# Verwendung:
#   ./testmails.sh                  # nutzt root42.at als Beispieldomain
#   DOMAIN=meine-testdomain.local ./testmails.sh
#
# Danach das Ergebnis unter http://localhost:8025 ansehen.

set -euo pipefail

DOMAIN="${DOMAIN:-root42.at}"
SERVER="${SERVER:-mailhog:1025}"
NETWORK="${NETWORK:-mailhog-demo}"
IMAGE="nicolaka/netshoot"

send() {
  docker run --rm --network "$NETWORK" "$IMAGE" swaks "$@" --server "$SERVER"
}

echo "==> Mail 1: Envelope und From matchen (legitim)"
send --to opfer@local.test \
  --from "test@${DOMAIN}" \
  --header "From: test@${DOMAIN}" \
  --body "Hi, ich bin's - legitim."

echo
echo "==> Mail 2: Envelope != From (klassisches Spoofing)"
send --to opfer@local.test \
  --from angreifer@fremde-testdomain.local \
  --header "From: buchhaltung@${DOMAIN}" \
  --body "Dringende Ueberweisung noetig."

echo
echo "==> Mail 3: nur der Anzeigename gefaelscht (Display-Name-Spoofing)"
send --to opfer@local.test \
  --from "test@${DOMAIN}" \
  --header "From: \"Geschaeftsfuehrung (dringend)\" <test@${DOMAIN}>" \
  --body "Bitte um vertrauliche Ueberweisung, sofort."

echo
echo "Fertig. Ergebnis ansehen: http://localhost:8025"
