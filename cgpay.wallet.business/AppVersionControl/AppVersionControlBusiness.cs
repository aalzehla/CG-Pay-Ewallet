using cgpay.wallet.repository.AppVersionControl;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.AppVersionControl;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.AppVersionControl
{
   public class AppVersionControlBusiness:IAppVersionControlBusiness
    {
        IAppVersionControlRepository repo;
        public AppVersionControlBusiness()
        {
            repo = new AppVersionControlRepository();
        }
        public List<AppVersionControlCommon> GetAppVersionList()
        {
            return repo.GetAppVersionList();
        }
        public CommonDbResponse ManageAppVersion(AppVersionControlCommon AVC)
        {
            return repo.ManageAppVersion(AVC);
        }
    }
}
