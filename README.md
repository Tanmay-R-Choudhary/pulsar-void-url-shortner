# Void - Ephemeral URL Shortener & File Storage

**Void** is a full-stack, privacy-focused application for creating temporary, short-lived links for both URLs and files. It combines a sleek, responsive Flutter frontend with a robust Spring Boot backend to provide a seamless and secure user experience.

All shared content is ephemeral by design, automatically vanishing from the void after a set period, ensuring your data doesn't linger on the internet forever.

---

## Core Features

- **Dual-Purpose Functionality:** Seamlessly switch between shortening a long URL and uploading a file to get a shareable link.
- **Password Protection:** Secure your links with an optional password, hashed securely on the backend for an extra layer of privacy.
- **Ephemeral by Design (TTL):** All generated links and uploaded files are automatically deleted after **2 hours**. This is managed by a server-side mechanism, ensuring content is purged reliably.
- **Secure, Direct File Uploads:** The backend generates pre-signed URLs, allowing the client to upload files directly and securely to a cloud storage bucket (AWS S3) without exposing credentials.
- **Responsive & Interactive UI:** A clean Flutter web interface that works beautifully across devices, featuring a dynamic, animated "Pulsar" background that reacts to user interaction.
- **RESTful API:** A well-defined API built with Spring Boot that handles all business logic, from code generation to password verification and redirect management.
- **Stateful Redirection:** The application can gracefully handle password-protected links, prompting the user for a password before revealing the destination URL or initiating a file download.

---

## Tech Stack

This project is a full-stack application built with modern technologies.

### Backend (Spring Boot)

- **[Java](https://www.java.com/) & [Spring Boot](https://spring.io/projects/spring-boot)**: For building a robust, secure, and scalable RESTful API.
- **Spring Web**: To create REST controllers for handling HTTP requests.
- **Spring Data**: For database interaction to store link mappings and metadata (with MongoDB).
- **Cloud Storage Integration (AWS SDK for S3)**: To handle the generation of pre-signed URLs for secure file uploads and downloads.
- **Validation & Security**: For validating incoming requests and managing password hashing (e.g., using Spring Security).

### Frontend (Flutter)

- **[Flutter](https://flutter.dev/)**: The core framework for building the cross-platform web application.
- **[Bloc](https://bloclibrary.dev/)**: For predictable and robust state management.
- **[GoRouter](https://pub.dev/packages/go_router)**: For declarative routing and navigation.
- **[Dio](https://pub.dev/packages/dio)**: For powerful and reliable HTTP requests to the Spring Boot backend.
- **[File Picker](https://pub.dev/packages/file_picker)**: To enable file selection from the user's device.
