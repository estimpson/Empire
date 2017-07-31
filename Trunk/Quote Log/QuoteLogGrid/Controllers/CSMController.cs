using System;
using System.ComponentModel;
using System.Data.Entity;
using System.Data.Objects;
using System.Linq;
using QuoteLogData.Models;

namespace QuoteLogGrid.Controllers
{
    public class CSMController
    {
        private readonly QuoteLogContext _context;

        private string _quoteNumber { get; set; }

        public CSMController(string quoteNumber)
        {
            _context = new QuoteLogContext();
            _quoteNumber = quoteNumber;
        }


        #region North American CSM

        public BindingList<CSM_Mnemonic> GetNorthAmericanCsmData(out string error)
        {
            error = "";
            try
            {
                // Populate the DbSet with data (_context.CSM_Mnemonic)
                var query = (from csmm in _context.CSM_Mnemonic
                            select csmm).ToList();

                // Bind to local data, return as an observable collection that supports data binding
                if (query.Any()) return _context.CSM_Mnemonic.Local.ToBindingList();
            }
            catch (Exception ex)
            {
                error = "Failed to retrieve CSM grid data.";
            }
            return null;
        }

        public IQueryable<QuoteCSM> GetNorthAmericanCsmDataforQuote(out string error)
        {
            error = "";
            try
            {
                var query = from qcsm in _context.QuoteCSMs
                            where qcsm.QuoteNumber == _quoteNumber
                            select qcsm;

                if (query.Any()) return query;
            }
            catch (Exception ex)
            {
                error = "Failed to retrieve CSM grid data for quote.";
            }
            return null;
        }
            
        public BindingList<QuoteCSM> RefreshNorthAmericanCsmData(string quoteNumber)
        {
            // Create a list of the Entities (rows) in the Entity Set (table)
            var csmList = _context.QuoteCSMs.Local.ToList();
            foreach (var csm in csmList)
            {
                // Records that no longer exist in the database will be removed from the current state
                _context.Entry(csm).Reload();
            }

            // Look up CSM Mnemonics for this quote and check them in the grid
            _context.QuoteCSMs.Where(o => o.QuoteNumber == _quoteNumber).Load();
            return _context.QuoteCSMs.Local.ToBindingList();
        }

        #endregion


        #region Non-North American CSM

        public IQueryable<QuoteManualProgramData> GetNonNorthAmericanCMSData(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                // Query the database
                var query = from qmpd in _context.QuoteManualProgramDatas
                            where qmpd.QuoteNumber == _quoteNumber
                            select qmpd;

                if (query.Any()) return query;    
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to retrieve Non-North American CSM data.";
            }
            return null;
        }

        #endregion


        #region Save

        public void SaveMnemonics(string mnemonicVehiclePlant, string releaseId, string version, out string errorMessage)
        {
            errorMessage = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try // Tie CSM Mnemonic to Quote
            {
                _context.usp_QT_InsertQuoteCSM(_quoteNumber, mnemonicVehiclePlant, releaseId, version, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = string.Format("Error occured when attempting to save {0} to quote {1}.", mnemonicVehiclePlant, _quoteNumber);
                //if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");  
            }
        }

        public void DeleteMnemonics(string mnemonicVehiclePlant, out string errorMessage)
        {
            errorMessage = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try // Remove CSM Mnemonic from Quote
            {
                _context.usp_QT_DeleteQuoteCSM(_quoteNumber, mnemonicVehiclePlant, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = string.Format("Error occured when attempting to remove {0} from quote {1}.", mnemonicVehiclePlant, _quoteNumber);
                //if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
            }
        }

        public void SaveNonNorthAmericanCSM(string manufacturer, string platform, string program, string nameplate, out string errorMessage)
        {
            errorMessage = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try // Tie new Non-North American CSM record to quote, or update existing record
            {
                _context.usp_QT_InsertQuoteManualProgramData(_quoteNumber, manufacturer, platform, program, nameplate, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to save Non-North American CSM data.";
                //if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
            }
        }

        public void DeleteNonNorthAmericanCsm(out string errorMessage)
        {
            errorMessage = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try // Remove Non-North American CSM mnemonic from quote
            {
                _context.usp_QT_DeleteQuoteManualProgramData(_quoteNumber, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to delete Non-North American CSM data.";
                //if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
            }
        }

        #endregion


    }
}
