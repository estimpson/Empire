#region Using

using System;
using System.Drawing;

#endregion

namespace Fx.WinForms.Flat
{
    public partial class MESCheckButton : MESButton
    {
        private bool _checked;
        private bool _clicking;
        private Color _checkedBorderColor;
        private Color _checkedColor;
        private Color _uncheckedBorderColor;
        private Color _uncheckedColor;

        public bool Checked
        {
            get { return _checked; }
            set
            {
                _checked = value;
                CheckChange();
            }
        }

        public Color CheckedBorderColor
        {
            get { return _checkedBorderColor; }
            set { _checkedBorderColor = value; }
        }

        public Color CheckedColor
        {
            get { return _checkedColor; }
            set
            {
                _checkedColor = value;
                FlatAppearance.MouseDownBackColor = CheckedColor;
            }
        }

        public Color UncheckedBorderColor
        {
            get { return _uncheckedBorderColor; }
            set { _uncheckedBorderColor = value; }
        }

        public Color UncheckedColor
        {
            get { return _uncheckedColor; }
            set { _uncheckedColor = value; }
        }

        public MESCheckButton()
        {
            InitializeComponent();

            //_checkedBorderColor = Color.FromArgb(28, 151, 234);
            //_checkedColor = Color.FromArgb(0, 122, 204);
            //_uncheckedBorderColor = Color.FromArgb(67, 67, 70);
            //_uncheckedColor = Color.FromArgb(31, 31, 32);
            ((MESButton)this).Click += OnClick;
        }

        private void OnClick(object sender, EventArgs eventArgs)
        {
            _clicking = true;
            FlatAppearance.MouseOverBackColor = CheckedColor;
            BackColor = FlatAppearance.MouseOverBackColor;
            FlatAppearance.BorderColor = CheckedBorderColor;

            OnClick();
            Checked = !Checked;
            _clicking = false;
        }

        private void CheckChange()
        {
            //if (_clicking) return;

            // Handle the changing of the background color for checked state.
            FlatAppearance.MouseOverBackColor = Checked ? CheckedColor : UncheckedColor;
            BackColor = FlatAppearance.MouseOverBackColor;
            FlatAppearance.BorderColor = Checked ? CheckedBorderColor : UncheckedBorderColor;
            //FlatAppearance.BorderColor = Checked ? Color.FromArgb(28, 151, 234) : Color.FromArgb(67, 67, 70);
        }

        public new event EventHandler Click;

        protected virtual void OnClick()
        {
            var handler = Click;
            if (handler != null) handler(this, EventArgs.Empty);
        }
    }
}