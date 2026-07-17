
-- CORREÇÃO 3: Remover índices duplicados
-- programacoes: manter idx_programacoes_* (mais descritivos), remover idx_prog_*
DROP INDEX IF EXISTS public.idx_prog_colab_id;
DROP INDEX IF EXISTS public.idx_prog_status;
DROP INDEX IF EXISTS public.idx_prog_tag;

-- catalogo_preservacoes: manter idx_catalogo_tag, remover idx_cat_tag
DROP INDEX IF EXISTS public.idx_cat_tag;

-- Confirmar índices restantes
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname IN (
    'idx_prog_colab_id','idx_prog_status','idx_prog_tag',
    'idx_cat_tag',
    'idx_programacoes_colab_id','idx_programacoes_status','idx_programacoes_tag',
    'idx_catalogo_tag'
  )
ORDER BY tablename, indexname;
;
