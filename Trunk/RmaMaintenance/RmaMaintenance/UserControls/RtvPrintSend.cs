#region Using

using System;
using System.Windows.Forms;

#endregion

namespace RmaMaintenance.UserControls
{
    public partial class RtvPrintSend : UserControl
    {
        public event EventHandler RequestVisualUpdate;

        public RtvPrintSend()
        {
            InitializeComponent();
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
        }
    }
}