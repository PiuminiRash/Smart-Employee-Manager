# Smart Employee Manager
### Project Overview
**Smart Employee Manager** is a robust mobile application developed for the **Software Engineer Intern Assignment (2025)**. The application is built to handle complex real-world HR scenarios, focusing on secure authentication, employee record management (CRUD), and an automated attendance and leave system. It follows the **MVVM architecture** to ensure the code is modular, maintainable, and scalable.

### Technology Stack
* **Framework:** Flutter (Android & iOS)
* **Language:** Dart
* **Architecture:** MVVM (Model-View-ViewModel)
* **State Management:** Provider
* **Networking:** http / dio package
* **Local Storage/Mock API:** Integrated for data persistence

### Core Features & Functionalities
#### 1. Advanced Authentication System
* **Initial Login Security:** Implemented a secure login flow where, upon the first login attempt, a **verification code is sent to the user's email** to ensure account authenticity.
* **User Registration:** Secure signup process for new employees/admins.
* **Session Management:** Secure logout functionality to protect user data.

#### 2. Comprehensive Employee Management (CRUD)
* **Create:** Interface to add new employees with details like NIC, Name, and Department.
* **Read:** Real-time display of employee lists and individual profiles.
* **Update:** Ability to modify existing employee records.
* **Delete:** Functionality to remove employee records from the system.

#### 3. Real-time Attendance System
* **Check-in / Check-out:** A simplified user interface for employees to log their daily work hours.
* **Automatic Timestamping:** Records the exact time and date using `intl` formatting.
* **Attendance Logs:** A detailed history for admins to monitor punctuality and presence.

#### 4. Leave Request & Approval Workflow
* **Request Submission:** Employees can submit leave requests with specific types (e.g., Casual, Sick) and reasons.
* **Admin Approval:** A dedicated screen for admins to view pending requests and either **Approve** or **Reject** them instantly.
* **Status Tracking:** Real-time status updates (Pending/Approved/Rejected) for employees.

#### 5. Search & Dynamic Filtering
* **Search:** Quick search functionality to find employees by name.
* **Filtering:** Advanced filtering based on **Department** or **Designation** to manage large datasets easily.

#### 6. Admin Dashboard & Analytics
* **Company Overview:** High-level summary showing the total number of employees and active leave counts.
* **Payroll Calculation:** Automated calculation of the **Total Monthly Payroll cost** based on employee salary data.

### Setup and Installation
1. **Clone the Repository:**
```bash
git clone https://github.com/your-username/smart-employee-manager.git
```

2. **Install Dependencies:**
```bash
flutter pub get
```

3. **Run the Application:**
```bash
flutter run
```

### Design Principles
* **Clean Code:** Strictly followed naming conventions and modularized the ViewModels and Views.
* **Responsive UI:** Designed using Flutter widgets to be compatible with various screen sizes (Mobile & Tablet).
* **Error Handling:** Implemented validation for NIC, email formats, and network failure handling.
---
