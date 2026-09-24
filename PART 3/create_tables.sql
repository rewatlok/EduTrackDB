CREATE TABLE IF NOT EXISTS "AuditLog" (
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    operation TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT DEFAULT current_user,
    changed_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "ErrorLog" (
    id BIGSERIAL PRIMARY KEY,
    error_code TEXT,
    error_message TEXT,
    error_detail TEXT,
    error_hint TEXT,
    context JSONB,
    occurred_at TIMESTAMPTZ DEFAULT now()
);
