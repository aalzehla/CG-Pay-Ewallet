using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.repository.Card
{
    public class CardRepository:ICardRepository
    {
        RepositoryDao DAO;
        public CardRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<CardCommon> GetCardList(string UserId)
        {
            var card = new List<CardCommon>();
            string sql = "sproc_agent_cardMgmt @flag ='s',@user_id= " + DAO.FilterString(UserId);
            var dUser = DAO.ExecuteDataTable(sql);
            if (dUser != null)
            {
                foreach (DataRow dr in dUser.Rows)
                {
                    CardCommon cardCommon = new CardCommon();
                    cardCommon.AgentId = dr["agent_id"].ToString();
                    cardCommon.AgentName = dr["agent_name"].ToString();
                    cardCommon.UserId = dr["user_id"].ToString();
                    cardCommon.Email = dr["user_email"].ToString();
                    cardCommon.MobileNo = dr["user_mobile_no"].ToString();
                    cardCommon.CardId = dr["card_id"].ToString();
                    cardCommon.CardNo = dr["card_no"].ToString();
                    cardCommon.CardType = dr["card_type"].ToString();
                    cardCommon.IssueDate = dr["card_issued_date"].ToString();
                    cardCommon.ExpiryDate = dr["card_expiry_date"].ToString();
                    cardCommon.Status = dr["is_active"].ToString();
                    cardCommon.FullName = dr["full_name"].ToString();
                    cardCommon.Amount = dr["available_balance"].ToString();
                    cardCommon.IsReceived = dr["is_transfer"].ToString();
                    cardCommon.ReceivedFrom = dr["transfer_to"].ToString();

                    card.Add(cardCommon);
                }
            }
            return card;
        }
        public Dictionary<string, string> GetCardType()
        {
            string sql = "sproc_get_dropdown_list @flag='033'";
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
        public CommonDbResponse InsertCard(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt @flag = 'i'";
            sql += ", @agent_id=" + DAO.FilterString(cardCommon.AgentId);
            sql += ", @user_id=" + DAO.FilterString(cardCommon.UserId);
            sql += ", @user_name=" + DAO.FilterString(cardCommon.UserName);
            sql += ", @card_type=" + DAO.FilterString(cardCommon.CardType);
            sql += ", @action_user=" + DAO.FilterString(cardCommon.ActionUser);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse UpdateCard(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt @flag = 'u'";
            sql += ", @card_no=" + DAO.FilterString(cardCommon.CardNo);
            sql += ", @user_id=" + DAO.FilterString(cardCommon.UserId);
            sql += ", @card_type=" + DAO.FilterString(cardCommon.CardType);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse EnableDisableCard(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt @flag = 'e'";
            sql += ", @user_id=" + DAO.FilterString(cardCommon.UserId);
            sql += ", @card_no=" + DAO.FilterString(cardCommon.CardNo);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse RequestCard(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt @flag = 'r'";
            sql += ", @user_id=" + DAO.FilterString(cardCommon.UserId);
            sql += ", @user_name=" + DAO.FilterString(cardCommon.UserName);
            sql += ", @user_mobile_no=" + DAO.FilterString(cardCommon.MobileNo);
            sql += ", @user_email=" + DAO.FilterString(cardCommon.Email);
            sql += ", @action_user=" + DAO.FilterString(cardCommon.ActionUser);
            sql += ", @Created_ip=" + DAO.FilterString(cardCommon.CreatedIp);
            sql += ", @card_type=" + DAO.FilterString(cardCommon.CardType);
            sql += ", @requested_amount=" + DAO.FilterString(cardCommon.Amount);
            return DAO.ParseCommonDbResponse(sql);
        }
        public List<CardCommon> GetApprovalList()
        {
            var card = new List<CardCommon>();
            string sql = "sproc_agent_cardMgmt @flag ='l'";
            var dUser = DAO.ExecuteDataTable(sql);
            if (dUser != null)
            {
                foreach (DataRow dr in dUser.Rows)
                {
                    CardCommon cardCommon = new CardCommon();
                    cardCommon.RequestId = dr["req_id"].ToString();
                    cardCommon.UserName = dr["user_name"].ToString();
                    cardCommon.MobileNo = dr["user_mobile_no"].ToString();
                    cardCommon.Email = dr["user_email"].ToString();
                    cardCommon.CardType = dr["card_type"].ToString();
                    cardCommon.RequestStatus = dr["request_status"].ToString();
                    cardCommon.CreatedLocalDate = dr["created_local_date"].ToString();
                    cardCommon.Amount = dr["requested_amount"].ToString();
                    //cardCommon.CreatedBy = dr["created_by"].ToString();
                    //cardCommon.CreatedBy = dr["created_ip"].ToString();
                    //cardCommon.UpdatedLocalDate = dr["updated_local_date"].ToString();
                    //cardCommon.UpdatedUTCDate = dr["updated_UTC_Date"].ToString();
                    //cardCommon.UpdatedBy = dr["updated_by"].ToString();
                    //cardCommon.UpdatedIp = dr["updated_ip"].ToString();

                    card.Add(cardCommon);
                }
            }
            return card;
        }
        public CommonDbResponse CardApproval(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt @flag = 'a'";
            sql += ", @user_id=" + DAO.FilterString(cardCommon.UserId);
            sql += ", @user_name=" + DAO.FilterString(cardCommon.UserName);
            sql += ", @agent_id=" + DAO.FilterString(cardCommon.AgentId);
            sql += ", @card_type=" + DAO.FilterString(cardCommon.CardType);
            //sql += ", @is_active=" + DAO.FilterString(cardCommon.Status);
            sql += ", @action_user=" + DAO.FilterString(cardCommon.ActionUser);
            sql += ", @Created_ip=" + DAO.FilterString(cardCommon.CreatedIp);
            sql += ", @req_id=" + DAO.FilterString(cardCommon.RequestId);
            sql += ", @req_status=" + DAO.FilterString(cardCommon.RequestStatus);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse CardBalance(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt";
            sql += " @flag =" + DAO.FilterString(cardCommon.Type);
            sql += ", @card_id=" + DAO.FilterString(cardCommon.CardNo);
            sql += ", @requested_amount=" + DAO.FilterString(cardCommon.Amount);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse CardUser(CardCommon cardCommon)
        {
            string sql = "sproc_agent_cardMgmt";
            sql += " @flag =" + DAO.FilterString(cardCommon.Type);
            sql += ", @card_id=" + DAO.FilterString(cardCommon.CardNo);
            sql += ", @transfer_to_mobile=" + DAO.FilterString(cardCommon.MobileNo);
            //sql += string.IsNullOrEmpty(cardCommon.MobileNo) ? "" : ", @transfer_to_mobile=" + DAO.FilterString(cardCommon.MobileNo);
            sql += ", @action_user=" + DAO.FilterString(cardCommon.ActionUser);
            return DAO.ParseCommonDbResponse(sql);
        }


    }
}
