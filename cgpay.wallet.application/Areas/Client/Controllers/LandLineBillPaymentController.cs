using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.application.Models.Utilities;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.DynamicReport;
using cgpay.wallet.business.LandLine;
using cgpay.wallet.business.Mobile;
using cgpay.wallet.business.TransactionLimit;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Mobile;
using paypoint.service.data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class LandLineBillPaymentController : Controller
    {
        ILandLinePaymentBusiness _LLpay;
        ITransactionLimitBusiness _transactionLimit;
        IMobileTopUpPaymentBusiness _mtp;
        IWalletUserBusiness _payment;
        ICommonBusiness _ICB;
        string ControllerName="LandLineBillPayment"; 
        //IMobilePaymentBusiness _mpaymentPP;
        public LandLineBillPaymentController(MobileTopUpPaymentBusiness mtp)
        {
            _LLpay = new LandLinePaymentBusiness();
            _transactionLimit = new TransactionLimitBusiness();
            _payment = new WalletUserBusiness();
            _mtp = mtp;
            _ICB = new CommonBusiness();
        }
       
        public ActionResult LandLinePayment()
        {
            Dictionary<string, string> dictonary = new Dictionary<string, string>();
            ViewBag.productdenominationList = ApplicationUtilities.SetDDLValue(getdenominationlist("0", dictonary), "", "--select--");
            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
            LandLinePaymentModel landlinepayment = new LandLinePaymentModel()
            {
                TxnLimitMax = TxnLimit.TxnLimitMax,
                TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax,
                TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax,
                TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit,
                TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit
            };

            return View(landlinepayment);
        }
        [HttpPost]
        public ActionResult LandLinePayment(LandLinePaymentModel landmodel)
        {
            var validMobileNo = landlinenumbervalidation(landmodel.LandLineNo);
            if (validMobileNo.Code != "0")
            {
                ModelState.AddModelError("LandLineNo", validMobileNo.Message);
                return View(landmodel);
            }

            MobileTopUpPaymentRequest mtpr = new MobileTopUpPaymentRequest()
            {
                action_user = Session["UserName"].ToString(),
                product_id = landmodel.ProductId,
                amount = landmodel.Amount,
                subscriber_no = landmodel.LandLineNo,
                quantity = "",
                additonal_data = "",
                CardNo = landmodel.CardNo,
                CardAmount = landmodel.CardAmount
            };
            var response = _mtp.MobileTopUpPaymentRequest(mtpr);
            if (response.Code == 0)
            {
                var tranid = response.Extra1;
                var amt = landmodel.Amount.Contains(".") ? landmodel.Amount.Split('.')[0].ToString() : landmodel.Amount;
                var payment = _LLpay.DirectPayment(tranid);
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
                        data.amount = landmodel.Amount;
                        data.bill_number = billNo;
                        data.refstan = refStan;
                        data.status_code = ppresponse.Result;
                        data.remarks = ppresponse.ResultMessage;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = landmodel.ProductId;
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
                        data.amount = landmodel.Amount;
                        data.status_code = ((int)payment.Code).ToString();
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = landmodel.ProductId;
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
                        data.amount = landmodel.Amount;
                        data.bill_number = billNo;
                        data.refstan = refStan;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = landmodel.ProductId;
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
                        data.amount = landmodel.Amount;
                        data.bill_number = billNo;
                        data.refstan = refStan;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = landmodel.ProductId;
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
                        data.amount = landmodel.Amount;
                        data.status_code = "999";
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = landmodel.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                    }
                }

                if (failed)
                {
                    response.Code = shared.Models.ResponseCode.Failed;
                    response.Message = "Transaction Failed";
                }
                response.SetMessageInTempData(this, "LandLinePayment");
                if (failed)
                    return RedirectToAction("LandLinePayment");
                return RedirectToAction("ResultPage", ControllerName, new { txnid = response.Extra1.EncryptParameter() });
                //return RedirectToAction("MobileTopup");
            }
            response.SetMessageInTempData(this, "LandLinePayment");

            //if (Session["UserType"].ToString().ToLower() == "merchant")
            //    return RedirectToAction("MobileTopUp3");


            return RedirectToAction("LandLinePayment");
        }
        public async System.Threading.Tasks.Task<JsonResult> CheckLandLineNumber(string LandLineNo)
        {
            LandLineNumberValidation response = landlinenumbervalidation(LandLineNo);
            string Code = response.Code;
            string Message = response.Message;
            string LogoUrl = response.ProductLogo;
            string MinAmount = response.MinAmount;
            string MaxAmount = response.MaxAmount;
            string ProductId = response.ProductId;
            string CommissionValue = response.CommissionValue;
            string CommissionType = response.CommissionType;           
            Dictionary<string, string> dictionary = new Dictionary<string, string>();
            dictionary.Add("Subscriberno", LandLineNo);           
            Dictionary<string, string> Denomitation = getdenominationlist(ProductId,dictionary);
            return Json(new { Code, Message, LogoUrl, MinAmount, MaxAmount, ProductId, CommissionValue, CommissionType, response.CompanyCode, response.ServiceCode, Denomitation }, JsonRequestBehavior.AllowGet);


        }
        private LandLineNumberValidation landlinenumbervalidation(string landlinenumber, long Amount = 0)
        {
            //string type = "1";
            string userid = Session["UserId"].ToString();
            var serviceslist = _payment.ServiceDetail(userid);
            LandLineNumberValidation response = new LandLineNumberValidation();
            response.Code = "1";
            response.Message = "Invalid Number!!";
            if (string.IsNullOrEmpty(landlinenumber))
            {
                response.Message = "Number is Invalid!!";
                return response;
            }
            if (landlinenumber.Length > 9 && landlinenumber.Substring(0, 3) == "977")
            {
                landlinenumber = landlinenumber.Substring(3);
            }
            if (!landlinenumberLengthValidate(landlinenumber))
            {
                response.Code = "1";
                response.Message = "Please Enter Valid LandLine Number with Area Code";
                return response;
            }
            landlinenumber = landlinenumber.TrimStart(new Char[] { '0' });
            if (landlinenumber.Substring(0, 2) == "12" || landlinenumber.Substring(0, 3) == "512")//UTL
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "18");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount += string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : " " + serviceInfo.MaxAmount;
                response.ProductId += serviceInfo.ProductId;
                response.CommissionValue += serviceInfo.CommissionValue;
                response.CommissionType += serviceInfo.CommissionType;
                response.ServiceCode = "0";
                response.CompanyCode = "582";
                return response;
            }
            else//NTC
            {
                var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "15");
                response.Code = "0";
                response.Message = serviceInfo.ProductLabel;
                response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
                response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
                response.MaxAmount += string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "3000" : " " + serviceInfo.MaxAmount;
                response.ProductId += serviceInfo.ProductId;
                response.CommissionValue += serviceInfo.CommissionValue;
                response.CommissionType += serviceInfo.CommissionType;
                response.ServiceCode = "0";
                response.CompanyCode = "585";
                return response;
            }


        }
        private bool landlinenumberLengthValidate(string landlinenumber)
        {
            if (Regex.IsMatch(landlinenumber, @"^\d{9}$"))
            {
                return true;
            }
            return false;
        }

      /*  public async System.Threading.Tasks.Task<JsonResult> CheckDenomination(string , string ctrl)
        {
            string productid = "0";
            ctrl = ctrl.DecryptParameter().ToUpper();
            Dictionary<string, string> Denomitation = new Dictionary<string, string>();


            if (MobileNo.Substring(0, 3) == "980" || MobileNo.Substring(0, 3) == "981" || MobileNo.Substring(0, 3) == "982" || (ConfigurationManager.AppSettings["phase"] != null && (ConfigurationManager.AppSettings["phase"].ToString().ToUpper() == "DEVELOPMENT" || ConfigurationManager.AppSettings["phase"].ToString().ToUpper() == "LOCAL") && MobileNo.Substring(0, 3) == "880") && ctrl == "NCELL")//NCELL
            {
                productid = "2";
            }
            else if ((MobileNo.Substring(0, 3) == "984" || MobileNo.Substring(0, 3) == "986") && ctrl == "NTPRE")//ntc prepaid
            {
                productid = "1";
            }
            else if ((MobileNo.Substring(0, 3) == "974" || MobileNo.Substring(0, 3) == "976") && ctrl == "NTCDMAPRE")//ntc cdma
            {
                productid = "9";
            }
            else if ((MobileNo.Substring(0, 3) == "985") && ctrl == "NTPOST")//ntc postpaid
            {
                productid = "14";
            }
            else if ((MobileNo.Substring(0, 3) == "975") && ctrl == "NTCDMAPOST") //CDMA Postpaid
            {
                productid = "10";
            }
            else if ((MobileNo.Substring(0, 3) == "988" || MobileNo.Substring(0, 3) == "961" || MobileNo.Substring(0, 3) == "962") && ctrl == "SMARTCELL")//smartcell
            {
                productid = "4";
            }
            else if ((MobileNo.Substring(0, 3) == "972") && ctrl == "UTL")//UTL
            {
                productid = "3";

            }
            else
            {
                productid = "0";
                return Json(new { Denomitation }, JsonRequestBehavior.AllowGet);
            }
            Dictionary<string, string> dictonary = new Dictionary<string, string>();
            dictonary.Add("Subscriberno", MobileNo);
            Denomitation = getdenominationlist(productid, dictonary);

            return Json(new { Denomitation }, JsonRequestBehavior.AllowGet);
        }
        */
        public Dictionary<string, string> getdenominationlist(string extra1, Dictionary<string, string> dictionary = null)
        {
            string UserId = ApplicationUtilities.GetSessionValue("userid").ToString();
            string IpAddress = ApplicationUtilities.GetIP().ToString();
            dictionary.Add("UserId", UserId);
            dictionary.Add("IpAddress", IpAddress);
            return _ICB.Denomination(extra1, dictionary);
        }

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
            return RedirectToAction("LandLinePayment");
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
            return RedirectToAction("LandLinePayment");
        }
    }
}