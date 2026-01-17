-- ============================================================
-- DATABASE GRANDSTATION - COMPLETE SCHEMA & DATA
-- Sistem Pemesanan Tiket Kereta Api
-- ============================================================
-- Versi PostgreSQL
-- Pastikan database sudah dibuat terlebih dahulu
-- CREATE DATABASE grandstation;
-- ============================================================

BEGIN;

-- ============================================================
-- DROP EXISTING TABLES (OPTIONAL - Hati-hati data akan hilang!)
-- ============================================================
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS schedules CASCADE;
DROP TABLE IF EXISTS trains CASCADE;
DROP TABLE IF EXISTS stations CASCADE;
DROP TABLE IF EXISTS gallery_items CASCADE;
DROP TABLE IF EXISTS schedule_requests CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================================
-- TABLE: users (Pengguna & Admin)
-- ============================================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'user', -- 'user' atau 'admin'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: stations (Stasiun Kereta)
-- ============================================================
CREATE TABLE stations (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- ============================================================
-- TABLE: trains (Data Kereta)
-- ============================================================
CREATE TABLE trains (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    train_class VARCHAR(30) NOT NULL,
    seats_total INT NOT NULL DEFAULT 0 CHECK (seats_total >= 0)
);

-- ============================================================
-- TABLE: schedules (Jadwal Kereta)
-- ============================================================
CREATE TABLE schedules (
    id SERIAL PRIMARY KEY,
    train_id INT NOT NULL REFERENCES trains(id) ON DELETE CASCADE,
    origin_id INT NOT NULL REFERENCES stations(id) ON DELETE RESTRICT,
    destination_id INT NOT NULL REFERENCES stations(id) ON DELETE RESTRICT,
    depart_time TIMESTAMP NOT NULL,
    arrive_time TIMESTAMP NOT NULL,
    price NUMERIC(12,0) NOT NULL DEFAULT 0 CHECK (price >= 0),
    seats_available INT NOT NULL DEFAULT 0 CHECK (seats_available >= 0),
    CHECK (arrive_time > depart_time)
);

-- ============================================================
-- TABLE: bookings (Pemesanan Tiket)
-- ============================================================
CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    booking_code VARCHAR(20) NOT NULL UNIQUE,
    schedule_id INT NOT NULL REFERENCES schedules(id) ON DELETE CASCADE,
    passenger_name VARCHAR(100) NOT NULL,
    passenger_phone VARCHAR(30) NOT NULL,
    seats INT NOT NULL CHECK (seats > 0),
    total_price NUMERIC(12,0) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    approved_at TIMESTAMP,
    approved_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TABLE: payments (Pembayaran)
-- ============================================================
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    payment_code VARCHAR(50) UNIQUE NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'COMPLETED', 'FAILED'
    method VARCHAR(20) NOT NULL, -- 'TRANSFER', 'CARD', 'E_WALLET'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: schedule_requests (Permintaan jadwal dari user/guest)
-- ============================================================
CREATE TABLE schedule_requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    origin_station_id INTEGER NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
    destination_station_id INTEGER NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
    requested_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    request_count INTEGER NOT NULL DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    last_requested_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX idx_schedule_requests_route ON schedule_requests(origin_station_id, destination_station_id, requested_date);
CREATE INDEX idx_schedule_requests_status ON schedule_requests(status);

-- ============================================================
-- TABLE: gallery_items (Galeri Stasiun & Kereta)
-- ============================================================
CREATE TABLE gallery_items (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    image_url TEXT NOT NULL,
    description TEXT,
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- INDEXES untuk Performance
-- ============================================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_schedules_route_time ON schedules(origin_id, destination_id, depart_time);
CREATE INDEX idx_bookings_schedule ON bookings(schedule_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_payment_code ON payments(payment_code);
CREATE INDEX idx_payments_status ON payments(status);

-- ============================================================
-- DATA: Users (DEMO ONLY - Ganti password di production!)
-- ============================================================
INSERT INTO users (email, password, name, phone, address, role) VALUES
('admin@grandstation.com', 'admin123', 'Administrator', '081234567890', 'Jl. Gatot Subroto No. 5, Jakarta', 'admin'),
('user@grandstation.com', 'user123', 'Demo User', '081234567891', 'Jl. Sudirman No. 1, Jakarta', 'user'),
('customer1@gmail.com', 'password123', 'Budi Santoso', '081234567892', 'Jl. Asia Afrika No. 10, Bandung', 'user'),
('customer2@gmail.com', 'password123', 'Siti Nurhaliza', '081234567893', 'Jl. Malioboro No. 15, Yogyakarta', 'user');

-- ============================================================
-- DATA: Stations (Stasiun Kereta)
-- ============================================================
INSERT INTO stations(code, name, city) VALUES
('GMR', 'Gambir', 'Jakarta'),
('PSE', 'Pasar Senen', 'Jakarta'),
('BD',  'Bandung', 'Bandung'),
('SMT', 'Semarang Tawang', 'Semarang'),
('YK',  'Yogyakarta', 'Yogyakarta'),
('SGU', 'Surabaya Gubeng', 'Surabaya'),
('ML',  'Malang', 'Malang'),
('CRB', 'Cirebon', 'Cirebon'),
('TGL', 'Tegal', 'Tegal'),
('PWK', 'Purwokerto', 'Purwokerto');

-- ============================================================
-- DATA: Trains (Kereta Api)
-- ============================================================
INSERT INTO trains(code, name, train_class, seats_total) VALUES
('ARJ', 'Argo Jati', 'Eksekutif', 200),
('ARG', 'Argo Bromo Anggrek', 'Eksekutif', 220),
('SRB', 'Sancaka', 'Bisnis', 240),
('LOG', 'Logawa', 'Ekonomi', 300),
('MLG', 'Malioboro Express', 'Ekonomi', 280),
('BIM', 'Bima', 'Eksekutif', 180),
('GJY', 'Gajayana', 'Eksekutif', 190),
('TKS', 'Taksaka', 'Eksekutif', 210);

-- ============================================================
-- DATA: Gallery (Stasiun & Kereta)
-- ============================================================
INSERT INTO gallery_items(title, category, image_url, description, featured) VALUES
('Stasiun Gambir Malam Hari', 'Stasiun', 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?auto=format&fit=crop&w=1200&q=80', 'Pemandangan eksterior Gambir dengan pencahayaan malam yang elegan.', TRUE),
('Interior Kereta Eksekutif', 'Kereta', 'https://images.unsplash.com/photo-1504707748692-419802cf939d?auto=format&fit=crop&w=1200&q=80', 'Kenyamanan kabin kelas eksekutif untuk perjalanan jarak jauh.', TRUE),
('Peron Pagi Hari', 'Stasiun', 'https://images.unsplash.com/photo-1429042007245-890c9e2603af?auto=format&fit=crop&w=1200&q=80', 'Suasana peron yang sibuk saat jam berangkat pagi.', FALSE),
('Rangkaian Kereta Melintas', 'Kereta', 'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80', 'Rangkaian kereta melintas di jalur utama dengan kecepatan stabil.', FALSE),
('Stasiun Modern', 'Stasiun', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80', 'Zona keberangkatan dengan desain modern dan rapi.', FALSE),
('Kabupaten Hijau', 'Kereta', 'https://images.unsplash.com/photo-1523966211575-eb4a01e7dd51?auto=format&fit=crop&w=1200&q=80', 'Pemandangan hijau yang terlihat dari jendela kereta.', FALSE);

-- ============================================================
-- DATA: Schedules (Jadwal Kereta)
-- Menggunakan CURRENT_DATE agar selalu update otomatis
-- ============================================================

-- Hari ini
INSERT INTO schedules(train_id, origin_id, destination_id, depart_time, arrive_time, price, seats_available) VALUES
-- Jakarta - Bandung
((SELECT id FROM trains WHERE code='ARJ'), (SELECT id FROM stations WHERE code='GMR'), (SELECT id FROM stations WHERE code='BD'),
 (CURRENT_DATE + TIME '07:00'), (CURRENT_DATE + TIME '10:00'), 150000, 120),
((SELECT id FROM trains WHERE code='LOG'), (SELECT id FROM stations WHERE code='PSE'), (SELECT id FROM stations WHERE code='BD'),
 (CURRENT_DATE + TIME '13:00'), (CURRENT_DATE + TIME '16:30'), 90000, 180),

-- Jakarta - Yogyakarta
((SELECT id FROM trains WHERE code='SRB'), (SELECT id FROM stations WHERE code='GMR'), (SELECT id FROM stations WHERE code='YK'),
 (CURRENT_DATE + TIME '08:30'), (CURRENT_DATE + TIME '16:30'), 280000, 140),
((SELECT id FROM trains WHERE code='MLG'), (SELECT id FROM stations WHERE code='PSE'), (SELECT id FROM stations WHERE code='YK'),
 (CURRENT_DATE + TIME '19:00'), (CURRENT_DATE + INTERVAL '1 day' + TIME '03:30'), 250000, 160),

-- Jakarta - Surabaya
((SELECT id FROM trains WHERE code='ARG'), (SELECT id FROM stations WHERE code='GMR'), (SELECT id FROM stations WHERE code='SGU'),
 (CURRENT_DATE + TIME '20:00'), (CURRENT_DATE + INTERVAL '1 day' + TIME '04:30'), 350000, 110),
((SELECT id FROM trains WHERE code='GJY'), (SELECT id FROM stations WHERE code='GMR'), (SELECT id FROM stations WHERE code='SGU'),
 (CURRENT_DATE + TIME '18:30'), (CURRENT_DATE + INTERVAL '1 day' + TIME '02:45'), 340000, 100),

-- Semarang - Surabaya
((SELECT id FROM trains WHERE code='ARG'), (SELECT id FROM stations WHERE code='SMT'), (SELECT id FROM stations WHERE code='SGU'),
 (CURRENT_DATE + TIME '09:00'), (CURRENT_DATE + TIME '14:30'), 220000, 100),

-- Yogyakarta - Malang
((SELECT id FROM trains WHERE code='MLG'), (SELECT id FROM stations WHERE code='YK'), (SELECT id FROM stations WHERE code='ML'),
 (CURRENT_DATE + TIME '17:00'), (CURRENT_DATE + TIME '23:00'), 170000, 160);

-- Besok (Hari kedua)
INSERT INTO schedules(train_id, origin_id, destination_id, depart_time, arrive_time, price, seats_available) VALUES
-- Bandung - Jakarta
((SELECT id FROM trains WHERE code='ARJ'), (SELECT id FROM stations WHERE code='BD'), (SELECT id FROM stations WHERE code='GMR'),
 (CURRENT_DATE + INTERVAL '1 day' + TIME '09:00'), (CURRENT_DATE + INTERVAL '1 day' + TIME '12:00'), 150000, 120),
((SELECT id FROM trains WHERE code='LOG'), (SELECT id FROM stations WHERE code='BD'), (SELECT id FROM stations WHERE code='PSE'),
 (CURRENT_DATE + INTERVAL '1 day' + TIME '15:00'), (CURRENT_DATE + INTERVAL '1 day' + TIME '18:30'), 90000, 170),

-- Yogyakarta - Jakarta
((SELECT id FROM trains WHERE code='LOG'), (SELECT id FROM stations WHERE code='YK'), (SELECT id FROM stations WHERE code='PSE'),
 (CURRENT_DATE + INTERVAL '1 day' + TIME '07:30'), (CURRENT_DATE + INTERVAL '1 day' + TIME '15:30'), 260000, 160),

-- Surabaya - Jakarta
((SELECT id FROM trains WHERE code='BIM'), (SELECT id FROM stations WHERE code='SGU'), (SELECT id FROM stations WHERE code='GMR'),
 (CURRENT_DATE + INTERVAL '1 day' + TIME '19:00'), (CURRENT_DATE + INTERVAL '2 day' + TIME '03:30'), 360000, 95),

-- Malang - Yogyakarta
((SELECT id FROM trains WHERE code='GJY'), (SELECT id FROM stations WHERE code='ML'), (SELECT id FROM stations WHERE code='YK'),
 (CURRENT_DATE + INTERVAL '1 day' + TIME '08:00'), (CURRENT_DATE + INTERVAL '1 day' + TIME '14:00'), 175000, 140);

-- Lusa (Hari ketiga)
INSERT INTO schedules(train_id, origin_id, destination_id, depart_time, arrive_time, price, seats_available) VALUES
-- Jakarta - Bandung
((SELECT id FROM trains WHERE code='TKS'), (SELECT id FROM stations WHERE code='GMR'), (SELECT id FROM stations WHERE code='BD'),
 (CURRENT_DATE + INTERVAL '2 day' + TIME '06:30'), (CURRENT_DATE + INTERVAL '2 day' + TIME '09:30'), 160000, 130),

-- Jakarta - Yogyakarta
((SELECT id FROM trains WHERE code='TKS'), (SELECT id FROM stations WHERE code='GMR'), (SELECT id FROM stations WHERE code='YK'),
 (CURRENT_DATE + INTERVAL '2 day' + TIME '10:00'), (CURRENT_DATE + INTERVAL '2 day' + TIME '18:00'), 290000, 150);

-- ============================================================
-- DATA: Sample Bookings (Contoh Pemesanan)
-- ============================================================
INSERT INTO bookings(booking_code, schedule_id, passenger_name, passenger_phone, seats, total_price, status, user_id, created_at) VALUES
('BKG-20260106-001', 1, 'Budi Santoso', '081234567892', 2, 300000, 'approved', 3, CURRENT_TIMESTAMP - INTERVAL '2 days'),
('BKG-20260106-002', 3, 'Siti Nurhaliza', '081234567893', 1, 280000, 'pending', 4, CURRENT_TIMESTAMP - INTERVAL '1 day'),
('BKG-20260106-003', 5, 'Ahmad Fauzi', '081234567894', 3, 1050000, 'approved', 2, CURRENT_TIMESTAMP - INTERVAL '3 hours');

-- ============================================================
-- DATA: Sample Payments (Contoh Pembayaran)
-- ============================================================
INSERT INTO payments(booking_id, payment_code, amount, status, method, created_at) VALUES
(1, 'PAY-20260106-001', 300000, 'COMPLETED', 'TRANSFER', CURRENT_TIMESTAMP - INTERVAL '1 day'),
(3, 'PAY-20260106-002', 1050000, 'COMPLETED', 'E_WALLET', CURRENT_TIMESTAMP - INTERVAL '2 hours');

-- ============================================================
-- COMMENTS untuk Dokumentasi
-- ============================================================
COMMENT ON TABLE users IS 'Tabel pengguna (user & admin)';
COMMENT ON TABLE stations IS 'Tabel stasiun kereta api';
COMMENT ON TABLE trains IS 'Tabel data kereta api';
COMMENT ON TABLE schedules IS 'Tabel jadwal keberangkatan kereta';
COMMENT ON TABLE bookings IS 'Tabel pemesanan tiket';
COMMENT ON TABLE payments IS 'Tabel pembayaran';

COMMENT ON COLUMN bookings.status IS 'Status: pending, approved, rejected';
COMMENT ON COLUMN users.role IS 'Role: user, admin';
COMMENT ON COLUMN payments.status IS 'Status: PENDING, COMPLETED, FAILED';
COMMENT ON COLUMN payments.method IS 'Metode: TRANSFER, CARD, E_WALLET';

COMMIT;

-- ============================================================
-- SELESAI! Database siap digunakan
-- ============================================================
-- Untuk login:
-- Admin: email=admin@grandstation.com, password=admin123
-- User:  email=user@grandstation.com, password=user123
-- ============================================================
