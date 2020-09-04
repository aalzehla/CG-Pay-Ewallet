using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.repository.Client
{
    public class ClientManagementRepository : IClientManagementRepository
    {
        RepositoryDao DAO;
        public ClientManagementRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<WalletUserInfo> WalletUserList(string agentType = "", string agentId = "",string ParentId="")
        {
            var WalletUserInfos = new List<WalletUserInfo>();
            string sql = "sproc_wallet_user @flag='s'";
            sql += (string.IsNullOrEmpty(agentType) ? "" : ", @agent_type =" + DAO.FilterString(agentType));
            sql += (string.IsNullOrEmpty(agentId) ? "" : ", @agent_id =" + DAO.FilterString(agentId));
            sql += (string.IsNullOrEmpty(ParentId) ? "" : ", @parent_id =" + DAO.FilterString(ParentId));
            //string sql = "select * from tbl_manage_services where txn_type_id= " + DAO.FilterString(type);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    WalletUserInfo walletUser = new WalletUserInfo();
                    walletUser.MobileNo = dr["user_mobile_no"].ToString();
                    walletUser.Email = dr["user_email"].ToString();
                    walletUser.FullName = dr["full_name"].ToString();
                    walletUser.AgentId = dr["agent_id"].ToString();
                    walletUser.UserId = dr["user_id"].ToString();
                    walletUser.ParentId = dr["parent_id"].ToString();
                    walletUser.KycStatus = dr["kyc_status"].ToString();
                    walletUser.AgentStatus = dr["userStatus"].ToString();
                    walletUser.Balance = dr["balance"].ToString();
                    walletUser.CreatedLocalDate = dr["Registered_Date"].ToString();

                    WalletUserInfos.Add(walletUser);
                }
            }
            return WalletUserInfos;
        }

        public CommonDbResponse UserStatusChange(string userId, string agentId, string status = "")
        {
            string sql = "sproc_wallet_user @flag = 'b'";
            sql += ", @user_id=" + DAO.FilterString(userId);
            sql += ", @agent_id=" + DAO.FilterString(agentId);
            sql += ", @status=" + DAO.FilterString(status);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse AddUser(WalletUserInfo walletUser)
        {
            string sql = "sproc_wallet_user @flag = 'i'";
            sql += ", @usermobileNumber=" + DAO.FilterString(walletUser.MobileNo);
            sql += ", @useremail=" + DAO.FilterString(walletUser.Email);
            sql += ", @fullname=" + DAO.FilterString(walletUser.FullName);
            sql += ", @parent_id=" + DAO.FilterString(walletUser.ParentId);
            sql += ", @action_user=" + DAO.FilterString(walletUser.ActionUser);
            sql += ", @action_IP=" + DAO.FilterString(walletUser.ActionIP);
            //if (!string.IsNullOrEmpty(DAO.FilterString(walletUser.ParentId)))
            //    sql += ", @parent_id=" + DAO.FilterString(walletUser.ParentId);
            sql += ", @action_browser=" + DAO.FilterString(walletUser.ActionBrowser);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse InsertBalance(WalletUserInfo walletUser)
        {
            string sql = "sproc_balance_transfer @flag = 'awu'";
            sql += ", @agent_id=" + DAO.FilterString(walletUser.AgentId);
            sql += ", @amount=" + DAO.FilterString(walletUser.BalanceToAdd);
            sql += ", @action_user=" + DAO.FilterString(walletUser.ActionUser);
            sql += ", @remarks=" + DAO.FilterString(walletUser.Remarks);
            sql += ", @created_ip=" + DAO.FilterString(walletUser.ActionIP);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse ResetPassword(WalletUserInfo walletUser)
        {
            string sql = "sproc_wallet_user @flag = 'rpassword'";
            //sql += ", @agent_id=" + DAO.FilterString(walletUser.AgentId);
            sql += ", @user_id=" + DAO.FilterString(walletUser.UserId);
            sql += ", @action_user=" + DAO.FilterString(walletUser.ActionUser);
            //sql += ", @created_ip=" + DAO.FilterString(walletUser.ActionIP);
            return DAO.ParseCommonDbResponse(sql);
        }
    }
}
