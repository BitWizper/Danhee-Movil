# Backend - Supabase Migrations

Este directorio contiene las migraciones SQL y configuración para Supabase.

## 📁 Estructura

```
backend/
└── supabase/
    ├── migrations/
    │   ├── 001_create_tables.sql      # Creación de tablas
    │   ├── 002_rls_policies.sql       # Políticas de seguridad (RLS)
    │   └── 003_storage_config.sql     # Configuración de Storage
    └── seed/
        └── (opcional) Datos de prueba
```

## 🚀 Cómo Ejecutar las Migraciones

### Opción 1: Desde el Dashboard de Supabase (Recomendado)

1. Ve a [SQL Editor](https://supabase.com/dashboard/project/_/sql/new)
2. Crea un nuevo query
3. Copia el contenido del archivo SQL deseado
4. Pega y haz clic en **"Run"**

### Opción 2: Usando CLI de Supabase

```bash
# Instalar Supabase CLI
npm install -g supabase

# Iniciar localmente (opcional)
supabase start

# Ejecutar migraciones
supabase db push
```

## 📋 Orden de Ejecución

Ejecuta las migraciones en este orden:

1. **001_create_tables.sql** - Crea todas las tablas
2. **002_rls_policies.sql** - Configura seguridad RLS
3. **003_storage_config.sql** - Configura Storage y Real-time

## 🗄️ Tablas Creadas

- `users` - Usuarios de la aplicación
- `baker_profiles` - Perfiles de bakers
- `categories` - Categorías de pasteles
- `cakes` - Catálogo de pasteles
- `reviews` - Reseñas de bakers
- `cake_designs` - Diseños personalizados
- `chat_sessions` - Sesiones de chat
- `chat_messages` - Mensajes de chat
- `appointments` - Citas programadas

## 🔒 Políticas de Seguridad (RLS)

Las políticas RLS aseguran que:
- Los usuarios solo pueden ver/editar sus propios datos
- Los bakers solo pueden gestionar sus pasteles
- Los clientes solo pueden ver sus propias citas y diseños
- El chat solo es accesible para los participantes

## 📦 Storage Buckets

- `cake-images` - Imágenes de pasteles (público)
- `avatars` - Avatares de usuarios (público)

## ⚡ Real-time

Las siguientes tablas tienen real-time habilitado:
- `chat_messages` - Mensajes en tiempo real
- `chat_sessions` - Sesiones de chat en tiempo real

## 🧪 Seed Data (Opcional)

Para agregar datos de prueba, crea archivos en `backend/supabase/seed/`:

```sql
-- Ejemplo: seed/categories.sql
INSERT INTO categories (name, slug, icon, description) VALUES
('Cumpleaños', 'cumpleanos', '🎂', 'Pasteles para cumpleaños'),
('Boda', 'boda', '💒', 'Pasteles para bodas'),
('Infantil', 'infantil', '🧸', 'Pasteles temáticos infantiles');
```

## 🔄 Actualizar Migraciones

Cuando necesites agregar una nueva migración:

1. Crea un nuevo archivo con el siguiente número: `004_new_feature.sql`
2. Escribe el SQL necesario
3. Documenta los cambios en este README
4. Ejecuta la migración en Supabase

## 📚 Recursos

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
