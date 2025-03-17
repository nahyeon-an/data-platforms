-- init
CREATE DATABASE flink_test;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO users (username, email, age, status)
VALUES
    ('alice', 'alice@example.com', 28, 'ACTIVE'),
    ('bob', 'bob@example.com', 34, 'INACTIVE'),
    ('charlie', 'charlie@example.com', 22, 'ACTIVE');

-- insert
INSERT INTO users (username, email, age) VALUES ('dave', 'dave@example.com', 30);

-- update
UPDATE users SET status = 'INACTIVE' WHERE username = 'alice';

-- delete
DELETE FROM users WHERE username = 'bob';

-- alter ~ add column
ALTER TABLE users
ADD COLUMN phone_number VARCHAR(15) AFTER email;

-- alter ~ drop column
ALTER TABLE users
DROP COLUMN phone_number;

-- alter ~ change column
ALTER TABLE users
CHANGE COLUMN username user_name VARCHAR(50) NOT NULL;

-- alter ~ rename column
ALTER TABLE users
RENAME COLUMN user_name TO username;

-- alter ~ modify column
ALTER TABLE users
MODIFY COLUMN age BIGINT;

-- alter ~ alter column
ALTER TABLE users
ALTER COLUMN status SET DEFAULT 'INACTIVE';

ALTER TABLE users
ALTER COLUMN status DROP DEFAULT;

-- alter ~ rename (table rename)
ALTER TABLE users
RENAME TO users_v2;

-- index
ALTER TABLE users_v2
ADD INDEX idx_email (email);

ALTER TABLE users_v2
ADD UNIQUE (email);

ALTER TABLE users_v2
DROP INDEX idx_email;

-- foreign key
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    order_status ENUM('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_order FOREIGN KEY (user_id) REFERENCES users_v2(id)
) ENGINE=InnoDB;

INSERT INTO orders (user_id, product_name, quantity, price, order_status)
VALUES
    (1, 'Laptop', 1, 1200.50, 'PENDING'),
    (1, 'Wireless Mouse', 2, 25.99, 'COMPLETED'),
    (2, 'Keyboard', 1, 75.00, 'PENDING'),
    (3, 'Monitor', 1, 300.00, 'CANCELLED'),
    (3, 'USB-C Cable', 3, 15.50, 'COMPLETED');

SELECT u.username, o.product_name, o.order_status, o.order_date
FROM orders o
JOIN users_v2 u ON o.user_id = u.id;

ALTER TABLE users_v2
ADD CONSTRAINT fk_user_order
FOREIGN KEY (user_id) REFERENCES orders(id);

ALTER TABLE users_v2
DROP FOREIGN KEY fk_user_order;

-- update auto increment
ALTER TABLE users_v2
AUTO_INCREMENT = 10;