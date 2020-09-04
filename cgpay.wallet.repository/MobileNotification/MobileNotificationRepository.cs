using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.MobileNotification;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.MobileNotification
{
    public class MobileNotificationRepository:IMobileNotificationRepository
    {
        RepositoryDao dao;
        public MobileNotificationRepository()
        {
            dao = new RepositoryDao();
        }
        public List<MobileNotificationCommon> GetNotificationList()
        {
            var sql = "Exec Sproc_mobile_notification ";
            sql += "@flag = 's' ";
            var dt = dao.ExecuteDataTable(sql);
            var list = new List<MobileNotificationCommon>();
            if(dt != null)
            {
                foreach(DataRow item in dt.Rows)
                {
                    var common = new MobileNotificationCommon
                    {
                        NotificationId = item["notification_id"].ToString(),
                        NotificationSubject = item["notification_subject"].ToString(),
                        NotificationSubtitle = item["notification_subtitle"].ToString(),
                        NotificationType = item["notification_type"].ToString(),
                        NotificationStatus = item["notification_status"].ToString()
                    };
                    list.Add(common);
                }
            }
            return list;
        }
        public MobileNotificationCommon GetNotificationById(string notificationid,string username)
        {
            var sql = "Exec Sproc_mobile_notification ";
            sql += "@flag = 'sid' ";
            sql += "@notification_id ="+dao.FilterString(notificationid);
            sql += "@action_user ="+dao.FilterString(username);
            MobileNotificationCommon common = new MobileNotificationCommon();

            var dt = dao.ExecuteDataRow(sql);
            if(dt != null)
            {
                common.NotificationId= dt["notification_id"].ToString();
                common.NotificationSubject= dt["notification_subject"].ToString();
                common.NotificationSubtitle= dt["notification_subtitle"].ToString();
                common.NotificationBody= dt["notification_body"].ToString();
                common.NotificationImageUrl= dt["notification_image_url"].ToString();
                common.ActionId= dt["action_id"].ToString();
                common.NotificationType= dt["notification_type"].ToString();
                common.NotificationImportanceLevel= dt["notification_importance_level"].ToString();
                common.NotificationStatus= dt["notification_status"].ToString();
                common.IsBackground= dt["is_background"].ToString();
                common.NotificationTo= dt["notification_to"].ToString();
                common.AgentId= dt["agent_id"].ToString();
                common.UserId= dt["user_id"].ToString();
                common.CreateDate= dt["created_local_date"].ToString();                
                common.TxnId= dt["txn_id"].ToString();
                common.ReadStatus= dt["read_status"].ToString();
                common.TxnStatusId= dt["txn_status_id"].ToString();
                common.TxnStatus= dt["txn_status"].ToString();
            }
            return common;
        }
        public CommonDbResponse ManageNotification(MobileNotificationCommon mnc)
        {
            var sql = "Exec Sproc_mobile_notification ";
            sql += "@flag = '" + (string.IsNullOrEmpty(mnc.NotificationId) ? "i" : "u") + "' ";
            sql += ",@notification_id=" + dao.FilterString(mnc.NotificationId);
            sql += ",@notification_subject=" + dao.FilterString(mnc.NotificationSubject);
            sql += ",@notification_subtitle=" + dao.FilterString(mnc.NotificationSubtitle);
            sql += ",@notification_body=" + dao.FilterString(mnc.NotificationBody);
            //sql += ",@notification_image_url=" + dao.FilterString(mnc.NotificationImageUrl);
            sql += ",@notification_image_url=" + dao.FilterString(mnc.ImageUpload);
            sql += ",@action_id=" + dao.FilterString(mnc.ActionId);
            sql += ",@notification_type=" + dao.FilterString(mnc.NotificationType);
            sql += ",@notification_importance_level=" + dao.FilterString(mnc.NotificationImportanceLevel);
            sql += ",@notification_status=" + dao.FilterString(mnc.NotificationStatus);
            sql += ",@is_background=" + dao.FilterString(mnc.IsBackground);
            sql += ",@notification_to=" + dao.FilterString(mnc.NotificationTo);
            sql += ",@agent_id=" + dao.FilterString(mnc.AgentId);
            sql += ",@user_id=" + dao.FilterString(mnc.UserId);          
            sql += ",@action_user=" + dao.FilterString(mnc.ActionUser);
            sql += ",@txn_id=" + dao.FilterString(mnc.TxnId);
            sql += ",@read_status=" + dao.FilterString(mnc.ReadStatus);
            sql += ",@txn_status_id=" + dao.FilterString(mnc.TxnStatusId);
            sql += ",@txn_status=" + dao.FilterString(mnc.TxnStatus);
            return dao.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse Disable_EnableNotification(string notificationid,string status,string username)
        {
            string sql = "exec Sproc_mobile_notification ";
            sql += " @flag='e'";
            sql += ",@notification_id=" + dao.FilterString(notificationid);
            sql += ",@notification_status=" + dao.FilterString(status);
            sql += ",@action_user=" + dao.FilterString(username);

            return dao.ParseCommonDbResponse(sql);
        }

    }
}
