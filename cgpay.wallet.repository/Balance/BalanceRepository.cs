using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Balance;

namespace cgpay.wallet.repository.Balance
{
    public class BalanceRepository:IBalanceRepository
    {
        RepositoryDao DAO;
        public BalanceRepository()
        {
            DAO = new RepositoryDao();
        }

        public Dictionary<string, string> GetDistributorName()
        {
            string sql = "sproc_get_dropdown_list @flag = 'distributor'";
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
        public Dictionary<string, string> GetBankList()
        {
            string sql = "sproc_get_dropdown_list @flag = '017'";
            Dictionary<string, string> dict = DAO.ParseSqlToDictionary(sql);
            return dict;
        }

        public CommonDbResponse DistributorTR(BalanceCommon balanceCommon)
        {
            string sql = "sproc_balance_transfer ";
            sql += "@flag =" + DAO.FilterString((balanceCommon.Type=="T") ? "t" : "rt");
            sql += ", @agent_id=" + DAO.FilterString(balanceCommon.AgentId);
            //sql += ", @agent_name=" + DAO.FilterString(balanceCommon.Name);
            sql += ", @bank_id=" + DAO.FilterString(balanceCommon.BankId);
            sql += ", @bank_name=" + DAO.FilterString(balanceCommon.BankName);
            sql += ", @amount=" + DAO.FilterString(balanceCommon.Amount);
            sql += ", @type=" + DAO.FilterString(balanceCommon.Type);
            sql += ", @remarks=" + DAO.FilterString(balanceCommon.Remarks);
            sql += ", @action_user=" + DAO.FilterString(balanceCommon.CreatedBy);
            sql += ", @created_ip=" + DAO.FilterString(balanceCommon.CreatedIp);

            return DAO.ParseCommonDbResponse(sql);
        }

        public List<BalanceCommon> GetDistributorReport(string AgentId = "", string BalanceId="")
        {
            var balanceCommons = new List<BalanceCommon>();
            string sql = "sproc_balance_transfer @flag = 'r'";
            sql += (string.IsNullOrEmpty(AgentId) ? "" : ", @agent_id =" + DAO.FilterString(AgentId));
            sql += (string.IsNullOrEmpty(BalanceId) ? "" : ", @balance_id =" + DAO.FilterString(BalanceId));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    BalanceCommon balanceCommon = new BalanceCommon();
                    balanceCommon.BalanceId = dr["balance_id"].ToString();
                    balanceCommon.AgentId = dr["agent_id"].ToString();
                    balanceCommon.Name = dr["agent_name"].ToString();
                    balanceCommon.Amount = dr["amount"].ToString();
                    balanceCommon.OldBalance = dr["Agent_old_balance"].ToString();
                    balanceCommon.NewBalance = dr["New_Balance"].ToString();
                    balanceCommon.BankBranch = dr["funding_bank_branch"].ToString();
                    balanceCommon.BankAcccountNo = dr["funding_account_number"].ToString();
                    balanceCommon.BankName = dr["bank_name"].ToString();
                    balanceCommon.Type = dr["txn_type"].ToString();
                    balanceCommon.TxnMode = dr["txn_mode"].ToString();
                    balanceCommon.Remarks = dr["agent_remarks"].ToString();
                    balanceCommon.CreatedBy = dr["created_by"].ToString();
                    balanceCommon.CreatedDate = dr["Created_date"].ToString();
                    balanceCommon.CreatedNepaliDate = dr["created_nepali_Date"].ToString(); //DateTime.Parse(dr["createddatelocal"].ToString()).ToLongDateString();

                    balanceCommons.Add(balanceCommon);
                }
            }
            return balanceCommons;
        }


        public List<BalanceCommon> GetAgentName(string AgentId="")
        {
            string sql = "sproc_get_dropdown_list @flag = 'getAgent'";
            sql += (string.IsNullOrEmpty(AgentId) ? "" : ", @search_field1 =" + DAO.FilterString(AgentId));
            var dbres = DAO.ExecuteDataTable(sql);
            var balanceCommons = new List<BalanceCommon>();
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    BalanceCommon balanceCommon = new BalanceCommon();
                    balanceCommon.AgentId = dr["value"].ToString();
                    balanceCommon.Name = dr["text"].ToString();
                    balanceCommon.ParentId = dr["Agent_Parent_Id"].ToString();
                    balanceCommon.ParentName = dr["AgentParentName"].ToString();

                    balanceCommons.Add(balanceCommon);
                }
            }
            return balanceCommons;
        }

        public CommonDbResponse AgentTR(BalanceCommon balanceCommon)
        {
            string sql = "sproc_balance_transfer ";
            sql += "@flag =" + DAO.FilterString((balanceCommon.Type == "T") ? "at" : "ar");
            sql += ", @agent_id=" + DAO.FilterString(balanceCommon.AgentId);
            //sql += ", @agent_name=" + DAO.FilterString(balanceCommon.Name);
            sql += ", @bank_id=" + DAO.FilterString(balanceCommon.BankId);
            sql += ", @bank_name=" + DAO.FilterString(balanceCommon.BankName);
            sql += ", @amount=" + DAO.FilterString(balanceCommon.Amount);
            sql += ", @type=" + DAO.FilterString(balanceCommon.Type);
            sql += ", @remarks=" + DAO.FilterString(balanceCommon.Remarks);
            sql += ", @action_user=" + DAO.FilterString(balanceCommon.CreatedBy);
            sql += ", @created_ip=" + DAO.FilterString(balanceCommon.CreatedIp);
            //sql += ", @agent_parent_Id=" + DAO.FilterString(balanceCommon.ParentId);

            return DAO.ParseCommonDbResponse(sql);
        }

        public List<BalanceCommon> GetAgentReport(string AgentId = "", string BalanceId = "")
        {
            var balanceCommons = new List<BalanceCommon>();
            string sql = "sproc_balance_transfer @flag = 're'";
            sql += (string.IsNullOrEmpty(AgentId) ? "" : ", @agent_id =" + DAO.FilterString(AgentId));
            sql += (string.IsNullOrEmpty(BalanceId) ? "" : ", @balance_id =" + DAO.FilterString(BalanceId));
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    BalanceCommon balanceCommon = new BalanceCommon();
                    balanceCommon.BalanceId = dr["balance_id"].ToString();
                    balanceCommon.AgentId = dr["agent_id"].ToString();
                    balanceCommon.Name = dr["agent_name"].ToString();
                    balanceCommon.Amount = dr["amount"].ToString();
                    balanceCommon.OldBalance = dr["Agent_old_balance"].ToString();
                    balanceCommon.NewBalance = dr["New_Balance"].ToString();
                    balanceCommon.BankBranch = dr["funding_bank_branch"].ToString();
                    balanceCommon.BankAcccountNo = dr["funding_account_number"].ToString();
                    balanceCommon.BankName = dr["bank_name"].ToString();
                    balanceCommon.Type = dr["txn_type"].ToString();
                    balanceCommon.TxnMode = dr["txn_mode"].ToString();
                    balanceCommon.Remarks = dr["agent_remarks"].ToString();
                    balanceCommon.CreatedBy = dr["created_by"].ToString();
                    balanceCommon.CreatedDate = dr["Created_date"].ToString();
                    balanceCommon.CreatedNepaliDate = dr["created_nepali_Date"].ToString();

                    balanceCommons.Add(balanceCommon);
                }
            }
            return balanceCommons;
        }

        public List<BalanceCommon> GetSubAgentName(string AgentId)
        {
            string sql = "sproc_get_dropdown_list @flag = 'getsubagent'";
            sql += (string.IsNullOrEmpty(AgentId) ? "" : ", @search_field1 =" + DAO.FilterString(AgentId));
            var dbres = DAO.ExecuteDataTable(sql);
            var balanceCommons = new List<BalanceCommon>();
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    BalanceCommon balanceCommon = new BalanceCommon();
                    balanceCommon.AgentId = dr["value"].ToString();
                    balanceCommon.Name = dr["text"].ToString();
                    balanceCommon.ParentId = dr["Agent_Parent_Id"].ToString();
                    balanceCommon.ParentName = dr["AgentParentName"].ToString();

                    balanceCommons.Add(balanceCommon);
                }
            }
            return balanceCommons;
        }
    }
}
