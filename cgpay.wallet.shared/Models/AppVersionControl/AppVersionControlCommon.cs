using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.AppVersionControl
{
    public class AppVersionControlCommon:Common
    {
        public string VersionId { get; set; }
        public string AppPlatform { get; set; }
        public string AppVersion { get; set; }
        public string IsMajorUpdate { get; set; }
        public string IsMinorUpdate { get; set; }
        public string AppUpdateInfo { get; set; }
    }
}
