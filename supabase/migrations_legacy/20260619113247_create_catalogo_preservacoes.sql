
-- Catálogo de preservações para consulta via QR Code
CREATE TABLE IF NOT EXISTS public.catalogo_preservacoes (
  id TEXT PRIMARY KEY,
  tag TEXT NOT NULL,
  equip_ref TEXT,
  descricao TEXT,
  familia TEXT,
  n_doc TEXT,
  atividade TEXT,
  periodicidade TEXT,
  data_relatorio DATE,
  proxima DATE,
  status_base TEXT,
  rpes_vinculados JSONB DEFAULT '[]',
  fonte TEXT,
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cat_tag ON public.catalogo_preservacoes (tag);

-- RLS: leitura pública (para o QR funcionar sem login)
ALTER TABLE public.catalogo_preservacoes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "catalogo_public_read" ON public.catalogo_preservacoes
  FOR SELECT USING (true);

CREATE POLICY "catalogo_auth_write" ON public.catalogo_preservacoes
  FOR ALL USING (true);
;
