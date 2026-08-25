# 🧥 Clothe The Poor

> **A Donation & Clothing Management System for connecting donors, warehouses, riders, and people in need.**

**Clothe The Poor** is a full-stack donation management system designed to streamline the process of collecting, managing, categorizing, and distributing clothing donations to people in need.

The system provides different role-based dashboards and workflows for **Donors, Donees, Riders, Warehouse Staff, Categorizing Officers, and Administrators**.

---

## 📌 Project Overview

Traditional donation systems often rely on manual coordination between donors, volunteers, warehouses, and recipients.

**Clothe The Poor** provides a centralized digital platform that manages the complete donation lifecycle:

**Donor → Pickup → Rider → Warehouse → Categorization → Donee Request → Delivery**

The system helps organizations track donations, manage inventory, assign riders, process requests, and ensure that donated clothes reach the right people.

---

## 🚀 Key Features

### 👤 Donor

* Register and login
* Submit clothing donations
* Upload donation images
* Add donation comments/details
* Schedule donation pickup
* Track donation status
* View donation history
* Location-based pickup support

### 🙋 Donee

* Register and login
* Submit clothing requests
* View available clothing/inventory
* Request required clothing items
* Track request status
* Receive delivered donations

### 🛵 Rider

* Rider authentication
* Online/Offline availability
* View assigned donations
* Accept/manage pickup tasks
* Navigate to donor locations
* Update pickup/delivery status
* Location-based workflow

### 🏭 Warehouse

* View pending donations
* Accept incoming donations
* Manage donation inventory
* Assign available riders
* Track donation status
* Manage warehouses and zones

### 👷 Warehouse Worker

* View assigned donations
* Process received clothing
* Manage inventory
* Update stock information
* Handle clothing distribution workflow

### 🗂️ Categorizing Officer

* Categorize donated clothes
* Manage clothing categories
* Process clothing according to type/size
* Update inventory categorization

### 👨‍💼 Administrator

* Manage users
* Manage roles
* Manage warehouses
* Manage zones
* Monitor donation activities
* Manage overall system data

---

## 🔄 Donation Workflow

```text
Donor
  │
  │ Submit Donation
  ▼
Warehouse
  │
  │ Accept Donation
  ▼
Rider Assigned
  │
  │ Pickup
  ▼
Warehouse
  │
  │ Sorting & Categorization
  ▼
Inventory
  │
  │ Donee Request
  ▼
Warehouse
  │
  │ Assign Delivery
  ▼
Rider
  │
  │ Deliver
  ▼
Donee
```

---

## 🛠️ Technology Stack

### Frontend

* **Flutter**
* **Dart**
* **GetX** — State Management
* **HTTP Package** — REST API communication
* **Shared Preferences** — Local session/user data
* **Google Maps** — Location and map functionality
* **Geolocator** — Device location
* **Image Picker** — Donation image upload

### Backend

* **ASP.NET Web API**
* **C#**
* **Entity Framework**
* **Database First Approach**
* **RESTful APIs**

### Database

* **Microsoft SQL Server**

### Development Tools

* **Visual Studio**
* **Android Studio**
* **VS Code**
* **Git & GitHub**
* **Postman**

---

## 🏗️ System Architecture

```text
┌───────────────────────────────┐
│          Flutter App          │
│                               │
│  UI + GetX + HTTP + Models    │
└───────────────┬───────────────┘
                │
                │ REST API
                ▼
┌───────────────────────────────┐
│      ASP.NET Web API          │
│                               │
│ Controllers + Business Logic  │
│        Entity Framework       │
└───────────────┬───────────────┘
                │
                │
                ▼
┌───────────────────────────────┐
│        SQL Server             │
│                               │
│ Users | Roles | Donations     │
│ Warehouses | Zones | Inventory│
└───────────────────────────────┘
```

---

## 📱 Application Highlights

### Authentication & Authorization

The application uses role-based authentication so that each user can access functionality according to their assigned role.

Example roles include:

```text
Admin
Donor
Donee
Rider
Warehouse Staff
Categorizing Officer
Warehouse Worker
```

### 📍 Location-Based Donations

Google Maps and device location services are integrated to support:

* Donor pickup locations
* Rider navigation
* Warehouse locations
* Latitude/Longitude handling
* Location-based workflows

### 📦 Donation Status Tracking

Donation requests move through different stages:

```text
Pending
   ↓
Accepted
   ↓
Rider Assigned
   ↓
Picked Up
   ↓
Delivered
```

This allows users and administrators to track the complete donation lifecycle.

---

## 🗄️ Database

The system uses **SQL Server** with **Entity Framework Database First**.

Major entities include:

```text
Users
Roles
Zones
DonorRequests
Warehouses
Inventory
RideAssignments
DoneeRequests
```

Relationships between entities are managed using primary keys and foreign keys.

---

## 🔌 API Integration

The Flutter application communicates with the ASP.NET Web API through RESTful HTTP requests.

Example operations include:

```text
GET     → Retrieve data
POST    → Create new records
PUT     → Update existing records
DELETE  → Remove records
```

The application handles JSON responses and converts API data into Dart model classes.

---

## 📂 Project Structure

### Flutter

```text
lib/
│
├── Controllers/
├── Models/
├── Screens/
├── Widgets/
├── Services/
├── Utils/
└── main.dart
```

### ASP.NET Web API

```text
Controllers/
Models/
Entities/
Services/
Database/
```

---

## 🔐 Security & Session Management

The application includes:

* Role-based access
* User authentication
* Session/user ID management
* API-based communication
* Validation of user input
* Database relationships and constraints

---

## 🎯 Project Objectives

The main objectives of **Clothe The Poor** are:

* Digitize the clothing donation process
* Reduce manual donation management
* Connect donors with people in need
* Improve warehouse inventory management
* Automate rider assignment
* Track donations from pickup to delivery
* Improve transparency and accountability
* Make clothing distribution more organized and efficient

---

## 💡 What I Learned

Through this project, I gained practical experience in:

* Flutter application development
* GetX state management
* REST API integration
* ASP.NET Web API development
* Entity Framework Database First
* SQL Server database design
* JSON serialization/deserialization
* Role-based application workflows
* Google Maps integration
* Location-based features
* Image handling
* Git and GitHub
* Debugging and API testing
* Full-stack application architecture

---

## 📸 Screenshots

> Add screenshots of your application here.

Recommended screenshots:

1. Login / Signup
2. Donor Dashboard
3. Add Donation
4. Map Location Selection
5. Warehouse Dashboard
6. Rider Dashboard
7. Inventory Management
8. Donee Request
9. Admin Dashboard

Example:

```markdown
![Login Screen](screenshots/login.png)

![Donor Dashboard](screenshots/donor_dashboard.png)

![Warehouse Dashboard](screenshots/warehouse_dashboard.png)
```

---

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

### 2. Flutter Setup

```bash
cd <project-folder>
flutter pub get
```

### 3. Configure API

Update the API base URL in the Flutter project according to your local/server environment.

Example:

```dart
const String baseUrl = "YOUR_API_URL";
```

### 4. Database Setup

* Create/restore the SQL Server database.
* Configure the database connection string in the ASP.NET Web API.
* Update Entity Framework models if required.

### 5. Run Backend

Open the ASP.NET Web API project in Visual Studio and run the API.

### 6. Run Flutter

```bash
flutter run
```

---

## 🧪 API Testing

APIs were tested using **Postman** during development.

The API supports operations related to:

* Authentication
* Users
* Donations
* Riders
* Warehouses
* Inventory
* Donee requests
* Zones
* Donation status management

---

## 📌 Project Status

**Completed / Academic Final Year Project**

The project was developed as a full-stack software solution for managing clothing donations and distribution.

---

## 👨‍💻 Developer

**Rehan Liaqat**

**Skills demonstrated in this project:**

`Flutter` • `Dart` • `GetX` • `REST APIs` • `ASP.NET Web API` • `C#` • `Entity Framework` • `SQL Server` • `Google Maps` • `Git` • `GitHub`

---

## ⭐ If You Find This Project Interesting

Feel free to explore the repository and review the implementation.

If you find the project useful, consider giving it a ⭐ on GitHub.
