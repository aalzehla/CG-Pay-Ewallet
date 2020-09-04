using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.repository.Client
{
    public class WalletUserRepository : IWalletUserRepository
    {
        RepositoryDao DAO;
        public WalletUserRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<ClientCommon> ServiceDetail(string userid = "")
        {
            var clientCommons = new List<ClientCommon>();
            string sql = "sproc_manage_services @flag='cv' ";
            sql += (string.IsNullOrEmpty(userid) ? "" : ", @user_id =" + DAO.FilterString(userid));
            //string sql = "select * from tbl_manage_services where txn_type_id= " + DAO.FilterString(type);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    ClientCommon clientCommon = new ClientCommon();
                    //clientCommon.TxtTypeId = dr["txn_type_id"].ToString();
                    clientCommon.TxtType = dr["txn_type"].ToString();
                    //clientCommon.CompanyId = dr["company_id"].ToString();
                    clientCommon.Company = dr["company"].ToString();
                    clientCommon.ProductId = dr["product_id"].ToString();
                    //clientCommon.ProductTypeId = dr["product_type_id"].ToString();
                    clientCommon.ProductType = dr["product_type"].ToString();
                    clientCommon.ProductLabel = dr["product_label"].ToString();
                    clientCommon.ProductLogo = dr["product_logo"].ToString();
                    clientCommon.ProductServiceInfo = dr["product_service_info"].ToString();
                    clientCommon.ProductCategory = dr["product_category"].ToString();
                    //clientCommon.SubscriberRegex = dr["subscriber_regex"].ToString();
                    clientCommon.MinAmount = dr["min_denomination_amount"].ToString();
                    clientCommon.MaxAmount = dr["max_denomination_amount"].ToString();
                    clientCommon.PrimaryGateway = dr["primary_gateway"].ToString();
                    clientCommon.SecondaryGateway = dr["secondary_gateway"].ToString();
                    clientCommon.Status = dr["product_status"].ToString();
                    if (!string.IsNullOrEmpty(userid))
                    {
                        clientCommon.CommissionValue = dr["commission_value"].ToString();
                        clientCommon.CommissionType = dr["commission_type"].ToString();
                    }

                    //clientCommon.CreatedDate = dr["created_local_date"].ToString();
                    //clientCommon.CreatedNepaliDate = dr["created_nepali_date"].ToString();
                    //clientCommon.CreatedBy = dr["created_by"].ToString();
                    //clientCommon.CreatedIp = dr["created_ip"].ToString();
                    //clientCommon.UpdatedBy = dr["updated_by"].ToString();
                    //clientCommon.UpdatedDate = dr["updated_local_date"].ToString();
                    //clientCommon.UpdatedNepaliDate = dr["updated_nepali_date"].ToString();
                    //clientCommon.UpdatedIp = dr["updated_ip"].ToString();
                    clientCommons.Add(clientCommon);
                }
            }
            return clientCommons;
        }
        public WalletUserInfo UserInfo(string UserId = "")
        {
            WalletUserInfo walletUser = new WalletUserInfo();
            string sql = "sproc_user_detail @flag = 'searchuser',@search= " + DAO.FilterString(UserId);
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {
                walletUser.UserId = dr["user_id"].ToString();
                walletUser.Email = dr["user_email"].ToString();
                walletUser.FullName = dr["full_name"].ToString();
                walletUser.MobileNo = dr["user_mobile_no"].ToString();
                walletUser.UserName = dr["user_name"].ToString();
                walletUser.AgentId = dr["agent_id"].ToString();
                walletUser.UserId = dr["user_id"].ToString();
                walletUser.Balance = dr["available_balance"].ToString();
                walletUser.CreatedLocalDate = dr["created_local_date"].ToString();
                walletUser.PPImage = dr["identification_photo_logo"].ToString();
            }
            return walletUser;
        }
        public Dictionary<string, string> GetProposeList()
        {
            string sql = "sproc_get_dropdown_list @flag = '032'";
            Dictionary<string, string> dict = DAO.ParseSqlToDictionary(sql);
            return dict;
        }
        public CommonDbResponse WalletBalanceRT(WalletBalanceCommon walletBalance)
        {
            string sql = "sproc_balance_transfer ";
            sql += "@flag =" + DAO.FilterString((walletBalance.Type == "T") ? "trf" : "trq");
            sql += ", @subscriber= " + DAO.FilterString(walletBalance.ReceiverAgentId);
            sql += ", @action_user= " + DAO.FilterString(walletBalance.ActionUser);
            sql += (walletBalance.Type == "T") ? ", @bt_purpose= " + DAO.FilterString(walletBalance.Propose) : "";
            sql += ", @amount= " + DAO.FilterString(walletBalance.Amount);
            sql += ", @description= " + DAO.FilterString(walletBalance.Remarks);
            sql += ", @created_ip= " + DAO.FilterString(walletBalance.IpAddress);

            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse AgentToWallet(WalletBalanceCommon walletBalance)
        {
            string sql = "sproc_balance_transfer @flag='aw' ";
            sql += ", @user_name= " + DAO.FilterString(walletBalance.MobileNumber);
            sql += ", @action_user= " + DAO.FilterString(walletBalance.ActionUser);
            sql += ", @amount= " + DAO.FilterString(walletBalance.Amount);
            sql += ", @remarks= " + DAO.FilterString(walletBalance.Remarks);
            sql += ", @created_ip= " + DAO.FilterString(walletBalance.IpAddress);
            sql += ", @agent_id= " + DAO.FilterString(walletBalance.AgentId);

            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse CheckMobileNumber(string agentid, string mobileno,  string usertype, string mode)
        {
            string sql = "sproc_user_detail";
            sql += " @flag='validuser' ";
            sql += ", @agent_id= " + DAO.FilterString(agentid);
            sql += ", @usr_type= " + DAO.FilterString(usertype);
            sql += ", @email= " + DAO.FilterString(mobileno);
            sql += ", @mode= " + DAO.FilterString(mode);

            return DAO.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse CheckProduct(string AgentId, string UserType, string ProductId )
        {
            string sqlCommand = "Execute sproc_txn_request @flag = 'product',";
            sqlCommand += " @agent_id = " + DAO.FilterString(AgentId);
            sqlCommand += ", @user_type = " + DAO.FilterString(UserType);
            sqlCommand += ", @product_id = " + DAO.FilterString(ProductId);
            return DAO.ParseCommonDbResponse(sqlCommand);
        }

    }
}
