# GARUDA

<p align="center">

  <img src="https://iili.io/d8Keirv.th.jpg" alt="GARUDA Logo" width="200" height="210">
</p>

## Overview
**GARUDA** is a geolocation-based mobile application built using Flutter that automates attendance tracking across multiple office locations. Developed for Smart India Hackathon 2024, the app streamlines employee attendance by recording check-ins and check-outs based on their proximity to predefined office locations.

## Problem Statement
**Problem Statement ID: SIH1707**  
Developed for **GAIL Ministry of Petroleum and Natural Gas**  
**Theme**: Miscellaneous  
The goal is to develop an app that automates attendance using geolocation technology, reducing manual tracking errors and enhancing operational efficiency.

## Team Members
- **Punyam Singh**
- **Aayush Arora**
- **Tejaswi M**
- **Aviral Chawla**
- **Kartheek Kotha**
- **Rahul Jayaram**

## Link to Presentation
[Download the GARUDA Presentation](https://drive.google.com/file/d/1hJ7mFn0K7-jhDQJfr9KjZnOag3Mc1QW2/view?usp=drive_link)

## Features

- **Automated Attendance:** Employees are automatically checked in/out based on geolocation data.
- **Real-Time Location Tracking:** Monitors employees’ positions throughout the day to ensure accuracy.
- **Break Management:** Automatically detects when employees leave and return to the office.
- **Working Hours Calculation:** Calculates total working hours based on the geo-check-ins/outs.
- **Off-Site Attendance:** Provides flexibility for employees working from off-site locations to mark attendance.

## Technologies Utilized

- **Flutter:** Cross-platform mobile framework used to create the application.
- **Dart:** Programming language used for Flutter development.
- **Geolocator API:** Tracks employee location and automates attendance actions based on proximity to office coordinates.
- **Cloud Infrastructure:** Ensures scalability and reliability for managing attendance data.

## Screenshots

<div style="white-space: nowrap; overflow-x: auto; overflow-y: hidden; width: 100%; display: inline-block;">
   <img src="https://iili.io/JNqdiiJ.md.jpg" alt="Screenshot 1" style="width: 15%; height: 30%; margin-right: 20px; display: inline-block;">-
   <img src="https://iili.io/JNq2qRS.md.jpg" alt="Screenshot 2" style="width: 15%; height: 30%; margin-right: 20px; display: inline-block;">-
   <img src="https://iili.io/JNq3n7p.md.jpg" alt="Screenshot 3" style="width: 15%; height: 30%; margin-right: 20px; display: inline-block;">-
   <img src="https://iili.io/JNq3RBs.md.jpg" alt="Screenshot 4" style="width: 15%; height: 30%; margin-right: 20px; display: inline-block;">
</div>

## How It Works

1. **Check-In:** The app triggers check-ins automatically when an employee enters the defined office radius.
2. **Break Detection:** Employees who leave the office are automatically checked out and checked back in when they return.
3. **Working Hours Calculation:** The app calculates the total time spent at work based on check-in and check-out events.
4. **Off-Site Attendance:** Managers can assign employees to off-site locations, enabling seamless attendance tracking from remote locations.

## Challenges & Solutions

1. **Location Accuracy:** Inconsistent GPS signals could lead to incorrect tracking.
   - **Solution:** Implement a location-smoothing algorithm and use additional sensors for higher accuracy.
   
2. **Data Privacy:** Managing sensitive location data is crucial.
   - **Solution:** All data is encrypted and complies with privacy regulations.

3. **Scalability:** The app needs to handle large numbers of users efficiently.
   - **Solution:** Cloud infrastructure with auto-scaling ensures performance under high load.

## Impact & Benefits

1. **Increased Efficiency:** Reduces manual effort for attendance management.
2. **Enhanced Accuracy:** Geolocation-based tracking minimizes errors.
3. **Cost Savings:** Reduces the financial burden of manual attendance discrepancies.
4. **Improved Transparency:** Ensures accurate and transparent records for both employees and managers.

## Installation

1. Clone the repository.
2. Set up Flutter environment.
3. Configure geolocation services and cloud infrastructure.

## Contributors

- **Aayush Arora** - Flutter Development  
Feel free to contribute to the development and improvement of the GARUDA platform.
