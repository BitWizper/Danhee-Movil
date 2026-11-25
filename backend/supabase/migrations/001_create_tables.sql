-- Migración 001: Crear tablas del esquema de Danhee
-- Ejecutar en Supabase SQL Editor

-- Habilitar UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla users
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT auth.uid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255),
  role VARCHAR(20) NOT NULL CHECK (role IN ('client', 'baker')),
  address TEXT,
  phone VARCHAR(20),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla baker_profiles
CREATE TABLE IF NOT EXISTS baker_profiles (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  business_name VARCHAR(255) NOT NULL,
  location VARCHAR(255) NOT NULL,
  specialty VARCHAR(255) NOT NULL,
  bio TEXT,
  portfolio_url TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  average_rating DECIMAL(3,1) DEFAULT 0.0,
  total_reviews INTEGER DEFAULT 0,
  business_hours JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla categories
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  icon VARCHAR(50),
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0
);

-- Tabla cakes
CREATE TABLE IF NOT EXISTS cakes (
  id SERIAL PRIMARY KEY,
  baker_id INTEGER REFERENCES baker_profiles(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  rating DECIMAL(3,1) DEFAULT 0.0,
  review_count INTEGER DEFAULT 0,
  image_url TEXT NOT NULL,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla reviews
CREATE TABLE IF NOT EXISTS reviews (
  id SERIAL PRIMARY KEY,
  client_id UUID REFERENCES users(id) ON DELETE CASCADE,
  baker_id INTEGER REFERENCES baker_profiles(id) ON DELETE CASCADE,
  rating DECIMAL(3,1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear ENUM para cake_designs
CREATE TYPE design_status AS ENUM ('pending', 'approved', 'rejected', 'completed');

-- Tabla cake_designs
CREATE TABLE IF NOT EXISTS cake_designs (
  id SERIAL PRIMARY KEY,
  client_id UUID REFERENCES users(id) ON DELETE CASCADE,
  sponge VARCHAR(50),
  filling VARCHAR(50),
  decoration VARCHAR(255),
  size VARCHAR(20),
  notes TEXT,
  status design_status DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla chat_sessions
CREATE TABLE IF NOT EXISTS chat_sessions (
  conversation_id VARCHAR(255) PRIMARY KEY,
  client_id UUID REFERENCES users(id) ON DELETE CASCADE,
  baker_id INTEGER REFERENCES baker_profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla chat_messages
CREATE TABLE IF NOT EXISTS chat_messages (
  id SERIAL PRIMARY KEY,
  conversation_id VARCHAR(255) REFERENCES chat_sessions(conversation_id) ON DELETE CASCADE,
  sender_role VARCHAR(20) NOT NULL CHECK (sender_role IN ('client', 'baker')),
  content TEXT NOT NULL,
  tool_calls JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear ENUM para appointments
CREATE TYPE appointment_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed');

-- Tabla appointments
CREATE TABLE IF NOT EXISTS appointments (
  id SERIAL PRIMARY KEY,
  client_id UUID REFERENCES users(id) ON DELETE CASCADE,
  baker_id INTEGER REFERENCES baker_profiles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  time_slot TIME NOT NULL,
  notes TEXT,
  status appointment_status DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_cakes_baker ON cakes(baker_id);
CREATE INDEX IF NOT EXISTS idx_cakes_category ON cakes(category_id);
CREATE INDEX IF NOT EXISTS idx_cakes_featured ON cakes(is_featured) WHERE is_featured = TRUE;
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation ON chat_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_reviews_baker ON reviews(baker_id);
CREATE INDEX IF NOT EXISTS idx_reviews_client ON reviews(client_id);
CREATE INDEX IF NOT EXISTS idx_appointments_client ON appointments(client_id);
CREATE INDEX IF NOT EXISTS idx_appointments_baker ON appointments(baker_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(date);
CREATE INDEX IF NOT EXISTS idx_cake_designs_client ON cake_designs(client_id);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_client ON chat_sessions(client_id);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_baker ON chat_sessions(baker_id);
