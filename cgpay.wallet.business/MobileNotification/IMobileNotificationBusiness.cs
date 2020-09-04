using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.MobileNotification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.MobileNotification
{
    public interface IMobileNotificationBusiness
    {
           List<MobileNotificationCommon> GetNotificationList();
        MobileNotificationCommon GetNotificationById(string notificationid, string username);
        CommonDbResponse ManageNotification(MobileNotificationCommon mnc);
        CommonDbResponse Disable_EnableNotification(string notificationid, string status, string username);
    }
}
