
-- Tabela de relatórios assinados (PDFs aprovados vinculados a RPEs)
CREATE TABLE IF NOT EXISTS public.relatorios_assinados (
  id          TEXT PRIMARY KEY,
  rpe         TEXT NOT NULL,
  tag         TEXT,
  equip_ref   TEXT,
  descricao   TEXT,
  data_rpe    DATE,
  responsavel TEXT,
  arquivo_url TEXT,           -- URL do PDF no Supabase Storage (futuro)
  arquivo_b64 TEXT,           -- Base64 do PDF (upload direto pelo app)
  nome_arquivo TEXT,
  obs         TEXT,
  criado_por  TEXT,
  criado_em   TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_rel_assin_rpe ON public.relatorios_assinados (rpe);
CREATE INDEX IF NOT EXISTS idx_rel_assin_tag ON public.relatorios_assinados (tag);

ALTER TABLE public.relatorios_assinados ENABLE ROW LEVEL SECURITY;
CREATE POLICY "rel_assin_all" ON public.relatorios_assinados FOR ALL USING (true);

-- Adicionar role 'observador' ao check de usuarios (documentação)
-- O role já é texto livre, apenas registrar na coluna de configurações
COMMENT ON COLUMN public.usuarios.role IS 'Roles: admin | qualidade | operador | observador';
;
