using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Notification
{
    public interface INotificationBusiness
    {
        List<NotificationCommon> GetAllNotification(string AgentId, string fromdate = "", string todate = "");

        DataSet GetNotificationByUser(String User);

        CommonDbResponse UpdateNotificationReadStatus(int id,string User, string UpdateFlag);

    }
}
