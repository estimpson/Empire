CREATE TABLE [FxPVQ].[PVQ_FileManagement]
(
[PartVendorQuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PVQ_FileMa__Statu__4B634CF3] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PVQ_FileMan__Type__4C57712C] DEFAULT ((0)),
[AttachmentCategory] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [sys].[sysname] NULL,
[PathLocator] [sys].[hierarchyid] NULL,
[StreamID] [uniqueidentifier] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PVQ_FileMa__RowCr__4D4B9565] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PVQ_FileMa__RowCr__4E3FB99E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PVQ_FileMa__RowMo__4F33DDD7] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PVQ_FileMa__RowMo__50280210] DEFAULT (suser_name())
) ON [PRIMARY]
GO
