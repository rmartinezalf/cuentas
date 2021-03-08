USE [cuentas]
GO

/****** Object:  Table [dbo].[Movimientos]    Script Date: 2/03/2021 10:50:22 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Movimientos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[IdCuenta] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[ValorRetiro] [money] NULL,
	[ValorGmf] [money] NULL,
	[SaldoMov] [money] NULL,
	[CuentaDestino] [nchar](50) NULL
) ON [PRIMARY]
GO


