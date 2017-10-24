CREATE TABLE [dbo].[SupplierReleasePlans]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GeneratedDT] [datetime] NOT NULL CONSTRAINT [DF__SupplierR__Gener__6B3165CA] DEFAULT (getdate()),
[GeneratedWeekNo] [int] NOT NULL,
[GeneratedWeekDay] [smallint] NOT NULL CONSTRAINT [DF__SupplierR__Gener__6C258A03] DEFAULT (datepart(weekday,getdate())),
[BaseDT] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SupplierReleasePlans] ADD CONSTRAINT [PK__Supplier__3214EC2769491D58] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
