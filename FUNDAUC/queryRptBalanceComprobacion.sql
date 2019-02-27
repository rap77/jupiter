select n1,d1,n2,d2,n3,d3,n4,d4,n1||'.'||n2||'.'||n3||'.'||n4||'.'||substr(to_char(ctc_cuenta),7,3) ctc_cuenta,ctc_descripcion,ctc_total,ctc_aux, ctc_balance,ctc_grupobal, sum(saldoant) saldoant, sum(debem) debem, sum(haberm) haberm ,sum(saldoant)+ (sum(debem) -sum(haberm)) saldoact  
  from ( 
     select distinct substr(to_char(c.ctc_cuenta),1,1) n1, t1.ctc_descripcion d1, 
                substr(to_char(c.ctc_cuenta),2,2) n2, t2.ctc_descripcion d2,
                substr(to_char(c.ctc_cuenta),4,1) n3, t3.ctc_descripcion d3,
                substr(to_char(c.ctc_cuenta),5,2) n4, t4.ctc_descripcion d4,
         --       substr(to_char(c.ctc_cuenta),7,3) n5, t5.ctc_descripcion d5,
                c.ctc_cuenta,c.ctc_descripcion,c.ctc_total,c.ctc_aux, c.ctc_balance,c.ctc_grupobal, a.saldoant, a.debem, a.haberm 
       from cuentas_plan c, cuentas_plan t1, cuentas_plan t2, cuentas_plan t3, cuentas_plan t4, 
       ((SELECT ctc_cuenta, SUM(nvl(ctc_saldoini,0)) + ( SUM(nvl(cmd_debe,0)) - SUM(nvl(cmd_haber, 0))) saldoant,0 debem,0 haberm 
           FROM cuentas_plan, comprobantes_det
          WHERE ctc_cia = 3 AND ctc_plan = 1 AND cmd_cia (+) = ctc_cia AND cmd_plan (+) = ctc_plan AND cmd_cuenta (+) = ctc_cuenta
            AND TO_CHAR(cmd_periodo(+),'YYYYMM') < TO_CHAR(TO_DATE('31/12/2016','DD/MM/YYYY'),'YYYYMM') 
            AND cmd_status (+) = 'P'
       GROUP BY ctc_cuenta
         having SUM(nvl(ctc_saldoini,0)) + ( SUM(nvl(cmd_debe,0)) - SUM(nvl(cmd_haber, 0)))<>0)
     union
     (SELECT ctc_cuenta, 0 saldoant,SUM(nvl(cmd_debe,0)) debem,SUM(nvl(cmd_haber,0)) haberm
        FROM cuentas_plan, comprobantes_det
       WHERE ctc_cia = 3 AND ctc_plan = 1 AND cmd_cia(+) = ctc_cia AND cmd_plan(+) = ctc_plan AND cmd_cuenta(+) = ctc_cuenta
         AND TO_CHAR(cmd_periodo(+), 'YYYYMM') = TO_CHAR(TO_DATE('31/12/2016','DD/MM/YYYY'),'YYYYMM')
         AND cmd_status (+) = 'P'
    GROUP BY ctc_cuenta 
      having (SUM(nvl(cmd_debe,0))-SUM(nvl(cmd_haber,0)))<>0)) a
       where c.ctc_cia = 3 AND c.ctc_plan = 1 and a.ctc_cuenta = c.ctc_cuenta
         and c.ctc_cia = t1.ctc_cia and c.ctc_plan=t1.ctc_plan and t1.ctc_cuenta = substr(to_char(a.ctc_cuenta),1,1)
         and c.ctc_cia = t2.ctc_cia and c.ctc_plan=t2.ctc_plan and t2.ctc_cuenta = substr(to_char(a.ctc_cuenta),1,3)
         and c.ctc_cia = t3.ctc_cia and c.ctc_plan=t3.ctc_plan and t3.ctc_cuenta = substr(to_char(a.ctc_cuenta),1,4)
         and c.ctc_cia = t4.ctc_cia and c.ctc_plan=t4.ctc_plan and t4.ctc_cuenta = substr(to_char(a.ctc_cuenta),1,6)
       order by to_char(c.ctc_cuenta)
   )
group by n1,d1,n2,d2,n3,d3,n4,d4,n1||'.'||n2||'.'||n3||'.'||n4||'.'||substr(to_char(ctc_cuenta),7,3),ctc_descripcion,ctc_total,ctc_aux, ctc_balance,ctc_grupobal
order by to_char(ctc_cuenta)