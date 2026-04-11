/*
 * Dark Souls 3 - Open Server
 * Copyright (C) 2021 Tim Leonard
 *
 * This program is free software; licensed under the MIT license. 
 * You should have received a copy of the license along with this program. 
 * If not, see <https://opensource.org/licenses/MIT>.
 */

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Loader
{
    public static class Program
    {
        // 当前支持的语言列表
        private static readonly string[] SupportedCultures = { "en-US", "zh-CN" };

        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            ApplyLanguageSetting();

            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }

        /// <summary>
        /// 根据用户设置或系统语言初始化 UI Culture。
        /// </summary>
        private static void ApplyLanguageSetting()
        {
            string lang = ProgramSettings.Default.ui_language ?? "auto";
            CultureInfo culture;

            if (lang.Equals("auto", StringComparison.OrdinalIgnoreCase))
            {
                // 跟随系统语言，若不在支持列表中则回退英文
                string systemLang = CultureInfo.CurrentUICulture.Name;
                if (Array.Exists(SupportedCultures, c => systemLang.StartsWith(c.Split('-')[0], StringComparison.OrdinalIgnoreCase)))
                {
                    culture = CultureInfo.CurrentUICulture;
                }
                else
                {
                    culture = new CultureInfo("en-US");
                }
            }
            else
            {
                try
                {
                    culture = new CultureInfo(lang);
                }
                catch
                {
                    culture = new CultureInfo("en-US");
                }
            }

            Thread.CurrentThread.CurrentUICulture = culture;
            Thread.CurrentThread.CurrentCulture = culture;
            CultureInfo.DefaultThreadCurrentUICulture = culture;
            CultureInfo.DefaultThreadCurrentCulture = culture;
        }
    }
}
