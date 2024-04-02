# Waxpeer

Welcome to Waxpeer, a comprehensive iOS application project designed to control [Waxpeer](waxpeer.com) APIs. This README will guide you through the project structure, packages, and primary target to help you get started.

## Table of Contents
1. [Introduction](#introduction)
2. [Project Structure](#project-structure)
3. [Packages](#packages)
4. [Main Target](#main-target)
5. [License](#license)

## Introduction
Waxpeer is a versatile iOS application project that encapsulates essential components and functionalities for building robust iOS applications. It offers four distinct packages, each serving a specific purpose and a primary target comprising view models and views for the application's user interface.

## Project Structure
The project is organized into several packages, each focusing on a different aspect of iOS app development:

- **AppNetwork**: Responsible for managing network business logic, especially for sockets.
- **AppColors**: Provides a centralized location for defining and managing app colors.
- **AppUIKit**: Houses reusable UI components used throughout the application.
- **AppBaseController**: Contains base models and controllers to streamline development.

The main target includes view models and views necessary for building the application's user interface.

## Packages
### 1. AppNetwork
The `AppNetwork` package handles network connections, particularly for sockets. It provides functionalities for establishing, maintaining, and managing network connections crucial for real-time communication.

### 2. AppColors
The `AppColors` package centralizes the definition and management of app colors. It simplifies maintaining a consistent color scheme across the application by providing a single source of truth for all color-related configurations.

### 3. AppUIKit
The `AppUIKit` package contains a collection of UI components designed to be reusable across different application parts. It offers a variety of UI elements and layouts to enhance app's visual appeal and user experience.

### 4. AppBaseController
The `AppBaseController` package houses base models and controllers that serve as the foundation for building various features within the application. It encapsulates standard functionalities and patterns to promote code reusability and maintainability.

## Main Target
The project's main target includes view models and views essential for constructing the application's user interface. It leverages the functionalities provided by the packages to create a seamless and intuitive user experience.

## License
Waxpeer is licensed under the [MIT License](LICENSE). 
