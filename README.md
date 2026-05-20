# 🌿 GreenGuard – Citizen Environmental Monitoring Network

> **CS5054NT – Advanced Programming and Technologies**
> Itahari International College | London Metropolitan University | 2026

---

## 📁 Project Structure

```
greenguard_complete/
├── greenguard/                         ← Web Application (Java Servlet + JSP)
│   ├── pom.xml                         ← Maven build file
│   ├── sql/
│   │   └── greenguard_schema.sql       ← Full MySQL schema + seed data
│   └── src/main/
│       ├── java/com/greenguard/
│       │   ├── api/
│       │   │   └── ApiServlet.java     ← REST API (all /api/* endpoints)
│       │   ├── dao/                    ← Database Access Objects
│       │   │   ├── UserDAO.java
│       │   │   ├── ViolationDAO.java
│       │   │   ├── EnforcementCaseDAO.java
│       │   │   ├── MonitorApplicationDAO.java
│       │   │   ├── WatchlistDAO.java
│       │   │   └── NotificationDAO.java
│       │   ├── filter/
│       │   │   ├── AuthFilter.java     ← Session authentication guard
│       │   │   ├── RoleFilter.java     ← Role-based access control
│       │   │   └── CORSFilter.java     ← CORS headers for Android app
│       │   ├── model/                  ← Java model/entity classes
│       │   ├── servlet/
│       │   │   ├── LoginServlet.java
│       │   │   ├── RegisterServlet.java
│       │   │   ├── LogoutServlet.java
│       │   │   ├── citizen/            ← Citizen servlets
│       │   │   ├── authority/          ← Authority servlets
│       │   │   └── admin/              ← Admin servlets
│       │   └── util/
│       │       ├── DBUtil.java         ← MySQL connection factory
│       │       ├── PasswordUtil.java   ← SHA-256 hashing
│       │       ├── FileUploadUtil.java ← Photo upload handler
│       │       └── JsonUtil.java       ← Gson JSON responses
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml             ← Servlet/filter mappings
│           │   └── views/
│           │       ├── common/         ← Shared header, footer, login, register
│           │       ├── citizen/        ← Citizen JSP pages
│           │       ├── authority/      ← Authority JSP pages
│           │       └── admin/          ← Admin JSP pages
│           ├── css/style.css           ← Full design system (no Bootstrap)
│           ├── js/main.js              ← Client-side JS
│           └── index.jsp               ← Landing page
│
└── greenguard-android/                 ← Android Mobile App (XML + Java)
    └── app/
        ├── build.gradle                ← Android dependencies
        └── src/main/
            ├── AndroidManifest.xml
            ├── java/com/greenguard/android/
            │   ├── api/
            │   │   ├── ApiClient.java      ← Retrofit client with auth token
            │   │   └── GreenGuardApi.java  ← All REST endpoint interfaces
            │   ├── model/                  ← Android model classes (Gson)
            │   ├── adapter/                ← RecyclerView adapters
            │   ├── ui/
            │   │   ├── auth/               ← Login, Register, Splash
            │   │   ├── citizen/            ← Dashboard, Report, My Reports, Watchlist, Monitor
            │   │   ├── authority/          ← Cases list, Case detail + update
            │   │   └── admin/              ← User management
            │   └── util/
            │       └── SessionManager.java ← SharedPreferences token store
            └── res/
                ├── layout/                 ← All XML activity/fragment layouts
                ├── values/                 ← Colors, strings, themes
                ├── drawable/               ← Custom drawables
                └── menu/                   ← Bottom nav menu
```

---

## 🚀 Setup: Web Application

### Prerequisites
- **Java 11+**
- **Apache Tomcat 9+** (via XAMPP or standalone)
- **MySQL 8+**
- **Maven 3.6+**
- **IntelliJ IDEA** (recommended)

### Step 1 – Database Setup
```sql
-- In MySQL Workbench or phpMyAdmin or CLI:
source /path/to/greenguard/sql/greenguard_schema.sql
```
This creates:
- Database: `greenguard_db`
- All 8 tables with correct relationships
- Admin seed account: `admin@greenguard.np` / `Admin@1234`

### Step 2 – Configure DB Connection
Edit `src/main/java/com/greenguard/util/DBUtil.java`:
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/greenguard_db?...";
private static final String DB_USER = "root";
private static final String DB_PASS = "";    // ← your MySQL password
```

### Step 3 – Build with Maven
```bash
cd greenguard/
mvn clean package
```
This generates: `target/greenguard.war`

### Step 4 – Deploy to Tomcat
- Copy `target/greenguard.war` to Tomcat's `webapps/` folder
- Start Tomcat
- Access: `http://localhost:8080/greenguard/`

### Step 5 – Login
| Role      | Email                    | Password     |
|-----------|--------------------------|--------------|
| Admin     | admin@greenguard.np      | Admin@1234   |
| Citizen   | Register via /register   | (own choice) |
| Authority | Admin promotes citizen   | (own choice) |

> **Note:** New citizen registrations require admin approval before login.

---

## 📱 Setup: Android Application

### Prerequisites
- **Android Studio** (Electric Eel or newer)
- **Android SDK** – API 24+ (minSdk), API 34 (target)
- Web server running and accessible from device/emulator

### Step 1 – Open in Android Studio
```
File → Open → select greenguard-android/ folder
```

### Step 2 – Configure Server URL
Edit `app/build.gradle`:
```groovy
// For emulator connecting to localhost:
buildConfigField "String", "BASE_URL", '"http://10.0.2.2:8080/greenguard/api"'

// For real device on same WiFi:
buildConfigField "String", "BASE_URL", '"http://192.168.x.x:8080/greenguard/api"'
```

### Step 3 – Build & Run
- Connect device or start AVD emulator
- Click **Run ▶** in Android Studio

---

## 🔌 REST API Reference

All API calls use base URL: `http://your-server/greenguard/api`

Authenticated endpoints require header:
```
X-Auth-Token: <token from login response>
```

### Auth
| Method | Endpoint         | Body                        | Auth |
|--------|------------------|-----------------------------|------|
| POST   | /auth/login      | `{email, password}`         | No   |
| POST   | /auth/register   | `{fullName, email, phone, password}` | No |

### Violations
| Method | Endpoint              | Notes                   | Auth |
|--------|-----------------------|-------------------------|------|
| GET    | /violations           | `?type=&status=&page=`  | No   |
| GET    | /violations/{id}      | Single violation        | No   |
| GET    | /violations/my        | Reporter's own reports  | Yes  |
| GET    | /violations/hotspots  | Hotspot violations      | No   |
| POST   | /violations           | Multipart or JSON       | Yes  |

### Cases (Authority)
| Method | Endpoint              | Body                            | Auth      |
|--------|-----------------------|---------------------------------|-----------|
| GET    | /cases/my             | Authority's assigned cases      | AUTHORITY |
| GET    | /cases/{id}           | Full case + timeline            | AUTHORITY |
| POST   | /cases/{id}/update    | `{status, notes, actionTaken}`  | AUTHORITY |

### Green Monitor
| Method | Endpoint              | Body                          | Auth |
|--------|-----------------------|-------------------------------|------|
| GET    | /monitor/application  | Own application               | Yes  |
| POST   | /monitor/apply        | `{motivation, experience}`    | Yes  |

### Watchlist
| Method | Endpoint          | Body                              | Auth |
|--------|-------------------|-----------------------------------|------|
| GET    | /watchlist        | Own watchlist areas               | Yes  |
| POST   | /watchlist/add    | `{areaName, lat, lng, radiusKm}` | Yes  |
| POST   | /watchlist/remove | `{areaId}`                        | Yes  |

### Admin
| Method | Endpoint                   | Body                           | Auth  |
|--------|----------------------------|--------------------------------|-------|
| GET    | /admin/users               | All users                      | ADMIN |
| POST   | /admin/users/action        | `{userId, action}`             | ADMIN |
| GET    | /admin/monitors            | All monitor applications       | ADMIN |
| POST   | /admin/monitors/review     | `{appId, userId, status, notes}` | ADMIN |
| GET    | /admin/violations          | All violations (paginated)     | ADMIN |
| POST   | /admin/violations/assign   | `{violationId, authorityId}`   | ADMIN |

---

## 🗄️ Database Tables

| Table                | Description                                     |
|----------------------|-------------------------------------------------|
| `users`              | All accounts – citizens, authorities, admins    |
| `violations`         | Every submitted environmental report            |
| `enforcement_cases`  | Cases assigned to authority officers            |
| `case_timeline`      | Step-by-step history of each enforcement case  |
| `monitor_applications` | Green Monitor program applications            |
| `certified_monitors` | Approved monitors with Bronze/Silver/Gold tier |
| `watchlist_areas`    | Areas citizens monitor for new violations      |
| `notifications`      | In-app notification messages                    |

---

## 👥 User Roles & Permissions

### Citizen (`/citizen/*`)
- Register and await admin approval
- Submit violation reports with photo + GPS
- Track own report statuses and enforcement timelines
- Apply to become a Certified Green Monitor
- Save watchlist areas → receive alerts for nearby violations

### Authority (`/authority/*`)
- View all cases assigned by admin
- Update case status: Assigned → Investigating → Action Taken → Resolved
- Add investigation notes and actions taken
- Each update appends to the public case timeline

### Admin (`/admin/*`)
- Approve/reject new user registrations
- Promote citizens to Authority role, suspend accounts
- View and filter all violations
- Assign violations to authority officers
- Review Green Monitor applications (Approve/Reject)
- View hotspot detection and system analytics

---

## 🔒 Security

- Passwords hashed with **SHA-256** (never stored plain text)
- **AuthFilter** blocks all `/citizen/*`, `/authority/*`, `/admin/*` without valid session
- **RoleFilter** enforces correct role for each URL prefix
- **CORSFilter** adds appropriate CORS headers for mobile API calls
- File uploads validated for type (image only) and size (max 5MB)
- SQL injection prevented through **PreparedStatement** throughout

---

## 📐 Architecture

```
Browser / Android App
        │
        ▼
   [Servlet Layer]          ← MVC Controller
        │
        ▼
   [DAO Layer]              ← Database Access (PreparedStatement)
        │
        ▼
   [MySQL Database]         ← greenguard_db

REST API (/api/*):
Android App → ApiServlet → DAO → MySQL
                         ↑
                    X-Auth-Token header
```

---

## 🌿 Features Checklist

| Feature                              | Web | Android |
|--------------------------------------|-----|---------|
| User registration + admin approval   | ✅  | ✅      |
| Login / logout with session          | ✅  | ✅      |
| Submit violation report              | ✅  | ✅      |
| Upload photo with report             | ✅  | ✅      |
| GPS location capture                 | ✅  | ✅      |
| View my reports + enforcement status | ✅  | ✅      |
| Public enforcement timeline          | ✅  | ✅      |
| Hotspot detection                    | ✅  | ✅      |
| Watchlist areas + alerts             | ✅  | ✅      |
| Green Monitor application            | ✅  | ✅      |
| Authority case management            | ✅  | ✅      |
| Admin user management                | ✅  | ✅      |
| Admin monitor review                 | ✅  | ✅      |
| Admin violation assignment           | ✅  | ✅      |
| In-app notifications                 | ✅  | ✅      |
| REST API for mobile                  | ✅  | ✅      |
| Role-based access control            | ✅  | ✅      |
| Responsive design (no Bootstrap)     | ✅  | —       |
