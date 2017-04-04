#region Using

using System;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.UserControls;

#endregion

namespace RmaMaintenance.Views
{
    public partial class NewRtvView : Form
    {
        private readonly Timer _visualStateTimer = new Timer { Interval = 20 };
        private string _warnings;
        public RtvController MyController { get; private set; }

        public String Warnings
        {
            get { return _warnings; }
            set
            {
                _warnings = value;
                UpdateVisualState();
            }
        }

        public NewRtvView()
        {
            InitializeComponent();
        }

        public void SetViewModel(RtvController myController)
        {
            //  2-way wiring...
            MyController = myController;
            MyController.SetView(this);

            //  Wire commands...
            newButton.Click += NewButtonClick;
            lookupButton.Click += LookupButtonOnClick;

            //  Use a timer to update visual state.
            _visualStateTimer.Tick += VisualStateTimerOnTick;

            rtvAddInventoryOLV1.RequestVisualUpdate += ChildControlOnRequestVisualUpdate;
            rtvOpenList1.RequestVisualUpdate += ChildControlOnRequestVisualUpdate;
            rtvPrintSend1.RequestVisualUpdate += ChildControlOnRequestVisualUpdate;

            rtvAddInventoryOLV1.ImportClipboard += RTVAddInventoryOLV1OnImportClipboard;

            //  Get the open RTV list.
            MyController.RefreshOpenRTVList();

            UpdateVisualState();
        }

        private void RTVAddInventoryOLV1OnImportClipboard(object sender, EventArgs eventArgs)
        {
            if (MyController.ImportDataFromSpreadsheet() == 1) UpdateVisualState();
        }

        private void ChildControlOnRequestVisualUpdate(object sender, EventArgs eventArgs)
        {
            UpdateVisualState();
        }

        void NewButtonClick(object sender, EventArgs eventArgs)
        {
            newButton.Checked = lookupButton.Checked = false;
            rtvAddInventoryOLV1.IsControlActive = true;
            rtvOpenList1.IsControlActive = false;
        }

        private void LookupButtonOnClick(object sender, EventArgs eventArgs)
        {
            newButton.Checked = lookupButton.Checked = false;
            rtvAddInventoryOLV1.IsControlActive = false;
            rtvOpenList1.IsControlActive = true;
        }

        public string OperatorCode { get; set; }

        private void LinkLblCloseLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Close();
        }

        public void UpdateVisualState()
        {
            if (MyController == null) return;
            _visualStateTimer.Start();
        }

        private void VisualStateTimerOnTick(object sender, EventArgs eventArgs)
        {
            _visualStateTimer.Stop();
            DoUpdateVisualState();
        }

        private void DoUpdateVisualState()
        {
            SuspendLayout();

            warningsLabel.Text = Warnings;

            rtvAddInventoryOLV1.SerialList = MyController.SerialsList;
            rtvAddInventoryOLV1.DoUpdateVisualState();

            rtvOpenList1.OpenRTVList = MyController.OpenRTVList;
            rtvOpenList1.DoUpdateVisualState();

            rtvPrintSend1.DoUpdateVisualState();
            
            ResumeLayout(false);
            PerformLayout();
            Visible = true;
        }
    }
}