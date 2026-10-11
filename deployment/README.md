# Déploiement SensAI sur un VPS

Ce dossier configure un déploiement Docker Compose avec le site, l’API, le
dashboard Streamlit, PostgreSQL et Caddy. Caddy gère automatiquement HTTPS.
Après l’installation, thérapeutes et patients utilisent le site dans leur
navigateur ; ils n’ont pas à installer Docker ni à utiliser un terminal.

## Prérequis

- Un VPS Linux avec Docker Engine et le plugin Docker Compose.
- Un nom de domaine ou sous-domaine dont l’enregistrement DNS `A` pointe vers
  l’adresse IPv4 du VPS (et `AAAA` vers son IPv6 si le serveur en a une).
- Les ports entrants `80/tcp` et `443/tcp` ouverts dans le pare-feu du VPS et
  chez l’hébergeur. Ils sont nécessaires à l’émission des certificats HTTPS.

## Installation

Depuis la racine du dépôt, sur le VPS :

```bash
git clone https://github.com/mayssemhannachi/SensAI.git
cd SensAI
cp deployment/.env.example deployment/.env
```

Modifie `deployment/.env` : indique le domaine réel et l’adresse e-mail
d’administration. Génère ensuite deux secrets différents :

```bash
openssl rand -hex 32
openssl rand -hex 48
```

Colle le premier résultat dans `POSTGRES_PASSWORD` et le second dans
`SECRET_KEY`. Garde le fichier `deployment/.env` privé : ne le publie pas et ne
le committe pas.

Démarre les services depuis la racine du dépôt :

```bash
docker compose --env-file deployment/.env -f deployment/compose.yaml up -d --build
```

Vérifie leur état et les journaux si nécessaire :

```bash
docker compose --env-file deployment/.env -f deployment/compose.yaml ps
docker compose --env-file deployment/.env -f deployment/compose.yaml logs -f
```

Quand les certificats HTTPS sont prêts, ouvre `https://<ton-domaine>`. Le site
redirige les thérapeutes vers `https://<ton-domaine>/analytics`. L’inscription
thérapeute se fait sur `/register`. Pour un patient, le thérapeute crée d’abord
son dossier et son code d’activation, puis le parent active le compte sur
`/activate`.

## Mise à jour

Récupère les changements et reconstruis les conteneurs depuis la racine :

```bash
git pull
docker compose --env-file deployment/.env -f deployment/compose.yaml up -d --build
```

## Sauvegarde PostgreSQL

Depuis la racine, crée une sauvegarde avant les mises à jour importantes :

```bash
docker compose --env-file deployment/.env -f deployment/compose.yaml exec -T db pg_dump -U sensai sensai_db > sensai-backup.sql
```

Conserve les sauvegardes dans un emplacement privé, distinct du VPS. Les
données de la base sont conservées dans le volume Docker `postgres_data` lors
d’un arrêt normal avec `docker compose down`.

## Avant d’utiliser de vraies données de santé

Ce dossier apporte le routage HTTPS et le déploiement des services ; il ne
constitue pas, à lui seul, une certification de conformité ou une solution
complète de sécurité des données de santé. Avant tout usage réel, configure et
vérifie les sauvegardes et leur restauration, les mises à jour de sécurité,
les règles de conservation et de suppression des données, les contrôles
d’accès, ainsi que les obligations légales applicables dans ton pays.
