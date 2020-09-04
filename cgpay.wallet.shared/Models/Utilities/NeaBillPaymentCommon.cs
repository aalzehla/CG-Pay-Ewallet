using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Utilities
{
    public class NeaBranchCommon
    {
        public string  OfficeCode { get; set; }
        public string  OfficeName { get; set; }
    }    

    public class NeaBillInquiryCommon:Common
    {
        public string OfficeCode { get; set; }
        //public string BranchName { get; set; }
        public string ConsumerId { get; set; }
        public string ScNo { get; set; }
    }
    public class NeaBillInquiryResponseCommon
    {
        public string OfficeCode { get; set; }
        public string ScNo { get; set; }
        public string ConsumerId { get; set; }
        public string CustomerName { get; set; }
        public string OfficeName { get; set; }
        public string ReceiptNo { get; set; }//reference no
        public string TotalDueAmount { get; set; }
    }

    public class NeaBillChargeCommon:Common
    {
        public string OfficeCode { get; set; }
        public string ConsumerId { get; set; }
        public string ScNo { get; set; }
        public string PayableAmount { get; set; }

    }

    public class NeaBillPaymentCommon:ProductDetailsCommon
    {
        public string OfficeCode { get; set; }
        public string ConsumerId { get; set; }
        public string ScNo { get; set; }
        public string BillAmount { get; set; }
        public string BillNumber { get; set; }
        public string DueDate { get; set; }
        public string ReferenceNo { get; set; }
        public string CustomerName { get; set; }
        public string TransactionId { get; set; }
        public string PayableAmount { get; set; }
        
        public string Charges { get; set; }
        
        public string TotalPayingAmount { get; set; }
    }
   
}
