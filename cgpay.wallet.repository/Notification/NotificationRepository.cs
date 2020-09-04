using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.repository.Notification
{
    public class NotificationRepository : INotificationRepository
    {
        RepositoryDao DAO;
        public NotificationRepository()
        {
            DAO = new RepositoryDao();
        }

        public List<NotificationCommon> GetAllNotification(string AgentId, string fromdate = "", string todate = "")
        {
            string sql = "EXEC sproc_agent_notification ";
            sql += "@flag = 'sa'";
            sql += (string.IsNullOrEmpty(fromdate) ? "" : ", @formDate =" + DAO.FilterString(fromdate)); 
            sql += (string.IsNullOrEmpty(todate) ? "" : ", @toDate =" + DAO.FilterString(todate)); 
            sql += ",@user_id = " + DAO.FilterString(AgentId);

            var dt = DAO.ExecuteDataset(sql);

            List<NotificationCommon> notificationList = new List<NotificationCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Tables[0].Rows)
                {
                    NotificationCommon AC = new NotificationCommon
                    {
                        Id = item["Id"].ToString(),
                        Subject = item["Subject"].ToString(),
                        CreatedDate = item["CreatedDate"].ToString(),
                        Notification = item["Notification"].ToString(),
                        ReadStatus = item["ReadStatus"].ToString(),
                        Type = item["type"].ToString()

                    };
                    notificationList.Add(AC);
                }

            }
            return notificationList;
        }

        public DataSet GetNotificationByUser(string User)
        {
            var sql = "EXEC sproc_agent_notification ";
            sql += "@flag = 's'";
            sql += ",@user_id = " + DAO.FilterString(User);
            var ds = DAO.ExecuteDataset(sql);
            return ds;
        }

        public CommonDbResponse UpdateNotificationReadStatus(int id,string User,string UpdateFlag)
        {
            var sql = "EXEC sproc_agent_notification ";
            sql += "@flag = 'us'";
            sql += ",@user_id = " + DAO.FilterString(User);
            sql += ",@update_flag = " + DAO.FilterString(UpdateFlag);
            sql += ",@notification_id = " + id;
            //var ds = DAO.ExecuteDataset(sql);

            return DAO.ParseCommonDbResponse(sql);
        }

        
    }
}
