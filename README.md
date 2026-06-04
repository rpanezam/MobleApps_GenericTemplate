# App Factory Monorepo Workspace (Generic Template)

Welcome to the **App Factory** repository! This monorepo is designed to facilitate the rapid generation, maintenance, and deployment of 36-60+ mobile applications utilizing a single reusable platform.

## Objective
* **Maximum Code Reuse:** Develop shared packages inside `packages/` (auth, database, ui, ads, payments, etc.) and consume them within apps.
* **Low Infrastructure Costs:** Host the unified backend on Google Cloud Run with Supabase PostgreSQL and Redis caching.
* **Solo Developer Agility:** Automate pipelines via GitHub Actions and leverage Claude Code for reviews.

---

## Directory Layout

```
app-factory/
  ├── apps/              # Mobile applications (receipt_scanner, invoice_scanner, etc.)
  ├── packages/          # Reusable shared Dart/Flutter packages
  │   ├── shared_auth/   # Firebase Authentication integration
  │   ├── shared_database/# Supabase PostgreSQL connections
  │   ├── shared_ui/     # Harmonious design system components
  │   └── ...
  ├── backend/           # Unified backend - ASP.NET Core (.NET 9)
  ├── docs/              # Architectural documentation
  ├── .github/           # GitHub Actions CI/CD workflows
  └── docker/            # Docker templates for services
```

---

## Getting Started

### Prerequisites
1. **Flutter & Dart SDK:** Install the latest stable ARM64 release.
2. **Melos:** Activate Melos globally to manage workspace dependencies:
   ```bash
   dart pub global activate melos
   ```

### Installation & Initialization
1. Clone the repository and navigate to the project root.
2. Setup environment variables:
   ```bash
   cp .env.example .env
   ```
   *Edit the newly created `.env` file to configure your local keys.*
3. Bootstrap the monorepo (installs dependencies and links all packages together):
   ```bash
   dart pub get
   ```
   *If Melos is activated globally, you can also run:*
   ```bash
   melos bootstrap
   ```

---

## Workspace Commands

The following scripts are pre-configured in `melos.yaml`:

* **Analyze Code:** Runs check on all workspace files.
  ```bash
  melos run analyze
  ```
* **Run Tests:** Executes unit and widget tests inside all apps and packages.
  ```bash
  melos run test
  ```
* **Clean Build Cache:** Runs clean in all Flutter subprojects.
  ```bash
  melos run clean
  ```
