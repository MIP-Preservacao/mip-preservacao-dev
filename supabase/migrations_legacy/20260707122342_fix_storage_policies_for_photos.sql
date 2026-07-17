
-- Garantir políticas corretas no bucket relatorios-assinados
DO $$
BEGIN
  -- Remover políticas antigas conflitantes
  DROP POLICY IF EXISTS "upload_relatorios" ON storage.objects;
  DROP POLICY IF EXISTS "read_relatorios" ON storage.objects;
  DROP POLICY IF EXISTS "delete_relatorios" ON storage.objects;
  DROP POLICY IF EXISTS "update_relatorios" ON storage.objects;
END$$;

-- Política de INSERT (upload) — qualquer um pode subir
CREATE POLICY "upload_relatorios" ON storage.objects
  FOR INSERT TO anon, authenticated
  WITH CHECK (bucket_id = 'relatorios-assinados');

-- Política de SELECT (leitura) — qualquer um pode ler
CREATE POLICY "read_relatorios" ON storage.objects
  FOR SELECT TO anon, authenticated
  USING (bucket_id = 'relatorios-assinados');

-- Política de UPDATE (upsert) — qualquer um pode atualizar
CREATE POLICY "update_relatorios" ON storage.objects
  FOR UPDATE TO anon, authenticated
  USING (bucket_id = 'relatorios-assinados');

-- Política de DELETE — qualquer um pode deletar
CREATE POLICY "delete_relatorios" ON storage.objects
  FOR DELETE TO anon, authenticated
  USING (bucket_id = 'relatorios-assinados');

-- Atualizar bucket: aceitar imagens explicitamente, sem restrição de mime
UPDATE storage.buckets
SET
  file_size_limit = 2147483648,
  allowed_mime_types = NULL  -- NULL = aceita qualquer tipo
WHERE id = 'relatorios-assinados';
;
