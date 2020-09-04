using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.AppVersionControl;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.AppVersionControl
{
    public interface IAppVersionControlBusiness
    {
        List<AppVersionControlCommon> GetAppVersionList();
        CommonDbResponse ManageAppVersion(AppVersionControlCommon AVC);
    }
}
