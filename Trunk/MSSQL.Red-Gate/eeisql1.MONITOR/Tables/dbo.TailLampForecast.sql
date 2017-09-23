CREATE TABLE [dbo].[TailLampForecast]
(
[OEM] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonic] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MnemonicVehicle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vehicle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[EOP] [datetime] NULL,
[LampType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supplier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (20, 6) NULL,
[date_inserted] [datetime] NULL
) ON [PRIMARY]
GO
