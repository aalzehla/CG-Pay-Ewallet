using cgpay.wallet.application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.LoadBalance;
using cgpay.wallet.shared.Models.LoadBalance;
using System.Configuration;
using System.Net;
using System.IO;
using System.Collections.Specialized;
using System.Text;
using admin.onepg.api.Models;
using cgpay.wallet.application.Models.OnePG;
using cgpay.wallet.business.Log;
using CommonResponse = cgpay.wallet.application.Models.OnePG.CommonResponse;


namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class LoadBalanceController : Controller
    {
        IWalletUserBusiness _walletUser;
        ILoadBalanceBusiness _iLoad;
        IApiLogBusiness _apiLog;
        public LoadBalanceController(IWalletUserBusiness walletUser)
        {
            _walletUser = walletUser;
            _iLoad = new LoadBalanceBusiness();
            _apiLog = new ApiLogBusiness();
        }
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Index(WalletBalanceModel walletBalance)
        {

            Dictionary<string, string> PurposeList = _walletUser.GetProposeList();
            walletBalance.PurposeList = ApplicationUtilities.SetDDLValue(PurposeList, "", "--Propose--");

            if ((Convert.ToDecimal(walletBalance.Amount) > 1000 || Convert.ToDecimal(walletBalance.Amount) < 10) && walletBalance.Type == "T")
            {
                ModelState.AddModelError("Amount", "Amount should be between 10-1000");
                return View(walletBalance);
            }

            ModelState.Remove("Purpose");
            ModelState.Remove("ReceiverAgentId");
            string usertype = Session["UserType"].ToString();
            string agentid = Session["AgentId"].ToString();
            CommonDbResponse response = _walletUser.CheckMobileNumber(agentid, walletBalance.MobileNumber, usertype, "lb");
            if (response.Code != 0)
            {
                ModelState.AddModelError("MobileNumber", "Invalid User Detail");
                return View(walletBalance);
            }
            else
            {
                ModelState.Remove("MobileNumber");
            }
            if (ModelState.IsValid)
            {
                walletBalance.AgentId = Session["AgentId"].ToString();
                walletBalance.ActionUser = Session["UserName"].ToString();
                walletBalance.IpAddress = ApplicationUtilities.GetIP();
                WalletBalanceCommon walletBalanceCommon = walletBalance.MapObject<WalletBalanceCommon>();
                CommonDbResponse dbResponse = _walletUser.AgentToWallet(walletBalanceCommon);
                if (dbResponse.Code == 0)
                {
                    dbResponse.SetMessageInTempData(this, "balanceTransfer");
                    return RedirectToAction("Index");
                }
                else
                {
                    dbResponse.SetMessageInTempData(this, "balanceTransfer");
                }
            }
            else
            {
                return View(walletBalance);
            }

            return RedirectToAction("Index");
        }
        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> CheckMobileNumber(string MobileNo)
        {
            string usertype = Session["UserType"].ToString();
            string agentid = Session["AgentId"].ToString();
            CommonDbResponse response = _walletUser.CheckMobileNumber(agentid, MobileNo, usertype, "lb");
            int Code = (int)response.Code;
            return Json(new { Code }, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        public ActionResult LoadBalanceIndex(string code)
        {
            var dbLimits = _iLoad.GetTransactionLimit(Session["AgentId"].ToString());
            var limits = dbLimits.Data.MapObject<LoadBalanceModel>();
            limits.instrument_code = string.IsNullOrEmpty(code) ? "" : code.DecryptParameter();
            //ViewData["instrumentcode"] = code.DecryptParameter();
            return View(limits);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LoadBalanceIndex(LoadBalanceModel balance)
        {
            CommonDbResponse dbResponse = new CommonDbResponse();
            var dbLimits = _iLoad.GetTransactionLimit(Session["AgentId"].ToString());
            var limits = dbLimits.Data.MapObject<LoadBalanceModel>();
            if (Convert.ToInt32(balance.amount) < 10 || Convert.ToInt32(balance.amount) > 100000)
            {

                return View(limits);
            }

            //if (
            //    int.Parse(balance.amount) > limits.transactiondailylimitmax
            //    || int.Parse(balance.amount) > limits.transactionmonthlylimitmax
            //    )
            //{
            //    dbResponse.Code = ResponseCode.Failed;
            //    dbResponse.Message = "Amount Exceeded Transaction Limit";
            //    dbResponse.SetMessageInTempData(this);
            //    return View(limits);
            //}
            if (int.Parse(balance.amount) > limits.transactiondailylimitmax && int.Parse(balance.amount) <= limits.transactionmonthlylimitmax)
            {
                dbResponse.Code = ResponseCode.Failed;
                dbResponse.Message = "Amount Exceeded Daily Transaction Limit";
                dbResponse.SetMessageInTempData(this);
                return View(limits);
            }
            if (int.Parse(balance.amount) > limits.transactionmonthlylimitmax)
            {
                dbResponse.Code = ResponseCode.Failed;
                dbResponse.Message = "Amount Exceeded Monthly Transaction Limit";
                dbResponse.SetMessageInTempData(this);
                return View(limits);
            }


            LoadBalanceCommon ld = new LoadBalanceCommon();

            if (ModelState.IsValid)
            {
                balance.action_user = Session["UserName"].ToString();
                balance.action_ip = ApplicationUtilities.GetIP();
                balance.action_browser = HttpContext.Request.Browser.ToString();



                ld = balance.MapObject<LoadBalanceCommon>();
                dbResponse = _iLoad.LoadBalance(ld);
                if (dbResponse.Code == ResponseCode.Success)
                {
                    string apiusername = ApplicationUtilities.GetAppConfigValue("apiusername");
                    string apipasssword = ApplicationUtilities.GetAppConfigValue("apipasssword");
                    string apisecretkey = ApplicationUtilities.GetAppConfigValue("apisecretkey");
                    string merchantname = ApplicationUtilities.GetAppConfigValue("merchantname");
                    string merchantid = ApplicationUtilities.GetAppConfigValue("merchantid");

                    try
                    {
                        MiddleServiceRequest middlewareCall = new MiddleServiceRequest("cgpay", apiusername, apipasssword, apisecretkey, Session["UserName"].ToString());
                        var response = middlewareCall.GetFormObject(merchantid, merchantname, dbResponse.Extra1, balance.amount, dbResponse.Extra2, balance.instrument_code);
                        if (response != null && response.code == "0")
                        {
                            var formString = ApplicationUtilities.MapObject<MiddlewareResponse.FormDataObject>(response.data);
                            Response.Write(formString.FormData);
                            Response.End();
                        }
                        else if (response != null && response.code == "1")
                        {
                            dbResponse.Code = ResponseCode.Failed;
                            dbResponse.Message = response.message;
                           // dbResponse.SetMessageInTempData(this);
                            return View(limits);
                        }
                        else
                        {
                            dbResponse.Code = ResponseCode.Failed;
                            dbResponse.Message = "Service Call Failed";
                            //dbResponse.SetMessageInTempData(this);
                            return View(limits);
                        }
                    }
                    catch (Exception)
                    {
                        dbResponse.Code = ResponseCode.Failed;
                        dbResponse.Message = "Service Call Failed";
                       // dbResponse.SetMessageInTempData(this);
                        return View(limits);

                    }

                }
                //dbResponse.SetMessageInTempData(this);
                return View(limits);
            }

            return View(limits);

        }

        [OverrideActionFilters]
        [HttpGet]

        public ActionResult ReceivePaymentNotification(string MerchantTxnId, string GatewayTxnId)
        {

            //check MerchantTxnId in our db first
            var dbRes = _iLoad.CheckTrnasactionExistence(MerchantTxnId, GatewayTxnId);
            if (dbRes.Code == ResponseCode.Success)
            {
                string apiusername = ApplicationUtilities.GetAppConfigValue("apiusername");
                string apipasssword = ApplicationUtilities.GetAppConfigValue("apipasssword");
                string apisecretkey = ApplicationUtilities.GetAppConfigValue("apisecretkey");
                string merchantname = ApplicationUtilities.GetAppConfigValue("merchantname");
                string merchantid = ApplicationUtilities.GetAppConfigValue("merchantid");
                try
                {
                    MiddleServiceRequest serviceCall = new MiddleServiceRequest("cgpay", apiusername, apipasssword, apisecretkey);
                    var resp = serviceCall.GetTransactionDetail(merchantid, merchantname, MerchantTxnId);

                    if (resp.code == "0")
                    {
                        var transactionModel = ApplicationUtilities.MapObject<CheckTransactionResponse>(resp.data);
                        LoadBalanceCommon lBalance = new LoadBalanceCommon()
                        {
                            pmt_gateway_id = "",
                            pmt_gateway_txn_id = GatewayTxnId,
                            gateway_status = transactionModel.Status,
                            gateway_process_id = "",
                            action_user = "System",
                            action_ip = ApplicationUtilities.GetIP(),
                            bank_name = transactionModel.Institution,
                            payment_mode = transactionModel.Instrument,
                            pmt_txn_id = MerchantTxnId,
                            amount = transactionModel.Amount,
                            service_charge = transactionModel.ServiceCharge
                        };
                        _iLoad.UpdateTransaction(lBalance);
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw;
                }

            }
            Response.Write("Received");
            Response.End();
            return View();



            // then check if transaction is already updated by merchanttxnid and gatewaytxnid



            //if transaction exists or already received or txn not found
            //return "Received";
            //
        }
        //[HttpGet]
        [OverrideActionFilters]
        public ActionResult ReceivePaymentResponse(string MerchantTxnId, string GatewayTxnId)
        {
            if (string.IsNullOrEmpty(MerchantTxnId) && string.IsNullOrEmpty(GatewayTxnId))
            {
                CommonDbResponse dbRes = new CommonDbResponse();
                ViewTransactionReponseModel viewModel = new ViewTransactionReponseModel();


                viewModel.code = 1;
                viewModel.Message = "Tranasaction Failed";
                viewModel.gateway_status = "Failed";
                //dbRes.SetMessageInTempData(this);
                return View(viewModel);

            }
            string apiusername = ApplicationUtilities.GetAppConfigValue("apiusername");
            string apipasssword = ApplicationUtilities.GetAppConfigValue("apipasssword");
            string apisecretkey = ApplicationUtilities.GetAppConfigValue("apisecretkey");
            string merchantname = ApplicationUtilities.GetAppConfigValue("merchantname");
            string merchantid = ApplicationUtilities.GetAppConfigValue("merchantid");
            CommonDbResponse dbResponse = new CommonDbResponse();
            ViewTransactionReponseModel model = new ViewTransactionReponseModel();
            try
            {
                MiddleServiceRequest serviceCall = new MiddleServiceRequest("cgpay", apiusername, apipasssword, apisecretkey, Session["UserName"].ToString());
                var resp = serviceCall.GetTransactionDetail(merchantid, merchantname, MerchantTxnId);

                //if (resp != null && resp.code == "0" && resp.data.Status.ToLower() == "success" )
                //{
                //    dbResponse = _iLoad.GetTransactionReposne(MerchantTxnId, GatewayTxnId);
                //    if (dbResponse.Code == ResponseCode.Success)
                //    {
                //        model = ApplicationUtilities.MapObject<ViewTransactionReponseModel>(dbResponse.Data);
                //        model.code = int.Parse(resp.code);
                //        return View(model);
                //    }
                //    else
                //    {
                //        //dbResponse.SetMessageInTempData(this);
                //        model.code = 1;
                //        return View(model);
                //    }
                //}
                //else if (resp != null && resp.code == "0" && resp.data.Status.ToLower() == "fail")
                //{

                //    model.code = 1;
                //    model.Message = "Tranasaction Failed";
                //    //dbResponse.SetMessageInTempData(this);
                //    return View(model);
                //}
                //else if (resp != null && resp.code == "1")
                //{
                //    dbResponse.Code = ResponseCode.Failed;
                //    dbResponse.Message = resp.message;
                //    dbResponse.SetMessageInTempData(this);
                //    model.code = int.Parse(resp.code);
                //    return View(model);
                //}
                //else
                //{
                //    dbResponse.Code = ResponseCode.Failed;
                //    dbResponse.Message = "Service Call Failed";
                //    dbResponse.SetMessageInTempData(this);
                //    model.code = 1;
                //    return View(model);
                //}
                if (resp != null && resp.code == "0")
                {
                    dbResponse = _iLoad.GetTransactionReposne(MerchantTxnId, GatewayTxnId);
                    if (dbResponse.Code == ResponseCode.Success)
                    {
                        model = ApplicationUtilities.MapObject<ViewTransactionReponseModel>(dbResponse.Data);
                        model.code = int.Parse(resp.code);
                        return View(model);
                    }
                    else
                    {
                        model.code = 1;
                        model.Message = "Transaction status failed.";
                        model.gateway_status = "Failed";
                        return View(model);
                    }
                }
                else if (resp != null && resp.code == "1")
                {
                    //dbResponse.Code = ResponseCode.Failed;
                    model.Message = "Transaction status failed.";
                    model.gateway_status = "Failed";
                    model.code = 1;
                    return View(model);
                }
                else
                {
                    //dbResponse.Code = ResponseCode.Failed;
                    model.Message = "Transaction status failed.";
                    model.gateway_status = "Failed";
                    model.code = 1;
                    return View(model);
                }
            }
            catch (Exception)
            {



                //dbResponse.Code = ResponseCode.Failed;
                model.Message = "Transaction status failed.";
                model.gateway_status = "Failed";
                //dbResponse.SetMessageInTempData(this);
                model.code = 1;
                return View(model);
            }
        }




        [OverrideActionFilters]
        public ActionResult BankList()
        {
            string apiusername = ApplicationUtilities.GetAppConfigValue("apiusername");
            string apipasssword = ApplicationUtilities.GetAppConfigValue("apipasssword");
            string apisecretkey = ApplicationUtilities.GetAppConfigValue("apisecretkey");
            string merchantname = ApplicationUtilities.GetAppConfigValue("merchantname");
            string merchantid = ApplicationUtilities.GetAppConfigValue("merchantid");
            MiddleServiceRequest middlewareCall = new MiddleServiceRequest("cgpay", apiusername, apipasssword, apisecretkey, Session["UserName"].ToString());
            var response = middlewareCall.GetPaymentInstrumentDetail(merchantid, merchantname);
            var bankList = ApplicationUtilities.MapObjects<BankList>(response.data);
            return View(bankList);

        }
    }

}
