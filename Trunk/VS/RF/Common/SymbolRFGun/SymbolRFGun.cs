using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using Symbol.Audio;
using System.Windows.Forms;

namespace SymbolRFGun
{
    public class SymbolRFGunException : System.Exception
    {
        public SymbolRFGunException(string Message)
            : base(Message)
        {
        }
    }

    public class RFScanEventArgs : EventArgs
    {
        private readonly string text;

        public RFScanEventArgs(string text)
        {
            this.text = text;
        }

        public string Text
        {
            get { return text; }
        }
    }

    public delegate void RFScanEventHandler(object sender, RFScanEventArgs e);

    public class SymbolRFGun
    {
        private Symbol.Barcode.Reader _myReader = null;
        private Symbol.Notification.Beeper _myBeeper = null;
        private Symbol.Audio.Controller _myAudioController = null;
        public Symbol.Barcode.Reader MyReader
        {
            get
            {
                return _myReader;
            }
            set
            {
                _myReader = value;
            }
        }
        public Symbol.Notification.Beeper MyBeeper
        {
            get
            {
                return _myBeeper;
            }
            set
            {
                _myBeeper = value;
            }
        }
        public Symbol.Audio.Controller MyAudioController
        {
            get { return _myAudioController; }
            set { _myAudioController = value; }
        }
        private Symbol.Barcode.ReaderData MyReaderData = null;
        private System.EventHandler MyEventHandler = null;

        public SymbolRFGun()
        {
            if (this.InitReader())
            { }
            else
            {
                SymbolRFGunException ex = new SymbolRFGunException("Unable to initialize barcode reader.");
                throw ex;
            }

            if (this.InitNotifier())
            { }
            else
            {
                SymbolRFGunException ex = new SymbolRFGunException("Unable to initialize notifier.");
                throw ex;
            }

            ////Select Device from device list
            //Symbol.Audio.Device MyDevice = (Symbol.Audio.Device)Symbol.StandardForms.SelectDevice.Select(
            //    Symbol.Audio.Controller.Title,
            //    Symbol.Audio.Device.AvailableDevices);


        }

        public void Close()
        {
            this.TermReader();
            this.TermBeeper();
        }

        public event RFScanEventHandler RFScan;

        protected virtual void OnRFScan(RFScanEventArgs e)
        {
            if (RFScan != null)
            {
                RFScan(this, e);
            }
        }

        /// <summary>
        /// Initialize the reader.
        /// </summary>
        private bool InitReader()
        {
            //  If reader is already present, fail.
            if (MyReader != null) return false;

            MyReader = new Symbol.Barcode.Reader();

            //  Create reader data.
            MyReaderData = new Symbol.Barcode.ReaderData(
                Symbol.Barcode.ReaderDataTypes.Text,
                Symbol.Barcode.ReaderDataLengths.DefaultText);

            //  Create event handler delegate.
            MyEventHandler = new EventHandler(MyReader_ReadNotify);

            //  Enable reader.
            MyReader.Actions.Enable();
            MyReader.Parameters.Feedback.Success.BeepTime = 100;
            MyReader.Parameters.Feedback.Success.BeepFrequency = 3000;
            MyReader.Parameters.Feedback.Fail.BeepTime = 0;
            MyReader.Parameters.Feedback.Fail.WaveFile = "\\windows\\alarm3.wav";

            return true;
        }

        /// <summary>
        /// Initialize beep notifier.
        /// </summary>
        private bool InitNotifier()
        {           
            // ***** Newest gun (newest operating system) uses Symbol.Audio.dll
            // ***** in place of Symbol.Notification.dll

            // Select Device from device list
            Symbol.Audio.Device MyDevice = (Symbol.Audio.Device)Symbol.StandardForms.SelectDevice.Select(
                Symbol.Audio.Controller.Title,
                Symbol.Audio.Device.AvailableDevices);

            MyAudioController = new Symbol.Audio.StandardAudio(MyDevice);
            MyAudioController.BeeperVolume = 1;
            //MyAudioController.PlayAudio(500, 1000);
            // *****


            //if (device == null) return false;
            //Symbol.Notification.Device device = new Symbol.Notification.Device("Beeper", Symbol.Notification.NotifyType.BEEPER, 2);
            //MyBeeper = new Symbol.Notification.Beeper(device);
            //MyBeeper.Duration = 1000;
            //MyBeeper.Frequency = 3000;
            //MyBeeper.Volume = 1;

            return true;
        }

        /// <summary>
        /// Read complete or failure notification
        /// </summary>
        private void MyReader_ReadNotify(object sender, EventArgs e)
        {
            Symbol.Barcode.ReaderData TheReaderData = this.MyReader.GetNextReaderData();

            // If it is a successful read (as opposed to a failed one)
            if (TheReaderData.Result == Symbol.Results.SUCCESS)
            {
                //  Handle the data from this read.
                RFScanEventArgs eRFScan = new RFScanEventArgs(TheReaderData.Text);
                OnRFScan(eRFScan);

                // Start the next read
                this.StartRead();
            }
        }

        /// <summary>
        /// Stop reading and disable/close reader
        /// </summary>
        private void TermReader()
        {
            // If we have a reader
            if (this.MyReader != null)
            {
                // Disable the reader
                this.MyReader.Actions.Disable();

                // Free it up
                this.MyReader.Dispose();

                // Indicate we no longer have one
                this.MyReader = null;
            }

            // If we have a reader data
            if (this.MyReaderData != null)
            {
                // Free it up
                this.MyReaderData.Dispose();

                // Indicate we no longer have one
                this.MyReaderData = null;
            }
        }

        /// <summary>
        /// Stop reading and disable/close reader
        /// </summary>
        private void TermBeeper()
        {
            // If we have a beeper
            if (MyBeeper != null)
            {
                MyBeeper.Dispose();
            }
            else if (MyAudioController != null)
            {
                MyAudioController.Dispose();
            }
        }

        /// <summary>
        /// Start a read on the reader
        /// </summary>
        public void StartRead()
        {
            // If we have both a reader and a reader data
            if ((this.MyReader != null) &&
                 (this.MyReaderData != null))
            {
                // Flush reading
                StopRead();

                // Submit a read
                this.MyReader.ReadNotify += this.MyEventHandler;
                this.MyReader.Actions.Read(this.MyReaderData);
            }
        }

        /// <summary>
        /// Stop all reads on the reader
        /// </summary>
        public void StopRead()
        {
            // If we have a reader
            if (this.MyReader != null)
            {
                // Flush (Cancel all pending reads)
                this.MyReader.ReadNotify -= this.MyEventHandler;
                this.MyReader.Actions.Flush();
            }
        }

        /// <summary>
        /// Beep notification
        /// </summary>
        public void Beep()
        {
            // If we have a beeper.
            if (this.MyBeeper != null)
            {
                MyBeeper.State = Symbol.Notification.NotifyState.CYCLE;
            }
            else
            {
                this.MyAudioController.PlayAudio(500, 1000); //play Default beep
            }
        }

        /// <summary>
        /// Beep notification
        /// </summary>
        public void BeepSuccess()
        {
            // If we have a beeper.
            if (this.MyBeeper != null)
            {
                MyBeeper.State = Symbol.Notification.NotifyState.CYCLE;
            }
            else
            {
                this.MyAudioController.PlayAudio(200, 2000);
                this.MyAudioController.PlayAudio(200, 3000);
            }
        }


    }


}
