
ALTER TABLE public.programacoes 
  DROP COLUMN IF EXISTS _data_relatorio_ant,
  DROP COLUMN IF EXISTS _proxima_ant,
  DROP COLUMN IF EXISTS vinculo_str;

ALTER TABLE public.programacoes 
  ALTER COLUMN status_base SET DEFAULT NULL;

UPDATE public.programacoes 
  SET status_base = NULL 
  WHERE status_base = '';
;
