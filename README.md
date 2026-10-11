# SensAI — Pediatric Motor Rehabilitation Through Gamified AI

SensAI is an AI-powered pediatric rehabilitation platform combining **webcam-based computer vision games** (MediaPipe, Phaser) for children and a comprehensive **clinical workspace** for therapists to prescribe exercises, calibrate motion thresholds, and track longitudinal motor recovery metrics.

This repository contains the **complete, fully integrated platform**: backend REST API, database schemas and migrations, child gaming portal, and the clinical analytics dashboard.

---

## Table of Contents

1. [Overview & Highlights](#1-overview--highlights)
2. [Prerequisites](#2-prerequisites)
3. [Quick Start (One-Click Installation & Launch)](#3-quick-start)
4. [Demo Accounts](#4-demo-accounts)
5. [The Full User Journey](#5-the-full-user-journey)
6. [Specialties & Available Games](#6-specialties--available-games)
7. [System Architecture](#7-system-architecture)
8. [Repository Structure](#8-repository-structure)
9. [Manual Setup (Alternative)](#9-manual-setup)
10. [Troubleshooting & FAQ](#10-troubleshooting--faq)
11. [Adding a New Game](#11-adding-a-new-game)
12. [Project Team & Credits](#12-project-team--credits)

---

## 1. Overview & Highlights

- **Child-Friendly Computer Vision**: Real-time pose, face-mesh, and hand tracking directly in the browser via MediaPipe. No specialized sensors or wearable hardware required—only a standard webcam.
- **Multidisciplinary Support**: Supports both **Physiotherapy** (*kinésithérapie*) and **Occupational Therapy** (*ergothérapie*), with isolated patient rosters and tailored game catalogs.
- **Clinically Actionable Analytics**: Automated detection of compensatory movements (e.g., shoulder shrugging, torso twisting, wrong arm usage), range-of-motion measurements, speed, and endurance tracking.
- **Safe & Engaging**: Features real-time guidance prompts, an immediate **"I feel pain / Stop"** emergency trigger, and self-evaluations (pain scale and perceived effort).
- **Offline / Keyboard Fallback**: All games support keyboard or mouse input for children unable to use a webcam or during testing.

---

## 2. Prerequisites

| Tool | Recommended Version | Download Link | Notes |
|---|---|---|---|
| **Git** | Latest | [git-scm.com](https://git-scm.com/downloads) | For cloning the repository |
| **Python** | 3.11+ (3.13 recommended) | [python.org](https://www.python.org/downloads/) | On Windows, ensure **"Add python.exe to PATH"** is checked |
| **Node.js** | 20 LTS+ (22 recommended) | [nodejs.org](https://nodejs.org) | Long-Term Support (LTS) release |
| **PostgreSQL** | 14+ (16 recommended) | [postgresql.org](https://www.postgresql.org/download/) | Remember the `postgres` superuser password |

> **Hardware & Connectivity**: A webcam and internet connection are needed to run MediaPipe models on initial load.

---

## 3. Quick Start

### Step 1: Clone the Repository
```bash
git clone https://github.com/mayssemhannachi/SensAI.git
cd SensAI
```

### Step 2: One-Click Installation
- **macOS / Linux**:
  ```bash
  chmod +x installer.sh demarrer.sh
  ./installer.sh
  ```
- **Windows**:
  Double-click `installer.bat` (or run `./installer.bat` in PowerShell).

The installer will prompt for your local PostgreSQL password, then automatically:
1. Verify Python & Node.js environments.
2. Create the Python virtual environment (`.venv`) and install backend & dashboard dependencies.
3. Generate `.env` with a secure random secret key, create the `sensai_db` database, and apply Alembic migrations.
4. Install frontend npm dependencies and configure `frontend/.env.local`.
5. Seed initial clinical demo data.

### Step 3: Run the Platform
- **macOS / Linux**:
  ```bash
  ./demarrer.sh
  ```
- **Windows**:
  Double-click `demarrer.bat`.

Once running, access the platform at:
- **Main Web Application**: [http://localhost:3000](http://localhost:3000)
- **Therapist Analytics Dashboard**: [http://localhost:8501](http://localhost:8501)
- **Interactive Backend API Docs**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

---

## 4. Demo Accounts

The platform uses a single unified login page at `http://localhost:3000/login`. Users are automatically routed based on their role:

| Role / Context | Email | Password | Destination |
|---|---|---|---|
| **Occupational Therapist (Ergo)** | `ergo.demo@sensai.tn` | `demo1234` | Clinical Analytics Space (`:8501`) |
| **Physiotherapist (Kiné)** | `demo@sensai.tn` | `demo1234` | Clinical Analytics Space (`:8501`) |
| **Patient — Ergo** (*Maya Demo*) | `ergo.patient@sensai.tn` | `demo1234` | Child Dashboard (`/dashboard`) |
| **Patient — Kiné** (*Salma Ben Ali*) | `salma.parent@sensai.tn` | `demo1234` | Child Dashboard (`/dashboard`) |

---

## 5. The Full User Journey

```
  Therapist                        Parent / Child                       Therapist
  ─────────                        ──────────────                       ─────────
  /login → Dashboard               /login → "Activate account"          Refresh Dashboard
  "New Patient":                   Code + Email + Password              Session appears:
   • Identity & diagnosis          → Child gaming portal                • Scores & accuracy
   • Game prescription   Code       → Plays with webcam/keyboard  Data  • Range of motion
   • Calibration target ───────►    → Reports pain & effort     ──────► • Compensations
   → 6-char Activation Code                                             • Alerts & evolution
```

1. **Therapist Onboarding**: The therapist signs up, chooses their specialty, creates patient profiles with diagnoses, and configures exercise parameters.
2. **Patient Activation**: The therapist provides the parent with an alphanumeric 6-character activation code (valid for 30 days). The parent activates their account at `/activate`.
3. **Gamified Therapy**: The child logs into their portal, sees only their prescribed games, and completes guided sessions with real-time feedback.
4. **Session Reporting**: Upon completion, the child submits self-evaluations (pain scale 0–5, perceived effort 0–5). The session data streams directly to the backend.
5. **Clinical Monitoring**: The therapist analyzes longitudinal progress charts, compensation rates, and session history in the Streamlit analytics workspace.

---

## 6. Specialties & Available Games

### By Specialty

| Specialty | Prescribed Games | Clinical Focus |
|---|---|---|
| **Physiotherapy** (*Kinésithérapie*) | *The Owl*, *Guardian of the Fireflies* | Cervical range of motion, head rotation, shoulder abduction/flexion |
| **Occupational Therapy** (*Ergothérapie*) | *Dance of the Fireflies*, *Guardian of the Castle* | Visual memory, sequence planning, bilateral motor coordination, impulse inhibition |

### Game Details

| Game | Movement & Action | Configurable Parameters | Tracked Metrics |
|---|---|---|---|
| **The Owl** (*Le Hibou*) | Cervical rotation (head turning) | Target angle, hold duration, repetitions, speed, safety limit, camera sensitivity, inverted direction | Left/right rotation angle, symmetry, stability, head tilt compensation |
| **Guardian of the Fireflies** (*Gardien des Lucioles*) | Shoulder elevation & abduction (arm raising) | Affected arm (L/R/Bilateral), elevation threshold, elbow extension minimum, resting tolerance | Peak angle, average peak, compensation count (other arm or trunk tilt) |
| **Dance of the Fireflies** (*Danse des Lucioles*) | Sequenced target tapping (flowers) | Active hand (Right, Left, Free, Alternating), initial sequence length, flower size | Longest sequence, ordering errors, hints used, mean step time |
| **Guardian of the Castle** (*Gardien du Château*) | Posture & gesture control (Fairies, Star, Crown, Dragon, Statue freeze) | Chosen gesture challenges, trial count, go/no-go ratio | Challenge success rate, statue inhibition success, reaction times, error breakdown |

---

## 7. System Architecture

```
┌─────────────────────────────────┐        ┌──────────────────────────────┐        ┌──────────────┐
│  SensAI Web Portal (Next.js 16) │  JWT   │  FastAPI Backend             │  SQL   │  PostgreSQL  │
│  frontend/  :3000               │───────►│  app/  :8000                 │───────►│  sensai_db   │
│  • Auth, Child Portal, Games    │        │  • Accounts, Patients, Games │        └──────────────┘
│  • MediaPipe & Phaser Engines   │        │  • Prescriptions & Sessions  │
└────────────────┬────────────────┘        └──────────────▲───────────────┘
                 │ Single Sign-On (Token)                 │ JWT
                 ▼                                        │
┌─────────────────────────────────────────────────────────┴────┐
│  Therapist Clinical Analytics (Streamlit)  data_analysis/    │
│  :8501 — Patient Roster, Prescriptions, Longitudinal Charts  │
└──────────────────────────────────────────────────────────────┘
```

- **Frontend**: Next.js 16 (App Router), React 19, Vanilla CSS & Tailwind CSS tokens, Lucide icons.
- **Computer Vision & Games**: MediaPipe (PoseLandmarker Lite, FaceMesh, HandLandmarker), Phaser 3.80.
- **Backend**: FastAPI, SQLAlchemy 2 (async-compatible declarative models), Alembic migrations, PostgreSQL, Pydantic v2, Passlib (bcrypt), python-jose (JWT).
- **Analytics & BI**: Streamlit, pandas, Plotly, NumPy.

---

## 8. Repository Structure

```
SensAI/
├── installer.bat / installer.sh   # One-click installation script
├── demarrer.bat  / demarrer.sh    # One-click multi-service launcher
├── scripts/                       # Automation logic (installer.py, demarrer.py)
├── app/                           # FastAPI application (routers, services, models, schemas)
├── alembic/                       # Database schema migrations
├── requirements.txt               # Backend dependencies
├── .env.example                   # Environment configuration template
├── data_analysis/                 # Clinical Streamlit dashboard & BI analytics
│   └── scripts/seed_backend.py    # Demo data generator
├── frontend/                      # Next.js web application
│   ├── app/                       # App Router pages (/login, /dashboard, /activate, etc.)
│   ├── components/                # UI design system, game wrappers, layout sections
│   ├── lib/                       # API clients, game specs, auth helpers
│   └── public/games/              # Embedded game bundles (gardien-lucioles, danse-lucioles, etc.)
├── games-src/gardien-chateau/     # TypeScript source code for Guardian of the Castle (Vite + Phaser)
└── docs/                          # Additional architectural and backend documentation
```

---

## 9. Manual Setup

If you prefer setting up the components manually without the automation scripts:

<details>
<summary>Click to view manual installation steps</summary>

### 1. Backend & Analytics Setup
```bash
# Create and activate Python virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
pip install -r data_analysis/requirements.txt

# Configure environment variables
cp .env.example .env
# Edit .env with your PostgreSQL credentials

# Run database migrations
python -m alembic upgrade head
```

### 2. Frontend Setup
```bash
cd frontend
npm install
cp .env.example .env.local
cd ..
```

### 3. Launch Services (Run in 3 separate terminals)
```bash
# Terminal 1: FastAPI Backend
uvicorn app.main:app --port 8000 --reload

# Terminal 2: Streamlit Dashboard
cd data_analysis && streamlit run dashboard/app.py --server.port 8501

# Terminal 3: Next.js Frontend
cd frontend && npm run dev
```

### 4. Seed Demo Data (Optional)
```bash
cd data_analysis
python scripts/seed_backend.py --register
```

</details>

---

## 10. Troubleshooting & FAQ

- **Cannot connect to PostgreSQL**: Ensure PostgreSQL is running locally (`pg_isready` or Windows Services). Verify that credentials in `.env` match your local database user.
- **Webcam permission denied**: Grant browser camera access in your browser settings. Ensure no other applications (Zoom, Teams) are locking the webcam.
- **Camera is mirrored / inverted**: In *The Owl*, head rotation direction can be inverted in the therapist game settings (toggle *Invert rotation direction*).
- **Phaser Game Compilation**: To rebuild *Guardian of the Castle* after making source modifications:
  ```bash
  cd games-src/gardien-chateau
  npm install
  npm test
  npm run build  # Compiles directly into frontend/public/games/gardien-chateau/
  ```

---

## 11. Adding a New Game

1. **Database Migration**: Create an Alembic migration adding the game entry (name, slug, specialty) to the `games` table.
2. **Frontend Route**: Add a page under `frontend/app/dashboard/game/<slug>/` and register its descriptor in `frontend/lib/games.ts` (`playable: true`).
3. **Session Reporting**: Fetch prescribed settings via `GET /me/games` and submit recorded outcomes via `POST /me/sessions`.
4. **Therapist Analytics**: Register the game slug in `PLAYABLE_GAME_SLUGS` in `data_analysis/dashboard/utils/data.py` and implement configuration widgets in `data_analysis/dashboard/components/game_settings.py`.

---

## 12. Project Team & Credits

| Domain | Contribution & Origin Branch |
|---|---|
| **SensAI Web Platform & UI/UX** | Mayssem — `sensAI-ui` |
| **FastAPI Backend & Security** | `backend-fastapi` |
| **Guardian & Dance of the Fireflies** | Maram — `maram-game` |
| **The Owl & Guardian of the Castle** | Chahed — `feature/game-hibou`, `feature/gardien-du-chateau` |
| **Clinical BI Analytics & Platform Integration** | `feature/dashboard-analytics` |

The `integration/plateforme-complete` branch unifies all subsystems into a single production-ready platform.
