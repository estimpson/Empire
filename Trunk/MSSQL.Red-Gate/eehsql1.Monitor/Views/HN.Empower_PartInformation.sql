SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [HN].[Empower_PartInformation]
as

Select 
       Part= Parts.Item,
       Parts.item_description,
       Parts.Commodity,
       Cost=Average_cost,         
       Account= issue_ledger_account,
       OnInventory = isnull(on_hand_quantity,0),
       InTransit = isnull(InTransit,0)
from   eeh.dbo.items Parts with (readuncommitted)
       left join eeh.dbo.item_locations Account with (readuncommitted)
              on Parts.item = Account.item
       left join (Select part1.Item,
                                  InTransit= isnull(on_hand_quantity,0)   
                           from eeh.dbo.items Part1 with (readuncommitted)                                                 
                                  left join eeh.dbo.item_locations Account1 with (readuncommitted)
                                         on Part1.item = Account1.item
                           where  status='A' and location = 'Troy' ) InTransit
              on Parts.item = intransit.item
where  status='A'
     --  and parts.item ='68015288'
       and Account.location = 'Honduras'


GO
