using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.Utilities
{
    public class NwscBillInquiryModel: ProductDetailsModel
    {
        public string OfficeCode { get; set; }
        public string CustomerId { get; set; }
      
    }
    public class NwscBillInquiryResponseModel:ProductDetailsModel
    {
        public string EncryptedContent { get; set; }
        public string CustomerId
        { get; set; }
        public string CustomerName
        { get; set; }
        public string Area
        { get; set; }
        public string Lagat
        { get; set; }
        public string OfficeCode
        { get; set; }
        public string Office
        { get; set; }
        public string TotalDueAmount
        { get; set; }
        public string TotalServiceCharge
        { get; set; }
        public List<NwscBillInquiryDetailModel> BillDetail
        { get; set; }
    }
    public class NwscBillInquiryDetailModel
    {
        public string BillFrom
        { get; set; }
        public string BillTo
        { get; set; }
        public string BillAmount
        { get; set; }
        public string FineAmount
        { get; set; }
        public string MeterRent
        { get; set; }
        public string DiscountAmount
        { get; set; }
        public string PayableAmount
        { get; set; }
    }
    public class PrabhuPayNwscBillInquiryResponseModel
    {
        public string CustomerId
        { get; set; }
        public string CustomerName
        { get; set; }
        public string Area
        { get; set; }
        public string Lagat
        { get; set; }
        public string OfficeCode
        { get; set; }
        public string Office
        { get; set; }
        public string TotalDueAmount
        { get; set; }
        public string TotalServiceCharge
        { get; set; }
        public List<PrabhuPayNwscBillInquiryDetailModel> BillDetail
        { get; set; }
    }
    public class PrabhuPayNwscBillInquiryDetailModel
    {
        public string BillFrom
        { get; set; }
        public string BillTo
        { get; set; }
        public string BillAmount
        { get; set; }
        public string FineAmount
        { get; set; }
        public string MeterRent
        { get; set; }
        public string DiscountAmount
        { get; set; }
        public string PayableAmount
        { get; set; }
    }
    public class NwscBillPaymentModel
    {

        public string CustomerId { get; set; }
        public string OfficeCode { get; set; }
        public string ServiceCharge { get; set; }
        public string TotalDueAmount { get; set; }

        public string TransactionId { get; set; }
    }
  
}