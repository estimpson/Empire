CREATE TABLE [EEIUser].[elpaso_protrans]
(
[RECVPONUM] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEMID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QTYTOTAL] [numeric] (20, 6) NULL,
[LOCATIONID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SKIDID] [int] NOT NULL,
[VMI_OWNERFLAG] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VMI_VENDORID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VMI_OWNERID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATETIMEPROD] [datetime] NULL,
[RECVDATETIME] [datetime] NULL,
[VMI_RESPID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOTID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VMI_CUSTID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[elpaso_protrans] ADD CONSTRAINT [PK__elpaso_protrans__0876219E] PRIMARY KEY CLUSTERED  ([SKIDID]) ON [PRIMARY]
GO
