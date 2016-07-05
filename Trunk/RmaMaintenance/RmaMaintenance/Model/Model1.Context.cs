﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RmaMaintenance.Model
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class MONITOREntities : DbContext
    {
        public MONITOREntities()
            : base("name=MONITOREntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<employee> employees { get; set; }
        public DbSet<vw_CreateRma_Destinations> vw_CreateRma_Destinations { get; set; }
        public DbSet<SerialsQuantitiesToAutoRMA_RTV> SerialsQuantitiesToAutoRMA_RTV { get; set; }
    
        public virtual int usp_CreateRma_ImportSerialsQuantities(Nullable<int> serial, Nullable<decimal> quantity, ObjectParameter tranDT, ObjectParameter result)
        {
            var serialParameter = serial.HasValue ?
                new ObjectParameter("Serial", serial) :
                new ObjectParameter("Serial", typeof(int));
    
            var quantityParameter = quantity.HasValue ?
                new ObjectParameter("Quantity", quantity) :
                new ObjectParameter("Quantity", typeof(decimal));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_CreateRma_ImportSerialsQuantities", serialParameter, quantityParameter, tranDT, result);
        }
    
        public virtual int usp_CreateRma_ProcessSerialsQuantities(string operatorCode, string rmaNumber, Nullable<int> createRTV, Nullable<int> placeSerialsOnHold, ObjectParameter nextShipper, ObjectParameter nextShipperRTV, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var rmaNumberParameter = rmaNumber != null ?
                new ObjectParameter("RmaNumber", rmaNumber) :
                new ObjectParameter("RmaNumber", typeof(string));
    
            var createRTVParameter = createRTV.HasValue ?
                new ObjectParameter("CreateRTV", createRTV) :
                new ObjectParameter("CreateRTV", typeof(int));
    
            var placeSerialsOnHoldParameter = placeSerialsOnHold.HasValue ?
                new ObjectParameter("PlaceSerialsOnHold", placeSerialsOnHold) :
                new ObjectParameter("PlaceSerialsOnHold", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_CreateRma_ProcessSerialsQuantities", operatorCodeParameter, rmaNumberParameter, createRTVParameter, placeSerialsOnHoldParameter, nextShipper, nextShipperRTV, tranDT, result);
        }
    
        public virtual int usp_CreateRma_DeleteSerialsQuantities(ObjectParameter tranDT, ObjectParameter result)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_CreateRma_DeleteSerialsQuantities", tranDT, result);
        }
    
        public virtual int usp_CreateRma_TransferOnHoldSerials(string operatorCode, Nullable<int> rmaShipper, string location, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var rmaShipperParameter = rmaShipper.HasValue ?
                new ObjectParameter("RmaShipper", rmaShipper) :
                new ObjectParameter("RmaShipper", typeof(int));
    
            var locationParameter = location != null ?
                new ObjectParameter("Location", location) :
                new ObjectParameter("Location", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_CreateRma_TransferOnHoldSerials", operatorCodeParameter, rmaShipperParameter, locationParameter, tranDT, result);
        }
    
        public virtual int usp_CreateRma_GetSerialsFromPartDest(string operatorCode, string destination, string partNumber, Nullable<decimal> requiredQuantity, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var destinationParameter = destination != null ?
                new ObjectParameter("Destination", destination) :
                new ObjectParameter("Destination", typeof(string));
    
            var partNumberParameter = partNumber != null ?
                new ObjectParameter("PartNumber", partNumber) :
                new ObjectParameter("PartNumber", typeof(string));
    
            var requiredQuantityParameter = requiredQuantity.HasValue ?
                new ObjectParameter("RequiredQuantity", requiredQuantity) :
                new ObjectParameter("RequiredQuantity", typeof(decimal));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_CreateRma_GetSerialsFromPartDest", operatorCodeParameter, destinationParameter, partNumberParameter, requiredQuantityParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_CreateRma_ProcessByDestGl_Result> usp_CreateRma_ProcessByDestGl(string operatorCode, string rmaNumber, Nullable<int> createRTV, Nullable<int> placeSerialsOnHold, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var rmaNumberParameter = rmaNumber != null ?
                new ObjectParameter("RmaNumber", rmaNumber) :
                new ObjectParameter("RmaNumber", typeof(string));
    
            var createRTVParameter = createRTV.HasValue ?
                new ObjectParameter("CreateRTV", createRTV) :
                new ObjectParameter("CreateRTV", typeof(int));
    
            var placeSerialsOnHoldParameter = placeSerialsOnHold.HasValue ?
                new ObjectParameter("PlaceSerialsOnHold", placeSerialsOnHold) :
                new ObjectParameter("PlaceSerialsOnHold", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_CreateRma_ProcessByDestGl_Result>("usp_CreateRma_ProcessByDestGl", operatorCodeParameter, rmaNumberParameter, createRTVParameter, placeSerialsOnHoldParameter, tranDT, result);
        }
    
        public virtual int usp_CreateRma_Honduras(string operatorCode, Nullable<int> rtvShipper, string locationCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var rtvShipperParameter = rtvShipper.HasValue ?
                new ObjectParameter("RtvShipper", rtvShipper) :
                new ObjectParameter("RtvShipper", typeof(int));
    
            var locationCodeParameter = locationCode != null ?
                new ObjectParameter("LocationCode", locationCode) :
                new ObjectParameter("LocationCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_CreateRma_Honduras", operatorCodeParameter, rtvShipperParameter, locationCodeParameter, tranDT, result);
        }
    
        public virtual int usp_ShipRtv(string operatorCode, Nullable<int> rtvShipper, string locationCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var rtvShipperParameter = rtvShipper.HasValue ?
                new ObjectParameter("RtvShipper", rtvShipper) :
                new ObjectParameter("RtvShipper", typeof(int));
    
            var locationCodeParameter = locationCode != null ?
                new ObjectParameter("LocationCode", locationCode) :
                new ObjectParameter("LocationCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_ShipRtv", operatorCodeParameter, rtvShipperParameter, locationCodeParameter, tranDT, result);
        }
    }
}
