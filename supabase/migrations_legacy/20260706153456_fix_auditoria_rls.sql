
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename='auditoria' AND policyname='mip_allow_anon'
  ) THEN
    CREATE POLICY "mip_allow_anon" ON public.auditoria
      FOR ALL USING (true) WITH CHECK (true);
  END IF;
END$$;
;
