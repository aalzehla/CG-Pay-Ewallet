using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.BulkUpload;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.BulkUpload
{

    public class BulkUploadRepository : IBulkUploadRepository
    {

        RepositoryDao DAO;
        public BulkUploadRepository()
        {
            DAO = new RepositoryDao();
        }


        public CommonDbResponse BulkUpload(string FileName, string FilePath, string ActionUser, string AgentId)
        {
            string sql = "spa_import_BULK_mobile_topup";
            sql += " @FilePath=" + DAO.FilterParameter(FilePath);
            sql += " ,@FileName=" + DAO.FilterParameter(FileName);
            sql += " ,@actionUser=" + DAO.FilterParameter(ActionUser);
            sql += " ,@agentId=" + DAO.FilterParameter(AgentId);
            sql += " ,@actionIPAddress = N':1'";

            return DAO.ParseCommonDbResponse(sql);
        }

        public List<BulkUploadCommon> GetUploadedDataDetailList(string ProcessId, string ActionUser, string DataImportSource = "")
        {
            string sql = "sproc_msg_bulk_topup";
            sql += " @flag='sd'";
            sql += " ,@processID=" + DAO.FilterParameter(ProcessId);
            sql += " ,@actionUser=" + DAO.FilterParameter(ActionUser);
            sql += " ,@dataImportSource=" + DAO.FilterParameter(DataImportSource);
            var dt = DAO.ExecuteDataTable(sql);

            List<BulkUploadCommon> lst = new List<BulkUploadCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    BulkUploadCommon common = new BulkUploadCommon
                    {
                        DataId = item["import_status_id"].ToString(),
                        ProcessId = item["process_id"].ToString(),
                        DataImportSource = item["data_import_source"].ToString(),
                        Type = item["type"].ToString(),
                        Description = item["data_import_description"].ToString(),
                        CreateDate = item["created_local_date"].ToString()
                    };
                    lst.Add(common);
                }
            }
            return lst;


        }

        public List<BulkUploadCommon> GetUploadedDataList(string ProcessId, string ActionUser, string DataImportSource = "")
        {
            string sql = "sproc_msg_bulk_topup";
            sql += " @flag='s'";
            sql += " ,@processID=" + DAO.FilterParameter(ProcessId);
            sql += " ,@actionUser=" + DAO.FilterParameter(ActionUser);
            sql += " ,@dataImportSource=" + DAO.FilterParameter(DataImportSource);
            var dt = DAO.ExecuteDataTable(sql);

            List<BulkUploadCommon> lst = new List<BulkUploadCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    BulkUploadCommon common = new BulkUploadCommon
                    {
                        DataId = item["data_import_id"].ToString(),
                        ProcessId = item["process_id"].ToString(),
                        DataImportSource = item["data_import_source"].ToString(),
                        DataImportStatus = item["data_import_status"].ToString(),
                        Type = item["type"].ToString(),
                        Module = item["module"].ToString(),
                        Description = item["data_import_description"].ToString(),
                        CreateDate = item["created_local_date"].ToString(),
                        Remarks = item["admin_remarks"].ToString()
                    };
                    lst.Add(common);
                }
            }
            return lst;
        }

        public CommonDbResponse ClearUploadedData(string ActionUser, string DataImportSource = "")
        {
            string sql = "sproc_msg_bulk_topup";
            sql += " @flag='c'";
           
            sql += " ,@actionUser=" + DAO.FilterParameter(ActionUser);
            sql += " ,@dataImportSource=" + DAO.FilterParameter(DataImportSource);

            return DAO.ParseCommonDbResponse(sql);
        }

        public List<BulkTopUpCommon> BulkTopUp(string AgentId, string ActionUser, string FileName = "")
        {
            List<BulkTopUpCommon> lst = new List<BulkTopUpCommon>();
            string sql = "sproc_txn_request";
            sql += " @flag='b'";

            sql += " ,@action_user=" + DAO.FilterParameter(ActionUser);
            sql += " ,@agent_id=" + DAO.FilterParameter(AgentId);
            sql += " ,@FileName=" + DAO.FilterParameter(FileName);

            var dt = DAO.ExecuteDataTable(sql);

           
            if (dt != null && dt.Rows.Count > 0)
            {
                var Code = dt.Rows[0]["Code"].ToString();
                if(Code != "0")
                {
                    BulkTopUpCommon common = new BulkTopUpCommon
                    {

                        Code = dt.Rows[0]["Code"].ToString(),
                        Message = dt.Rows[0]["Message"].ToString()
                   

                    };
                   // var Message = dt.Rows[0]["Message"].ToString();
                    lst.Add(common);
                    return lst;
                }
                foreach (DataRow item in dt.Rows)
                {
                    
                    BulkTopUpCommon common = new BulkTopUpCommon
                    {
                        
                        SubscriberNumber = item["SubscriberNo"].ToString(),
                        Amount = item["Amount"].ToString(),
                        Product = item["productId"].ToString(),
                        Remark = item["Remarks"].ToString(),
                        Code = item["Code"].ToString(),
                        Message = item["Message"].ToString()

                    };
                    lst.Add(common);
                }
            }
            return lst;
        }

        public CommonDbResponse LogFile(string FileName, string FilePath, string ActionUser)
        {
            string sql = "sproc_file_upload_log";
            sql += " @flag='i'";

            sql += " ,@fileName=" + DAO.FilterParameter(FileName);
            sql += " ,@filePath=" + DAO.FilterParameter(FilePath);
            sql += " ,@actionUser=" + DAO.FilterParameter(ActionUser);
            sql += " ,@actionIp = N':1'";

            return DAO.ParseCommonDbResponse(sql);
        }

        public List<BulkTopUpReceiptCommon> GetBulkTopUpReceiptList(string ProcessId = "")
        {
            List<BulkTopUpReceiptCommon> lst = new List<BulkTopUpReceiptCommon>();
            string sql = "sproc_topup_report";
            sql += " @flag='b'";
            sql += " ,@processId=" + DAO.FilterParameter(ProcessId);

            var dt = DAO.ExecuteDataTable(sql);


            if (dt != null)
            {
                //var Code = dt.Rows[0]["Code"].ToString();
                //if (Code != "0")
                //{
                //    BulkTopUpCommon common = new BulkTopUpCommon
                //    {

                //        Code = dt.Rows[0]["Code"].ToString(),
                //        Message = dt.Rows[0]["Message"].ToString()


                //    };
                //    // var Message = dt.Rows[0]["Message"].ToString();
                //    lst.Add(common);
                //    return lst;
                //}
                foreach (DataRow item in dt.Rows)
                {

                    BulkTopUpReceiptCommon common = new BulkTopUpReceiptCommon
                    {

                        SubscriberNumber = item["subscriber_no"].ToString(),
                        Amount = item["amount"].ToString(),
                        Product = item["product_label"].ToString(),
                        Remark = item["agent_remarks"].ToString(),
                        BonusAmount = item["bonus_amt"].ToString(),
                        SericeCharge = item["service_charge"].ToString(),
                        AgentCommission = item["agent_commission"].ToString(),
                        Status = item["STATUS"].ToString(),
                        TransactionCreatedDate = item["TxnCreatedDate"].ToString(),
                        TransactionUpdatedDate = item["TxnUpdatedDate"].ToString()

                    };
                    lst.Add(common);
                }
            }
            return lst;
        }
    }
}
