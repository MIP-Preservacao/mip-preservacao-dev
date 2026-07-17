
-- Criar bucket para relatórios assinados no Supabase Storage
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'relatorios-assinados',
  'relatorios-assinados', 
  true,
  52428800,  -- 50MB
  ARRAY['application/pdf','image/jpeg','image/png','image/jpg']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 52428800;

-- Policy: qualquer autenticado pode fazer upload
CREATE POLICY "upload_relatorios" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'relatorios-assinados');

-- Policy: leitura pública
CREATE POLICY "read_relatorios" ON storage.objects
  FOR SELECT USING (bucket_id = 'relatorios-assinados');

-- Policy: deletar próprios arquivos
CREATE POLICY "delete_relatorios" ON storage.objects
  FOR DELETE USING (bucket_id = 'relatorios-assinados');
;
