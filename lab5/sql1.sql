DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS room_types CASCADE;
DROP TABLE IF EXISTS guests CASCADE;
DROP TABLE IF EXISTS hotels CASCADE;

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE hotels (
    hotel_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(200) NOT NULL,
    star_rating INTEGER NOT NULL CHECK (star_rating BETWEEN 1 AND 5)
);

CREATE TABLE room_types (
    room_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    amenities TEXT
);

CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    room_type_id INTEGER NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    floor_number INTEGER,
    price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'available'
        CHECK (status IN ('available', 'occupied', 'maintenance', 'inactive')),

    CONSTRAINT fk_rooms_hotel
        FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_rooms_room_type
        FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
        ON DELETE RESTRICT,

    CONSTRAINT uq_room_per_hotel UNIQUE (hotel_id, room_number)
);

CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(30),
    email VARCHAR(150) UNIQUE,
    passport_number VARCHAR(50) UNIQUE,
    address VARCHAR(255)
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    guest_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_status VARCHAR(20) NOT NULL DEFAULT 'confirmed'
        CHECK (booking_status IN ('pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_bookings_guest
        FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_bookings_room
        FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_booking_dates
        CHECK (check_out_date > check_in_date)
);

ALTER TABLE bookings
ADD CONSTRAINT no_overlap_booking
EXCLUDE USING gist (
    room_id WITH =,
    daterange(check_in_date, check_out_date, '[)') WITH &&
)
WHERE (booking_status <> 'cancelled');

CREATE INDEX idx_rooms_hotel_id ON rooms(hotel_id);
CREATE INDEX idx_rooms_room_type_id ON rooms(room_type_id);
CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_room_id ON bookings(room_id);

CREATE INDEX idx_bookings_daterange
ON bookings USING gist (daterange(check_in_date, check_out_date, '[)'));
