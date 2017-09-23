CREATE TABLE [dbo].[SSR_LogbySerial]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[SSR_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Serial] [int] NULL,
[RegisterUser] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegisterDate] [datetime] NULL,
[AuditTrailID] [int] NULL,
[OriginalStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_SSR_LogbySerial_Quantity] DEFAULT ((0))
) ON [PRIMARY]
GO
