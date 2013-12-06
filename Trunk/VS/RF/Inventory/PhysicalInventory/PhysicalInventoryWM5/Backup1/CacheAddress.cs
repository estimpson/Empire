using System;
using System.Collections.Generic;
using System.Text;

namespace PhysicalInventory
{
    static class CacheAddress
    {
        public const string PhysicalInventoryData = "/PhysicalInventory/Data";
        public const string PhysicalProgressSummaryTableAdapter = "/PhysicalInventory/TA/PhysicalProgressSummary";
        public const string PhysicalProgressTableAdapter = "/PhysicalInventory/TA/PhysicalProgress";
        public const string EmployeeTableAdapter = "/PhysicalInventory/TA/Employee";
        public const string WarehouseInventoryTableAdapter = "/PhysicalInventory/TA/WarehouseInventory";
        public const string WarehouseLocationsTableAdapter = "/PhysicalInventory/TA/WarehouseLocations";
        public const string BeginPhysicalAisle = "/PhysicalInventory/Address/BeginPhysical/Aisle";
        public const string BeginPhysicalShelf = "/PhysicalInventory/Address/BeginPhysical/Shelf";
        public const string BeginPhysicalSubshelf = "/PhysicalInventory/Address/BeginPhysical/Subshelf";
    }
}
