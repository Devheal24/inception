ARG ALPINE_IMAGE=alpine@sha256:14358309a308569c32bdc37e2e0e9694be33a9d99e68afb0f5ff33cc1f695dce

# Étape 1 : Étape de build avec outils Python + compilation
FROM ${ALPINE_IMAGE} AS builder

# Installer Python et outils de build
RUN apk add --no-cache python3:3.12 py3-pip py3-venv build-base libffi-dev && \
    python3 -m venv /venv

# Activer le venv et installer les dépendances
ENV PATH="/venv/bin:$PATH"
WORKDIR /app
COPY srcs/ /app/
RUN pip install --no-cache-dir -r requirements.txt

# Étape 2 : Image finale minimaliste
FROM ${ALPINE_IMAGE}

# Installer uniquement Python minimal pour faire tourner le venv
RUN apk add --no-cache python3:3.12

# Copier le venv depuis l'étape précédente
COPY --from=builder /venv /venv
ENV PATH="/venv/bin:$PATH"

# Copier l'application
WORKDIR /app

# Utilisateur non-root (optionnel)
RUN adduser -D appuser
USER appuser

# Exposer le port de l'API
EXPOSE 8000

# Commande de démarrage
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
