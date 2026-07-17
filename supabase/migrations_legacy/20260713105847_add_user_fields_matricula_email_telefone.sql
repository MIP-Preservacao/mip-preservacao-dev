
ALTER TABLE public.usuarios
  ADD COLUMN IF NOT EXISTS matricula TEXT,
  ADD COLUMN IF NOT EXISTS email     TEXT,
  ADD COLUMN IF NOT EXISTS telefone  TEXT;

-- Índice único na matrícula (quando preenchida)
CREATE UNIQUE INDEX IF NOT EXISTS idx_usuarios_matricula
  ON public.usuarios(matricula)
  WHERE matricula IS NOT NULL AND matricula <> '';
;
