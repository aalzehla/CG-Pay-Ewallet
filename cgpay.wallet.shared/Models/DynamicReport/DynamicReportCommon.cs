using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.DynamicReport
{
    public class DynamicReportCommon
    {
        public string AgentId { get; set; }
        public string UserId { get; set; }
        public string TxnId { get; set; }
        public string TxnType { get; set; }
        public string TxnStatus { get; set; }
        public string TxnDate { get; set; }
        public string TxnTitle { get; set; }
        public string TxnMode { get; set; }
        public string ParentId { get; set; }
        public string GrandparentId { get; set; }
        public string ProductId { get; set; }
        public string ProductName { get; set; }
        public string GatewayId { get; set; }
        public string GatewayName { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Status { get; set; }
        public string DistributorId { get; set; }
        public string SubDistId { get; set; }
        public string ProductType { get; set; }
        public string CreatedBy { get; set; }
        public string ActionUser { get; set; }
        public string SubscriberNo { get; set; }
        public string Amount { get; set; }
        public string Remarks { get; set; }
        //For Details
        public string CompanyId { get; set; }
        public string Company { get; set; }
        public string ServiceCharge { get; set; }
        public string BonusAmount { get; set; }
        public string StatusCode { get; set; }
        public string CreatedLocalDate { get; set; }
        public string CreatedPlatform { get; set; }
        public string AdminCommission { get; set; }
        public string AgentCommission { get; set; }
        public string ParentCommission { get; set; }
        public string GrandParentCommission { get; set; }
        public string CommissionEarned { get; set; }
        
        
        public string TxnRewardPoint { get; set; }
        public string CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string PlanId { get; set; }
        public string PlanName { get; set; }
        public string ExtraField1 { get; set; }
        public string ExtraField2 { get; set; }
        public string ExtraField3 { get; set; }
        public string ExtraField4 { get; set; }
        public string AdminRemarks { get; set; }
        public string Debit { get; set; }
        public string Credit { get; set; }
        public string Currency { get; set; }
        public string BankName { get; set; }



    }

    public class DynamicReportFilter
    {
        public List<DynamicReportCommon> reportlist { get; set; }
       [Display(Name="Transaction Type")]
        public string TxnType { get; set; }
        [Display(Name = "Transaction Status")]
        public string TxnStatus { get; set; }
        public string Service { get; set; }
        [Display(Name = "Search")]
        public string UserName { get; set; }
        [Display(Name = "From Date (AD)")]
        public string FromDate { get; set; }
        [Display(Name = "To Date (AD)")]
        public string ToDate { get; set; }
        [Display(Name = "From Date (BS)")]
        public string NepFromDate { get; set; }
        [Display(Name = "To Date (BS)")]
        public string NepToDate { get; set; }
        public string UserId { get; set; }
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }
        [Display(Name = "Mobile Number")]
        public string MobileNumber { get; set; }
        [Display(Name = "Payment Gateway Id")]
        public string GatewayId { get; set; }
        [Display(Name = "Payment Gateway Transaction Id")]
        public string PgTxnId { get; set; }
        [Display(Name = "Transaction Id")]
        public string TxnId { get; set; }
        [Display(Name = "Merchant Name")]
        public string MerchantId { get; set; }
        [Display(Name = "Product Id")]
        public string ProductId { get; set; }
    }

    public class PaymentGatewayTransactionReport
    {
        [Display(Name = "Transaction Id")]
        public string TxnId { get; set; }
        public string Amount { get; set; }
        [Display(Name = "Service Charge")]
        public string ServiceCharge { get; set; }
        [Display(Name = "Total Amount")]
        public string TotalAmount { get; set; }
        public string Status { get; set; }
        [Display(Name = "Gateway Name")]
        public string GatewayName { get; set; }
        [Display(Name = "Gateway Txn Id")]
        public string GatewayTxnId { get; set; }
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }
        [Display(Name = "User Id")]
        public string UserId { get; set; }
        [Display(Name = "Transaction Type")]
        public string TxnType { get; set; }
        [Display(Name = "Agent Name")]
        public string AgentName { get; set; }
        [Display(Name = "Created Date")]
        public string CreatedDate { get; set; }
        public string Action { get; set; }
    }

    public class MerchantTransactionCommon
    {
        public string MerchantId { get; set; }      
        public string MerchantCode { get; set; }      
        public string MerchantName { get; set; }      
        public string Amount { get; set; }      
        public string CommissionAmt { get; set; }      
        public string UserId { get; set; }      
        public string TxnId { get; set; }      
        public string CreatedDate { get; set; }      
    }

    public class ManualCommissionReportCommon
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Mobile Number is required")]
        [Display(Name = "Mobile Number")]
        public string MobileNumber { get; set; }
        [Display(Name = "From Date (AD)")]
        public string FromDate { get; set; }
        [Display(Name = "To Date (AD)")]
        public string ToDate { get; set; }
        [Display(Name = "From Date (BS)")]
        public string NepFromDate { get; set; }
        [Display(Name = "To Date (BS)")]
        public string NepToDate { get; set; }
        [Display(Name = "User Id")]
        public string UserId { get; set; }
    }
    public class SettlementReportCommon
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Mobile Number is required")]
        [Display(Name = "Mobile Number")]
        public string MobileNumber { get; set; }
        [Display(Name = "From Date (AD)")]
        public string FromDate { get; set; }
        [Display(Name = "To Date (AD)")]
        public string ToDate { get; set; }
        [Display(Name = "From Date (BS)")]
        public string NepFromDate { get; set; }
        [Display(Name = "To Date (BS)")]
        public string NepToDate { get; set; }
        [Display(Name = "User Id")]
        public string UserId { get; set; }
    }

    public class AdminCommissionReportCommon
    {
        public string TransactionDate { get; set; }
        public string TransactionId { get; set; }
        public string Service { get; set; }
        public string ProductId { get; set; }
        public string TransactionType { get; set; }
        public string TotalTransaction { get; set; }
        public string TotalAmount { get; set; }
        public string CommissionEarned { get; set; }
        public string SubscriberNo { get; set; }
        public string CreatedDate { get; set; }
        public string GatewayTxnId { get; set; }
        public string CreatedBy { get; set; }
        public string AdminCommission { get; set; }
        public string AdminCostAmount { get; set; }
        public string AdminRemark { get; set; }
        public string AgentRemark { get; set; }
        public string GatewayName { get; set; }
        public string AgentName { get; set; }
        public string ServiceCharge { get; set; }
        public string Status { get; set; }
        public string BonusAmount { get; set; }
        public string Company { get; set; }
        public string Action { get; set; }
    }
}
