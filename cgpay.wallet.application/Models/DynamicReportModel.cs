
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class DynamicReportModel
    {
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }

        [Display(Name = "User Id")]
        public string UserId { get; set; }
        [Display(Name = "Transaction Id")]
        public string TxnId { get; set; }
        [Display(Name = "Transaction Type")]
        public string TxnType { get; set; }
        public string TxnStatus { get; set; }
        public string TxnDate { get; set; }
        public string ParentId { get; set; }
        public string GrandparentId { get; set; }
        public string ProductId { get; set; }
        [Display(Name = "Product Name")]
        public string ProductName { get; set; }
        public string GatewayId { get; set; }
        public string GatewayName { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Status { get; set; }
        public string DistributorId { get; set; }
        public string SubDistId { get; set; }
        public string ProductType { get; set; }

        [Display(Name = "Created By")]
        public string CreatedBy { get; set; }
      
        public string ActionUser { get; set; }
        [Display(Name = "Subscriber Number")]
        public string SubscriberNo { get; set; }
        public string Amount { get; set; }
        public string Remarks { get; set; }
        //For Details
        [Display(Name = "Company Id")]
        public string CompanyId { get; set; }
        public string Company { get; set; }
        [Display(Name = "Service Charge")]
        public string ServiceCharge { get; set; }
        [Display(Name = "Bonus Amount")]
        public string BonusAmount { get; set; }
        public string StatusCode { get; set; }
        [Display(Name = "Created Local Date")]
        public string CreatedLocalDate { get; set; }
        public string CreatedPlatform { get; set; }
        [Display(Name = "Admin Commission")]
        public string AdminCommission { get; set; }
        [Display(Name = "Agent Commission")]
        public string AgentCommission { get; set; }
        public string GrandParentCommission { get; set; }
        [Display(Name = "Parent Commission")]
        public string ParentCommission { get; set; }
        [Display(Name = "Commission Earned")]
        public string CommissionEarned { get; set; }
        
        [Display(Name = "Transaction Reward Point")]
        public string TxnRewardPoint { get; set; }
        public string CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string PlanId { get; set; }
        public string PlanName { get; set; }
        public string ExtraField1 { get; set; }
        public string ExtraField2 { get; set; }
        public string ExtraField3 { get; set; }
        public string ExtraField4 { get; set; }
        [Display(Name = "Remarks")]
        public string AdminRemarks { get; set; }
        public string Action { get; set; }
        public string Debit { get; set; }
        public string Credit { get; set; }
        public string Currency { get; set; }
        public string BankName { get; set; }

    }
}