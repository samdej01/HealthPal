# Health Pal – AI & IoT-Powered Health Maintenance Mobile App

## 📱 Project Overview

Health Pal is an intelligent iOS health maintenance application that integrates Artificial Intelligence (AI) and Internet of Things (IoT) technologies to help users maintain a healthy lifestyle.

The application collects real-time health data from wearable devices via Apple HealthKit, analyzes user goals using machine learning, and generates personalized meal and workout plans, functioning as a virtual personal health coach.

This project was developed as a Computer Science graduation project at Imam Mohammad Ibn Saud Islamic University (IMSIU).

---

## 🎯 Problem Statement

Many individuals struggle to maintain healthy habits due to:

- Busy lifestyles  
- Manual health tracking  
- Lack of personalized guidance  
- Low motivation and engagement  

Traditional health tracking methods are time-consuming and inconsistent. Health Pal addresses this by offering automated tracking, AI-driven recommendations, and motivational features in one unified platform  


---

## ✨ Key Features

### 📊 Real-Time Health Monitoring
- Steps, heart rate, calories burned, sleep duration  
- Data fetched automatically via Apple HealthKit  

### 🤖 AI-Powered Personalization
- Personalized workout and meal plans  
- Generated based on user goals and health data  

### 🧠 Machine Learning (K-Means Clustering)
- Groups users into health-goal clusters  
- Improves recommendation accuracy  

### 🏆 Gamification & Motivation
- Leaderboard comparing step counts  
- Daily motivational messages & affirmations  

### 📈 Progress Visualization
- Charts and dashboards for activity tracking  
- Weekly and monthly performance insights  

### 🔔 Smart Notifications
- Workout reminders  
- Health risk alerts  
- Customizable notification settings  

### 📨 User Feedback System
- In-app feedback via email integration  

---

## 🧠 AI & Machine Learning Details

### K-Means Clustering
Used to cluster users based on:
- Activity level  
- Fitness goals  
- Health metrics  

Enables scalable and efficient personalization.

Trained using curated datasets from Kaggle  


### Preprocessing
- Feature normalization and scaling  
- Sleep analysis, step normalization, calorie recommendations  

Ensures consistent and accurate predictions.

---

## 🏗️ System Architecture

Architecture Pattern: MVVM (Model-View-ViewModel)  
Frontend: SwiftUI  
Backend & Database: Firebase  
Health Data: Apple HealthKit  
AI Layer: K-Means clustering model  

The architecture ensures:
- Separation of concerns  
- Maintainability  
- Scalability  
- Clean data flow between UI, logic, and storage  

---

## 🛠️ Technologies Used

- Language: Swift  
- Frameworks: SwiftUI, HealthKit  
- Machine Learning: K-Means  
- Backend: Firebase (Authentication, Realtime Database, Cloud Messaging)  
- Tools: Xcode, Apple Developer Tools  

---

## 📂 Project Structure (Conceptual)

```text
HealthPal/
│
├── Models/              # Data models & ML logic
├── ViewModels/          controversies & state management
├── Views/               # SwiftUI screens
├── Services/            # HealthKit & Firebase services
├── AI/                  # K-Means clustering & preprocessing
├── Resources/           # Assets & UI resources
└── README.md
```

## 📱 Supported Devices

- iPhone / iPad (iOS)  
- Apple Watch (via HealthKit integration)  

---

## 🚀 Installation & Deployment

- Clone the repository  
- Open the project in Xcode  
- Connect an iOS device  
- Configure:
  - Apple HealthKit permissions  
  - Firebase project & GoogleService-Info.plist  
- Run the app directly on the device (no App Store required)  

---

## 🧪 Testing

The application was tested using multiple real-world scenarios, including:
- Valid & missing HealthKit data  
- Goal-based plan generation  
- Notification enable/disable  
- Leaderboard updates  
- Feedback submission failures  

All core features were validated for reliability and usability  

---

## 🔮 Future Enhancements

- Deep learning models (RNNs) for advanced recommendations  
- User authentication & multi-device sync  
- Android version  
- Custom wearable device  
- Enhanced data privacy & encryption  

---

## 👩‍💻 Team Members

- Samia Sami Aldejwi  
- Leen Abdullah Alzahrani  
- Reem Faisal Almalki  
- Sitah Talal Alshalawi  

Supervisor: Dr. Sultan Noman Qasem  

---

## 📄 License

This project is developed for academic and research purposes.
