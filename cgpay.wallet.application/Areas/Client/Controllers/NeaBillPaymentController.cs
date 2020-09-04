using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models.Utilities;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.Mobile;
using cgpay.wallet.business.TransactionLimit;
using cgpay.wallet.business.Utilities;
using cgpay.wallet.shared.Models.Mobile;
using cgpay.wallet.shared.Models.Utilities;
using paypoint.service.data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    [SessionExpiryFilterAttribute]
    public class NeaBillPaymentController : Controller
    {
        // GET: Client/NeaBillPayment
        INeaBillPaymentBusiness _nea;

        IWalletUserBusiness _payment;
        IMobileTopUpPaymentBusiness _mtp;       
        ITransactionLimitBusiness _transactionLimit;
        ICommonBusiness _ICB;
        

        public NeaBillPaymentController(INeaBillPaymentBusiness nea, IMobileTopUpPaymentBusiness mtp, ITransactionLimitBusiness transactionLimit,IWalletUserBusiness payment, ICommonBusiness ICB)
        {
            _nea = nea;
            _mtp = mtp;
            _transactionLimit = transactionLimit;
            _payment = payment;
            _ICB = ICB;
        }
        public ActionResult NeaBillInquiry()
        {
            //Dictionary<string, string> list = new Dictionary<string, string>();
            ViewBag.branchlist = ApplicationUtilities.SetDDLValue(Denomination("26"), "", "--Select Branch--");
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult NeaBillInquiry(NeaBillInquiryModel INQ)
        {
            NeaBillInquiryCommon INC = INQ.MapObject<NeaBillInquiryCommon>();
            ViewBag.branchlist = ApplicationUtilities.SetDDLValue(Denomination("26"), INQ.OfficeCode, "--Select Branch--");
            INC.IpAddress = ApplicationUtilities.GetIP();
            INC.ActionUser = ApplicationUtilities.GetSessionValue("userid").ToString();
            var inquiry = _nea.GetPackage(INC);
            //if (inquiry.Code == shared.Models.ResponseCode.Success)
            //{
                NeaBillInquiryResponseModel neabillresponse = new NeaBillInquiryResponseModel();
                if (inquiry.GatewayName == "PRABHUPAY")
                {
                    if (inquiry.Code == shared.Models.ResponseCode.Success)
                    {

                        var obj = Newtonsoft.Json.JsonConvert.SerializeObject(inquiry.Data);
                        var prabhupayinq = Newtonsoft.Json.JsonConvert.DeserializeObject<PrabhuPayNeaBillInquiryResponseModel>(obj);
                        neabillresponse.OfficeCode = prabhupayinq.OfficeCode;
                        neabillresponse.OfficeName = prabhupayinq.Office;
                        neabillresponse.ScNo = prabhupayinq.ScNo;
                        neabillresponse.CustomerId = prabhupayinq.ConsumerId;
                        neabillresponse.CustomerName = prabhupayinq.CustomerName;
                        neabillresponse.TotalDueAmount = prabhupayinq.TotalDueAmount;
                        List<NeaBill> nb = new List<NeaBill>();
                        foreach (var item in prabhupayinq.BillDetail)
                        {
                            NeaBill pbill = new NeaBill()
                            {
                                DueDate = item.DueBillOf,
                                PayableAmount = item.PayableAmount,
                                BillDateOf = item.BillDate,
                                NoOfDays = item.NoOfDays,
                                BillAmount = item.BillAmount,
                                Status = item.Status
                            };
                            nb.Add(pbill);
                        }
                        neabillresponse.BillDetail = nb;
                        NeaBillPaymentModel payment=new NeaBillPaymentModel();

                        payment.BranchName = neabillresponse.OfficeName;
                        payment.CustomerName = neabillresponse.CustomerName;
                        payment.ConsumerId = neabillresponse.CustomerId;
                        payment.ScNo = neabillresponse.ScNo;
                        payment.OfficeCode = neabillresponse.OfficeCode;
                        payment.BillAmount = neabillresponse.TotalDueAmount;
                        payment.BillDetail = neabillresponse.BillDetail.MapObjects<Neabilldetail>();
                        payment.EncryptedContent = (payment.ScNo + payment.ConsumerId + payment.BillAmount).EncryptParameter();

                        //
                        var product = GetNEAproductDetails();
                        //  PM.DueDate = PM.DueDate.ToDateTime();
                        payment.ProductId = product.ProductId;
                        payment.ProductLogo = product.ProductLogo;
                        payment.MinAmount = product.MinAmount;
                        payment.MaxAmount = product.MaxAmount;
                        payment.CommissionType = product.CommissionType;
                        payment.CommissionValue = product.CommissionValue;
                        string AgentId = Session["AgentId"].ToString();
                        var TxnLimit = _transactionLimit.GetTransactionLimitForUser(AgentId);
                        payment.TxnLimitMax = TxnLimit.TxnLimitMax;
                        payment.TxnDailyLimitMax = TxnLimit.TxnDailyLimitMax;
                        payment.TxnMonthlyLimitMax = TxnLimit.TxnMonthlyLimitMax;
                        payment.TxnDailyRemainingLimit = TxnLimit.TxnDailyRemainingLimit;
                        payment.TxnMonthlyRemainingLimit = TxnLimit.TxnMonthlyRemainingLimit;
                        //
                        return View("NeaBillPayment", payment);
                    }
                    else
                    {
                        this.ShowPopup(1, inquiry.Message);
                        return View(INQ);
                    }

                }
            //}
           
            this.ShowPopup(1, "Service Unavaliable");
            return View(INQ);
        }

        [HttpPost,OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetCharges(string ConsumerId,string ScNo,string OfficeCode,string PayableAmount)
        {
            NeaBillChargeCommon charge = new NeaBillChargeCommon();
            charge.ConsumerId = ConsumerId;
            charge.ScNo = ScNo;
            charge.OfficeCode = OfficeCode;
            charge.PayableAmount = PayableAmount;
            charge.IpAddress = ApplicationUtilities.GetIP();
            charge.ActionUser = ApplicationUtilities.GetSessionValue("userid").ToString();
            var chargeamount = _nea.neabillCharges(charge);
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(chargeamount.Data);
            var obj = Newtonsoft.Json.JsonConvert.DeserializeObject<NeaServiceChargeModel>(jstring);
            return Json(obj.SCharge);
        }


        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult NeaBillPayment(NeaBillPaymentModel NBP, string ActionType)
        {
            if (ActionType != "submitaction")
            {
                return RedirectToAction("NeaBillInquiry");
            }
            if (NBP.EncryptedContent.DecryptParameter() != NBP.ScNo + NBP.ConsumerId + NBP.BillAmount)
            {
                return RedirectToAction("NeaBillInquiry");
            }
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(NBP);
            MobileTopUpPaymentRequest mtpr = new MobileTopUpPaymentRequest()
            {
                action_user = Session["UserName"].ToString(),
                product_id = NBP.ProductId,
                amount = NBP.TotalPayingAmount,
                subscriber_no = NBP.ScNo,
                quantity = "",
                additonal_data = jstring
            };
            var response = _mtp.MobileTopUpPaymentRequest(mtpr);
            
            if (response.Code == 0)
            {
                NBP.TransactionId = response.Extra1;
                NeaBillPaymentCommon NPC = NBP.MapObject<NeaBillPaymentCommon>();
                var amt = NBP.PayableAmount.Contains(".") ? NBP.PayableAmount.Split('.')[0].ToString() : NBP.PayableAmount;
                NPC.PayableAmount = amt;
                var payment = _nea.payment(NPC);
                bool failed = true;
                if (payment.GatewayName == "PRABHUPAY")
                {
                    if (payment.Code == shared.Models.ResponseCode.Success)
                    {

                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["username"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = NPC.PayableAmount;

                        data.refstan = ppresponse.TransactionId;
                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = NPC.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                        return RedirectToAction("ResultPage", "NeaBillPayment", new { payment = ppresponse });

                    }
                    else if(payment.Code == shared.Models.ResponseCode.Exception)
                    {

                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["username"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = NPC.PayableAmount;
                        data.refstan = ppresponse.TransactionId;

                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = NPC.ProductId;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                        return RedirectToAction("ResultPage", "NeaBillPayment", new { payment = ppresponse });

                    }
                    else
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)payment.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = NPC.PayableAmount;
                        data.status_code = ((int)payment.Code).ToString();
                        data.remarks = payment.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        data.product_id = NPC.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);


                    }
                }
             
                response.SetMessageInTempData(this, "NEAPayment");
                if (failed)
                {
                    NeaBillInquiryModel query = new NeaBillInquiryModel()
                    {
                        ConsumerId= NBP.ConsumerId,
                        OfficeCode = NBP.OfficeCode,
                        ScNo= NBP.ScNo
                    };
                    return RedirectToAction("NeaBillInquiry",new {INQ=query });

                }
               
            }
            response.SetMessageInTempData(this, "NEAPayment");
            NeaBillInquiryModel que = new NeaBillInquiryModel()
            {
                ConsumerId = NBP.ConsumerId,
                OfficeCode = NBP.OfficeCode,
                ScNo = NBP.ScNo
            };
            return RedirectToAction("NeaBillInquiry", new { INQ = que });
        }



        public ActionResult ResultPage(NeaBillPaymentModel payment)
        {
            var obj = Newtonsoft.Json.JsonConvert.SerializeObject(payment);
            var prabhupaypay = Newtonsoft.Json.JsonConvert.DeserializeObject<NeaBillPaymentResponseModel>(obj);
            //neabillresponse.OfficeCode = prabhupaypay.OfficeCode;
            //neabillresponse.OfficeName = prabhupaypay.OfficeName;
            //neabillresponse.ScNo = prabhupaypay.ScNo;
            //neabillresponse.CustomerId = prabhupaypay.CustomerId;
            //neabillresponse.CustomerName = prabhupaypay.CustomerName;
            //neabillresponse.TotalDueAmount = prabhupaypay.TotalDueAmount;
            //List<NeaBill> nb = new List<NeaBill>();
            //foreach (var item in prabhupayinq.BillDetail)
            //{
            //    NeaBill pbill = new NeaBill()
            //    {
            //        DueDate = item.DueDateOf,
            //        PayableAmount = item.PayableAmount,
            //        BillDateOf = item.BillDate,
            //        NoOfDays = item.NoOfDays,
            //        BillAmount = item.BillAmount,
            //        Status = item.Status
            //    };
            //    nb.Add(pbill);
            //}

            return View(prabhupaypay);
        }



        public ProductDetailsModel GetNEAproductDetails()
        {
            ProductDetailsModel response = new ProductDetailsModel();
            string userid = Session["UserId"].ToString();
            var serviceslist = _payment.ServiceDetail(userid);
            var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "26");
            response.Code = "0";
            response.Message = serviceInfo.ProductLabel;
            response.ProductLogo = "/Content/assets/images/service logos/" + serviceInfo.ProductLogo;
            response.MinAmount = string.IsNullOrEmpty(serviceInfo.MinAmount) ? "1" : serviceInfo.MinAmount;
            response.MaxAmount += string.IsNullOrEmpty(serviceInfo.MaxAmount) ? "1000" : serviceInfo.MaxAmount;
            response.ProductId += serviceInfo.ProductId;
            response.CommissionValue += serviceInfo.CommissionValue;
            response.CommissionType += serviceInfo.CommissionType;
            response.ServiceCode = "1";
            response.CompanyCode = "598";
            return response;
        }      

        public Dictionary<string, string> Denomination(string extra1)
        {

            Dictionary<string, string> dictionary = new Dictionary<string, string>();
            string UserId = ApplicationUtilities.GetSessionValue("userid").ToString();
            string IpAddress = ApplicationUtilities.GetIP().ToString();
            dictionary.Add("UserId", UserId);
            dictionary.Add("IpAddress", IpAddress);
            var oflist = _ICB.Denomination(extra1, dictionary);
            var list = oflist.ToDictionary(x => x.Value,x=>x.Key);
            
            return list;
        }

    }
}