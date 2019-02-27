Select Distinct CCI_Codigo , Dc_Cia,Bc_Nombre, CCI_Cuenta, Td_Nombre, Td_Codigo
From  Documentos,Tipos_Doc, Cuentas_Cia, Bancos, Clases_Doc
Where  CCI_Codigo = Dc_CliPro
     And CCI_Banco  = Bc_Codigo
     And CCI_Cia        = :Cia
     And Bc_Agencia = 0
     And  Dc_Tipo   = Td_Codigo
     And  Dc_Clase  = Cd_Codigo
     And  Dc_Tipo   =  Cd_Tipo
     And  Cd_Naturaleza = 'N'
     And  CCI_Codigo Between Nvl(:Cliente,'000000000') and Nvl(:Cliente,'999999999')
     And  Dc_FecEmi <= :FHasta
     And  Dc_Clipro = To_Char(CCI_Codigo(+))
     And  Dc_Cia  =    CCI_Cia(+)
Union
Select Distinct CCI_Codigo, Dec_Cia,Bc_Nombre, CCI_Cuenta, Td_Nombre, Td_Codigo
From  Documentos_EC,Tipos_Doc, Cuentas_Cia, Bancos, Clases_Doc
Where  To_Char(CCI_Codigo) = Dec_CliPro
     And CCI_Banco  = Bc_Codigo
     And CCI_Cia        = :Cia
     And Bc_Agencia = 0
     And  Dec_Tipo   = Td_Codigo
     And  Dec_Clase  = Cd_Codigo
     And  Dec_Tipo   =  Cd_Tipo
     And  Cd_Naturaleza = 'N'
     And  CCI_Codigo Between Nvl(:Cliente,'000000000') and Nvl(:Cliente,'999999999')
     And  Dec_FecEmi <= :FHasta
     And  Dec_Cia  = :Cia
-------------------------------
Select Dc_Cia, Dc_Tipo, Dc_Clase, Dc_CliPro, Dc_Numero, Dc_FecEmi,
           Cd_Abrv,Decode(Cd_Signo,'+',Dc_Monto,'-',Dc_Monto*-1) Dc_Monto
From Documentos,Clases_Doc
Where Dc_Tipo = Cd_Tipo
    And Dc_Clase = Cd_Codigo
    And To_Char(:CCI_Codigo) = Dc_CliPro
    And Nvl(Dc_status,'1') Not In ('24','**')
     And  Cd_Naturaleza = 'N'
     And  Dc_FecEmi <= :FHasta
     Order by To_Char(Dc_FecEmi,'YYYYMMDD'),dc_numero
--------------------------------
   Select CCI_SaldoAnt
     Into SaldoAnt
     From Bancos, Cuentas_Cia
    Where CCI_Codigo = :Cliente
      And Bc_Codigo  = CCI_Banco
      And Nvl(Bc_Agencia,0) = 0             
      And CCI_Cia = :Cia;	
    Select Sum(Decode(Cd_Signo,'+',dc_Monto+Nvl(dc_Iva,0),'-',(dc_Monto+Nvl(dc_Iva,0))*-1))
      Into SMovi
      From Clases_Doc,Documentos
     Where dc_Clase   = Cd_Codigo
       And dc_Tipo    = Cd_Tipo
       And Cd_Naturaleza = 'N'
       And dc_FlgCp   = 'B'
       And dc_FecAnul is Null
       And dc_CliPro  = To_Char(:Cliente)
       And To_Char(Dc_FecEmi,'YYYYMMDD') <= To_Char(:FHasta,'YYYYMMDD')
       And Nvl(Dc_Status,' ') Not in ('**','NC')
       And dc_Cia     = :Cia;
---------------------------------
