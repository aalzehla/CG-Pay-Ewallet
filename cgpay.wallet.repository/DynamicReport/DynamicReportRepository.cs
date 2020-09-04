using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models.DynamicReport;

namespace cgpay.wallet.repository.DynamicReport
{
    public class DynamicReportRepository : IDynamicReportRepository
    {
        RepositoryDao DAO;
        public DynamicReportRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<DynamicReportCommon> GetTransactionReport(DynamicReportFilter model)
        {
            var DynamicReportCommons = new List<DynamicReportCommon>();
            string sql = "sproc_topup_report @flag = 's'";
            sql += (string.IsNullOrEmpty(model.AgentId) ? "" : ", @agent_id =" + DAO.FilterString(model.AgentId));
            sql += (string.IsNullOrEmpty(model.TxnId) ? "" : ", @txn_id =" + DAO.FilterString(model.TxnId));
            sql += (string.IsNullOrEmpty(model.ProductId) ? "" : ", @product_id =" + DAO.FilterString(model.ProductId));
            sql += (string.IsNullOrEmpty(model.GatewayId) ? "" : ", @gateway_id =" + DAO.FilterString(model.GatewayId));
            sql += (string.IsNullOrEmpty(model.TxnStatus) ? "" : ", @status =" + DAO.FilterString(model.TxnStatus));
            sql += (string.IsNullOrEmpty(model.FromDate) ? "" : ", @from_date =" + DAO.FilterString(model.FromDate));
            sql += (string.IsNullOrEmpty(model.ToDate) ? "" : ", @to_date =" + DAO.FilterString(model.ToDate));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    DynamicReportCommon dynamicReport = new DynamicReportCommon();
                    dynamicReport.TxnId = dr["txnid"].ToString();
                    dynamicReport.ProductName = dr["product_label"].ToString();
                    dynamicReport.GrandparentId = dr["grand_parent_id"].ToString();
                    dynamicReport.ParentId = dr["parent_id"].ToString();
                    dynamicReport.AgentId = dr["agent_id"].ToString();
                    dynamicReport.SubscriberNo = dr["subscriber_no"].ToString();
                    dynamicReport.Amount = dr["amount"].ToString();
                    dynamicReport.TxnStatus = dr["txnstatus"].ToString();
                    dynamicReport.UserId = dr["user_id"].ToString();
                    dynamicReport.TxnDate = dr["txndate"].ToString();
                    dynamicReport.Remarks = dr["agent_remarks"].ToString();

                    DynamicReportCommons.Add(dynamicReport);
                }
            }
            return DynamicReportCommons;
        }
        public DynamicReportCommon GetTransactionReportDetail(string TxnId, string AgentId = "")
        {
            DynamicReportCommon dynamicReport = new DynamicReportCommon();
            string sql = "sproc_topup_report @flag = 'rct', @txn_id =" + DAO.FilterString(TxnId);
            sql += (string.IsNullOrEmpty(AgentId) ? "" : ", @agent_id =" + DAO.FilterString(AgentId));
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {
                dynamicReport.TxnId = dr["txnid"].ToString();
                dynamicReport.ProductName = dr["product_label"].ToString();
                dynamicReport.CompanyId = dr["company_id"].ToString();
                dynamicReport.Company = dr["company"].ToString();
                dynamicReport.TxnType = dr["txn_type"].ToString();
                dynamicReport.AgentId = dr["agent_id"].ToString();
                dynamicReport.SubscriberNo = dr["subscriber_no"].ToString();
                dynamicReport.Amount = dr["amount"].ToString();
                dynamicReport.ServiceCharge = dr["service_charge"].ToString();
                dynamicReport.BonusAmount = dr["bonus_amt"].ToString();
                dynamicReport.Status = dr["status"].ToString();
                dynamicReport.StatusCode = dr["status_code"].ToString();
                dynamicReport.UserId = dr["user_id"].ToString();
                dynamicReport.CreatedLocalDate = dr["created_local_date"].ToString();
                dynamicReport.CreatedBy = dr["created_by"].ToString();
                dynamicReport.CreatedPlatform = dr["created_platform"].ToString();
                dynamicReport.AdminCommission = dr["admin_commission"].ToString();
                dynamicReport.AgentCommission = dr["agent_commission"].ToString();
                dynamicReport.ParentCommission = dr["parent_commission"].ToString();
                dynamicReport.GrandParentCommission = dr["grand_parent_commission"].ToString();
                dynamicReport.TxnRewardPoint = dr["txn_reward_point"].ToString();
                dynamicReport.CustomerId = dr["customer_id"].ToString();
                dynamicReport.CustomerName = dr["customer_name"].ToString();
                dynamicReport.PlanId = dr["plan_id"].ToString();
                dynamicReport.PlanName = dr["plan_name"].ToString();
                dynamicReport.ExtraField1 = dr["extra_field1"].ToString();
                dynamicReport.ExtraField2 = dr["extra_field2"].ToString();
                dynamicReport.ExtraField3 = dr["extra_field3"].ToString();
                dynamicReport.ExtraField4 = dr["extra_field4"].ToString();
                dynamicReport.AdminRemarks = dr["admin_remarks"].ToString();
                dynamicReport.GatewayName = dr["gatewayname"].ToString();
            }
            return dynamicReport;
        }

        public List<DynamicReportCommon> GetPendingReport(DynamicReportFilter model)
        {
            var DynamicReportCommons = new List<DynamicReportCommon>();
            string sql = "sproc_topup_report @flag = 'p'";
            sql += ", @from_date =" + DAO.FilterString(model.FromDate);
            sql += ", @to_Date =" + DAO.FilterString(model.ToDate);
            //sql += (string.IsNullOrEmpty(AgentId) ? "" : ", @agent_id =" + DAO.FilterString(AgentId));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    DynamicReportCommon dynamicReport = new DynamicReportCommon();
                    dynamicReport.TxnId = dr["txnid"].ToString();
                    dynamicReport.ProductName = dr["product_label"].ToString();
                    dynamicReport.GrandparentId = dr["grand_parent_id"].ToString();
                    dynamicReport.ParentId = dr["parent_id"].ToString();
                    dynamicReport.AgentId = dr["agent_id"].ToString();
                    dynamicReport.SubscriberNo = dr["subscriber_no"].ToString();
                    dynamicReport.Amount = dr["amount"].ToString();
                    dynamicReport.TxnStatus = dr["txnstatus"].ToString();
                    dynamicReport.UserId = dr["user_id"].ToString();
                    dynamicReport.TxnDate = dr["txndate"].ToString();
                    dynamicReport.Remarks = dr["agent_remarks"].ToString();

                    DynamicReportCommons.Add(dynamicReport);
                }
            }
            return DynamicReportCommons;
        }

        public List<DynamicReportCommon> GetSettlementReport(DynamicReportFilter model)
        {
            var DynamicReportCommons = new List<DynamicReportCommon>();
            string sql = "sproc_admin_settlement_report  @flag = 'a'";
            sql += ", @user_id =" + DAO.FilterString(model.UserId);
            sql += (string.IsNullOrEmpty(model.FromDate) ? "" : ", @from_Date =" + DAO.FilterString(model.FromDate));
            sql += (string.IsNullOrEmpty(model.ToDate) ? "" : ", @to_Date =" + DAO.FilterString(model.ToDate));
            //sql += (string.IsNullOrEmpty(DRW.ProductName) ? "" : ", @service =" + DAO.FilterString(DRW.ProductName));
            //sql += (string.IsNullOrEmpty(DRW.TxnStatus) ? "" : ", @txnStatus =" + DAO.FilterString(DRW.TxnStatus));
            //sql += (string.IsNullOrEmpty(DRW.TxnType) ? "" : ", @txnType =" + DAO.FilterString(DRW.TxnType));
            //sql += (string.IsNullOrEmpty(DRW.CustomerName) ? "" : ", @username =" + DAO.FilterString(DRW.CustomerName));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    DynamicReportCommon dynamicReport = new DynamicReportCommon();
                    //dynamicReport.TxnId = dr["txn_id"].ToString();// dr["Txn_Dates"].ToString();
                    dynamicReport.TxnDate = dr["Txn_Date"].ToString();
                    dynamicReport.TxnType = dr["Txn_Type"].ToString();
                    //dynamicReport.TxnMode = dr["txn_mode"].ToString();
                    //dynamicReport.CreatedLocalDate = dr["CreatedDate"].ToString();
                    dynamicReport.Remarks = dr["Remarks"].ToString();
                    //dynamicReport.TxnTitle = dr["txn_title"].ToString();
                    dynamicReport.Debit = dr["DR"].ToString();
                    dynamicReport.Credit = dr["Cr"].ToString();
                    dynamicReport.Amount = dr["Balance"].ToString();
                    //dynamicReport.Amount = dr["Settlement_Amount"].ToString();
                    dynamicReport.Currency = dr["CCY"].ToString();

                    DynamicReportCommons.Add(dynamicReport);
                }
            }
            return DynamicReportCommons;
        }

        public List<DynamicReportCommon> GetSettlementReportclient(DynamicReportFilter DRF)
        {
            var DynamicReportCommons = new List<DynamicReportCommon>();
            string sql = "sproc_settlement_report_2 @flag = 'a'";
            sql += ", @user_id =" + DAO.FilterString(DRF.UserId);
            sql += (string.IsNullOrEmpty(DRF.FromDate) ? "" : ", @from_Date =" + DAO.FilterString(DRF.FromDate));
            sql += (string.IsNullOrEmpty(DRF.ToDate) ? "" : ", @to_Date =" + DAO.FilterString(DRF.ToDate));
            sql += (string.IsNullOrEmpty(DRF.Service) ? "" : ", @service =" + DAO.FilterString(DRF.Service));
            sql += (string.IsNullOrEmpty(DRF.TxnStatus) ? "" : ", @txnStatus =" + DAO.FilterString(DRF.TxnStatus));
            sql += (string.IsNullOrEmpty(DRF.TxnType) ? "" : ", @txnType =" + DAO.FilterString(DRF.TxnType));
            sql += (string.IsNullOrEmpty(DRF.UserName) ? "" : ", @username =" + DAO.FilterString(DRF.UserName));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    DynamicReportCommon dynamicReport = new DynamicReportCommon();
                    dynamicReport.TxnId = dr["txn_id"].ToString();// dr["Txn_Dates"].ToString();
                    dynamicReport.TxnDate = dr["Txn_Dates"].ToString();
                    dynamicReport.TxnType = dr["Txn_Type"].ToString();
                    dynamicReport.TxnMode = dr["txn_mode"].ToString();
                    //dynamicReport.CreatedLocalDate = dr["CreatedDate"].ToString();
                    dynamicReport.Remarks = dr["Remarks"].ToString();
                    dynamicReport.TxnTitle = dr["txn_title"].ToString();
                    dynamicReport.Debit = dr["DR"].ToString();
                    dynamicReport.Credit = dr["Cr"].ToString();
                    dynamicReport.Amount = dr["Settlement_Amount"].ToString();
                    dynamicReport.Currency = dr["CCY"].ToString();

                    DynamicReportCommons.Add(dynamicReport);
                }
            }
            return DynamicReportCommons;
        }
        public List<DynamicReportCommon> GetManualCommissionReport(DynamicReportFilter model)
        {
            var DynamicReportCommons = new List<DynamicReportCommon>();
            string sql = "sproc_commission_report @flag = 'a'";
            sql += ", @user_id =" + DAO.FilterString(model.UserId);
            sql += ", @from_date =" + DAO.FilterString(model.FromDate);
            sql += ", @to_Date =" + DAO.FilterString(model.ToDate);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    DynamicReportCommon dynamicReport = new DynamicReportCommon();
                    dynamicReport.TxnDate = dr["Txn_Date"].ToString();
                    dynamicReport.TxnType = dr["Txn_Type"].ToString();
                    dynamicReport.Remarks = dr["Remarks"].ToString();
                    dynamicReport.ProductName = dr["product_label"].ToString();
                    dynamicReport.Amount = dr["amount"].ToString();
                    dynamicReport.CommissionEarned = dr["Commissionearned"].ToString();
                    dynamicReport.SubscriberNo = dr["user_mobile_no"].ToString();

                    DynamicReportCommons.Add(dynamicReport);
                }
            }
            return DynamicReportCommons;

        }

        public DynamicReportCommon GetActivityDetail(string txnid, string flag)
        {
            var report = new DynamicReportCommon();
            string sql = "sproc_settlement_report_2  @flag =" + DAO.FilterString(flag);
            sql += ", @txn_id =" + DAO.FilterString(txnid);
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {

                if (flag.ToUpper() == "T")
                {
                    report.TxnType = dr["txntype"].ToString();
                    report.CustomerName = dr["agent_name"].ToString();
                    report.Amount = dr["Amount"].ToString();
                    report.Currency = dr["currency_code"].ToString();
                    report.Remarks = dr["agent_remarks"].ToString();
                    report.BankName = dr["bank_name"].ToString();
                    report.CreatedLocalDate = dr["created_local_date"].ToString();
                    // report.CreatedBy = dr["created_by"].ToString();
                    report.CreatedPlatform = dr["created_platform"].ToString();
                }
                else if (flag.ToUpper() == "M")
                {
                    report.TxnId = dr["txnid"].ToString();
                    report.ProductName = dr["product_label"].ToString();
                    report.CompanyId = dr["company_id"].ToString();
                    report.Company = dr["company"].ToString();
                    report.TxnType = dr["txn_type"].ToString();
                    report.AgentId = dr["agent_id"].ToString();
                    report.SubscriberNo = dr["subscriber_no"].ToString();
                    report.Amount = dr["amount"].ToString();
                    report.ServiceCharge = dr["service_charge"].ToString();
                    report.BonusAmount = dr["bonus_amt"].ToString();
                    report.Status = dr["status"].ToString();
                    report.StatusCode = dr["status_code"].ToString();
                    report.UserId = dr["user_id"].ToString();
                    report.CreatedLocalDate = dr["created_local_date"].ToString();
                    report.CreatedBy = dr["created_by"].ToString();
                    report.CreatedPlatform = dr["created_platform"].ToString();
                    report.AdminCommission = dr["admin_commission"].ToString();
                    report.AgentCommission = dr["agent_commission"].ToString();
                    report.ParentCommission = dr["parent_commission"].ToString();
                    report.GrandParentCommission = dr["grand_parent_commission"].ToString();
                    report.TxnRewardPoint = dr["txn_reward_point"].ToString();
                    report.CustomerId = dr["customer_id"].ToString();
                    report.CustomerName = dr["customer_name"].ToString();
                    report.PlanId = dr["plan_id"].ToString();
                    report.PlanName = dr["plan_name"].ToString();
                    report.ExtraField1 = dr["extra_field1"].ToString();
                    report.ExtraField2 = dr["extra_field2"].ToString();
                    report.ExtraField3 = dr["extra_field3"].ToString();
                    report.ExtraField4 = dr["extra_field4"].ToString();
                    report.AdminRemarks = dr["admin_remarks"].ToString();
                    report.GatewayName = dr["gatewayname"].ToString();
                }
                else if (flag.ToUpper() == "F")
                {
                    report.TxnType = dr["txntype"].ToString();
                    report.CustomerName = dr["agent_name"].ToString();
                    report.Amount = dr["Amount"].ToString();
                    report.Currency = dr["currency_code"].ToString();
                    report.Remarks = dr["agent_remarks"].ToString();
                    report.BankName = dr["bank_name"].ToString();
                    report.ServiceCharge = dr["service_charge"].ToString();
                    report.CreatedLocalDate = dr["created_local_date"].ToString();
                    // report.CreatedBy = dr["created_by"].ToString();
                    report.CreatedPlatform = dr["created_platform"].ToString();
                }
                else if (flag.ToUpper() == "MP")
                {
                    report.TxnType = dr["txntype"].ToString();
                    report.CustomerName = dr["agent_name"].ToString();
                    report.Amount = dr["Amount"].ToString();
                    report.Currency = dr["currency_code"].ToString();
                    report.Remarks = dr["agent_remarks"].ToString();
                    report.BankName = dr["bank_name"].ToString();
                    report.CreatedLocalDate = dr["created_local_date"].ToString();
                    // report.CreatedBy = dr["created_by"].ToString();
                    report.CreatedPlatform = dr["created_platform"].ToString();
                }
            }
            return report;
        }

        public List<PaymentGatewayTransactionReport> PaymentGatewayTransactionList(DynamicReportFilter filter)
        {
            var model = new List<PaymentGatewayTransactionReport>();
            string sql = "sproc_pmt_gatewayTxn_report @flag = 's'";
            sql += ", @fromdate =" + DAO.FilterString(filter.FromDate);
            sql += ", @todate =" + DAO.FilterString(filter.ToDate);
            sql += ", @userMobileNo =" + DAO.FilterString(filter.MobileNumber);
            sql += ", @pmtGatewayId =" + DAO.FilterString(filter.GatewayId);
            sql += ", @pmtGatewayTxnId =" + DAO.FilterString(filter.PgTxnId);
            sql += ", @pmtTxnId =" + DAO.FilterString(filter.TxnId);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    PaymentGatewayTransactionReport dynamicReport = new PaymentGatewayTransactionReport();
                    dynamicReport.TxnId = dr["TxnId"].ToString();
                    dynamicReport.Amount = dr["Amount"].ToString();
                    dynamicReport.ServiceCharge = dr["ServiceCharge"].ToString();
                    dynamicReport.TotalAmount = dr["TotalAmount"].ToString();
                    dynamicReport.Status = dr["status"].ToString();
                    dynamicReport.GatewayName = dr["GatewayName"].ToString();
                    dynamicReport.GatewayTxnId = dr["GatewayTxnId"].ToString();
                    dynamicReport.AgentId = dr["AgentId"].ToString();
                    dynamicReport.UserId = dr["UserId"].ToString();
                    dynamicReport.TxnType = dr["TxnType"].ToString();
                    dynamicReport.AgentName = dr["AgentName"].ToString();
                    dynamicReport.CreatedDate = dr["createdDate"].ToString();
                    model.Add(dynamicReport);
                }
            }
            return model;

        }

        public PaymentGatewayTransactionReport PaymentGatewayTransactionDetail(string TxnId)
        {
            var dynamicReport = new PaymentGatewayTransactionReport();
            string sql = "sproc_pmt_gatewayTxn_report  @flag = 's'";
            sql += ", @pmtGatewayTxnId =" + DAO.FilterString(TxnId);
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {
                dynamicReport.TxnId = dr["TxnId"].ToString();
                dynamicReport.Amount = dr["Amount"].ToString();
                dynamicReport.ServiceCharge = dr["ServiceCharge"].ToString();
                dynamicReport.TotalAmount = dr["TotalAmount"].ToString();
                dynamicReport.Status = dr["status"].ToString();
                dynamicReport.GatewayName = dr["GatewayName"].ToString();
                dynamicReport.GatewayTxnId = dr["GatewayTxnId"].ToString();
                dynamicReport.AgentId = dr["AgentId"].ToString();
                dynamicReport.UserId = dr["UserId"].ToString();
                dynamicReport.TxnType = dr["TxnType"].ToString();
                dynamicReport.AgentName = dr["AgentName"].ToString();
                dynamicReport.CreatedDate = dr["createdDate"].ToString();
            }
            return dynamicReport;
        }

        public List<MerchantTransactionCommon> MerchantTransactionReport(DynamicReportFilter model)
        {
            var MerchantTransactionCommons = new List<MerchantTransactionCommon>();
            string sql = "sproc_topup_report @flag = 'mt'";
            sql += (string.IsNullOrEmpty(model.MerchantId) ? "" : ", @agent_id =" + DAO.FilterString(model.MerchantId));
            sql += (string.IsNullOrEmpty(model.FromDate) ? "" : ", @from_date =" + DAO.FilterString(model.FromDate));
            sql += (string.IsNullOrEmpty(model.ToDate) ? "" : ", @to_date =" + DAO.FilterString(model.ToDate));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    MerchantTransactionCommon merchantTransaction = new MerchantTransactionCommon();
                    merchantTransaction.TxnId = dr["txnid"].ToString();
                    merchantTransaction.MerchantId = dr["MerchantID"].ToString();
                    merchantTransaction.MerchantName = dr["MerchantName"].ToString();
                    merchantTransaction.MerchantCode = dr["MerchantCode"].ToString();
                    merchantTransaction.Amount = dr["Amount"].ToString();
                    merchantTransaction.CommissionAmt = dr["CommissionAmt"].ToString();
                    merchantTransaction.UserId = dr["UserId"].ToString();
                    merchantTransaction.CreatedDate = dr["createdDate"].ToString();

                    MerchantTransactionCommons.Add(merchantTransaction);
                }
            }
            return MerchantTransactionCommons;
        }

        public Dictionary<string, string> MerchantDropdown()
        {
            string sql = "sproc_merchant_detail";
            sql += " @flag='mlist'";
            Dictionary<string, string> dict = new Dictionary<string, string>();
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    dict = dbres.AsEnumerable().ToDictionary<DataRow, string, string>(row => row["value"].ToString(), row => row["text"].ToString());
                }
            }

            else
                dict = null;
            return dict;
        }
    }
}
