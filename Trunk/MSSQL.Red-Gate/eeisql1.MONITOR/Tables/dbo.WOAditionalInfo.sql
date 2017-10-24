CREATE TABLE [dbo].[WOAditionalInfo]
(
[WOTracerID] [int] NOT NULL IDENTITY(1, 1),
[OldWODID] [int] NULL,
[NewWODID] [int] NULL,
[CreateDT] [datetime] NULL CONSTRAINT [DF__WOTracert__Creat__021A62E1] DEFAULT (getdate()),
[Opeartor] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstPiece] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPiece] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstPieceDT] [datetime] NULL,
[LastPieceDT] [datetime] NULL,
[ControlFirstDT] [datetime] NULL,
[ControlLastDT] [datetime] NULL,
[Reporte] [bit] NULL,
[UsuarioFLP] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodigoHojaParametros] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weight] [numeric] (18, 4) NULL,
[Operador] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tecnico] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cavidad] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OperadorPP] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WOAditionalInfo] ADD CONSTRAINT [PK__WOTracert__01263EA8] PRIMARY KEY CLUSTERED  ([WOTracerID]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[WOAditionalInfo] TO [APPUser]
GO
