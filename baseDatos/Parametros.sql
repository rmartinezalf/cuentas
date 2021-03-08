USE [cuentas]
GO

/****** Object:  Table [dbo].[Parametros]    Script Date: 2/03/2021 10:50:45 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Parametros](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Parametro] [nvarchar](10) NULL,
	[Valor] [money] NULL
) ON [PRIMARY]
GO


