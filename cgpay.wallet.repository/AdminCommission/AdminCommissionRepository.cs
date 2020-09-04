using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models.DynamicReport;

namespace cgpay.wallet.repository.AdminCommission
{
    public class AdminCommissionRepository : IAdminCommissionRepository
    {
        RepositoryDao dao;
        public AdminCommissionRepository()
        {
            dao = new RepositoryDao();
        }
        public List<AdminCommissionReportCommon> GetAdminCommissionDetail(string TransactionId)
        {
            string sql = "exec sproc_admin_Commission ";
            sql += " @flag='dd'";
            sql += ", @txn_id=" + dao.FilterString(TransactionId);
            var dt = dao.ExecuteDataTable(sql);
            List<AdminCommissionReportCommon> list = new List<AdminCommissionReportCommon>();

            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    var common = new AdminCommissionReportCommon
                    {
                        TransactionId = item["TxnId"].ToString(),
                        Service = item["Services"].ToString(),
                        SubscriberNo = item["SubscriberNo"].ToString(),
                        TotalAmount = item["amount"].ToString(),
                        CreatedDate = item["CreatedDate"].ToString(),
                        GatewayTxnId = item["GatewayTxnId"].ToString(),
                        CreatedBy = item["created_by"].ToString(),
                        AdminCommission = item["adminCommission"].ToString(),
                        AdminCostAmount = item["AdminCostAmount"].ToString(),
                        AdminRemark = item["admin_remarks"].ToString(),
                        AgentRemark = item["agent_remarks"].ToString(),
                        GatewayName = item["gateway_name"].ToString(),
                        TransactionType = item["txn_type"].ToString(),
                        AgentName = item["agent_name"].ToString(),
                        Status = item["status"].ToString(),
                        ServiceCharge = item["ServiceCharge"].ToString(),
                        BonusAmount = item["BonusAmount"].ToString(),
                        Company = item["company"].ToString()
                    };
                    list.Add(common);

                }
            }
            return list;
        }

        public List<AdminCommissionReportCommon> GetAdminCommissionDetailList(string ProductId, string CurrentDate)
        {
            string sql = "exec sproc_admin_Commission ";
            sql += " @flag='dt'";
            sql += ", @product_id=" + dao.FilterString(ProductId);
            sql += ", @currentDate=" + dao.FilterString(CurrentDate);
            var dt = dao.ExecuteDataTable(sql);
            List<AdminCommissionReportCommon> list = new List<AdminCommissionReportCommon>();

            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    var common = new AdminCommissionReportCommon
                    {
                        TransactionId = item["TxnId"].ToString(),
                        Service = item["Services"].ToString(),
                        SubscriberNo = item["SubscriberNo"].ToString(),
                        TotalAmount = item["amount"].ToString(),
                        TransactionDate = item["CreatedDate"].ToString(),
                        TransactionType = item["txn_type"].ToString(),
                        GatewayTxnId = item["GatewayTxnId"].ToString(),
                        CreatedBy = item["created_by"].ToString(),
                        AdminCommission = item["admin_commission"].ToString()
                    };
                    list.Add(common);

                }
            }
            return list;
        }

        public List<AdminCommissionReportCommon> GetAdminCommissionReport(string FromDate="", string ToDate="")
        {
            string sql = "exec sproc_admin_Commission ";
            sql += " @flag='s'";
            sql += ", @from_Date=" + dao.FilterString(FromDate);
            sql += ", @to_Date=" + dao.FilterString(ToDate);
            var dt = dao.ExecuteDataTable(sql);
            List<AdminCommissionReportCommon> list = new List<AdminCommissionReportCommon>();

            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    var common = new AdminCommissionReportCommon
                    {
                        TransactionDate = item["Transaction_date"].ToString(),
                        Service = item["Service"].ToString(),
                        ProductId = item["product_id"].ToString(),
                        TransactionType = item["TransactionType"].ToString(),
                        TotalTransaction = item["TotalTransaction"].ToString(),
                        TotalAmount = item["TotalAmount"].ToString(),
                        CommissionEarned = item["CommissionEarned"].ToString()
                    };
                    list.Add(common);

                 }
            }
            return list;
        }
    }
}
