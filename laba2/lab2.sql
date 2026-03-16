-- =========================================
-- Лабораторна робота 2
-- Тема: Система бронювання готелю
-- PostgreSQL schema + sample data
-- =========================================

-- Для повторного запуску скрипта
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS reservation_room CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS room_type CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS guest CASCADE;

-- =========================================
-- 1. Таблиця guest
-- =========================================
CREATE TABLE guest (
    guest_id         SERIAL PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    phone            VARCHAR(20) NOT NULL UNIQUE,
    email            VARCHAR(100) NOT NULL UNIQUE,
    passport_number  VARCHAR(20) NOT NULL UNIQUE
);

-- =========================================
-- 2. Таблиця staff
-- =========================================
CREATE TABLE staff (
    staff_id         SERIAL PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    position         VARCHAR(50) NOT NULL,
    phone            VARCHAR(20) NOT NULL UNIQUE,
    email            VARCHAR(100) NOT NULL UNIQUE
);

-- =========================================
-- 3. Таблиця room_type
-- =========================================
CREATE TABLE room_type (
    room_type_id     SERIAL PRIMARY KEY,
    type_name        VARCHAR(50) NOT NULL UNIQUE,
    capacity         INTEGER NOT NULL CHECK (capacity > 0),
    price_per_night  NUMERIC(10,2) NOT NULL CHECK (price_per_night > 0),
    description      TEXT
);

-- =========================================
-- 4. Таблиця room
-- =========================================
CREATE TABLE room (
    room_id          SERIAL PRIMARY KEY,
    room_number      VARCHAR(10) NOT NULL UNIQUE,
    floor            INTEGER NOT NULL CHECK (floor >= 1),
    status           VARCHAR(20) NOT NULL DEFAULT 'Available'
                     CHECK (status IN ('Available', 'Occupied', 'Maintenance')),
    room_type_id     INTEGER NOT NULL,
    CONSTRAINT fk_room_room_type
        FOREIGN KEY (room_type_id)
        REFERENCES room_type(room_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================
-- 5. Таблиця reservation
-- =========================================
CREATE TABLE reservation (
    reservation_id   SERIAL PRIMARY KEY,
    guest_id         INTEGER NOT NULL,
    staff_id         INTEGER NOT NULL,
    check_in_date    DATE NOT NULL,
    check_out_date   DATE NOT NULL,
    reservation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status           VARCHAR(20) NOT NULL DEFAULT 'New'
                     CHECK (status IN ('New', 'Confirmed', 'Cancelled', 'Completed')),
    total_amount     NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    CONSTRAINT chk_reservation_dates
        CHECK (check_out_date > check_in_date),
    CONSTRAINT fk_reservation_guest
        FOREIGN KEY (guest_id)
        REFERENCES guest(guest_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_reservation_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================
-- 6. Таблиця reservation_room
-- =========================================
CREATE TABLE reservation_room (
    reservation_id    INTEGER NOT NULL,
    room_id           INTEGER NOT NULL,
    price_per_night   NUMERIC(10,2) NOT NULL CHECK (price_per_night > 0),
    number_of_guests  INTEGER NOT NULL CHECK (number_of_guests > 0),
    PRIMARY KEY (reservation_id, room_id),
    CONSTRAINT fk_rr_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservation(reservation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_rr_room
        FOREIGN KEY (room_id)
        REFERENCES room(room_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================
-- 7. Таблиця payment
-- =========================================
CREATE TABLE payment (
    payment_id       SERIAL PRIMARY KEY,
    reservation_id   INTEGER NOT NULL,
    payment_date     DATE NOT NULL,
    amount           NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    payment_method   VARCHAR(20) NOT NULL
                     CHECK (payment_method IN ('Cash', 'Card', 'Online')),
    payment_status   VARCHAR(20) NOT NULL
                     CHECK (payment_status IN ('Pending', 'Paid', 'Refunded')),
    CONSTRAINT fk_payment_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservation(reservation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- INSERT INTO guest
-- =========================================
INSERT INTO guest (first_name, last_name, phone, email, passport_number) VALUES
('Ivan', 'Petrenko', '+380671111111', 'ivan.petrenko@example.com', 'AA123456'),
('Olena', 'Shevchenko', '+380672222222', 'olena.shevchenko@example.com', 'BB234567'),
('Maksym', 'Kovalenko', '+380673333333', 'maksym.kovalenko@example.com', 'CC345678'),
('Iryna', 'Melnyk', '+380674444444', 'iryna.melnyk@example.com', 'DD456789'),
('Andrii', 'Tkachenko', '+380675555555', 'andrii.tkachenko@example.com', 'EE567890');

-- =========================================
-- INSERT INTO staff
-- =========================================
INSERT INTO staff (first_name, last_name, position, phone, email) VALUES
('Anna', 'Bondarenko', 'Administrator', '+380681111111', 'anna.bondarenko@hotel.com'),
('Serhii', 'Marchenko', 'Receptionist', '+380682222222', 'serhii.marchenko@hotel.com'),
('Natalia', 'Hrytsenko', 'Manager', '+380683333333', 'natalia.hrytsenko@hotel.com'),
('Oleh', 'Savchenko', 'Receptionist', '+380684444444', 'oleh.savchenko@hotel.com'),
('Kateryna', 'Danylchuk', 'Accountant', '+380685555555', 'kateryna.danylchuk@hotel.com');

-- =========================================
-- INSERT INTO room_type
-- =========================================
INSERT INTO room_type (type_name, capacity, price_per_night, description) VALUES
('Single', 1, 1200.00, 'Single room with one bed'),
('Double', 2, 1800.00, 'Double room with one large bed'),
('Twin', 2, 1700.00, 'Room with two separate beds'),
('Suite', 4, 3500.00, 'Luxury suite with living area'),
('Family', 5, 4200.00, 'Large room for family accommodation');

-- =========================================
-- INSERT INTO room
-- =========================================
INSERT INTO room (room_number, floor, status, room_type_id) VALUES
('101', 1, 'Available', 1),
('102', 1, 'Available', 2),
('201', 2, 'Occupied', 4),
('202', 2, 'Maintenance', 3),
('301', 3, 'Available', 5);

-- =========================================
-- INSERT INTO reservation
-- =========================================
INSERT INTO reservation (guest_id, staff_id, check_in_date, check_out_date, reservation_date, status, total_amount) VALUES
(1, 1, '2026-04-10', '2026-04-12', '2026-04-01', 'Confirmed', 2400.00),
(2, 2, '2026-04-15', '2026-04-18', '2026-04-05', 'New', 5400.00),
(3, 1, '2026-04-20', '2026-04-23', '2026-04-08', 'Completed', 10500.00),
(4, 4, '2026-04-25', '2026-04-27', '2026-04-10', 'Cancelled', 3400.00),
(5, 3, '2026-05-01', '2026-05-04', '2026-04-12', 'Confirmed', 12600.00);

-- =========================================
-- INSERT INTO reservation_room
-- =========================================
INSERT INTO reservation_room (reservation_id, room_id, price_per_night, number_of_guests) VALUES
(1, 1, 1200.00, 1),
(2, 2, 1800.00, 2),
(3, 3, 3500.00, 3),
(4, 4, 1700.00, 2),
(5, 5, 4200.00, 4);

-- =========================================
-- INSERT INTO payment
-- =========================================
INSERT INTO payment (reservation_id, payment_date, amount, payment_method, payment_status) VALUES
(1, '2026-04-01', 2400.00, 'Card', 'Paid'),
(2, '2026-04-05', 2000.00, 'Online', 'Pending'),
(3, '2026-04-08', 10500.00, 'Cash', 'Paid'),
(4, '2026-04-10', 1000.00, 'Card', 'Refunded'),
(5, '2026-04-12', 5000.00, 'Online', 'Pending');

-- =========================================
-- Перевірка даних
-- =========================================
SELECT * FROM guest;
SELECT * FROM staff;
SELECT * FROM room_type;
SELECT * FROM room;
SELECT * FROM reservation;
SELECT * FROM reservation_room;
SELECT * FROM payment;
