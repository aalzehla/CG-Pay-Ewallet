using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.application.Models.Utilities;
using cgpay.wallet.application.Models.Utilities.WorldLink;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.DynamicReport;
using cgpay.wallet.business.Mobile;
using cgpay.wallet.business.TransactionLimit;
using cgpay.wallet.business.Utilities;
using cgpay.wallet.shared.Models.Mobile;
using cgpay.wallet.shared.Models.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    [SessionExpiryFilterAttribute]

    public class WorldLinkBillPaymentController : Controller
    {
        // GET: Client/WorldLinkBillPayment
        IWalletUserBusiness _payment;
        IWorldLinkBillPaymentBusiness _wlink;
        IMobileTopUpPaymentBusiness _mtp;
        ITransactionLimitBusiness _transactionLimit;

        public WorldLinkBillPaymentController(IWorldLinkBillPaymentBusiness wlink, IWalletUserBusiness payment, IMobileTopUpPaymentBusiness mtp, ITransactionLimitBusiness transactionLimit)
        {
            _wlink = wlink;
            _payment = payment;
            _mtp = mtp;
            _transactionLimit = transactionLimit;
        }

        public ActionResult WlinkBillInquiry()
        {
            WorldLinkBillInquiryModel wpm = new WorldLinkBillInquiryModel();
            var productdetails = GetWorldLinkproductDetails();
            wpm.ProductLogo = productdetails.ProductLogo;

            string AgentId = Session["AgentId"].ToString();
            var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
            var trangrid = ProjectGrid.TransactionLimit(TxnLimit);
            ViewData["trangrid"] = trangrid;

            return View(wpm);
        }
        [HttpPost,ValidateAntiForgeryToken]
        public ActionResult WlinkBillInquiry(WorldLinkBillInquiryModel wpm)
        {
            

            WorldLinkBillInquiryCommon wpc = wpm.MapObject<WorldLinkBillInquiryCommon>();
            var productdetails = GetWorldLinkproductDetails();
            wpm.ProductLogo = productdetails.ProductLogo;
            wpm.CommissionType = productdetails.CommissionType;
            wpm.CommissionValue = productdetails.CommissionValue;

            wpc.IpAddress = ApplicationUtilities.GetIP();
            wpc.UserId = ApplicationUtilities.GetSessionValue("userid").ToString();
            var inquiry = _wlink.CheckWlinkAccount(wpc);
            WorldLinkBillInquiryResponseModel wlink = new WorldLinkBillInquiryResponseModel();
            wlink.ProductLogo = productdetails.ProductLogo;
            wlink.CommissionType = productdetails.CommissionType;
            wlink.CommissionValue = productdetails.CommissionValue;
            wlink.ProductId = productdetails.ProductId.EncryptParameter();
            if (inquiry.GatewayName.ToUpper() == "PRABHUPAY")
            {
                if (inquiry.Code == shared.Models.ResponseCode.Success)
                {
                    var obj = Newtonsoft.Json.JsonConvert.SerializeObject(inquiry.Data);
                    var prabhupayinqresp = Newtonsoft.Json.JsonConvert.DeserializeObject<PrabhuPayWorldLinkBillInquiryResponseModel>(obj);
                    wlink.CustomerName = prabhupayinqresp.CustomerName;
                    wlink.WlinkUserName = prabhupayinqresp.WlinkUserName;
                    wlink.PaymentMessage = prabhupayinqresp.PaymentMessage;
                    List<PlansModel> lst = new List<PlansModel>();
                    foreach (var item in prabhupayinqresp.RenewalPlans)
                    {
                        PlansModel plan = new PlansModel()
                        {
                            PlanId = item.PlanId,
                            PlanAmount = item.PlanAmount,
                            PlanName = item.PlanName,
                            PlanDescription = item.PlanDescription
                        };
                        lst.Add(plan);
                    }
                    //wlink.RenewalPlans = lst;
                    //var planlst = DropdownPlan(lst);
                    //if (planlst == null)
                    //{
                    //    ViewBag.Planlist = null;
                    //}
                    ViewBag.Planlist = ApplicationUtilities.SetDDLValue(DropdownPlan(lst), "", "--Select--");
                    wlink.Encryptioncontent = (prabhupayinqresp.WlinkUserName+prabhupayinqresp.BillAmount).EncryptParameter();

                    string AgentId = Session["AgentId"].ToString();
                    var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
                    var trangrid = ProjectGrid.TransactionLimit(TxnLimit);
                    ViewData["trangrid"] = trangrid;

                    return View("WlinkBillPayment", wlink);
                }
                else
                {
                    string AgentId = Session["AgentId"].ToString();
                    var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
                    var trangrid = ProjectGrid.TransactionLimit(TxnLimit);
                    ViewData["trangrid"] = trangrid;

                    this.ShowPopup(1, inquiry.Message);
                    return View(wpm);
                }
            }
            this.ShowPopup(1, "Service Unavaliable");
            return View(wpm);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult WlinkBillPayment(WorldLinkBillInquiryResponseModel Response)
        {
            if (Response.Encryptioncontent.DecryptParameter() != (Response.WlinkUserName + Response.BillAmount))
            {
                this.ShowPopup(1, "Data Mismatch");
                return RedirectToAction("WlinkBillInquiry");
            }
            if(string.IsNullOrEmpty( Response.BillAmount)&&string.IsNullOrEmpty(Response.RenewalPlans))
            {
                this.ShowPopup(1, "Invalid Plan");
                return View(Response);
            }
            WorldLinkBillPaymentModel payment = new WorldLinkBillPaymentModel();
            if (!string.IsNullOrEmpty(Response.RenewalPlans))
            {
                var plan = Response.RenewalPlans;
                var plansplit = plan.Split('|');
                payment.WlinkUserName = Response.WlinkUserName;
                if (plansplit.Length == 2)
                {
                    payment.Amount = plansplit[0];
                    payment.PlanId = plansplit[1];
                }
                else
                {
                    this.ShowPopup(1, "Select Plan Invalid");
                    return RedirectToAction("WlinkBillInquiry");
                }
            }
            else
            {
                payment.Amount = Response.BillAmount;
            }
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(payment);
            MobileTopUpPaymentRequest mtpr = new MobileTopUpPaymentRequest()
            {
                action_user = Session["UserName"].ToString(),
                product_id = Response.ProductId.DecryptParameter(),
                amount = payment.Amount,
                subscriber_no = payment.WlinkUserName,
                quantity = "",
                additonal_data = jstring,
                CreatedIp = ApplicationUtilities.GetIP()
            };
            var response = _mtp.MobileTopUpPaymentRequest(mtpr);
            if (response.Code == 0)
            {
                payment.TransactionId = response.Extra1;
                WorldLinkBillPaymentCommon pcommon = new WorldLinkBillPaymentCommon();
                var amt = payment.Amount.Contains(".") ? payment.Amount.Split('.')[0].ToString() : payment.Amount;
                payment.Amount = amt;
                pcommon = payment.MapObject<WorldLinkBillPaymentCommon>();
                var paymentresponse = _wlink.BillPayment(pcommon);
                bool failed = true;
                if (paymentresponse.GatewayName == "PRABHUPAY")
                {
                    if (paymentresponse.Code == shared.Models.ResponseCode.Success)
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)paymentresponse.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["username"].ToString();
                        data.refstan = ppresponse.TransactionId;
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = pcommon.Amount;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                        //return RedirectToAction("ResultPage", "WorldLinkBillPayment", new { txnid = ppresponse });
                        return RedirectToAction("ResultPage", "WorldLinkBillPayment", new { txnid = response.Extra1.EncryptParameter() });

                    }
                    else if (paymentresponse.Code == shared.Models.ResponseCode.Exception)
                    {

                        var ppresponse = (prabhupay.service.data.ReturnTransaction)paymentresponse.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["username"].ToString();
                        data.transaction_id = response.Extra1;
                        data.refstan = ppresponse.TransactionId;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = pcommon.Amount;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        //data.product_id = pcommon.;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                        return RedirectToAction("ResultPage", "WorldLinkBillPayment", new { txnid = response.Extra1.EncryptParameter() });
                    }
                    else
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)paymentresponse.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = pcommon.Amount;
                        data.status_code = ((int)paymentresponse.Code).ToString();
                        data.remarks = paymentresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        //data.product_id = pcommon.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                    }

                    response.SetMessageInTempData(this, "WorldLinkBillPayment");
                    if (failed)
                    {
                        WorldLinkBillInquiryCommon query = new WorldLinkBillInquiryCommon()
                        {
                            WlinkUserName = payment.WlinkUserName

                        };
                        return RedirectToAction("WlinkBillInquiry", new { wpm = query });

                    }
                }
            }
            response.SetMessageInTempData(this, "WorldLinkBillPayment");

            WorldLinkBillInquiryCommon que = new WorldLinkBillInquiryCommon()
            {
                WlinkUserName = payment.WlinkUserName

            };
            return RedirectToAction("WlinkBillInquiry", new { wpm = que });
        }
        public Dictionary<string, string> DropdownPlan(List<PlansModel> lst)
        {
            Dictionary<string, string> Dist = new Dictionary<string, string>();
            foreach (var item in lst)
            {
                Dist.Add(item.PlanAmount + "|" + item.PlanId,item.PlanName );
            }
            return Dist;

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



            return RedirectToAction("WlinkBillInquiry");
        }

        public ProductDetailsModel GetWorldLinkproductDetails()
        {
            ProductDetailsModel response = new ProductDetailsModel();
            string userid = Session["UserId"].ToString();
            var serviceslist = _payment.ServiceDetail(userid);
            var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "29");
            response.Code = "0";
            response.Message = serviceInfo.ProductLabel;
            response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
            response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
            response.MaxAmount += string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
            response.ProductId += serviceInfo.ProductId;
            response.CommissionValue += serviceInfo.CommissionValue;
            response.CommissionType += serviceInfo.CommissionType;
            //response.ServiceCode = "1";
            //response.CompanyCode = "598";
            return response;
        }

    }
}