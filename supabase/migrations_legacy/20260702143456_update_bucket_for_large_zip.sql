
-- Aumentar limite para 2GB e aceitar ZIP
UPDATE storage.buckets 
SET 
  file_size_limit = 2147483648,
  allowed_mime_types = ARRAY[
    'application/pdf',
    'image/jpeg', 
    'image/png',
    'image/jpg',
    'application/zip',
    'application/x-zip-compressed',
    'application/octet-stream'
  ]
WHERE id = 'relatorios-assinados';
;
