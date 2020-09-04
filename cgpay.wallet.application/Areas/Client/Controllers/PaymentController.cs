using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.application.Models.Utilities;
using cgpay.wallet.business.Card;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.Client.MobileTopup;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.DynamicReport;
using cgpay.wallet.business.LandLine;
using cgpay.wallet.business.Mobile;
using cgpay.wallet.business.TransactionLimit;
using cgpay.wallet.business.Utilities;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Mobile;
using cgpay.wallet.shared.Models.Utilities;
using paypoint.service.data;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class PaymentController : Controller
    {

        ICommonBusiness _ICB;
        IWalletUserBusiness _payment;
        IMobileTopUpPaymentBusiness _mtp;
        IMobilePaymentBusiness _mpaymentPP;
        ITransactionLimitBusiness _transactionLimit;
        ICardBusiness _card;
        
        string ControllerName = "Payment";
        public PaymentController(ICommonBusiness ICB,IWalletUserBusiness payment, IMobileTopUpPaymentBusiness mtp, IMobilePaymentBusiness mpaymentPP, ITransactionLimitBusiness tbuss, ICardBusiness card)
        {
            _ICB = ICB;
            _payment = payment;
            _mtp = mtp;
            _mpaymentPP = mpaymentPP;
            _transactionLimit = tbuss;
            _card = card;
            
            
        }

        #region Mobile Topup
        public ActionResult MobileTopUp()
        {
            //ViewBag.ProductId = id;
            //TempData["ProductId"] = id;
            //Session["ProductId"] = id;

            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
            var trangrid = ProjectGrid.TransactionLimit(TxnLimit);
            ViewData["trangrid"] = trangrid;
            //ClientModel clientModel = new ClientModel()
            //{
            //    TxnLimitMax = TxnLimit.TxnLimitMax,
            //    TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
            //    TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
            //    TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
            //    TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            //};
            return View();
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult MobileTopup(ClientModel clientModel)
        {
            //string productid = clientModel.ProductId;
            var validMobileNo = MobileNumberValidate(clientModel.MobileNo);
            if (validMobileNo.Code != "0")
            {
                if (validMobileNo.Code.Equals("1"))
                    ModelState.AddModelError("MobileNo", validMobileNo.Message);
                else
                {
                    CommonDbResponse dbResponse = new CommonDbResponse();
                    dbResponse.Code = ResponseCode.Exception;
                    dbResponse.Message = validMobileNo.Message;
                    dbResponse.SetMessageInTempData(this, "MobileTopup");
                }
                return View(clientModel);
            }

            MobileTopUpPaymentRequest mtpr = new MobileTopUpPaymentRequest()
            {
                action_user = Session["UserName"].ToString(),
                product_id = clientModel.ProductId,
                amount = clientModel.Amount,
                subscriber_no = clientModel.MobileNo,
                quantity = "",
                additonal_data = "",
                CardNo = clientModel.CardNo,
                CardAmount = clientModel.CardAmount
            };
            var response = _mtp.MobileTopUpPaymentRequest(mtpr);
            if (response.Code == 0)
            {
                var tranid = response.Extra1;
                var amt = clientModel.Amount.Contains(".") ? clientModel.Amount.Split('.')[0].ToString() : clientModel.Amount;
                var payment = _mpaymentPP.DirectPayment(tranid);
                //var payment = _mpaymentPP.ConsumeService(clientModel.MobileNo, long.Parse(amt));
                bool failed = true;
                if (payment.GatewayName == "PAYPOINT")
                {
                    if (payment.Code == shared.Models.ResponseCode.Success)
                    {
                        var billNo = payment.Extra1;
                        var refStan = payment.Extra2;
                        var ppresponse = (PPResponse)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        data.bill_number = billNo;
                        data.refstan = refStan;
                        data.status_code = ppresponse.Result;
                        data.remarks = ppresponse.ResultMessage;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;

                    }
                    else
                    {
                        var ppresponse = (PPResponse)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        data.status_code = ((int)payment.Code).ToString();
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);

                    }
                }
                if (payment.GatewayName == "PRABHUPAY")
                {
                    if (payment.Code == ResponseCode.Success)
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var billNo = ppresponse.TransactionId;  //payment.Extra1;
                        var refStan = ppresponse.TransactionId;  //payment.Extra2;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        //data.bill_number = billNo;
                        //data.refstan = refStan;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;

                    }
                    else if (payment.Code == ResponseCode.Exception)
                    {

                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var billNo = ppresponse.TransactionId;  //payment.Extra1;
                        var refStan = ppresponse.TransactionId;  //payment.Extra2;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        //data.bill_number = billNo;
                        //data.refstan = refStan;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                    }
                    else
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        data.status_code = "999";
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                    }
                }
                response.SetMessageInTempData(this, "MobileTopup");
                if (failed)
                    return RedirectToAction("MobileTopup");
                return RedirectToAction("ResultPage", ControllerName, new { txnid = response.Extra1.EncryptParameter() });
                //return RedirectToAction("MobileTopup");
            }
            response.SetMessageInTempData(this, "MobileTopup");

            return RedirectToAction("MobileTopup");

        }
        public Dictionary<string, string> getdenominationlist(string extra1, Dictionary<string, string> dictionary = null)
        {
            string UserId = ApplicationUtilities.GetSessionValue("userid").ToString();
            string IpAddress = ApplicationUtilities.GetIP().ToString();
            dictionary.Add("UserId", UserId);
            dictionary.Add("IpAddress", IpAddress);
            return _ICB.Denomination(extra1, dictionary);
        }
        [HttpGet]
        public ActionResult NTPre()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
            
            NTPre model = new NTPre()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "NTPre";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("1");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            //Dictionary<string, string> dictonary = new Dictionary<string, string>();
            //dictonary.Add("Subscriberno", "9849650000");
            //ViewBag.productdenominationList = ApplicationUtilities.SetDDLValue(getdenominationlist("1", dictonary), "", "--select--");
            return View(model);
        }
        [HttpGet]
        public ActionResult NTPost()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);

            NTPost model = new NTPost()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "NTPost";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("14");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            return View(model);
        }
        [HttpGet]
        public ActionResult NTCdmaPre()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);

            NTCdmaPre model = new NTCdmaPre()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "NTCdmaPre";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("9");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            return View(model);
        }
        [HttpGet]
        public ActionResult NTCdmaPost()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);

            NTCdmaPost model = new NTCdmaPost()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "NTCdmaPost";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("10");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            return View(model);
        }
        [HttpGet]
        public ActionResult Ncell()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);

            Ncell model = new Ncell()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "Ncell";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("2");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            //Dictionary<string, string> dictonary = new Dictionary<string, string>();
            //dictonary.Add("Subscriberno", "8800000238");
            //ViewBag.productdenominationList = ApplicationUtilities.SetDDLValue(getdenominationlist("2", dictonary), "", "--select--");
            return View(model);
        }
        [HttpGet]
        public ActionResult SmartCell()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);

            SmartCell model = new SmartCell()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "SmartCell";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("4");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            return View(model);
        }
        [HttpGet]
        public ActionResult UTL()
        {
            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);

            UTL model = new UTL()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit

            };
            model.Ctrl = "UTL";
            model.Ctrl = model.Ctrl.EncryptParameter();
            var ProductDetail = ProductDetails("3");

            model.ProductLabel = ProductDetail.ProductLabel;
            model.ProductLogo = ProductDetail.ProductLogo;
            model.MinAmount = ProductDetail.MinAmount;
            model.MaxAmount = ProductDetail.MaxAmount;
            model.ProductId = ProductDetail.ProductId;
            model.ProductServiceInfo = ProductDetail.ProductServiceInfo;
            model.CommissionValue = ProductDetail.CommissionValue;
            model.CommissionType = ProductDetail.CommissionType;
            return View(model);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult TopUpMobile(ClientModel clientModel)
        {
            if (string.IsNullOrEmpty(clientModel.Ctrl.DecryptParameter()))
            {
                return RedirectToAction("Index", "Home");
            }

            clientModel.Ctrl = clientModel.Ctrl.DecryptParameter();
            //string productid = clientModel.ProductId;
            var validMobileNo = MobileNumberValidate(clientModel.MobileNo);
            if (validMobileNo.Code != "0")
            {
                ModelState.AddModelError("MobileNo", validMobileNo.Message);
                return RedirectToAction(clientModel.Ctrl);
            }

            MobileTopUpPaymentRequest mtpr = new MobileTopUpPaymentRequest()
            {
                action_user = Session["UserName"].ToString(),
                product_id = clientModel.ProductId,
                amount = clientModel.Amount,
                subscriber_no = clientModel.MobileNo,
                quantity = "",
                additonal_data = "",
                CardNo = clientModel.CardNo,
                CardAmount = clientModel.CardAmount
            };
            var response = _mtp.MobileTopUpPaymentRequest(mtpr);
            if (response.Code == 0)
            {
                var tranid = response.Extra1;
                var amt = clientModel.Amount.Contains(".") ? clientModel.Amount.Split('.')[0].ToString() : clientModel.Amount;
                var payment = _mpaymentPP.DirectPayment(tranid);
                //var payment = _mpaymentPP.ConsumeService(clientModel.MobileNo, long.Parse(amt));
                bool failed = true;
                if(payment.GatewayName=="PAYPOINT")
                {
                    if (payment.Code == shared.Models.ResponseCode.Success)
                    {
                        var billNo = payment.Extra1;
                        var refStan = payment.Extra2;
                        var ppresponse = (PPResponse)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        data.bill_number = billNo;
                        data.refstan = refStan;
                        data.status_code = ppresponse.Result;
                        data.remarks = ppresponse.ResultMessage;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;

                    }
                    else
                    {
                        var ppresponse = (PPResponse)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        data.status_code = ((int)payment.Code).ToString();
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);

                    }
                }
                if(payment.GatewayName=="PRABHUPAY")
                {
                    if(payment.Code== ResponseCode.Success)
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var billNo = ppresponse.TransactionId;  //payment.Extra1;
                        var refStan = ppresponse.TransactionId;  //payment.Extra2;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        //data.bill_number = billNo;
                        //data.refstan = refStan;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;

                    }
                    else if (payment.Code == ResponseCode.Exception)
                    {

                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var billNo = ppresponse.TransactionId;  //payment.Extra1;
                        var refStan = ppresponse.TransactionId;  //payment.Extra2;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        //data.bill_number = billNo;
                        //data.refstan = refStan;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                    }
                    else
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = clientModel.Amount;
                        data.status_code = "999";
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = clientModel.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                    }
                }


               
                if (failed)
                {
                    response.Code = shared.Models.ResponseCode.Failed;
                    response.Message =payment.Message ;
                }
                response.SetMessageInTempData(this, "MobileTopup");
                if (failed)
                    return RedirectToAction(clientModel.Ctrl);
                return RedirectToAction("ResultPage", ControllerName, new { txnid = response.Extra1.EncryptParameter() });
                //return RedirectToAction("MobileTopup");
            }
            response.SetMessageInTempData(this, clientModel.Ctrl);

            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            return RedirectToAction(clientModel.Ctrl);
        }
        public MobileTopUpModel ProductDetails(string productId = "")
        {
            MobileTopUpModel response =new MobileTopUpModel();
            string userid = Session["UserId"].ToString();
            var serviceslist = _payment.ServiceDetail(userid);
            var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == productId);
            response.ProductLabel = serviceInfo.ProductLabel;
            response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
            response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
            response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
            response.ProductId = serviceInfo.ProductId;
            response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
            response.CommissionValue = serviceInfo.CommissionValue;
            response.CommissionType = serviceInfo.CommissionType;
            return response;
        }
        public async System.Threading.Tasks.Task<JsonResult> CheckDenomination(string MobileNo,string ctrl)
        {
            string productid = "0";
            string Code = "0";
            ctrl = ctrl.DecryptParameter().ToUpper();
            Dictionary<string, string> Denomitation = new Dictionary<string, string>();
           
            
                if (MobileNo.Substring(0, 3) == "980" || MobileNo.Substring(0, 3) == "981" || MobileNo.Substring(0, 3) == "982" || (ConfigurationManager.AppSettings["phase"] != null && (ConfigurationManager.AppSettings["phase"].ToString().ToUpper() == "DEVELOPMENT" || ConfigurationManager.AppSettings["phase"].ToString().ToUpper() == "LOCAL") && MobileNo.Substring(0, 3) == "880")&& ctrl=="NCELL")//NCELL
            {
                productid = "2";
                Code = "Ncell";
                Code = Code.EncryptParameter();
            }
            else if ((MobileNo.Substring(0, 3) == "984" || MobileNo.Substring(0, 3) == "986") && ctrl=="NTPRE")//ntc prepaid
            {
                productid = "1";
                Code = "NTPre";
                Code = Code.EncryptParameter();
            }
            else if ((MobileNo.Substring(0, 3) == "974" || MobileNo.Substring(0, 3) == "976") && ctrl == "NTCDMAPRE")//ntc cdma
            {
                productid = "9";
                Code = "NTCdmaPre";
                Code = Code.EncryptParameter();
            }
            else if ((MobileNo.Substring(0, 3) == "985") && ctrl == "NTPOST")//ntc postpaid
            {
                productid = "14";
                Code = "NTPost";
                Code = Code.EncryptParameter();
            }
            else if ((MobileNo.Substring(0, 3) == "975")&& ctrl== "NTCDMAPOST" ) //CDMA Postpaid
            {
                productid = "10";
                Code = "NTCdmaPost";
                Code = Code.EncryptParameter();
            }
            else if ((MobileNo.Substring(0, 3) == "988" || MobileNo.Substring(0, 3) == "961" || MobileNo.Substring(0, 3) == "962")&& ctrl== "SMARTCELL")//smartcell
            {
                productid = "4";
                Code = "SmartCell";
                Code = Code.EncryptParameter();
            }
            else if ((MobileNo.Substring(0, 3) == "972") && ctrl == "UTL")//UTL
            {
                productid = "3";
                Code = "UTL";
                Code = Code.EncryptParameter();
            }
            else
            {
                productid = "0";
                return Json(new { Denomitation,Code }, JsonRequestBehavior.AllowGet);
            }            
            Dictionary<string, string> dictonary = new Dictionary<string, string>();
            dictonary.Add("Subscriberno", MobileNo);
            Denomitation = getdenominationlist(productid, dictonary);
            
            return Json(new {Denomitation,Code }, JsonRequestBehavior.AllowGet);
        }
    
        #endregion Mobile Topup

        public ActionResult ResultPage(string txnid)
        {
            DynamicReportModel dynamicReportModel = new DynamicReportModel();
            //DynamicReportCommon dynamicReportCommons = new DynamicReportCommon();
            string txnId = txnid.DecryptParameter();
            ViewBag.TxnId = txnid;
            if (!String.IsNullOrEmpty(txnId))
            {
                IDynamicReportBusiness _dynamicReport = new DynamicReportBusiness();
                dynamicReportModel = _dynamicReport.GetTransactionReportDetail(txnId).MapObject<DynamicReportModel>(); ;
                return View(dynamicReportModel);
            }
            //dynamicReportModel = dynamicReportCommons.MapObject<DynamicReportModel>();

            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            return RedirectToAction("MobileTopup");
        }
        [HttpGet, OverrideActionFilters]
        public ActionResult PrintTransactionResult(string txnid)
        {
            DynamicReportModel dynamicReportModel = new DynamicReportModel();
            //DynamicReportCommon dynamicReportCommons = new DynamicReportCommon();
            string txnId = txnid.DecryptParameter();
            if (!String.IsNullOrEmpty(txnId))
            {
                IDynamicReportBusiness _dynamicReport = new DynamicReportBusiness();
                dynamicReportModel = _dynamicReport.GetTransactionReportDetail(txnId).MapObject<DynamicReportModel>(); ;
                return View(dynamicReportModel);
            }
            //dynamicReportModel = dynamicReportCommons.MapObject<DynamicReportModel>();

            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            return RedirectToAction("MobileTopup");
        }
        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> CheckMobileNumber(string MobileNo)
        {
            MobileNumberClass response = MobileNumberValidate(MobileNo);
            string Code = response.Code;
            string Message = response.Message;
            string LogoUrl = response.ProductLogo;
            string MinAmount = response.MinAmount;
            string MaxAmount = response.MaxAmount;
            string ProductId = response.ProductId;
            string ProductServiceInfo = response.ProductServiceInfo;
            string CommissionValue = response.CommissionValue;
            string CommissionType = response.CommissionType;
            Dictionary<string, string> dictonary = new Dictionary<string, string>();
            dictonary.Add("Subscriberno", MobileNo);
            Dictionary<string, string> Denomitation = getdenominationlist(ProductId, dictonary);

            return Json(new { Code, Message, LogoUrl, MinAmount, MaxAmount, ProductId, ProductServiceInfo, CommissionValue, CommissionType, Denomitation }, JsonRequestBehavior.AllowGet);
        }

        private MobileNumberClass MobileNumberValidate(string MobileNumber)
        {
            //string type = "1";
            string userid = Session["UserId"].ToString();
            var serviceslist = _payment.ServiceDetail(userid);
            MobileNumberClass response = new MobileNumberClass();
            CommonDbResponse dbResponse = new CommonDbResponse();
            response.Code = "1";
            response.Message = "Invalid Number!!";
            if (string.IsNullOrEmpty(MobileNumber))
            {
                response.Message = "Number is Invalid!!";
                return response;
            }
            if (MobileNumber.Length > 10 && MobileNumber.Substring(0, 3) == "977")
            {
                MobileNumber = MobileNumber.Substring(3);
            }
            if (!MobileNumberLengthValidate(MobileNumber))
            {
                response.Code = "1";
                response.Message = "Please Enter Valid Mobile Number of length 10";
                return response;
            }
            if (MobileNumber.Substring(0, 3) == "980" || MobileNumber.Substring(0, 3) == "981" || MobileNumber.Substring(0, 3) == "982" || (ConfigurationManager.AppSettings["phase"] != null && (ConfigurationManager.AppSettings["phase"].ToString().ToUpper() == "DEVELOPMENT"|| ConfigurationManager.AppSettings["phase"].ToString().ToUpper() == "LOCAL") && MobileNumber.Substring(0, 3) == "880"))//NCELL
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "2");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" :serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                }
                return response;
            }
            else if (MobileNumber.Substring(0, 3) == "984" || MobileNumber.Substring(0, 3) == "986")//ntc prepaid
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "1");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                    //this.ShowPopup(1, string.IsNullOrEmpty(response.Message) ? "Error" : response.Message);
                    //dbResponse.SetMessageInTempData(this, "MobileTopup");
                }
                return response;
            }
            else if (MobileNumber.Substring(0, 3) == "974" || MobileNumber.Substring(0, 3) == "976")//ntc cdma
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "9");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                }
                return response;
            }
            else if (MobileNumber.Substring(0, 3) == "985")//ntc postpaid
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "14");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                }
                return response;
            }
            else if (MobileNumber.Substring(0, 3) == "975") //CDMA Postpaid
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "10");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                }
                return response;
            }
            else if (MobileNumber.Substring(0, 3) == "988" || MobileNumber.Substring(0, 3) == "961" || MobileNumber.Substring(0, 3) == "962")//smartcell
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "4");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" :serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                }
                return response;
            }
            else if (MobileNumber.Substring(0, 3) == "972")//UTL
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "3");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount = string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" :serviceInfo.MaxAmount;
                response.ProductId = serviceInfo.ProductId;
                response.ProductServiceInfo = serviceInfo.ProductServiceInfo;
                response.CommissionValue = serviceInfo.CommissionValue;
                response.CommissionType = serviceInfo.CommissionType;
                dbResponse = CheckProductValid(serviceInfo.ProductId);
                if (dbResponse.Code != 0)
                {
                    response.Code = (dbResponse.Code == ResponseCode.Exception).ToString();
                    response.Message = dbResponse.Message;
                }
                return response;
            }
            else
            {
                return response;
            }
        }
        private CommonDbResponse CheckProductValid(string ProductId)
        {
            CommonDbResponse response =new CommonDbResponse();
            if (string.IsNullOrEmpty(ProductId))
            {
                response.Code = ResponseCode.Exception;
                response.Message = "ProductId not provided";
                return response;
            }
            string AgentId = Session["AgentId"].ToString();
            string UserType = Session["UserType"].ToString();
            response = _payment.CheckProduct(AgentId,UserType,ProductId);
            
            return response;
        }
        private bool MobileNumberLengthValidate(string MobileNumber)
        {
            if (Regex.IsMatch(MobileNumber, @"^\d{10}$"))
            {
                return true;
            }
            return false;
        }
        //[HttpPost, OverrideActionFilters]
        //public async System.Threading.Tasks.Task<JsonResult> GetCards(string cardno)
        //{
        //    List<SelectListItem> list = new List<SelectListItem>();
        //    string userid = Session["UserId"].ToString();
        //    var cardsList = _card.GetCardList(userid).MapObjects<CardModel>();
        //    var cardType = _card.GetCardType();
        //    Dictionary<string, string> cardNo = new Dictionary<string, string>();
        //    foreach (var item in cardsList.Where(x => x.CardNo == cardno).Where(x => x.Status.ToUpper() == "Y"))
        //    {
        //        cardNo.Add(item.CardId, item.CardNo);
        //    }
        //    list = ApplicationUtilities.SetDDLValue(cardNo, "");
        //    return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        //}

        private class MobileNumberClass
        {
            public string Code { get; set; }
            public string Message { get; set; }
            public string ProductLogo { get; set; }
            public string MinAmount { get; set; }
            public string MaxAmount { get; set; }
            public string ProductId { get; set; }
            public string ProductLabel { get; set; }
            public string CommissionValue { get; set; }
            public string CommissionType { get; set; }
            public string ProductServiceInfo { get; set; }
        }
    }
}