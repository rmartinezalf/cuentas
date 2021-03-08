USE [cuentas]
GO

/****** Object:  Table [dbo].[Cuentas]    Script Date: 2/03/2021 10:49:58 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cuentas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NombreCta] [nchar](50) NULL,
	[Excento] [nvarchar](2) NULL,
	[Banco] [nvarchar](20) NULL,
	[IdCliente] [int] NULL,
	[Saldo] [money] NULL,
 CONSTRAINT [PK_Cuentas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


