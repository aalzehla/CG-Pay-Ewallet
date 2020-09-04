using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.Utilities
{
    public class NeaBranchModel
    {
        public string BranchCode { get; set; }
        public string BranchName { get; set; }
    }
    public class NeaBillInquiryModel
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Select Branch")]
        [Display(Name = "Branch")]
        public string OfficeCode { get; set; }
        //public string BranchName { get; set; }
        [Display(Name = "Consumer Id")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Enter Customer Id")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "Invalid Consumer Id")]      
        public string ConsumerId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Enter SC No")]
        [Display(Name = "SC No")]
        [RegularExpression(@"^[0-9][0-9.]*[A-za-z0-9]*$", ErrorMessage = "Not Valid Eg: 013.01.001 , 013.01.001KA ")]        
        public string ScNo { get; set; }
    }

    public class PrabhuPayNeaBillInquiryResponseModel
    {
        
        public string Office { get; set; }
        public string ScNo { get; set; }
        public string ConsumerId { get; set; }
        public string CustomerName { get; set; }
        public string OfficeCode { get; set; }
        public string ReceiptNo { get; set; }
        public string TotalDueAmount { get; set; }        
        public List<PrabhuPayNeaBill> BillDetail { get; set; }
    }
    public class PrabhuPayNeaBill
    {
        public string DueBillOf { get; set; }
        public string PayableAmount { get; set; }
        public string BillDate { get; set; }
        public string NoOfDays { get; set; }
        public string BillAmount { get; set; }
        public string Status { get; set; }
    }

    /*
    public class PayPointNeaBillInquiryResponseModel
    {
        public string Result { get; set; }
        public string ResultMessage { get; set; }
        public List<Bill> Billinfo { get; set; }
        public string RefStan { get; set; }
        public string BillNo { get; set; }
        public string Amount { get; set; }
    }
   
    public class Bill
    {
        public string _totalAmount { get; set; }
        public string _pointName { get; set; }
        public string _pointId { get; set; }
        public string _customerId { get; set; }
        public string _account { get; set; }
        public string _description { get; set; }
        public string _billDate { get; set; }
        public string _billAmount { get; set; }
        public string _status { get; set; }
        public string _destination { get; set; }
    }
    */

    public class NeaBillInquiryResponseModel
    {
        public string OfficeCode { get; set; }
        public string ScNo { get; set; }
        public string CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string OfficeName { get; set; }
        public string ReceiptNo { get; set; }//reference no
        public string TotalDueAmount { get; set; }
        public List<NeaBill> BillDetail { get; set; }
    }
    public class NeaBill
    {
        public string DueDate { get; set; }
        public string PayableAmount { get; set; }
        public string BillDateOf { get; set; }
        public string NoOfDays { get; set; }
        public string BillAmount { get; set; }
        public string Status { get; set; }
    }


    /*
    public class NeaBillInquiryResponseModel
    {
        public string BranchCode { get; set; }
        public string CustomerId { get; set; }
        public string ScNo { get; set; }
        public string BillAmount { get; set; }
        public string BillNumber { get; set; }
        public string DueDate { get; set; }
        public string ReferenceNo { get; set; }
        public string CustomerName { get; set; }
        public string TransactionId { get; set; }
    }*/

    public class NeaBillChargeModel 
    { 
        public string OfficeCode { get; set; }
        public string ConsumerId { get; set; }
        public string ScNo { get; set; }
        public string PayableAmount { get; set; }
       
    }
    public class NeaServiceChargeModel
    {
        public string Code { get; set; }
        public string Message { get; set; }
        public string SCharge { get; set; }
    }


    public class NeaBillPaymentModel:ProductDetailsModel
    {
        //public string ProductId { get; set; }
        //public string CommissionType { get; set; }
        //public string CommissionValue { get; set; }
        public string TxnLimitMax { get; set; }
        public string TxnDailyLimitMax { get; set; }
        public string TxnMonthlyLimitMax { get; set; }
        public string TxnDailyRemainingLimit { get; set; }
        public string TxnMonthlyRemainingLimit { get; set; }
        public string BranchName { get; set; }
        public string OfficeCode { get; set; }
        public string ConsumerId { get; set; }
        public string ScNo { get; set; }
        public string BillAmount { get; set; }
        public string BillNumber { get; set; }
        public string DueDate { get; set; }
        public string ReferenceNo { get; set; }
        public string CustomerName { get; set; }
        public string TransactionId { get; set; }
        [Required]
        [Display(Name = "Payable Amount")]
        public string PayableAmount { get; set; }
        [Display(Name ="Make Advance Payment")]
        public bool MakeAdvancePayment { get; set; }
        public List<Neabilldetail> BillDetail { get; set; }
        public string EncryptedContent { get; set; }
        [Required]
        [Display(Name = "Charges")]

        public string Charges { get; set; }
        [Required]
        [Display(Name = "Total Amount")]

        public string TotalPayingAmount { get; set; }
  
    }
    public class Neabilldetail
    {
        public string DueDate { get; set; }
        public string PayableAmount { get; set; }
        public string BillDateOf { get; set; }
        public string NoOfDays { get; set; }
        public string BillAmount { get; set; }
        public string Status { get; set; }
    }


    public class NeaBillPaymentResponseModel
    {
        public string OfficeCode { get; set; }
        public string ScNo { get; set; }
        public string ConsumerId { get; set; }
        public string CustomerName { get; set; }
        public string OfficeName { get; set; }
        public string ReceiptNo { get; set; }//reference no
        //public string TotalDueAmount { get; set; }
        public List<NeaBillPayment> BillDetail { get; set; }
    }
    public class NeaBillPayment
    {
        public string DueBillOf { get; set; }
        public string PayableAmount { get; set; }
        public string BillDate { get; set; }
        public string NoOfDays { get; set; }
        public string BillAmount { get; set; }
        public string Status { get; set; }
        public string PaidAmt { get; set; }
        public string AdvancePaid { get; set; }
    }



}