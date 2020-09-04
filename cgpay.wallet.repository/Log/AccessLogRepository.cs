using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Log
{
    public class AccessLogRepository : IAccessLogRepository
    {
        RepositoryDao DAO;
        public AccessLogRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<AccessLogCommon> GetAccessLogList(string from_date, string to_date)
        {
            List<AccessLogCommon> acclog = new List<AccessLogCommon>();
            string sql = "sproc_access_log @flag = 's'";
            sql += string.IsNullOrEmpty(from_date) ? "" : ", @from_date=" + DAO.FilterString(from_date);
            sql += string.IsNullOrEmpty(to_date) ? "" : ", @to_date=" + DAO.FilterString(to_date);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    AccessLogCommon accesslog = new AccessLogCommon();
                    accesslog.pageName = dr["page_name"].ToString();                    
                    accesslog.logType = dr["log_type"].ToString();                   
                    accesslog.actionIpAddress = dr["from_ip_address"].ToString();
                    accesslog.browser = dr["browser_info"].ToString();
                    accesslog.CreatedBy = dr["created_by"].ToString();
                    accesslog.createdUtcDate = dr["created_UTC_date"].ToString();
                    accesslog.createdLocalDate = dr["created_local_date"].ToString();
                    //accesslog.fromDate = dr["created_UTC_date"].ToString();
                    //accesslog.toDate = dr["created_UTC_date"].ToString();
                    accesslog.Msg = dr["remarks"].ToString();

                    acclog.Add(accesslog);
                }
            }
            return acclog;
        }
    }
}
