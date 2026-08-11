-- Drop tables if they exist in reverse order of dependencies
DROP TABLE IF EXISTS payment_info;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS account_info;
DROP TABLE IF EXISTS customer;

-- 1. Customer Table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Address Table (Supports multiple addresses per customer, e.g., shipping/billing)
CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_type ENUM('SHIPPING', 'BILLING', 'HOME') DEFAULT 'HOME',
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- 3. Payment Info Table (Stores masked credit card or payment gateway details)
CREATE TABLE payment_info (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    provider VARCHAR(50) NOT NULL, -- e.g., 'Stripe', 'PayPal', 'Visa'
    masked_card_number VARCHAR(20) NOT NULL, -- e.g., '****-****-****-1234'
    expiry_month INT NOT NULL,
    expiry_year INT NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- 4. Account Info Table (One-to-one relationship with customer for login/status data)
CREATE TABLE account_info (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    status ENUM('ACTIVE', 'SUSPENDED', 'DEACTIVATED', 'PENDING') DEFAULT 'PENDING',
    role ENUM('CUSTOMER', 'ADMIN', 'SUPPORT') DEFAULT 'CUSTOMER',
    last_login TIMESTAMP NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);
