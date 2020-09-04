using cgpay.wallet.application.Models.OnePG;
using cgpay.wallet.business.Log;
using cgpay.wallet.shared.Models.Log;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Configuration;

namespace cgpay.wallet.application.Library
{
    public static class MakeHttpRequest
    {

        public static CommonResponse InvokeGetProcessId(string MerchantId, string MerchantName, string MerchantTxnId, string Amount, string TransactionRemarks, string ApiUsername, string ApiPassword, string ApiSecretKey)
        {
            ApiLogBusiness _apiLog = new ApiLogBusiness();
            AuthenticationLogRequest authLog;
            using (WebClient client = new WebClient())
            {
                client.Credentials = new NetworkCredential(ApiUsername, ApiPassword);
                var postValues = new NameValueCollection();
                postValues["MerchantId"] = MerchantId;
                postValues["MerchantName"] = MerchantName;
                postValues["Amount"] = Amount.ToString();
                postValues["MerchantTxnId"] = MerchantTxnId;
                postValues["Signature"] = HMACSignatureGenerator
                    .SHA512_ComputeHash(CommonFunctions.SingnatureGenerator<AuthenticationLogRequest>(authLog = new AuthenticationLogRequest { Amount = Amount, MerchantId = MerchantId, MerchantName = MerchantName, MerchantTxnId = MerchantTxnId }), ApiSecretKey);
                var response = client.UploadValues(GetApiUrl() + "/GetProcessId", "Post", postValues);
                var responseString = Encoding.Default.GetString(response);
                var responseModel = responseString.SerializeJSON<CommonResponse>();
                //maintain log
                _apiLog.InsertApiLog(new ApiLogCommon()
                {
                    apiRequest = JsonConvert.SerializeObject(authLog),
                    apiResponse = responseModel.data.SerializeObjectToJSON(),
                    userId = HttpContext.Current.Session["UserName"].ToString(),
                    IpAddress = ApplicationUtilities.GetIP(),
                    functionName = "GetProcessId"
                });

                //end
                if (responseModel.code == "0")
                {
                    ProcessResponse pRes = new ProcessResponse()
                    {
                        MerchantId = MerchantId,
                        MerchantTxnId = MerchantTxnId,
                        Amount = Amount,
                        ProcessId = responseModel.data.ToString().SerializeJSON<ProcessIdResponse>().ProcessId,
                        GatewayUrl = CommonFunctions.Getwayurl(),
                        GatewayFormMethod = "Post"
                    };
                    responseModel.data = pRes;
                    return responseModel;
                }
                //var s = responseModel.data.ToString();
                ////var s1 = s.Split(new char [] { ':'});
                //var getProcessId = responseModel.data.ToString().SerializeJSON<ProcessIdResponse>();
                //if (getProcessId != null)
                //{
                //    return getProcessId.ProcessId;
                //}
                return responseModel;

            }
        }
        public static CommonResponse InvokeCheckTransactionStatus(string MerchantId, string MerchantName, string MerchantTxnId, string ApiUsername, string ApiPassword, string ApiSecretKey)
        {
            ApiLogBusiness _apiLog = new ApiLogBusiness();
            CheckTransactionRequest checkTran;
            using (WebClient client = new WebClient())
            {
                client.Credentials = new NetworkCredential(ApiUsername, ApiPassword);
                var postValues = new NameValueCollection();
                postValues["MerchantId"] = MerchantId;
                postValues["MerchantName"] = MerchantName;
                postValues["MerchantTxnId"] = MerchantTxnId;
                postValues["Signature"] = HMACSignatureGenerator.SHA512_ComputeHash(CommonFunctions.SingnatureGenerator<CheckTransactionRequest>(checkTran = new CheckTransactionRequest { MerchantId = MerchantId, MerchantName = MerchantName, MerchantTxnId = MerchantTxnId }), ApiSecretKey);
                var response = client.UploadValues(GetApiUrl() + "/CheckTransactionStatus", "Post", postValues);
                var responseString = Encoding.Default.GetString(response);
                var responseModel = responseString.SerializeJSON<CommonResponse>();

                //maintain log
                var transactionModel = ApplicationUtilities.MapObject<CheckTransactionResponse>(responseModel.data);

                _apiLog.InsertApiLog(new ApiLogCommon()
                {
                    transacionId = transactionModel.MerchantTxnId,
                    partner_tran_id = transactionModel.GatewayReferenceNo,
                    apiRequest = JsonConvert.SerializeObject(checkTran),
                    apiResponse = responseModel.data.SerializeObjectToJSON(),
                    userId = HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session["UserName"] != null ? HttpContext.Current.Session["UserName"].ToString() : "system",
                    IpAddress = ApplicationUtilities.GetIP(),
                    functionName = "CheckTransactionStatus"

                });

                //end

                //CheckTransactionResponse
                //var s = responseModel.data.ToString();
                ////var s1 = s.Split(new char [] { ':'});
                //var getProcessId = responseModel.data.ToString().SerializeJSON<ProcessIdResponse>();
                //if (getProcessId != null)
                //{
                //    return getProcessId.ProcessId;
                //}
                return responseModel;

            }
        }
        private static string GetApiUrl()
        {
            if (ConfigurationManager.AppSettings["phase"] != null && ConfigurationManager.AppSettings["phase"].ToString() == "local")
            {
                return "http://localhost:56445";
            }
            else if (ConfigurationManager.AppSettings["phase"] != null && ConfigurationManager.AppSettings["phase"].ToString() == "development")
            {
                return "http://202.79.47.32";//wepay port local server
            }
            else if (ConfigurationManager.AppSettings["phase"] != null && ConfigurationManager.AppSettings["phase"].ToString() == "uat")
            {
                return "https://apisandbox.nepalpayment.com";//wepay port local server
            }
            else
            { //live
                return "https://apigateway.nepalpayment.com";//wepay  live
            }
        }
    }
}