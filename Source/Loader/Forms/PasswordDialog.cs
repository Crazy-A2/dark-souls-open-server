using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Loader.Properties;

namespace Loader.Forms
{
    public partial class PasswordDialog : Form
    {
        private ServerConfig Config;
        private Task GetPublicKeyTask = null;

        public PasswordDialog(ServerConfig InConfig)
        {
            Config = InConfig;

            InitializeComponent();
        }

        private void OnSubmit(object sender, EventArgs e)
        {
            submitButton.Enabled = false;
            submitButton.Text = Resources.Password_RetrievingKeys;

            string Password = passwordTextBox.Text;

            GetPublicKeyTask = Task.Run(() =>
            {
                string PublicKey = MasterServerApi.GetPublicKey(Config.Id, Password);
                this.Invoke((MethodInvoker)delegate {
                    ProcessPublicKey(PublicKey);
                });
            });
        }

        private void ProcessPublicKey(string Key)
        {
            if (string.IsNullOrEmpty(Key))
            {
                MessageBox.Show(Resources.Password_FailedGetKeys, Resources.MsgTitle_Error, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            Config.PublicKey = Key;
            GetPublicKeyTask = null;

            DialogResult = DialogResult.OK;
            Close();
        }

        private void OnFormClosing(object sender, FormClosingEventArgs e)
        {
            if (GetPublicKeyTask != null)
            {
                e.Cancel = true;
            }
        }
    }
}
