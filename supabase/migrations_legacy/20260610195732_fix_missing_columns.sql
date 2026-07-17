
-- ============================================================
-- MIP Preservação — Adicionar colunas faltantes
-- ============================================================

-- programacoes: vinculo_str, _data_relatorio_ant, _proxima_ant
-- (colab_id e adm_id precisam aceitar UUID TEXT, não INTEGER)
ALTER TABLE programacoes
  ADD COLUMN IF NOT EXISTS vinculo_str TEXT,
  ADD COLUMN IF NOT EXISTS _data_relatorio_ant TEXT,
  ADD COLUMN IF NOT EXISTS _proxima_ant TEXT;

-- colab_id e adm_id: o app salva UUID como string, mas a coluna é INTEGER
ALTER TABLE programacoes
  ALTER COLUMN colab_id TYPE TEXT USING colab_id::TEXT,
  ALTER COLUMN adm_id   TYPE TEXT USING adm_id::TEXT;

-- rpes: prog_id também é UUID no app, mas a coluna é INTEGER
ALTER TABLE rpes
  ALTER COLUMN prog_id TYPE TEXT USING prog_id::TEXT;

-- desenhos_tecnicos: faltam imagem_url e as colunas de datas como timestamptz
ALTER TABLE desenhos_tecnicos
  ADD COLUMN IF NOT EXISTS imagem_url TEXT,
  ADD COLUMN IF NOT EXISTS equipamento_referencia_old TEXT; -- já existe com nome correto, ignorado

-- Garantir atualizado_em como timestamptz em desenhos_tecnicos
ALTER TABLE desenhos_tecnicos
  ALTER COLUMN atualizado_em TYPE TIMESTAMPTZ USING atualizado_em::TIMESTAMPTZ;

-- usuarios: adicionar atualizado_em (usada em DB_Usuarios.salvar)
ALTER TABLE usuarios
  ADD COLUMN IF NOT EXISTS atualizado_em TIMESTAMPTZ DEFAULT NOW();
;
