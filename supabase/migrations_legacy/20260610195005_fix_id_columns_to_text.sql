
-- ============================================================
-- MIP Preservação — Fix IDs: INTEGER → TEXT (UUID-compatible)
-- Tabelas: usuarios, desenhos_tecnicos, programacoes, rpes
-- mapa_tags já é TEXT — não alterada
-- ============================================================

-- ── usuarios ────────────────────────────────────────────────
ALTER TABLE usuarios DROP CONSTRAINT IF EXISTS usuarios_pkey CASCADE;
ALTER TABLE usuarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE usuarios ALTER COLUMN id TYPE TEXT USING id::TEXT;
ALTER TABLE usuarios ADD PRIMARY KEY (id);
DROP SEQUENCE IF EXISTS usuarios_id_seq;

-- ── desenhos_tecnicos ────────────────────────────────────────
ALTER TABLE desenhos_tecnicos DROP CONSTRAINT IF EXISTS desenhos_tecnicos_pkey CASCADE;
ALTER TABLE desenhos_tecnicos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE desenhos_tecnicos ALTER COLUMN id TYPE TEXT USING id::TEXT;
ALTER TABLE desenhos_tecnicos ADD PRIMARY KEY (id);
DROP SEQUENCE IF EXISTS desenhos_tecnicos_id_seq;

-- ── programacoes ─────────────────────────────────────────────
ALTER TABLE programacoes DROP CONSTRAINT IF EXISTS programacoes_pkey CASCADE;
ALTER TABLE programacoes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE programacoes ALTER COLUMN id TYPE TEXT USING id::TEXT;
ALTER TABLE programacoes ADD PRIMARY KEY (id);
DROP SEQUENCE IF EXISTS programacoes_id_seq;

-- ── rpes ─────────────────────────────────────────────────────
ALTER TABLE rpes DROP CONSTRAINT IF EXISTS rpes_pkey CASCADE;
ALTER TABLE rpes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE rpes ALTER COLUMN id TYPE TEXT USING id::TEXT;
ALTER TABLE rpes ADD PRIMARY KEY (id);
DROP SEQUENCE IF EXISTS rpes_id_seq;

-- ── mip_dados ────────────────────────────────────────────────
-- Verificar e corrigir também para consistência
ALTER TABLE mip_dados DROP CONSTRAINT IF EXISTS mip_dados_pkey CASCADE;
ALTER TABLE mip_dados ALTER COLUMN id DROP DEFAULT;
ALTER TABLE mip_dados ALTER COLUMN id TYPE TEXT USING id::TEXT;
ALTER TABLE mip_dados ADD PRIMARY KEY (id);
DROP SEQUENCE IF EXISTS mip_dados_id_seq;
;
