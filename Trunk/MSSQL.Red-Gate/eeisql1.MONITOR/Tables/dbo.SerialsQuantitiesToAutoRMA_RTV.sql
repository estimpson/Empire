CREATE TABLE [dbo].[SerialsQuantitiesToAutoRMA_RTV]
(
[Serial] [int] NOT NULL,
[Quantity] [numeric] (20, 6) NOT NULL,
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SerialsQuantitiesToAutoRMA_RTV] ADD CONSTRAINT [PK_SerialsQuantitiesToAutoRMA_RTV] PRIMARY KEY CLUSTERED  ([Serial]) ON [PRIMARY]
GO
