


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."next_rpe_seq"() RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  novo_seq integer;
BEGIN
  UPDATE public.configuracoes
  SET rpe_seq = rpe_seq + 1
  WHERE id = 1
  RETURNING rpe_seq INTO novo_seq;
  
  IF novo_seq IS NULL THEN
    RAISE EXCEPTION 'configuracoes id=1 não encontrada';
  END IF;
  
  RETURN novo_seq;
END;
$$;


ALTER FUNCTION "public"."next_rpe_seq"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."registrar_mudanca_status_programacao"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO auditoria (
      usuario,
      funcao,
      acao,
      tabela,
      registro_id,
      descricao,
      dados
    )
    VALUES (
      COALESCE(NEW.adm_nome, NEW.colab_nome, 'sistema'),
      'sistema',
      'STATUS_PROGRAMACAO_ALTERADO',
      'programacoes',
      NEW.id,
      'Status da programação alterado de "' || COALESCE(OLD.status, 'vazio') || '" para "' || COALESCE(NEW.status, 'vazio') || '".',
      jsonb_build_object(
        'tag', NEW.tag,
        'rpe', NEW.rpe,
        'status_anterior', OLD.status,
        'status_novo', NEW.status,
        'colaborador', NEW.colab_nome,
        'administrador', NEW.adm_nome,
        'origem', 'trigger_supabase'
      )
    );
  END IF;

  RETURN NEW;

EXCEPTION WHEN OTHERS THEN
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."registrar_mudanca_status_programacao"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."auditoria" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "usuario" "text" NOT NULL,
    "funcao" "text",
    "acao" "text" DEFAULT ''::"text",
    "tabela" "text",
    "registro_id" "text",
    "descricao" "text",
    "dados" "jsonb" DEFAULT '{}'::"jsonb",
    "criado_em" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."auditoria" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."catalogo_preservacoes" (
    "id" "text" NOT NULL,
    "tag" "text" NOT NULL,
    "equip_ref" "text",
    "descricao" "text",
    "familia" "text",
    "n_doc" "text",
    "atividade" "text",
    "periodicidade" "text",
    "data_relatorio" "date",
    "proxima" "date",
    "status_base" "text",
    "rpes_vinculados" "jsonb" DEFAULT '[]'::"jsonb",
    "fonte" "text",
    "atualizado_em" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."catalogo_preservacoes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."configuracoes" (
    "id" integer DEFAULT 1 NOT NULL,
    "rpe_seq" integer DEFAULT 1511,
    "foto_min" integer DEFAULT 0
);


ALTER TABLE "public"."configuracoes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."desenhos_tecnicos" (
    "id" "text" NOT NULL,
    "nome_desenho" "text" NOT NULL,
    "area" "text",
    "equipamento_referencia" "text",
    "observacoes" "text",
    "criado_em" "date" DEFAULT CURRENT_DATE,
    "atualizado_em" timestamp with time zone DEFAULT "now"(),
    "imagem_url" "text"
);


ALTER TABLE "public"."desenhos_tecnicos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mapa_tags" (
    "id" "text" NOT NULL,
    "desenho_id" "text" NOT NULL,
    "tag" "text" NOT NULL,
    "equipamento" "text",
    "area" "text",
    "observacao" "text",
    "pos_x" numeric DEFAULT 50 NOT NULL,
    "pos_y" numeric DEFAULT 50 NOT NULL,
    "criado_em" "date" DEFAULT CURRENT_DATE,
    "atualizado_em" "date" DEFAULT CURRENT_DATE
);


ALTER TABLE "public"."mapa_tags" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mip_dados" (
    "id" "text" NOT NULL,
    "payload" "text"
);


ALTER TABLE "public"."mip_dados" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."programacoes" (
    "id" "text" NOT NULL,
    "tag" "text",
    "equip_ref" "text",
    "descricao" "text",
    "n_doc" "text",
    "familia" "text",
    "atividade" "text",
    "periodicidade" "text",
    "data_relatorio" "date",
    "proxima" "date",
    "proxima_texto" "text",
    "vinculo" "jsonb" DEFAULT '[]'::"jsonb",
    "colab_id" "text",
    "colab_nome" "text",
    "adm_id" "text",
    "adm_nome" "text",
    "status" "text" DEFAULT 'Pendente'::"text",
    "enviado_em" "date",
    "obs_campo" "text",
    "exec_em" "date",
    "exec_time" bigint,
    "obs_adm" "text",
    "laudo" "text",
    "rpe" "text",
    "resp_rpe" "text",
    "qmip" "text",
    "status_log" "jsonb" DEFAULT '[]'::"jsonb",
    "comentario_interno" "text",
    "valid_em" "date",
    "gps" "jsonb",
    "fonte" "text",
    "atualizado_em" timestamp with time zone DEFAULT "now"(),
    "status_base" "text",
    "recebimento" "date",
    "rpes_vinculados" "jsonb" DEFAULT '[]'::"jsonb",
    "fotos_urls" "jsonb" DEFAULT '[]'::"jsonb"
);


ALTER TABLE "public"."programacoes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."relatorios_assinados" (
    "id" "text" NOT NULL,
    "rpe" "text" NOT NULL,
    "tag" "text",
    "equip_ref" "text",
    "descricao" "text",
    "data_rpe" "date",
    "responsavel" "text",
    "arquivo_url" "text",
    "arquivo_b64" "text",
    "nome_arquivo" "text",
    "obs" "text",
    "criado_por" "text",
    "criado_em" timestamp with time zone DEFAULT "now"(),
    "atualizado_em" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."relatorios_assinados" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."rpes" (
    "id" "text" NOT NULL,
    "rpe" "text",
    "prog_id" "text",
    "tag" "text",
    "equip_ref" "text",
    "descricao" "text",
    "n_doc" "text",
    "familia" "text",
    "atividade" "text",
    "obs" "text",
    "obs_adm" "text",
    "laudo" "text",
    "comentario_interno" "text",
    "data" "date",
    "responsavel" "text",
    "qmip" "text",
    "colab" "text",
    "periodicidade" "text",
    "data_relatorio" "date",
    "vinculo" "jsonb" DEFAULT '[]'::"jsonb",
    "gerado_em" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."rpes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."usuarios" (
    "id" "text" NOT NULL,
    "nome" "text" NOT NULL,
    "usuario" "text" NOT NULL,
    "senha" "text" NOT NULL,
    "role" "text" DEFAULT 'operador'::"text" NOT NULL,
    "ativo" boolean DEFAULT true,
    "atualizado_em" timestamp with time zone DEFAULT "now"(),
    "permissoes" "jsonb" DEFAULT '{}'::"jsonb",
    "matricula" "text",
    "email" "text",
    "telefone" "text"
);


ALTER TABLE "public"."usuarios" OWNER TO "postgres";


COMMENT ON COLUMN "public"."usuarios"."role" IS 'Roles: admin | qualidade | operador | observador';



COMMENT ON COLUMN "public"."usuarios"."permissoes" IS 'Permissões granulares: {
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



CREATE OR REPLACE VIEW "public"."vw_dashboard_mip" AS
 SELECT ( SELECT "count"(*) AS "count"
           FROM "public"."catalogo_preservacoes") AS "total_catalogo",
    ( SELECT "count"(*) AS "count"
           FROM "public"."programacoes") AS "total_programacoes",
    ( SELECT "count"(*) AS "count"
           FROM "public"."programacoes"
          WHERE ("programacoes"."status" ~~* '%venc%'::"text")) AS "total_vencidas",
    ( SELECT "count"(*) AS "count"
           FROM "public"."programacoes"
          WHERE ("programacoes"."status" ~~* '%campo%'::"text")) AS "total_enviadas_campo",
    ( SELECT "count"(*) AS "count"
           FROM "public"."programacoes"
          WHERE ("programacoes"."status" ~~* '%exec%'::"text")) AS "total_em_execucao",
    ( SELECT "count"(*) AS "count"
           FROM "public"."programacoes"
          WHERE ("programacoes"."status" ~~* '%valid%'::"text")) AS "total_aguardando_validacao",
    ( SELECT "count"(*) AS "count"
           FROM "public"."rpes") AS "total_rpes",
    ( SELECT "count"(*) AS "count"
           FROM "public"."relatorios_assinados") AS "total_relatorios_assinados";


ALTER VIEW "public"."vw_dashboard_mip" OWNER TO "postgres";


ALTER TABLE ONLY "public"."auditoria"
    ADD CONSTRAINT "auditoria_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."catalogo_preservacoes"
    ADD CONSTRAINT "catalogo_preservacoes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."configuracoes"
    ADD CONSTRAINT "configuracoes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."desenhos_tecnicos"
    ADD CONSTRAINT "desenhos_tecnicos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mapa_tags"
    ADD CONSTRAINT "mapa_tags_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mip_dados"
    ADD CONSTRAINT "mip_dados_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."programacoes"
    ADD CONSTRAINT "programacoes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."relatorios_assinados"
    ADD CONSTRAINT "relatorios_assinados_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."rpes"
    ADD CONSTRAINT "rpes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."usuarios"
    ADD CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."usuarios"
    ADD CONSTRAINT "usuarios_usuario_key" UNIQUE ("usuario");



CREATE INDEX "idx_catalogo_proxima" ON "public"."catalogo_preservacoes" USING "btree" ("proxima");



CREATE INDEX "idx_catalogo_rpes_vinculados" ON "public"."catalogo_preservacoes" USING "gin" ("rpes_vinculados");



CREATE INDEX "idx_catalogo_tag" ON "public"."catalogo_preservacoes" USING "btree" ("tag");



CREATE INDEX "idx_mapa_desenho" ON "public"."mapa_tags" USING "btree" ("desenho_id");



CREATE INDEX "idx_programacoes_colab_id" ON "public"."programacoes" USING "btree" ("colab_id");



CREATE INDEX "idx_programacoes_proxima" ON "public"."programacoes" USING "btree" ("proxima");



CREATE INDEX "idx_programacoes_rpe" ON "public"."programacoes" USING "btree" ("rpe");



CREATE INDEX "idx_programacoes_status" ON "public"."programacoes" USING "btree" ("status");



CREATE INDEX "idx_programacoes_tag" ON "public"."programacoes" USING "btree" ("tag");



CREATE INDEX "idx_rel_assin_rpe" ON "public"."relatorios_assinados" USING "btree" ("rpe");



CREATE INDEX "idx_rel_assin_tag" ON "public"."relatorios_assinados" USING "btree" ("tag");



CREATE INDEX "idx_rpes_data" ON "public"."rpes" USING "btree" ("data");



CREATE INDEX "idx_rpes_prog_id" ON "public"."rpes" USING "btree" ("prog_id");



CREATE INDEX "idx_rpes_responsavel" ON "public"."rpes" USING "btree" ("responsavel");



CREATE INDEX "idx_rpes_rpe" ON "public"."rpes" USING "btree" ("rpe");



CREATE INDEX "idx_rpes_tag" ON "public"."rpes" USING "btree" ("tag");



CREATE UNIQUE INDEX "idx_usuarios_matricula" ON "public"."usuarios" USING "btree" ("matricula") WHERE (("matricula" IS NOT NULL) AND ("matricula" <> ''::"text"));



CREATE OR REPLACE TRIGGER "trg_auditoria_status_programacao" AFTER UPDATE OF "status" ON "public"."programacoes" FOR EACH ROW EXECUTE FUNCTION "public"."registrar_mudanca_status_programacao"();



ALTER TABLE "public"."auditoria" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "catalogo_auth_write" ON "public"."catalogo_preservacoes" USING (true);



ALTER TABLE "public"."catalogo_preservacoes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "catalogo_public_read" ON "public"."catalogo_preservacoes" FOR SELECT USING (true);



ALTER TABLE "public"."configuracoes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."desenhos_tecnicos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."mapa_tags" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "mip_allow_anon" ON "public"."auditoria" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."configuracoes" TO "authenticated", "anon" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."desenhos_tecnicos" TO "authenticated", "anon" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."mapa_tags" TO "authenticated", "anon" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."mip_dados" TO "authenticated", "anon" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."programacoes" TO "authenticated", "anon" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."rpes" TO "authenticated", "anon" USING (true) WITH CHECK (true);



CREATE POLICY "mip_allow_anon" ON "public"."usuarios" TO "authenticated", "anon" USING (true) WITH CHECK (true);



ALTER TABLE "public"."mip_dados" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."programacoes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "rel_assin_all" ON "public"."relatorios_assinados" USING (true);



ALTER TABLE "public"."relatorios_assinados" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."rpes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."usuarios" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."next_rpe_seq"() TO "anon";
GRANT ALL ON FUNCTION "public"."next_rpe_seq"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."next_rpe_seq"() TO "service_role";



GRANT ALL ON FUNCTION "public"."registrar_mudanca_status_programacao"() TO "anon";
GRANT ALL ON FUNCTION "public"."registrar_mudanca_status_programacao"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."registrar_mudanca_status_programacao"() TO "service_role";



GRANT ALL ON TABLE "public"."auditoria" TO "anon";
GRANT ALL ON TABLE "public"."auditoria" TO "authenticated";
GRANT ALL ON TABLE "public"."auditoria" TO "service_role";



GRANT ALL ON TABLE "public"."catalogo_preservacoes" TO "anon";
GRANT ALL ON TABLE "public"."catalogo_preservacoes" TO "authenticated";
GRANT ALL ON TABLE "public"."catalogo_preservacoes" TO "service_role";



GRANT ALL ON TABLE "public"."configuracoes" TO "anon";
GRANT ALL ON TABLE "public"."configuracoes" TO "authenticated";
GRANT ALL ON TABLE "public"."configuracoes" TO "service_role";



GRANT ALL ON TABLE "public"."desenhos_tecnicos" TO "anon";
GRANT ALL ON TABLE "public"."desenhos_tecnicos" TO "authenticated";
GRANT ALL ON TABLE "public"."desenhos_tecnicos" TO "service_role";



GRANT ALL ON TABLE "public"."mapa_tags" TO "anon";
GRANT ALL ON TABLE "public"."mapa_tags" TO "authenticated";
GRANT ALL ON TABLE "public"."mapa_tags" TO "service_role";



GRANT ALL ON TABLE "public"."mip_dados" TO "anon";
GRANT ALL ON TABLE "public"."mip_dados" TO "authenticated";
GRANT ALL ON TABLE "public"."mip_dados" TO "service_role";



GRANT ALL ON TABLE "public"."programacoes" TO "anon";
GRANT ALL ON TABLE "public"."programacoes" TO "authenticated";
GRANT ALL ON TABLE "public"."programacoes" TO "service_role";



GRANT ALL ON TABLE "public"."relatorios_assinados" TO "anon";
GRANT ALL ON TABLE "public"."relatorios_assinados" TO "authenticated";
GRANT ALL ON TABLE "public"."relatorios_assinados" TO "service_role";



GRANT ALL ON TABLE "public"."rpes" TO "anon";
GRANT ALL ON TABLE "public"."rpes" TO "authenticated";
GRANT ALL ON TABLE "public"."rpes" TO "service_role";



GRANT ALL ON TABLE "public"."usuarios" TO "anon";
GRANT ALL ON TABLE "public"."usuarios" TO "authenticated";
GRANT ALL ON TABLE "public"."usuarios" TO "service_role";



GRANT ALL ON TABLE "public"."vw_dashboard_mip" TO "anon";
GRANT ALL ON TABLE "public"."vw_dashboard_mip" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_dashboard_mip" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







