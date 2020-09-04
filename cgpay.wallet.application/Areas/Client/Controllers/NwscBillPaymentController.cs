using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.application.Models.Utilities;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.DynamicReport;
using cgpay.wallet.business.Mobile;
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
    public class NwscBillPaymentController : Controller
    {
        INwscBillPaymentBusiness _nwsc;
        ICommonBusiness _ICB;
        IWalletUserBusiness _payment;
        IMobileTopUpPaymentBusiness _mtp;


        // GET: Client/NwscBillPayment

        public NwscBillPaymentController(INwscBillPaymentBusiness nwsc, ICommonBusiness ICB, IMobileTopUpPaymentBusiness mtp, IWalletUserBusiness payment)
        {
            _nwsc = nwsc;
            _ICB = ICB;
            _mtp = mtp;
            _payment = payment;
        }
        public ActionResult NwscBillInquiry()
        {
            NwscBillInquiryModel inq = new NwscBillInquiryModel();
            ViewBag.branchlist = ApplicationUtilities.SetDDLValue(Denomination("34"), "", "--Select Office--");
            var productdetails = GetNWSCproductDetails();

            inq.ProductLogo = productdetails.ProductLogo;
            return View(inq);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult NwscBillInquiry(NwscBillInquiryModel nwsc)
        {
            NwscBillInquiryCommon nbc = nwsc.MapObject<NwscBillInquiryCommon>();
            ViewBag.branchlist = ApplicationUtilities.SetDDLValue(Denomination("34"), "", "--Select Office--");
            var productdetails = GetNWSCproductDetails();
            nwsc.ProductLogo = productdetails.ProductLogo;


            nbc.IpAddress = ApplicationUtilities.GetIP();
            nbc.UserId = ApplicationUtilities.GetSessionValue("userid").ToString();

            var inquiry = _nwsc.GetNwscBill(nbc);
            NwscBillInquiryResponseModel nwspbillresp = new NwscBillInquiryResponseModel();
            if(inquiry.GatewayName.ToUpper()=="PRABHUPAY")
            {
                if (inquiry.Code == shared.Models.ResponseCode.Success)
                {
                    var obj = Newtonsoft.Json.JsonConvert.SerializeObject(inquiry.Data);
                    var prabhupayinqresp = Newtonsoft.Json.JsonConvert.DeserializeObject<PrabhuPayNwscBillInquiryResponseModel>(obj);
                    nwspbillresp.CustomerId = prabhupayinqresp.CustomerId;
                    nwspbillresp.CustomerName = prabhupayinqresp.CustomerName;
                    nwspbillresp.Area = prabhupayinqresp.Area;
                    nwspbillresp.Lagat = prabhupayinqresp.Lagat;
                    nwspbillresp.OfficeCode = prabhupayinqresp.OfficeCode;
                    nwspbillresp.Office = prabhupayinqresp.Office;
                    nwspbillresp.TotalDueAmount = prabhupayinqresp.TotalDueAmount;
                    nwspbillresp.TotalServiceCharge = prabhupayinqresp.TotalServiceCharge;
                    List<NwscBillInquiryDetailModel> lst = new List<NwscBillInquiryDetailModel>();
                    foreach(var item in prabhupayinqresp.BillDetail)
                    {
                        NwscBillInquiryDetailModel bill = new NwscBillInquiryDetailModel()
                        {
                            BillFrom = item.BillFrom,
                            BillTo = item.BillTo,
                            BillAmount = item.BillAmount,
                            FineAmount = item.FineAmount,
                            MeterRent = item.MeterRent,
                            DiscountAmount = item.DiscountAmount,
                            PayableAmount = item.PayableAmount,
                        };
                        lst.Add(bill);
                    }
                    nwspbillresp.BillDetail = lst;
                    nwspbillresp.EncryptedContent = (prabhupayinqresp.TotalDueAmount + prabhupayinqresp.TotalServiceCharge + prabhupayinqresp.CustomerId+prabhupayinqresp.OfficeCode).EncryptParameter();
                    return View("NwscBillPayment", nwspbillresp);

                }
                else
                {
                    this.ShowPopup(1, inquiry.Message);
                    return View(nwsc);
                }
            }
            this.ShowPopup(1, "Service Unavaliable");
            return View(nwsc);

        }
        [HttpPost,ValidateAntiForgeryToken]
        public ActionResult NwscBillPayment(NwscBillInquiryResponseModel Response)
        {
            if(Response.EncryptedContent.DecryptParameter()!= Response.TotalDueAmount + Response.TotalServiceCharge + Response.CustomerId + Response.OfficeCode)
            {
                this.ShowPopup(1, "Data Mismatch");
                return RedirectToAction("NwscBillInquiry");
            }
            NwscBillPaymentModel payment = new NwscBillPaymentModel();
            payment.CustomerId = Response.CustomerId;
            payment.TotalDueAmount = Response.TotalDueAmount;
            payment.ServiceCharge = Response.TotalServiceCharge;
            payment.OfficeCode = Response.OfficeCode;


            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(payment);
            MobileTopUpPaymentRequest mtpr = new MobileTopUpPaymentRequest()
            {
                action_user = Session["UserName"].ToString(),
                product_id = Response.ProductId,
                amount = payment.TotalDueAmount,
                subscriber_no = payment.CustomerId,
                quantity = "",
                additonal_data = jstring
            };
            var response = _mtp.MobileTopUpPaymentRequest(mtpr);
            if(response.Code==0)
            {
                payment.TransactionId = response.Extra1;
                NwscBillPaymentCommon pcommon = payment.MapObject<NwscBillPaymentCommon>();

                var amt = payment.TotalDueAmount.Contains(".") ? payment.TotalDueAmount.Split('.')[0].ToString() : payment.TotalDueAmount;
                payment.TotalDueAmount = amt;
                var paymentresponse = _nwsc.BillPayment(pcommon);
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
                        data.amount = pcommon.TotalDueAmount;

                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        //data.product_id = pcommon.;
                       //data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                        return RedirectToAction("ResultPage", "NwscBillPayment", new { payment = ppresponse });

                    }
                    else if (paymentresponse.Code == shared.Models.ResponseCode.Exception)
                    {

                        var ppresponse = (prabhupay.service.data.ReturnTransaction)paymentresponse.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["username"].ToString();
                        data.transaction_id = response.Extra1;
                        data.refstan = ppresponse.TransactionId;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = pcommon.TotalDueAmount;

                        data.status_code = ppresponse.Code;
                        data.remarks = ppresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        //data.product_id = pcommon.;
                        data.partner_txn_id = ppresponse.TransactionId;
                        response = _mtp.MobileTopUpPaymentResponse(data);
                        failed = false;
                        return RedirectToAction("ResultPage", "NwscBillPayment", new { payment = ppresponse });

                    }
                    else
                    {
                        var ppresponse = (prabhupay.service.data.ReturnTransaction)paymentresponse.Data;
                        var data = new MobileTopUpPaymentUpdateRequest();
                        data.action_user = Session["UserName"].ToString();
                        data.transaction_id = response.Extra1;
                        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
                        data.amount = pcommon.TotalDueAmount;
                        data.status_code = ((int)paymentresponse.Code).ToString();
                        data.remarks = paymentresponse.Message;
                        data.ip_address = ApplicationUtilities.GetIP();
                        //data.product_id = pcommon.ProductId;
                        response = _mtp.MobileTopUpPaymentResponse(data);


                    }

                    response.SetMessageInTempData(this, "NwscPayment");
                    if (failed)
                    {
                        NwscBillInquiryModel query = new NwscBillInquiryModel()
                        {
                            CustomerId = payment.CustomerId,
                            OfficeCode = payment.OfficeCode,
                         
                        };
                        return RedirectToAction("NwscBillInquiry", new { INQ = query });

                    }
                }

              
            }
            response.SetMessageInTempData(this, "NEAPayment");
            NwscBillInquiryModel que = new NwscBillInquiryModel()
            {
                CustomerId = payment.CustomerId,
                OfficeCode = payment.OfficeCode,

            };
            return RedirectToAction("NwscBillInquiry", new { INQ = que });

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

           

            return RedirectToAction("NwscBillInquiry");
        }
        [OverrideActionFilters]
        public ProductDetailsModel GetNWSCproductDetails()
        {
            ProductDetailsModel response = new ProductDetailsModel();
            string userid = Session["UserId"].ToString();
            var serviceslist = _payment.ServiceDetail(userid);
            var serviceInfo = serviceslist.FirstOrDefault(x => x.ProductId == "34");
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
        public Dictionary<string, string> Denomination(string extra1)
        {

            Dictionary<string, string> dictionary = new Dictionary<string, string>();
            string UserId = ApplicationUtilities.GetSessionValue("username").ToString();
            string IpAddress = ApplicationUtilities.GetIP().ToString();
            dictionary.Add("UserId", UserId);
            dictionary.Add("IpAddress", IpAddress);
            var oflist = _ICB.Denomination(extra1, dictionary);
            var list = oflist.ToDictionary(x => x.Value, x => x.Key);

            return list;
        }
    }
}