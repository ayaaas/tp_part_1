#!/usr/bin/env bash
set -euo pipefail

DOCKERFILE="${1:-Dockerfile.infer}"
IMAGE="iris-infer:bench"

[[ -f "$DOCKERFILE" ]] || { echo "Dockerfile introuvable : $DOCKERFILE" >&2; exit 1; }
[[ -f app.py ]] || { echo "app.py introuvable" >&2; exit 1; }

cp app.py app.py.bak
trap 'mv -f app.py.bak app.py' EXIT

echo "Build à froid..."
START=$(date +%s)
docker build --no-cache -f "$DOCKERFILE" -t "$IMAGE" . > build_froid_infer.log 2>&1
FROID=$(( $(date +%s) - START ))

echo "Rebuild après modification..."
echo "# modification benchmark" >> app.py
START=$(date +%s)
docker build -f "$DOCKERFILE" -t "$IMAGE" . > build_chaud_infer.log 2>&1
CHAUD=$(( $(date +%s) - START ))

TAILLE=$(docker image inspect "$IMAGE" --format '{{.Size}}')
TAILLE_MO=$(( TAILLE / 1000000 ))

echo
echo "Image : $IMAGE"
echo "Taille : ${TAILLE_MO} Mo"
echo "Build à froid : ${FROID} s"
echo "Rebuild à chaud : ${CHAUD} s"