USE [cuentas]
GO

IF OBJECT_ID('calculoSaldo','P') IS NOT NULL
BEGIN
   DROP PROCEDURE [dbo].[calculoSaldo]
END    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ricardo Martinez
-- Create date: 01/03/2021
-- Description:	Calcula el nuevo saldo y gmf si la cuenta no es excenta
-- =============================================
CREATE PROCEDURE [dbo].[calculoSaldo] 
   @nombreCta           NCHAR(50) NULL,
   @valorRetiro         MONEY     NULL,
   @cuentaDestino       NCHAR(50) NULL,
   @tipoTransaccion     NCHAR(1)  NULL
	AS
BEGIN
DECLARE @contadorCta        INT,
        @saldo              MONEY,
		@excento            NVARCHAR(2),
		@idCuenta           INT,
		@fechaProceso       DATETIME,
		@valorGmf           MONEY,
		@saldoNuevo         MONEY,
		@valorParametro     MONEY,
		@valorParametroTope MONEY

	SET NOCOUNT ON;
	--Asignar fecha actual con hora
	SET @fechaProceso = GETDATE()

	IF @valorRetiro IS NULL
	 BEGIN	
	    RAISERROR ('Debe ingresar un valor de retiro', -- Mensaje 
                   10, -- Severity,  
                   1   -- State
                  );    
	    RETURN 1
	 END
	 IF @tipoTransaccion = 'T' AND @cuentaDestino IS NULL
	 BEGIN	
	    RAISERROR ('Debe ingresar cuenta destino porque es una transferencia', -- Mensaje 
                   10, -- Severity,  
                   1   -- State
                  );    
	    RETURN 1
	 END
	--Recuperar id de la cuenta, saldo y excención
	SELECT @idCuenta    = IdCuenta,
	       @saldo       = isnull(Saldo,0),
           @excento     = isnull(Excento,'N')
	  FROM Cuentas
	 WHERE NombreCta = @NombreCta
	 IF @@ROWCOUNT = 0
	 BEGIN	
	    RAISERROR ('No Existe cuenta', -- Mensaje 
                   10, -- Severity,  
                   1   -- State
                  );    
	    RETURN 1
	 END
   SELECT @valorParametro = Valor
     FROM Parametros
    WHERE Parametro = 'GMF'
   IF @@ROWCOUNT = 0
   BEGIN	
	  --ROLLBACK TRAN 
	  RAISERROR ('No existe parametro', -- Mensaje 
                 10, -- Severity,  
                 1   -- State
                );   
	  RETURN 1
   END
     SELECT @valorParametroTope = Valor
     FROM Parametros
    WHERE Parametro = 'TOPEGMF'
   IF @@ROWCOUNT = 0
   BEGIN	
	  --ROLLBACK TRAN 
	  RAISERROR ('No existe parametro', -- Mensaje 
                 10, -- Severity,  
                 1   -- State
                );   
	  RETURN 1
   END
   -- Iniciar valor de gmf
	SET @valorGmf = 0
    IF @excento  ='N' AND @valorRetiro >= @valorParametroTope 
	BEGIN
	    -- Calcular gmf
	    SET @valorGmf = @valorRetiro * @valorParametro/1000
	END 
	--calcular nuevo saldo
	SET @saldoNuevo = ISNULL(@saldo,0) - ISNULL(@valorRetiro,0) - ISNULL(@valorGmf,0)
BEGIN TRAN
     --Insertar movimiento
     INSERT INTO [dbo].[Movimientos]
           ([IdCuenta]
           ,[Fecha]
           ,[ValorRetiro]
           ,[ValorGmf]
           ,[SaldoMov]
           ,[CuentaDestino])
     VALUES
           (@idCuenta
           ,@fechaProceso
           ,@valorRetiro
           ,@valorGmf
           ,@saldoNuevo
           ,@cuentaDestino)
     IF @@ERROR <> 0
	 BEGIN	
	    ROLLBACK TRAN 
	    RAISERROR ('Error insertando movimiento', -- Mensaje 
                   10, -- Severity,  
                   1   -- State
                  );   
	    RETURN 1
	 END
	 --Actualizar saldo cuenta
	 UPDATE  [dbo].[Cuentas]
	    SET Saldo = @saldoNuevo
	  WHERE NombreCta = @NombreCta
	 IF @@ERROR <> 0
	 BEGIN	
	    ROLLBACK TRAN 
	    RAISERROR ('Error actualizando cuenta', -- Mensaje 
                   10, -- Severity,  
                   1   -- State
                  );   
	    RETURN 1
	 END
COMMIT TRAN
END
GO
