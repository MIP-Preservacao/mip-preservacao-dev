
-- Adicionar campo de permissões granulares na tabela de usuários
ALTER TABLE public.usuarios ADD COLUMN IF NOT EXISTS permissoes JSONB DEFAULT '{}';

-- Adicionar campo arquivo_url para quando usar Supabase Storage
ALTER TABLE public.relatorios_assinados ADD COLUMN IF NOT EXISTS arquivo_nome TEXT;

COMMENT ON COLUMN public.usuarios.permissoes IS 
'Permissões granulares: {
  ver_programacao: bool,
  enviar_atividade: bool, 
  executar_atividade: bool,
  validar_atividade: bool,
  gerar_rpe: bool,
  ver_relatorios: bool,
  ver_historico: bool,
  ver_mapa: bool,
  ver_qr: bool,
  editar_catalogo: bool
}';
;
