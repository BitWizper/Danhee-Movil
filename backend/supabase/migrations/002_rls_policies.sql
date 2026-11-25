-- Migración 002: Row-Level Security (RLS) Policies
-- Ejecutar en Supabase SQL Editor después de crear las tablas

-- Habilitar RLS en todas las tablas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE baker_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE cakes ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE cake_designs ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- POLICIES PARA USERS
-- ============================================================================

-- Cualquiera puede ver perfiles públicos (limitado)
CREATE POLICY "Public can view user profiles"
ON users FOR SELECT
USING (true);

-- Usuarios pueden ver su propio perfil completo
CREATE POLICY "Users can view own profile"
ON users FOR SELECT
USING (auth.uid() = id);

-- Usuarios pueden insertar su propio perfil durante el registro
CREATE POLICY "Users can insert own profile"
ON users FOR INSERT
WITH CHECK (auth.uid() = id);

-- Usuarios pueden actualizar su propio perfil
CREATE POLICY "Users can update own profile"
ON users FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- ============================================================================
-- POLICIES PARA BAKER_PROFILES
-- ============================================================================

-- Cualquiera puede ver perfiles de bakers
CREATE POLICY "Anyone can view baker profiles"
ON baker_profiles FOR SELECT
USING (true);

-- Bakers pueden ver su propio perfil
CREATE POLICY "Bakers can view own profile"
ON baker_profiles FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = baker_profiles.user_id
    AND users.id = auth.uid()
  )
);

-- Bakers pueden actualizar su propio perfil
CREATE POLICY "Bakers can update own profile"
ON baker_profiles FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = baker_profiles.user_id
    AND users.id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = baker_profiles.user_id
    AND users.id = auth.uid()
  )
);

-- ============================================================================
-- POLICIES PARA CAKES
-- ============================================================================

-- Cualquiera puede ver pasteles
CREATE POLICY "Anyone can view cakes"
ON cakes FOR SELECT
USING (true);

-- Bakers pueden insertar sus propios pasteles
CREATE POLICY "Bakers can insert own cakes"
ON cakes FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = cakes.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
);

-- Bakers pueden actualizar sus propios pasteles
CREATE POLICY "Bakers can update own cakes"
ON cakes FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = cakes.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = cakes.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
);

-- Bakers pueden eliminar sus propios pasteles
CREATE POLICY "Bakers can delete own cakes"
ON cakes FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = cakes.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
);

-- ============================================================================
-- POLICIES PARA REVIEWS
-- ============================================================================

-- Cualquiera puede ver reseñas
CREATE POLICY "Anyone can view reviews"
ON reviews FOR SELECT
USING (true);

-- Clientes pueden insertar sus propias reseñas
CREATE POLICY "Clients can insert own reviews"
ON reviews FOR INSERT
WITH CHECK (auth.uid() = client_id);

-- Clientes pueden ver sus propias reseñas
CREATE POLICY "Clients can view own reviews"
ON reviews FOR SELECT
USING (auth.uid() = client_id);

-- Clientes pueden eliminar sus propias reseñas
CREATE POLICY "Clients can delete own reviews"
ON reviews FOR DELETE
USING (auth.uid() = client_id);

-- ============================================================================
-- POLICIES PARA CAKE_DESIGNS
-- ============================================================================

-- Clientes pueden ver sus propios diseños
CREATE POLICY "Clients can view own designs"
ON cake_designs FOR SELECT
USING (auth.uid() = client_id);

-- Clientes pueden insertar sus propios diseños
CREATE POLICY "Clients can insert own designs"
ON cake_designs FOR INSERT
WITH CHECK (auth.uid() = client_id);

-- Clientes pueden actualizar sus propios diseños
CREATE POLICY "Clients can update own designs"
ON cake_designs FOR UPDATE
USING (auth.uid() = client_id)
WITH CHECK (auth.uid() = client_id);

-- Clientes pueden eliminar sus propios diseños
CREATE POLICY "Clients can delete own designs"
ON cake_designs FOR DELETE
USING (auth.uid() = client_id);

-- ============================================================================
-- POLICIES PARA CHAT_SESSIONS
-- ============================================================================

-- Usuarios pueden ver sus propias sesiones de chat
CREATE POLICY "Users can view own chat sessions"
ON chat_sessions FOR SELECT
USING (
  auth.uid() = client_id OR
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = chat_sessions.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
);

-- Clientes pueden crear sesiones de chat
CREATE POLICY "Clients can create chat sessions"
ON chat_sessions FOR INSERT
WITH CHECK (auth.uid() = client_id);

-- ============================================================================
-- POLICIES PARA CHAT_MESSAGES
-- ============================================================================

-- Participantes pueden ver mensajes de sus conversaciones
CREATE POLICY "Participants can view chat messages"
ON chat_messages FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM chat_sessions
    WHERE chat_sessions.conversation_id = chat_messages.conversation_id
    AND (
      chat_sessions.client_id = auth.uid() OR
      EXISTS (
        SELECT 1 FROM baker_profiles
        WHERE baker_profiles.id = chat_sessions.baker_id
        AND baker_profiles.user_id = auth.uid()
      )
    )
  )
);

-- Participantes pueden insertar mensajes
CREATE POLICY "Participants can insert messages"
ON chat_messages FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM chat_sessions
    WHERE chat_sessions.conversation_id = chat_messages.conversation_id
    AND (
      chat_sessions.client_id = auth.uid() OR
      EXISTS (
        SELECT 1 FROM baker_profiles
        WHERE baker_profiles.id = chat_sessions.baker_id
        AND baker_profiles.user_id = auth.uid()
      )
    )
  )
);

-- ============================================================================
-- POLICIES PARA APPOINTMENTS
-- ============================================================================

-- Usuarios pueden ver sus propias citas
CREATE POLICY "Users can view own appointments"
ON appointments FOR SELECT
USING (
  auth.uid() = client_id OR
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = appointments.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
);

-- Clientes pueden crear citas
CREATE POLICY "Clients can create appointments"
ON appointments FOR INSERT
WITH CHECK (auth.uid() = client_id);

-- Clientes pueden actualizar sus propias citas
CREATE POLICY "Clients can update own appointments"
ON appointments FOR UPDATE
USING (auth.uid() = client_id)
WITH CHECK (auth.uid() = client_id);

-- Bakers pueden actualizar citas con ellos
CREATE POLICY "Bakers can update own appointments"
ON appointments FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = appointments.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.id = appointments.baker_id
    AND baker_profiles.user_id = auth.uid()
  )
);
