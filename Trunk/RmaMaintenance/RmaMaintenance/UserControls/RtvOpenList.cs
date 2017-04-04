#region Using

using System;
using System.Collections.Generic;
using System.Windows.Forms;
using RmaMaintenance.Model;
using RmaMaintenance.Views.Helpers;

#endregion

namespace RmaMaintenance.UserControls
{
    public partial class RtvOpenList : UserControl
    {
        public event EventHandler RequestVisualUpdate;
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
                ShowHideInstruction.Text = _isControlActive ? "" : "Show to display a list of open RTVs";
            }
        }

        public List<OpenRTV> OpenRTVList { get; set; }

        public RtvOpenList()
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
            openRTVListView.Objects = OpenRTVList;
        }

        private void RtvOpenListLoad(object sender, EventArgs e)
        {
            openRTVListView.RestoreViewPreferences();
        }
    }
}