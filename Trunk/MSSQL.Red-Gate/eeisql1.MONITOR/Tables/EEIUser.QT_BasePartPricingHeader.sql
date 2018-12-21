CREATE TABLE [EEIUser].[QT_BasePartPricingHeader]
(
[PartNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_BasePa__Statu__1F659A7B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_BasePar__Type__2059BEB4] DEFAULT ((0)),
[OriginalQuote] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActiveQuote] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LtaEffectiveDate] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_BasePa__RowCr__214DE2ED] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_BasePa__RowCr__22420726] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_BasePa__RowMo__23362B5F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_BasePa__RowMo__242A4F98] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_BasePartPricingHeader] ADD CONSTRAINT [PK__QT_BaseP__FFEE74511D7D5209] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
