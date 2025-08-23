# Void - Ephemeral URL Shortener & File Storage

**Void** is a full-stack, privacy-focused application for creating temporary, short-lived links for both URLs and files. It combines a sleek, responsive Flutter frontend with a robust Spring Boot backend to provide a seamless and secure user experience.

All shared content is ephemeral by design, automatically vanishing from the void after a set period, ensuring your data doesn't linger on the internet forever.

---

## Deployment Status

**This project is not currently deployed to a public server, but it is fully architected to be deployable.**

The included configuration files, such as the `nginx.conf`, are production-ready templates. Please note that the domain `void.io` is used as a placeholder throughout the configuration and should be replaced with your actual domain name during deployment.

---

## Prerequisites for Deployment

### Backend (Spring Boot)

To run the backend service, you must configure access to an **Amazon Web Services (AWS) S3 bucket**. This bucket is used for storing uploaded files securely.

#### S3 Bucket Setup:

1.  **Create an S3 Bucket:** Set up a new bucket in the AWS region of your choice.
2.  **Block Public Access:** For security, it is critical that you **Block all public access** in the bucket's permission settings. The application uses pre-signed URLs to grant temporary, secure access to files, so the bucket itself should never be public.

#### Backend Configuration:

The method for providing AWS credentials to the application differs based on the environment.

**1. Production (Recommended: Using IAM Roles on EC2)**

For a production environment running on an AWS EC2 instance, the most secure method is to use an IAM role. This avoids hardcoding credentials.

1.  **Create an IAM Role:** Create a role and grant it permissions to perform `s3:PutObject` and `s3:GetObject` actions on the specific S3 bucket you created.
2.  **Attach Role to EC2:** Attach this IAM role to the EC2 instance where the Spring Boot application will be deployed.
3.  **Set Environment Variables:** The AWS SDK will automatically discover credentials from the IAM role. You only need to provide the bucket name and region as environment variables:
    - `AWS_S3_BUCKET_NAME`: The name of your S3 bucket.
    - `AWS_REGION`: The AWS region where your bucket is located (e.g., `us-east-1`).

**2. Local Development (Using `.env` file)**

For running the backend on a local machine, you can use a `.env` file with credentials from an IAM user.

1.  **Create an IAM User:** Create an IAM user with the same S3 permissions (`s3:PutObject`, `s3:GetObject`) as described for the IAM role.
2.  **Generate Access Keys:** Generate an access key ID and a secret access key for this user.
3.  **Create `.env` File:** Create a `.env` file in the root of the Spring Boot project and add the following:
    - `AWS_S3_BUCKET_NAME`: The name of your S3 bucket.
    - `AWS_REGION`: The AWS region where your bucket is located.
    - `AWS_ACCESS_KEY_ID`: The IAM user's access key.
    - `AWS_SECRET_ACCESS_KEY`: The IAM user's secret key.

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

### Deployment & Proxy

- **[Nginx](https://www.nginx.com/)**: Used as a reverse proxy to manage incoming traffic, handle SSL termination, and route requests between the frontend and backend services.

---

## Architecture with Nginx

Nginx plays a crucial role as a reverse proxy, sitting in front of the Flutter and Spring Boot applications. It handles all incoming traffic and routes it intelligently.

The provided `nginx.conf` is configured to:

1.  **Serve the Flutter Frontend:** It serves the compiled static files of the Flutter web app. The `try_files $uri /index.html;` directive is key for single-page applications, ensuring that all paths are handled by `index.html` and allowing Flutter's `GoRouter` to manage the application's routes.
2.  **Proxy API Requests:** It acts as an API gateway. Any request with the `/api/` prefix is proxied to the backend Spring Boot application. This allows both the frontend and backend to be served from the same domain, which simplifies the architecture and avoids Cross-Origin Resource Sharing (CORS) issues.
3.  **Handle SSL Termination:** Nginx manages all HTTPS and SSL certificate logic (using Let's Encrypt in this example). It decrypts incoming traffic and forwards it to the appropriate service, simplifying the application-level configuration.
4.  **Enforce HTTPS:** It automatically redirects all standard HTTP (port 80) traffic to the secure HTTPS (port 443) version of the site, ensuring all communication is encrypted.
