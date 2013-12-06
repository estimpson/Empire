using System;
using System.Collections.Generic;

namespace SymbolRFGun
{
    public class ScanData
    {
        private string rawData;
        private string dataIdentifier;
        private string dataValue;
        private eScanDataType scanDataType = eScanDataType.Undef;
        private Dictionary<string, eScanDataType> ScanDataIdentifiers;

        public ScanData(string pRawData)
        {
            BuildIdentifierDictionary();
            RawData = pRawData;
        }

        public ScanData()
        {
            BuildIdentifierDictionary();
        }

        public string RawData
        {
            get
            {
                return rawData;
            }
            set
            {
                rawData = value;
            }
        }

        public string DataIdentifier
        {
            get
            {
                FindIdentifier();
                return dataIdentifier;
            }
        }

        public string DataValue
        {
            get
            {
                FindIdentifier();
                return dataValue;
            }
        }

        public eScanDataType ScanDataType
        {
            get
            {
                FindIdentifier();
                return scanDataType;
            }
        }

        private void FindIdentifier()
        {
            foreach (KeyValuePair<string, eScanDataType> ScanDataIdentifier in ScanDataIdentifiers)
            {
                if (rawData.StartsWith(ScanDataIdentifier.Key, StringComparison.OrdinalIgnoreCase))
                {
                    dataIdentifier = ScanDataIdentifier.Key;
                    dataValue = RawData.Substring(ScanDataIdentifier.Key.Length);
                    scanDataType = ScanDataIdentifier.Value;
                    break;
                }
            }
            if (scanDataType == eScanDataType.Undef)
            {
                dataIdentifier = "";
                dataValue = RawData;
            }
        }

        private void BuildIdentifierDictionary()
        {
            //  This should probably be implemented as an interface...
            ScanDataIdentifiers = new Dictionary<string, eScanDataType>();
            ScanDataIdentifiers.Add("V", eScanDataType.SupplierCode);
            //ScanDataIdentifiers.Add("L", eScanDataType.Lot);
            ScanDataIdentifiers.Add("S", eScanDataType.Serial);
            ScanDataIdentifiers.Add("1S", eScanDataType.Serial);
            ScanDataIdentifiers.Add("3S", eScanDataType.Serial);
            ScanDataIdentifiers.Add("P", eScanDataType.Part);
            ScanDataIdentifiers.Add("Q", eScanDataType.Quantity);
            ScanDataIdentifiers.Add("K", eScanDataType.PO);
            ScanDataIdentifiers.Add("L", eScanDataType.Location);
            ScanDataIdentifiers.Add("1L", eScanDataType.Location);
            ScanDataIdentifiers.Add("2K", eScanDataType.Shipper);
        }

        public void AddApplicationSpecificIdentifier(string sID, eScanDataType eType)
        {
            ScanDataIdentifiers.Add(sID, eType);
        }

        public static implicit operator ScanData(System.String value)
        {
            ScanData scanData = new ScanData(value);
            return scanData;
        }


    }
}
