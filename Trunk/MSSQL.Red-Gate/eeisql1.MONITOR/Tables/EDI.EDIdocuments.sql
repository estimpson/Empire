CREATE TABLE [EDI].[EDIdocuments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__EDIdocumen__GUID__1ADBEF0A] DEFAULT (newid()),
[Status] [int] NOT NULL CONSTRAINT [DF__EDIdocume__Statu__6FD55C5D] DEFAULT ((-1)),
[FileName] [sys].[sysname] NOT NULL,
[Data] [xml] NOT NULL,
[TradingPartner] AS ([EDI].[udf_EDIDocument_TradingPartner]([Data])),
[Type] AS ([EDI].[udf_EDIDocument_Type]([Data])),
[Version] AS ([EDI].[udf_EDIDocument_Version]([Data])),
[Release] AS ([EDI].[udf_EDIDocument_Release]([Data])),
[DocNumber] AS ([EDI].[udf_EDIDocument_DocNumber]([Data])),
[ControlNumber] AS ([EDI].[udf_EDIDocument_ControlNumber]([Data])),
[DeliverySchedule] AS ([EDI].[udf_EDIDocument_DeliverySchedule]([Data])),
[MessageNumber] AS ([EDI].[udf_EDIDocument_MessageNumber]([Data])),
[RowTS] [timestamp] NOT NULL,
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__EDIdocume__RowCr__1CC4377C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__EDIdocume__RowCr__1DB85BB5] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EDI].[EDIdocuments] ADD CONSTRAINT [PK__EDIdocum__3214EC27170B5E26] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
