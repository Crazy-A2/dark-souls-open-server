using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Loader.Properties;

namespace Loader
{
    public partial class SettingsForm : Form
    {
        public string ExeLocation = "";
        private bool DoNotSaveSettings = false;

        // 语言选项：显示名称与对应的设置值
        private readonly (string Display, string Value)[] LanguageOptions = {
            ("Auto (System)", "auto"),
            ("English", "en-US"),
            ("简体中文", "zh-CN")
        };

        public SettingsForm()
        {
            InitializeComponent();
        }

        private void OnLoad(object sender, EventArgs e)
        {
            DoNotSaveSettings = true;
            UseSeperateSavesCheckbox.Checked = ProgramSettings.Default.use_seperate_saves;

            // 初始化语言下拉框
            foreach (var lang in LanguageOptions)
            {
                LanguageComboBox.Items.Add(lang.Display);
            }
            string currentLang = ProgramSettings.Default.ui_language ?? "auto";
            int langIndex = Array.FindIndex(LanguageOptions, o => o.Value.Equals(currentLang, StringComparison.OrdinalIgnoreCase));
            LanguageComboBox.SelectedIndex = langIndex >= 0 ? langIndex : 0;

            DoNotSaveSettings = false;

            UpdateState();
        }

        private void UpdateState()
        {
            CopySavesButton.Enabled = ProgramSettings.Default.use_seperate_saves;
        }

        private void CopySavesClicked(object sender, EventArgs e)
        {   
            if (MessageBox.Show(Resources.Settings_OverwriteSavesConfirm, Resources.MsgTitle_Warning, MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) != DialogResult.Yes)
            {
                return;
            }

            int FilesCopied = 0;
            
            string BasePath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\DarkSoulsIII";
            FilesCopied += CopySavesInDirectory(BasePath);
            
            BasePath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\DarkSoulsII";
            FilesCopied += CopySavesInDirectory(BasePath);
            
            MessageBox.Show(string.Format(Resources.Settings_CopiedSaves, FilesCopied));
        }

        private int CopySavesInDirectory(string BasePath)
        {
            int FilesCopied = 0;
            
            if (!Directory.Exists(BasePath))
            {
                return 0;
            }

            string[] RetailFiles = System.IO.Directory.GetFiles(BasePath, "*.sl2", SearchOption.AllDirectories);
            foreach (string file in RetailFiles)
            {
                string NewPath = Path.ChangeExtension(file, ".ds3os");
                Console.WriteLine(file + " -> " + NewPath);

                File.Copy(file, NewPath, true);

                FilesCopied++;
            }
            
            return FilesCopied;
        }

        private void SettingChanged(object sender, EventArgs e)
        {
            if (DoNotSaveSettings)
            {
                return;
            }

            ProgramSettings.Default.use_seperate_saves = UseSeperateSavesCheckbox.Checked;
            ProgramSettings.Default.Save();

            UpdateState();
        }

        private void LanguageChanged(object sender, EventArgs e)
        {
            if (DoNotSaveSettings)
            {
                return;
            }

            int idx = LanguageComboBox.SelectedIndex;
            if (idx >= 0 && idx < LanguageOptions.Length)
            {
                string newLang = LanguageOptions[idx].Value;
                string oldLang = ProgramSettings.Default.ui_language ?? "auto";

                if (!newLang.Equals(oldLang, StringComparison.OrdinalIgnoreCase))
                {
                    ProgramSettings.Default.ui_language = newLang;
                    ProgramSettings.Default.Save();

                    MessageBox.Show(
                        "Language change will take effect after restarting the application.\n语言更改将在重启应用后生效。",
                        "Info",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                }
            }
        }
    }
}
