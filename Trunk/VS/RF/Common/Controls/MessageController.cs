using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;

namespace Controls
{
    public class MessageController
    {
        private String currentInstructions;
        private System.Windows.Forms.Label uxMessageControl;
        private List<String> priorMessages = new List<string>();
        private int? currentMessage = null;
        System.Windows.Forms.Timer displayTimer = new System.Windows.Forms.Timer();

        //  Public constructor requires a control to display messages.
        public MessageController(System.Windows.Forms.Label uxMessageControl, String initialInstructions)
        {
            this.uxMessageControl = uxMessageControl;
            this.currentInstructions = initialInstructions;
            displayTimer.Enabled = false;
            displayTimer.Interval = 10000;
            displayTimer.Tick += new EventHandler(displayTimer_Tick);
        }

        public void ShowInstruction(String instructions)
        {
            currentInstructions = instructions;
            uxMessageControl.Text = currentInstructions;
            displayTimer.Enabled = false;
        }

        public void ShowMessage(String message)
        {
            priorMessages.Add(message);
            currentMessage = priorMessages.Count - 1;
            uxMessageControl.Text = priorMessages[(int)currentMessage];
            displayTimer.Enabled = false;
            displayTimer.Enabled = true;
        }

        public void ShowPreviousMessage()
        {
            if (priorMessages.Count == 0)
            {
                currentMessage = null;
                return;
            }
            currentMessage = (currentMessage == null) ? priorMessages.Count - 1 : currentMessage - 1;
            if (currentMessage > priorMessages.Count - 1) currentMessage = priorMessages.Count - 1;
            if (currentMessage < 0) currentMessage = 0;
            uxMessageControl.Text = priorMessages[(int)currentMessage];
            displayTimer.Enabled = false;
            displayTimer.Enabled = true;
        }

        public void ShowNextMessage()
        {
            if (priorMessages.Count == 0)
            {
                currentMessage = null;
                return;
            }
            if (currentMessage == null) return;
            currentMessage = currentMessage + 1;
            if (currentMessage > priorMessages.Count - 1) currentMessage = priorMessages.Count - 1;
            if (currentMessage < 0) currentMessage = 0;
            uxMessageControl.Text = priorMessages[(int)currentMessage];
            displayTimer.Enabled = false;
            displayTimer.Enabled = true;
        }

        void displayTimer_Tick(object sender, EventArgs e)
        {
            displayTimer.Enabled = false;
            currentMessage = null;
            uxMessageControl.Text = currentInstructions;
        }
    }
}
