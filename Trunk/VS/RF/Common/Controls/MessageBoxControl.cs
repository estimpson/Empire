using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace Controls
{
    public partial class MessageBoxControl : UserControl
    {
        public string Instructions;
        public MessageController myController;

        public event EventHandler<EventArgs> MessageBoxControl_ShowPrevMessage;
        public event EventHandler<EventArgs> MessageBoxControl_ShowNextMessage;

        public MessageBoxControl()
        {
            InitializeComponent();
        }

        protected virtual void ucPrevMessage_Click(object sender, EventArgs e)
        {
            // Make a temporary copy of the event to avoid possibility of
            // a race condition if the last subscriber unsubscribes
            // immediately after the null check and before the event is raised.
            EventHandler<EventArgs> handler = MessageBoxControl_ShowPrevMessage;

            // Event will be null if there are no subscribers
            if (handler != null)
            {
                // Raise event.
                handler(this, new EventArgs());
            }

            //myController.ShowPreviousMessage();
            //myController.MessageBack();
        }

        protected virtual void ucNextMessage_Click(object sender, EventArgs e)
        {
            // Make a temporary copy of the event to avoid possibility of
            // a race condition if the last subscriber unsubscribes
            // immediately after the null check and before the event is raised.
            EventHandler<EventArgs> handler = MessageBoxControl_ShowNextMessage;

            // Event will be null if there are no subscribers
            if (handler != null)
            {
                // Raise event.
                handler(this, new EventArgs());
            }

            //myController.ShowNextMessage();
            //myController.MessageForward();
        }

        private void MessageBoxControl_TextChanged(object sender, EventArgs e)
        {
            Instructions = e.ToString();
        }



    }
}