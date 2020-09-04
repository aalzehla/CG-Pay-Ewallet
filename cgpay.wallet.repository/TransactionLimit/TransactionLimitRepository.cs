using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.TransactionLimit;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.TransactionLimit
{
    public class TransactionLimitRepository : ITransactionLimitRepository
    {
        RepositoryDao dao;
        public TransactionLimitRepository()
        {
            dao = new RepositoryDao();
        }
        public List<TransactionLimitCommon> GetTransactionLimitList()
        {
            string sql = "exec sproc_transaction_limit ";
            sql += " @flag='s'";
            var dt = dao.ExecuteDataTable(sql);
            List<TransactionLimitCommon> list = new List<TransactionLimitCommon>();

            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    var common = new TransactionLimitCommon
                    {
                        transacation_id = item["txnl_Id"].ToString(),
                       transacation_type = item["txn_type"].ToString(),
                        transaction_limit_maximum = item["transaction_limit_max"].ToString(),
                        daily_maximum_limit = item["transaction_daily_limit_max"].ToString(),
                        monthly_maximum_limit = item["transaction_monthly_limit_max"].ToString(),
                        kyc_status = item["KYC_Status"].ToString(),
                       // Action = item["action_by"].ToString()
                    };
                    list.Add(common);

                }
            }
            return list;
        }

        public TransactionLimitCommon GetTransactionLimitById(string Id)
        {

            string sql = "exec sproc_transaction_limit ";
            sql += " @flag='s'";
            sql += ",@txnl_Id = " + dao.FilterString(Id);
            var dt = dao.ExecuteDataRow(sql);
            TransactionLimitCommon tl = new TransactionLimitCommon();
            if (dt != null)
            {
                tl.transacation_id = dt["txnl_Id"].ToString();
                tl.transacation_type = dt["txn_type"].ToString();
                tl.kyc_status = dt["KYC_Status"].ToString();
                tl.transaction_limit_maximum = dt["transaction_limit_max"].ToString();
                tl.daily_maximum_limit = dt["transaction_daily_limit_max"].ToString();
                tl.monthly_maximum_limit = dt["transaction_monthly_limit_max"].ToString();
            }
            return tl;
        }

        public CommonDbResponse ManageTransactionlimit(TransactionLimitCommon TLC)
        {
            string sql = "exec sproc_transaction_limit ";
            sql += "@flag ='" + (!string.IsNullOrEmpty(TLC.transacation_id) ? "u" : "") + "' ";
            sql += ",@txnl_Id = " + dao.FilterString(TLC.transacation_id);
            sql += ",@txn_type = " + dao.FilterString(TLC.transacation_type);
            sql += ",@KYC_Status = " + dao.FilterString(TLC.kyc_status);
            sql += ", @transaction_limit_max=" + dao.FilterString(TLC.transaction_limit_maximum);
            sql += ", @daily_max_limit=" + dao.FilterString(TLC.daily_maximum_limit);
            sql += ", @monthly_max_limit=" + dao.FilterString(TLC.monthly_maximum_limit);
            return dao.ParseCommonDbResponse(sql);
        }

        public TransactionLimitCommon GetTransactionLimitForUser(string AgentId)
        {
            string sql = "exec sproc_transaction_limit @flag='r'";
            sql += ",@agent_id = " + dao.FilterString(AgentId);
            var dt = dao.ExecuteDataRow(sql);
            TransactionLimitCommon tl = new TransactionLimitCommon();
            if (dt != null)
            {
                tl.TxnLimitMax = dt["transaction_limit_max"].ToString();
                tl.TxnDailyLimitMax = dt["transaction_daily_limit_max"].ToString();
                tl.TxnDailyRemainingLimit = dt["daily_remaining_limit"].ToString();
                tl.TxnMonthlyLimitMax = dt["transaction_monthly_limit_max"].ToString();
                tl.TxnMonthlyRemainingLimit = dt["monthly_remaining_limit"].ToString();
            }
            return tl;
        }
    }
}
