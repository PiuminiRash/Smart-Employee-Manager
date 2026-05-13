# Smart Employee Manager
### Project Overview
**Smart Employee Manager** is a mobile application developed as part of the Software Engineer Intern assignment (2025). The application is designed to reflect real-world development scenarios, providing a streamlined platform for managing employee data through a clean and intuitive user interface.

### Technology Stack
**Technology:** Flutter
**Language:** Dart
**Architecture:** MVVM (Model-View-ViewModel)
**UI Framework:** Flutter widgets
**Networking:** Dio / http package for API integration



### Key Features
**Authentication:** * Secure Login and Registration functionalities.
* Implementation using mock APIs and local storage.

**CRUD Operations:** * Full implementation of Create, Read, Update, and Delete functionalities for employee records.
**Search & Filtering:** * Search functionality allows users to find items by name.
* Advanced filtering based on criteria such as Department and Job Role.

*
**UI/UX Design:** * Responsive and scrollable layouts designed for various device sizes.
* Intuitive navigation and user-friendly interface.




*
**Enhancements:** * Displays logged-in user details.


* Logout functionality.


* Robust error handling for network failures and invalid inputs.





### API Integration

The project prioritizes proper API integration using mock services to demonstrate professional data handling.

*
**Mock Tools:** MockAPI.io / Reqres.in


* **Endpoints Used:**
*
`GET /employees`: Retrieve all employee records.


*
`POST /employees`: Create a new employee entry.


*
`PUT /employees/:id`: Update existing employee details.


*
`DELETE /employees/:id`: Remove an employee from the system.





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
   Ensure you have an emulator or physical device connected, then run:
```bash
flutter run

```


4. **Generate Build:**
* To generate an Android APK: `flutter build apk --split-per-abi`.





### Evaluation Criteria Compliance

*
**Clean Code:** The project follows a modular and maintainable structure.


*
**Functionality:** All core features including CRUD, Search, and Filtering are fully operational.


*
**API Handling:** Correct usage of networking libraries with appropriate error states.



---

This project was completed within the 2-day time allocation as per the assignment guidelines.