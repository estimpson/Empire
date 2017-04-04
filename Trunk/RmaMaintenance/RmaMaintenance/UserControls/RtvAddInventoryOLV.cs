#region Using

using System;
using System.Collections.Generic;
using System.Windows.Forms;
using RmaMaintenance.Model;
using RmaMaintenance.Views.Helpers;

#endregion

namespace RmaMaintenance.UserControls
{
    public partial class RtvAddInventoryOLV : UserControl
    {
        public event EventHandler RequestVisualUpdate;
        public event EventHandler ImportClipboard;

        private bool _isControlActive;

        public bool IsControlActive
        {
            get { return _isControlActive; }
            set
            {
                _isControlActive = value;
                ControlActivePanel.Visible = _isControlActive;
                ActivateDeactivateButton.Checked = _isControlActive;
                ActivateDeactivateButton.Text = _isControlActive ? "- Hide" : "Show +";
                ShowHideInstruction.Text = _isControlActive ? "" : "Show to add inventory to RTV";
            }
        }

        public List<InventoryToRTV> SerialList { get; set; }

        public RtvAddInventoryOLV()
        {
            InitializeComponent();
        }

        private void ActivateDeactivateButtonClick(object sender, EventArgs e)
        {
            IsControlActive = !IsControlActive;
        }

        private void UpdateVisualState()
        {
            OnRaiseRequestVisualUpdate();
        }

        // Wrap event invocations inside a protected virtual method
        // to allow derived classes to override the event invocation behavior
        protected virtual void OnRaiseRequestVisualUpdate()
        {
            // Make a temporary copy of the event to avoid possibility of
            // a race condition if the last subscriber unsubscribes
            // immediately after the null check and before the event is raised.
            var handler = RequestVisualUpdate;

            // Event will be null if there are no subscribers
            if (handler != null)
            {
                // Use the () operator to raise the event.
                handler(this, new EventArgs());
            }
        }

        public void DoUpdateVisualState()
        {
            serialListView.Objects = SerialList;
        }

        protected virtual void OnRaiseImportClipboard()
        {
            // Make a temporary copy of the event to avoid possibility of
            // a race condition if the last subscriber unsubscribes
            // immediately after the null check and before the event is raised.
            var handler = ImportClipboard;

            // Event will be null if there are no subscribers
            if (handler != null)
            {
                // Use the () operator to raise the event.
                handler(this, new EventArgs());
            }
        }

        private void ImportButtonClick(object sender, EventArgs e)
        {
            OnRaiseImportClipboard();
        }

        private void RtvAddInventoryOLVLoad(object sender, EventArgs e)
        {
            serialListView.RestoreViewPreferences();
        }
    }
}