# Campus Guard - Intelligent Safety Assistant

## **Introduction**
The **Campus Guard** is a context-aware mobile application built with **Flutter** and powered by a **PHP/MySQL** backend. It provides a real-time safety ecosystem for educational institutions, offering tailored interfaces for Students and Campus Administrators. The system ensures a seamless flow from instant emergency SOS triggers to detailed multimedia incident reporting.

---

## **Features**
- **Role-Based Access Control (RBAC):** Distinct secure portals for Student/User and Admin roles (Login via Email or Google).
- **Emergency SOS Module:** A quick, one-touch (press and hold) SOS button for immediate distress signaling.
- **Multimedia Incident Reporting:** Submit detailed security reports with categorized text, photo attachments, and audio recordings.
- **Admin Command Center:** Managerial oversight to view incident reports, manage registered users, and update unsafe campus zones.
- **Campus Safety Broadcasts:** Admins can send real-time safety alerts to notify students about campus risks.
- **Data Persistence:** Robust backend integration using custom PHP REST APIs and a MySQL database.

---

## **Technologies Used**
- **Frontend Framework:** Flutter (Dart)
- **Backend API:** PHP 8.5.5 (RESTful Architecture)
- **Database:** MySQL (Hosted locally via XAMPP)
- **Architecture:** Multi-tier Client-Server Model
- **Security:** Encrypted Login and secure multipart data transmission for media.

---

## **Project Visuals & Logic**

### **1. Entry Point**
The application starts with a unified Welcome Screen where users select their specific role to access their respective authenticated dashboards.

![Welcome Dashboard](screenshots/welcome_screen.png)

---

### **2. Admin Portal (Command Center)**
The Admin acts as the system architect, managing security alerts and overseeing student reports.
- **Incident Oversight:** View and resolve multimedia reports submitted by students.
- **Safety Alerts:** Broadcast urgent safety notifications to the student body.

| Admin Dashboard | View Incident Reports | Send Safety Alerts |
| :---: | :---: | :---: |
| ![Admin Dashboard](screenshots/admin_dashboard.png) | ![Incident Reports](screenshots/admin_reports.png) | ![Safety Alerts](screenshots/admin_alerts.png) |

---

### **3. Student Journey (Safety Flow)**
A logical, highly accessible process designed for high-stress scenarios:
1.  **Dashboard:** Central hub to check location safety or view alert history.
2.  **Emergency SOS:** Long-press activation to prevent accidental triggers; sends immediate priority alerts.
3.  **Report Incident:** Form with category selection and media tools (Camera/Microphone).
4.  **Alert History:** Track the status (Pending/Action Taken/Resolved) of previous alerts.

| 1. Student Dashboard | 2. Emergency SOS | 3. Report Incident (Media) | 4. Alert History |
| :---: | :---: | :---: | :---: |
| ![Dashboard](screenshots/student_dashboard.png) | ![SOS](screenshots/student_sos.png) | ![Report Incident](screenshots/student_report.png) | ![History](screenshots/student_history.png) |

---

## **Core Logic & Implementation**
### **Database Schema**
The system utilizes a relational **MySQL** database for reliable data storage. Key tables include:
- `users`: Stores credentials, roles, and profile data.
- `sos_alerts`: Tracks instant, high-priority distress signals and their resolution status.
- `incident_reports`: Stores descriptive contextual data, including file paths for `photo_path` and `audio_path`.

### **Context-Aware Decision Mechanism**
The system adapts its response severity based on the trigger. 
- **SOS Alerts** bypass extensive data entry for speed, marking a high-priority flag in the database.
- **Incident Reports** require context (category, description, media) to aid campus security in forensic analysis.

---

## **Conclusion**
The **Campus Guard** system demonstrates the power of Flutter and PHP in creating professional, context-aware mobile solutions. By separating concerns between Students and Admins and integrating device hardware (GPS, Camera, Mic), it provides a secure, fast, and scalable solution for modern campus safety management.

---

## **Contact**
For inquiries or collaborations:
- **Developer:** Armaghan Malik
- **Email:** [armaghanmalik81@gmail.com](mailto:armaghanmalik81@gmail.com)
- **Phone:** +92 305 5356221
- **LinkedIn:** [View Profile](https://www.linkedin.com/in/malik-armaghan-4629493aa)

---

## **License**
> **This project is owned by Armaghan Malik and is intended for educational purposes. All rights reserved.**
