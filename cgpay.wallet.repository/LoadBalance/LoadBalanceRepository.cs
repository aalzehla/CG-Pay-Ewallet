using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.LoadBalance;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.LoadBalance
{
    public class LoadBalanceRepository : ILoadBalanceRepositroy
    {
        RepositoryDao DAO;

        public LoadBalanceRepository()
        {
            DAO = new RepositoryDao();
        }

        public CommonDbResponse CheckTrnasactionExistence(string MerchantTxnId, string GatewayTxnId)
        {
            CommonDbResponse dbRes = new CommonDbResponse();
            string sqlCommand = "Execute sproc_payment_gateway_transaction @flag = 'c'";
            sqlCommand += ",@merchat_txn_id = " +DAO.FilterString( MerchantTxnId);
            sqlCommand += ",@pmt_gateway_txn_id = " +DAO.FilterString( GatewayTxnId);
            var dbResponse = DAO.ExecuteDataRow(sqlCommand);
            if (dbResponse != null)
            {
                string code = dbResponse["code"].ToString();
                string message = dbResponse["message"].ToString();
                string id = dbResponse["id"].ToString();
                if ((code ?? "1")== "0")
                {
                    dbRes.Code = ResponseCode.Success;
                    dbRes.Message = message;
                    dbRes.Extra1 = id;
                }
                else
                {
                    dbRes.Code = ResponseCode.Failed;
                    dbRes.Message = message;

                }
            }
            else
            {
                dbRes.Code = ResponseCode.Failed;
                dbRes.Message = "Something Went Wrong";
            }
            return dbRes;

        }

        public CommonDbResponse GetTransactionLimit(string AgentId)
        {
            CommonDbResponse dbResponse = new CommonDbResponse();
            string sqlCommand = "Execute sproc_transaction_limit @flag = 'r'";
            sqlCommand += ",@txn_type = " + DAO.FilterString("Load");
            sqlCommand += ",@agent_id = " + DAO.FilterString(AgentId);
            var dtable = DAO.ExecuteDataTable(sqlCommand);
            if (dtable != null)
            {
                dbResponse.Code = ResponseCode.Success;
                dbResponse.Message = "Success";
                dbResponse.Data = DAO.DataTableToObject<FundLoadTransactionLimitCommon>(dtable);
            }
            else
            {
                dbResponse.Code = ResponseCode.Failed;
                dbResponse.Message = "Something Went Wrong";
            }
            return dbResponse;
        }

        public CommonDbResponse GetTransactionReposne(string MerchantTxnId, string GatewayTxnId)
        {
            CommonDbResponse dbRes = new CommonDbResponse();
            string sqlCommand = "Execute sproc_payment_gateway_transaction @flag = 's'";
            sqlCommand += ",@merchat_txn_id = " +DAO.FilterString( MerchantTxnId);
            sqlCommand += ",@pmt_gateway_txn_id = " +DAO.FilterString( GatewayTxnId);
            var dbResponse = DAO.ExecuteDataTable(sqlCommand);
            if (dbResponse != null)
            {
                string code = dbResponse.Rows[0]["code"].ToString();
                string message = dbResponse.Rows[0]["message"].ToString();
                
                if ((code ?? "1") == "0")
                {
                    dbRes.Code = ResponseCode.Success;
                    dbRes.Message = message;
                    dbRes.Data = DAO.DataTableToObject<LoadBalanceResponseCommon>(dbResponse);
                    //List<LoadBalanceResponseCommon> lstBalanceCommon = new List<LoadBalanceResponseCommon>();
                    //foreach (DataRow item in dbResponse.Rows)
                    //{
                    //    LoadBalanceResponseCommon lc = new LoadBalanceResponseCommon()
                    //    {
                    //        pmt_gateway_txn_id = item["pmt_gateway_txn_id"].ToString(),
                    //        pmt_txn_id = item["pmt_txn_id"].ToString(),
                    //        amount = item["amount"].ToString(),
                    //        gateway_status = item["gateway_status"].ToString(),
                    //        user_name = item["user_name"].ToString(),
                    //        agent_id = item["agent_id"].ToString()

                    //    };
                    //    lstBalanceCommon.Add(lc);

                    //}
                    //dbRes.Data = lstBalanceCommon;
                    
                }
                else
                {
                    dbRes.Code = ResponseCode.Failed;
                    dbRes.Message = message;

                }
            }
            else
            {
                dbRes.Code = ResponseCode.Failed;
                dbRes.Message = "Something Went Wrong";
            }
            return dbRes;
        }

        public CommonDbResponse LoadBalance(LoadBalanceCommon balance)
        {
            
            CommonDbResponse dbRes = new CommonDbResponse();
            string sqlCommand = "Execute sproc_payment_gateway_transaction @flag = 'i'";
            sqlCommand += ",@pmt_txn_id = " +DAO.FilterString( balance.pmt_txn_id);
            sqlCommand += ",@service_charge = " +DAO.FilterString( balance.service_charge);
            sqlCommand += ",@amount = " +DAO.FilterString( balance.amount);
            sqlCommand += ",@card_no = " +DAO.FilterString( balance.card_no);
            sqlCommand += ",@remarks = " +DAO.FilterString( balance.remarks);
            sqlCommand += ",@user_id = " +DAO.FilterString( balance.user_id);
            sqlCommand += ",@gateway_status = " +DAO.FilterString( balance.gateway_status);
            sqlCommand += ",@pmt_gateway_id = " +DAO.FilterString( balance.pmt_gateway_id);
            sqlCommand += ",@action_user = " +DAO.FilterString( balance.action_user);
            sqlCommand += ",@action_browser = " +DAO.FilterString( balance.action_browser);
            sqlCommand += ",@error_code = " +DAO.FilterString( balance.error_code);
            sqlCommand += ",@action_ip = " +DAO.FilterString( balance.action_ip);
            sqlCommand += ",@pmt_gateway_txn_id = " +DAO.FilterString( balance.pmt_gateway_txn_id);
            var dbResponse = DAO.ExecuteDataRow(sqlCommand);
            if (dbResponse != null)
            {
                string code = dbResponse["code"].ToString();
                string messasge = dbResponse["message"].ToString();
                string id = dbResponse["id"].ToString();
                if ((code ?? "1") == "0")
                {
                    dbRes.Code = ResponseCode.Success;
                    dbRes.Message = messasge;
                    dbRes.Extra1 = id;
                    dbRes.Extra2 = dbResponse["Remarks"].ToString();
                }
                else
                {
                    dbRes.Code = ResponseCode.Failed;
                    dbRes.Message = messasge;
                    dbRes.Extra1 = id;
                }
                return dbRes;
            }
            else
            {
                dbRes.Code = ResponseCode.Failed;
                dbRes.Message = "Something Went Wrong";
            }
            return dbRes;
        }

        public CommonDbResponse UpdateTransaction(LoadBalanceCommon balance)
        {
            CommonDbResponse dbRes = new CommonDbResponse();
            string sqlCommand = "Execute sproc_payment_gateway_transaction @flag = 'u'";
            sqlCommand += ",@pmt_txn_id = " + DAO.FilterString(balance.pmt_txn_id);
            sqlCommand += ",@service_charge = " + DAO.FilterString(balance.service_charge);
            sqlCommand += ",@amount = " + DAO.FilterString(balance.amount);
            sqlCommand += ",@card_no = " + DAO.FilterString(balance.card_no);
            sqlCommand += ",@remarks = " + DAO.FilterString(balance.remarks);
            sqlCommand += ",@user_id = " + DAO.FilterString(balance.user_id);
            sqlCommand += ",@gateway_status = " + DAO.FilterString(balance.gateway_status);
            sqlCommand += ",@pmt_gateway_id = " + DAO.FilterString(balance.pmt_gateway_id);
            sqlCommand += ",@action_user = " + DAO.FilterString(balance.action_user);
            sqlCommand += ",@action_browser = " + DAO.FilterString(balance.action_browser);
            sqlCommand += ",@error_code = " + DAO.FilterString(balance.error_code);
            sqlCommand += ",@action_ip = " + DAO.FilterString(balance.action_ip);
            sqlCommand += ",@pmt_gateway_txn_id = " + DAO.FilterString(balance.pmt_gateway_txn_id);
            sqlCommand += ",@gateway_process_id = " + DAO.FilterString(balance.gateway_process_id);
            sqlCommand += ",@pmt_gateway_name = " + DAO.FilterString(balance.bank_name);
            sqlCommand += ",@txn_type = " + DAO.FilterString(balance.payment_mode);
            var dbResponse = DAO.ExecuteDataRow(sqlCommand);
            if (dbResponse != null)
            {
                string code = dbResponse["Code"].ToString();
                string messasge = dbResponse["message"].ToString();
                string id = dbResponse["id"].ToString();
                if ((code ?? "1") == "0")
                {
                    dbRes.Code = ResponseCode.Success;
                    dbRes.Message = messasge;
                    dbRes.Extra1 = id;
                }
                else
                {
                    dbRes.Code = ResponseCode.Failed;
                    dbRes.Message = messasge;
                    dbRes.Extra1 = id;
                }
                return dbRes;
            }
            else
            {
                dbRes.Code = ResponseCode.Failed;
                dbRes.Message = "Something Went Wrong";
            }
            return dbRes;
        }


    }
}
