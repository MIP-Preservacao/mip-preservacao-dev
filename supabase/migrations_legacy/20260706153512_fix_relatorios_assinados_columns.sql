
UPDATE public.relatorios_assinados
  SET nome_arquivo = arquivo_nome
  WHERE (nome_arquivo IS NULL OR nome_arquivo = '')
    AND arquivo_nome IS NOT NULL;

ALTER TABLE public.relatorios_assinados
  DROP COLUMN IF EXISTS arquivo_nome;

ALTER TABLE public.desenhos_tecnicos
  DROP COLUMN IF EXISTS equipamento_referencia_old;

INSERT INTO public.configuracoes (id, rpe_seq, foto_min)
VALUES (1, 1574, 0)
ON CONFLICT (id) DO NOTHING;

CREATE INDEX IF NOT EXISTS idx_prog_status   ON public.programacoes(status);
CREATE INDEX IF NOT EXISTS idx_prog_colab_id ON public.programacoes(colab_id);
CREATE INDEX IF NOT EXISTS idx_prog_tag      ON public.programacoes(tag);
CREATE INDEX IF NOT EXISTS idx_rpes_tag      ON public.rpes(tag);
CREATE INDEX IF NOT EXISTS idx_mapa_desenho  ON public.mapa_tags(desenho_id);
;
