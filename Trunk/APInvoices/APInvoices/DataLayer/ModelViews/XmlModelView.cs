using System;
using System.IO;
using System.Xml;

namespace APInvoices.DataLayer.ModelViews
{
    public class XmlModelView
    {
        public string BartenderPath { get; set; }
        public string LabelPath { get; set; }
        public string PrinterPort { get; set; }

        public string GetXmlConfigurationData()
        {
            string error;

            error = FindXmlConfigFile();
            if (error != "") return error;

            error = GetBartenderPathXml();
            if (error != "") return error;
            
            error = GetNetworkLabelPathXml();
            if (error != "") return error;

            error = GetPrinterPortXml();
            if (error != "") return error;

            return "";
        }

        private string FindXmlConfigFile()
        {
            string filePath = @"C:\APInvoices\APInvoices.xml";
            if (!File.Exists(filePath))
            {
                return string.Format("Could not find the required XML configuration file at: {0}.", filePath);
            }
            return "";
        }

        private string GetBartenderPathXml()
        {
            string bartenderPathNodePath = "/configuration/BartenderPath";
            try
            {
                var doc = new XmlDocument();
                doc.Load(@"C:\APInvoices\APInvoices.xml");

                XmlNode node = doc.SelectSingleNode(bartenderPathNodePath);
                if (node == null) return "BartenderPath was not found in the XML configuration file.";

                string validationError = ValidateFilePathXML(node.InnerText);
                if (validationError != "") return validationError;

                BartenderPath = node.InnerText;
            }
            catch (Exception ex)
            {
                return (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return "";
        }

        private string GetNetworkLabelPathXml()
        {
            string networkLabelPathNodePath = "/configuration/NetworkLabelPath";
            try
            {
                var doc = new XmlDocument();
                doc.Load(@"C:\APInvoices\APInvoices.xml");

                XmlNode node = doc.SelectSingleNode(networkLabelPathNodePath);
                if (node == null) return "NetworkLabelPath was not found in the XML configuration file.";

                string validationError = ValidateFilePathXML(node.InnerText);
                if (validationError != "") return validationError;

                LabelPath = node.InnerText;
            }
            catch (Exception ex)
            {
                return (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return "";
        }

        private string ValidateFilePathXML(string filePath)
        {
            if (!File.Exists(filePath))
            {
                return string.Format(String.Format("Could not find the required file:  {0}.", filePath));
            }
            return "";
        }

        private string GetPrinterPortXml()
        {
            string printerPortNodePath = "/configuration/PrinterPort";
            try
            {
                var doc = new XmlDocument();
                doc.Load(@"C:\APInvoices\APInvoices.xml");

                XmlNode node = doc.SelectSingleNode(printerPortNodePath);
                if (node == null) return "PrinterPort was not found in the XML configuration file.";

                PrinterPort = node.InnerText;
            }
            catch (Exception ex)
            {
                return (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return "";
        }


    }
}
