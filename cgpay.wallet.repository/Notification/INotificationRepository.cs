using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.repository.Notification
{
    public interface INotificationRepository
    {
        List<NotificationCommon> GetAllNotification(string AgentId, string fromdate = "", string todate = "");
        DataSet GetNotificationByUser(string User);
        CommonDbResponse UpdateNotificationReadStatus(int id,string User, string UpdateFlag);
    }
}
