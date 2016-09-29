using System;
using System.Data.Objects;
using RmaMaintenance.Controls;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class AssignPoController
    {
        #region Class Objects

        private readonly MONITOREntities _context;
        private readonly Messages _messages;

        #endregion

                
        #region Constructor

        public AssignPoController()
        {
            _context = new MONITOREntities();
            _messages = new Messages();
        }

        #endregion


        #region Methods

        public void AssignPo(string opCode, int serial)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_StageShipoutRtv_UpdatePo(opCode, serial, dt, result);

                _messages.Message = string.Format("Success.  Assigned a PO number to serial {0}.", serial.ToString());
                _messages.ShowDialog();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = error;
                _messages.ShowDialog();
            }
        }

        #endregion


    }
}
