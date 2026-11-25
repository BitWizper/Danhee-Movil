-- Migración 003: Configuración de Storage
-- Ejecutar en Supabase SQL Editor después de las migraciones anteriores

-- ============================================================================
-- CREAR BUCKETS DE STORAGE
-- ============================================================================

-- Crear bucket para imágenes de pasteles
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'cake-images',
  'cake-images',
  true,
  5242880, -- 5MB
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- Crear bucket para avatares de usuarios
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,
  2097152, -- 2MB
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- POLICIAS PARA STORAGE - CAKE IMAGES
-- ============================================================================

-- Cualquiera puede ver imágenes de pasteles
CREATE POLICY "Public can view cake images"
ON storage.objects FOR SELECT
USING (bucket_id = 'cake-images');

-- Bakers pueden subir imágenes de pasteles
CREATE POLICY "Bakers can upload cake images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'cake-images' AND
  auth.role() = 'authenticated' AND
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.user_id = auth.uid()
  )
);

-- Bakers pueden actualizar sus propias imágenes de pasteles
CREATE POLICY "Bakers can update own cake images"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'cake-images' AND
  auth.role() = 'authenticated' AND
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  bucket_id = 'cake-images' AND
  auth.role() = 'authenticated' AND
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.user_id = auth.uid()
  )
);

-- Bakers pueden eliminar sus propias imágenes de pasteles
CREATE POLICY "Bakers can delete own cake images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'cake-images' AND
  auth.role() = 'authenticated' AND
  EXISTS (
    SELECT 1 FROM baker_profiles
    WHERE baker_profiles.user_id = auth.uid()
  )
);

-- ============================================================================
-- POLICIAS PARA STORAGE - AVATARS
-- ============================================================================

-- Cualquiera puede ver avatares
CREATE POLICY "Public can view avatars"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

-- Usuarios pueden subir su propio avatar
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'avatars' AND
  auth.role() = 'authenticated' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Usuarios pueden actualizar su propio avatar
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'avatars' AND
  auth.role() = 'authenticated' AND
  (storage.foldername(name))[1] = auth.uid()::text
)
WITH CHECK (
  bucket_id = 'avatars' AND
  auth.role() = 'authenticated' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Usuarios pueden eliminar su propio avatar
CREATE POLICY "Users can delete own avatar"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'avatars' AND
  auth.role() = 'authenticated' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- ============================================================================
-- HABILITAR REALTIME PARA TABLAS DE CHAT
-- ============================================================================

-- Habilitar real-time para chat_messages
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;

-- Habilitar real-time para chat_sessions
ALTER PUBLICATION supabase_realtime ADD TABLE chat_sessions;

-- Nota: También puedes habilitar real-time para otras tablas si necesitas
-- actualizaciones en tiempo real (ej: cakes, appointments)
-- ALTER PUBLICATION supabase_realtime ADD TABLE cakes;
-- ALTER PUBLICATION supabase_realtime ADD TABLE appointments;
