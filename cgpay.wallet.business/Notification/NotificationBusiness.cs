using cgpay.wallet.repository.Notification;
using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Notification
{
    public class NotificationBusiness :INotificationBusiness
    {
        INotificationRepository _repo;

        public NotificationBusiness()
        {
            _repo = new NotificationRepository();
        }

        public List<NotificationCommon> GetAllNotification(string AgentId, string fromdate = "", string todate = "")
        {
            return _repo.GetAllNotification(AgentId,fromdate,todate);
        }

        public DataSet GetNotificationByUser(String User)
        {
            return _repo.GetNotificationByUser(User);
        }

        public CommonDbResponse UpdateNotificationReadStatus(int id, string User, string UpdateFlag)
        {
            return _repo.UpdateNotificationReadStatus(id,User,UpdateFlag);
        }

    }
}
