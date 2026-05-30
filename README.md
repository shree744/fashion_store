# FashionStore – E-Commerce Web Application

## Project Overview
FashionStore is a Java Full Stack E-Commerce web application developed to provide users with an online shopping experience for fashion products. The application allows customers to browse products, add items to cart, apply coupons, place orders, track orders, give reviews, and manage their shopping activities.

The project also includes an Admin Module for managing products, customers, orders, refunds, rewards, and coupons efficiently.

---

## Objectives of the Project
* To develop a secure and user-friendly online shopping platform.
* To simplify product browsing and order management.
* To provide separate functionalities for users and admin.
* To implement real-time cart and order management.
* To understand Java Full Stack Development concepts practically.

---

## Technologies Used
| Technology | Purpose |
| :--- | :--- |
| **Java** | Backend programming language |
| **JSP** | Dynamic web page creation |
| **Servlets** | Handling request and response |
| **JDBC** | Database connectivity |
| **MySQL** | Database management |
| **HTML** | Structure of web pages |
| **CSS** | Styling and design |
| **JavaScript** | Client-side validation and interaction |
| **Maven** | Dependency and project management |
| **Apache Tomcat** | Server deployment |
| **Jakarta EE** | Enterprise Java APIs |

---

## Architecture Used
The project follows the **MVC (Model View Controller)** Architecture.

### 1. Model
Contains Java classes representing database entities. Examples:
* `Product`
* `User`
* `Cart`
* `Order`
* `Coupon`
* `Review`

### 2. View
Contains JSP pages for displaying UI to users. Examples:
* Home Page (`home.jsp`)
* Product Page (`products.jsp`)
* Cart Page (`cart.jsp`)
* Login/Register Page (`login.jsp`/`register.jsp`)
* Admin Dashboard (`dashboard.jsp`)

### 3. Controller
Contains Servlets which process requests and responses. Examples:
* `LoginServlet`
* `ProductServlet`
* `CartServlet`
* `CheckoutServlet`
* `AdminProductServlet`

---

## Main Modules

### User Module
Users can:
* Register and login
* Browse products
* View product details
* Add products to cart
* Apply coupons
* Place orders
* View order history
* Track orders
* Give product reviews
* Logout securely

### Admin Module
Admin can:
* Login securely
* Add/Edit/Delete products
* Manage orders
* Manage customers
* Handle refunds
* Manage coupons
* View dashboard details
* Manage rewards and offers

---

## Important Features

* **Product Management:** Admin can add products with product name, description, price, category, product images, and product variants (size, color, etc.).
* **Cart Management:** Users can add products to cart, update quantity, remove products, and view the total price.
* **Coupon System:** Users can apply coupons during checkout to receive discounts.
* **Reward System:** Reward points are maintained for users based on purchases.
* **Review System:** Customers can provide ratings and reviews for products.
* **Refund Management:** Refund requests are managed through the admin module.
* **Order Tracking:** Users can check the status of placed orders.

---

## Database Tables Used
Main tables used in the project:
* `users`
* `admin`
* `products`
* `product_variants`
* `product_images`
* `categories`
* `cart`
* `cart_items`
* `orders`
* `order_items`
* `coupons`
* `rewards`
* `reviews`
* `refunds`

---

## DAO Layer Used
The project uses the **DAO (Data Access Object)** pattern for database operations.
Examples:
* `ProductDAO`
* `UserDAO`
* `OrderDAO`
* `CartDAO`
* `CouponDAO`

DAO implementation classes (`impl` package) are used to separate business logic from database operations.

---

## Servlets Used in the Project
Some important servlets used are:

| Servlet Name | Purpose |
| :--- | :--- |
| **LoginServlet** | User login |
| **RegisterServlet** | User registration |
| **ProductServlet** | Display products |
| **ProductDetailServlet** | Show product details |
| **CartServlet** | Manage cart |
| **CheckoutServlet** | Handle checkout |
| **OrderServlet** | Manage orders |
| **ReviewServlet** | Handle reviews |
| **AdminProductServlet** | Manage products |
| **AdminOrderServlet** | Manage orders by admin |

---

## Maven Usage in the Project
Maven is used for:
* Managing dependencies
* Building the project
* Packaging WAR file
* Simplifying project structure

Dependencies used include:
* Jakarta Servlet API
* JSP API
* JSTL
* MySQL Connector

---

## WAR File Usage
The project is packaged as a `.war` (Web Application Archive) file.
WAR file is used to:
* Deploy the application on Apache Tomcat server
* Store all project files together
* Run the web application easily

---

## Why Product Variants are Used
Product variants are used to store different versions of the same product.
Example:
* Different sizes
* Different colors
* Different stock quantities

This helps in better inventory management and improves the user shopping experience.

---

## APIs Used in the Project
The project mainly uses:
* **JDBC API** for database connectivity
* **Servlet API** for request handling
* **JSP/JSTL APIs** for dynamic page rendering

These APIs help communication between frontend, backend, and database.

---

## Database Connectivity
The project uses JDBC for connecting the backend with the MySQL database.
* **Connection utility class:** `DBConnection.java`

It helps in:
* Opening database connections
* Executing SQL queries
* Managing transactions

---

## Frontend and Backend Connection

### Frontend to Backend
Frontend JSP pages send requests to Servlets using forms and URLs.
* *Example:* Login form &rarr; `LoginServlet`, Cart page &rarr; `CartServlet`

### Backend to Database
Servlets call DAO classes. DAO classes use JDBC to interact with the MySQL database.
* *Flow:* `JSP` &rarr; `Servlet` &rarr; `DAO` &rarr; `Database`

---

## Security Features
* Session management for login
* Admin authentication filter
* Secure logout functionality
* Input validations

---

## 📁 Project Directory Structure

```text
FashionStore/
├── .settings/                  # Eclipse/IDE-specific configurations
├── .vscode/                    # VS Code environment configurations
├── apache-maven-3.9.6/         # Bundled Maven build tool
├── pom.xml                     # Maven project configuration and dependency tree (Java 21, Jakarta EE 10)
├── start_server.ps1            # Automated PowerShell start-up, compilation, and Tomcat deployment script
├── db_output.txt               # DB Schema output file
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/
    │   │       └── fashionstore/
    │   │           ├── controller/  # Jakarta HTTP Servlets managing customer and admin requests
    │   │           ├── dao/         # Data Access Object Interfaces defining JDBC queries
    │   │           │   └── impl/    # Concrete DAO implementations connecting to MySQL DB
    │   │           ├── filter/      # Request filters (AdminAuthFilter securing the /admin/ path)
    │   │           ├── model/       # Domain Entity Models (User, Product, Order, Reward, Coupon, Refund, etc.)
    │   │           ├── service/     # Business logic packages
    │   │           └── util/        # Database connection configurations, initializer lists, and setup utilities
    │   └── webapp/
    │       ├── assets/              # Public asset folder (Vanilla CSS stylesheets, JavaScript files, images)
    │       │   ├── css/
    │       │   ├── images/
    │       │   └── js/
    │       ├── WEB-INF/             # Secured server resources
    │       │   ├── views/           # Front-end JSP view templates
    │       │   │   ├── admin/       # Dashboard, Order processing, Inventory control panels
    │       │   │   │   └── partials/# Admin Sidebar layouts
    │       │   │   └── partials/    # Core headers, footers, and Navigation structures
    │       │   └── web.xml          # Web deployment descriptor
    │       └── index.html           # Root index redirection page
    └── test/                        # Verification unit test files
```

---

---

## Future Enhancements
* Integrate online payment gateway
* Add AI-based product recommendations
* Implement email notifications
* Add wishlist functionality
* Improve security with OTP verification
* Develop mobile responsive UI

---

## Learning Outcomes
Through this project, the following concepts were learned:
* Java Full Stack Development
* MVC Architecture
* JDBC Connectivity
* Servlet and JSP integration
* Database management
* Session handling
* Maven project management
* Web application deployment

---

## Conclusion
FashionStore is a complete Java Full Stack E-Commerce application that demonstrates real-world implementation of online shopping functionalities using Java, JSP, Servlets, JDBC, MySQL, Maven, and Jakarta EE technologies. The project provides a practical understanding of frontend, backend, and database integration in enterprise web application development.
