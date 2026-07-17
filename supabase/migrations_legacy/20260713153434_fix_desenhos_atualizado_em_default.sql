
-- CORREÇÃO 2: Corrigir default de atualizado_em em desenhos_tecnicos
ALTER TABLE public.desenhos_tecnicos
  ALTER COLUMN atualizado_em SET DEFAULT now();

-- Confirmar
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_name = 'desenhos_tecnicos' AND column_name = 'atualizado_em';
;
