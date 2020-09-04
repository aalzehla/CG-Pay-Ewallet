using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Log
{
    public class ApiLogRepository : IApiLogRepository
    {
        RepositoryDao DAO;
        public ApiLogRepository()
        {
            DAO = new RepositoryDao();
        }

        public List<ApiLogCommon> GetApiLogList(string api_log_id = "", string fromDate = "", string toDate = "", string txnId = "", string userName = "")
        {
            List<ApiLogCommon> apiLog = new List<ApiLogCommon>();
            string sql = "sproc_api_log_report @flag = 's'";
            sql += string.IsNullOrEmpty(api_log_id) ? "" : ", @api_log_id=" + DAO.FilterString(api_log_id);
            sql += string.IsNullOrEmpty(txnId) ? "" : ", @txn_id=" + DAO.FilterString(txnId);
            sql += string.IsNullOrEmpty(userName) ? "" : ", @user_name=" + DAO.FilterString(userName);
            sql += string.IsNullOrEmpty(fromDate) ? "" : ", @from_date=" + DAO.FilterString(fromDate);
            sql += string.IsNullOrEmpty(toDate) ? "" : ", @to_date=" + DAO.FilterString(toDate);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    ApiLogCommon apilog = new ApiLogCommon();
                    apilog.apiLogId = dr["api_log_id"].ToString();
                    apilog.apiRequest = dr["api_request"].ToString();
                    apilog.apiResponse = dr["api_response"].ToString();
                    apilog.transacionId = dr["txn_id"].ToString();
                    apilog.userId = dr["user_id"].ToString();
                    apilog.functionName = dr["function_ame"].ToString();
                    apilog.createdLocalDate = dr["created_local_Date"].ToString();
                    apilog.createdUtcDate = dr["created_UTC_Date"].ToString();



                    apiLog.Add(apilog);
                }
            }
            return apiLog;
        }

        public CommonDbResponse InsertApiLog(ApiLogCommon apiLog)
        {
            CommonDbResponse dbRes = new CommonDbResponse();
            string sqlCommand = "Execute sproc_api_log @flag = 'i'";
            sqlCommand += ",@partner_Id = " + DAO.FilterString(apiLog.partner_Id);
            sqlCommand += ",@txn_id = " + DAO.FilterString(apiLog.transacionId);
            sqlCommand += ",@partner_tran_id = " + DAO.FilterString(apiLog.partner_tran_id);
            sqlCommand += ",@request = " + DAO.FilterString(apiLog.apiRequest);
            sqlCommand += ",@response = " + DAO.FilterString(apiLog.apiResponse);
            sqlCommand += ",@from_ip_address = " + DAO.FilterString(apiLog.IpAddress);
            sqlCommand += ",@user_id = " + DAO.FilterString(apiLog.userId);
            sqlCommand += ",@func_Name = " + DAO.FilterString(apiLog.functionName);
            var dbResponse = DAO.ExecuteDataRow(sqlCommand);
            if (dbResponse != null)
            {
                dbRes.Code = ResponseCode.Success;
                dbRes.Message = "Success";
                dbRes.Id = DAO.ParseColumnValue(dbResponse, "sno").ToString();
            }
            else
            {
                dbRes.Code = ResponseCode.Failed;
                dbRes.Message = "Something Went Wrong!";
            }
            return dbRes;



        }
       

        public CommonDbResponse UpdateApiLog(ApiLogCommon apiLog)
        {
            CommonDbResponse dbRes = new CommonDbResponse();
            string sqlCommand = "Execute sproc_api_log @flag = 'u'";
            sqlCommand += ",@partner_Id = " + DAO.FilterString(apiLog.partner_Id);
            sqlCommand += ",@txn_id = " + DAO.FilterString(apiLog.transacionId);
            sqlCommand += ",@partner_tran_id = " + DAO.FilterString(apiLog.partner_tran_id);
            sqlCommand += ",@response = " + DAO.FilterString(apiLog.apiResponse);
            sqlCommand += ",@from_ip_address = " + DAO.FilterString(apiLog.IpAddress);
            sqlCommand += ",@user_id = " + DAO.FilterString(apiLog.userId);
            sqlCommand += ",@log_id = " + DAO.FilterString(apiLog.apiLogId);
            var dbResponse = DAO.ExecuteDataRow(sqlCommand);
            if (dbResponse != null)
            {
                dbRes.Code = ResponseCode.Success;
                dbRes.Message = "Success";
               
            }
            else
            {
                dbRes.Code = ResponseCode.Failed;
                dbRes.Message = "Something Went Wrong!";
            }
            return dbRes;



        }
    }
}
