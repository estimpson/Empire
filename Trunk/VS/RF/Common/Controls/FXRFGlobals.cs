using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace Controls
{
    public class FXRFGlobals
    {  
#if PocketPC
        public static SymbolRFGun.SymbolRFGun MyRFGun = null;
#endif
        private static string _globalsFile = @"FXRFGlobals.xml";

        public static string _FXConnectionString;
        public string FXConnectionString
        {
            get
            {
                return _FXConnectionString;
            }
            set
            {
                _FXConnectionString = value;
            }
        }

        public FXRFGlobals()
        {
            //_FXConnectionString = (_FXConnectionString == null) ? "" : _FXConnectionString;
        }

        private void PersistState()
        {
            VerifyFileCanOpen();
            using (FileStream fs = new FileStream(_globalsFile, FileMode.Create))
            {
                XmlSerializer xs = new XmlSerializer(typeof(FXRFGlobals));
                xs.Serialize(fs, this);
            }
        }

        public static FXRFGlobals GetFXMESGlobals()
        {
            FXRFGlobals thisGlobals = null;
            try
            {
                VerifyFileCanOpen();
                using (FileStream fs = new FileStream(_globalsFile, FileMode.Open))
                {
                    XmlSerializer xs = new XmlSerializer(typeof(FXRFGlobals));
                    thisGlobals = (FXRFGlobals)xs.Deserialize(fs);
                }
            }
            catch (Exception ex)
            {
                thisGlobals = new FXRFGlobals();
                thisGlobals.PersistState();

                using (StreamWriter wtr = new StreamWriter(@"My Device\Temp\debugFXMES.txt", true))
                {
                    wtr.WriteLine(String.Format("{0} - {1}", DateTime.Now.ToString(), ex.Message));
                }
            }
            thisGlobals.PersistState();
            return thisGlobals;
        }

        private static void VerifyFileCanOpen()
        {
            FileInfo globalFile = new FileInfo(_globalsFile);
            while (true)
            {
                // Cause the current thread to sleep for 100 miliseconds.
                System.Threading.Thread.Sleep(100);
                try
                {
                    // Try to open the file for reading.
                    globalFile.OpenWrite().Close();
                    // If the file can be opened for reading, then exit the loop and continue execution of the method.
                    break;
                }
                catch
                {
                    // If the file cannot be read from yet, then continue looping.
                    continue;
                }
            }
        }


    }
}
