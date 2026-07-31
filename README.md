# korean-tech

Online test and examination platform starter built as a monorepo with:

- `mobile/`: Flutter app for Android and iOS
- `backend/`: Laravel API backend

## What’s Included

- Flutter app shell with dashboard, exams, results, enquiries, and profile screens
- Laravel API routes for dashboard, categories, courses, packages, exams, and enquiries
- SQLite-backed Laravel database schema with sample seeded data
- SRS-aligned domain tables for categories, subjects, courses, exams, questions, options, packages, and enquiries

## Mobile App

The Flutter app currently uses a mock repository so the UI works immediately and can be wired to the API next.

Run it with:

```bash
cd mobile
flutter run
```

## Backend API

The Laravel backend uses SQLite by default.

Run the migrations and seeders with:

```bash
cd backend
php artisan migrate --force
php artisan db:seed --force
php artisan serve
```

## API Endpoints

- `GET /api/v1/health`
- `GET /api/v1/dashboard`
- `GET /api/v1/categories`
- `GET /api/v1/courses`
- `GET /api/v1/packages`
- `GET /api/v1/exams`
- `GET /api/v1/enquiries`
- `POST /api/v1/enquiries`

## Notes

- The current build is a strong MVP scaffold, not the full production platform from the SRS.
- The next step is to connect the Flutter repository layer to the Laravel API and add auth, payment, and admin features.
