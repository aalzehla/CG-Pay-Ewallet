using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.Utilities.Vianet
{
   

        public class VianetBillInquiryModel : ProductDetailsModel
        {
            [Required(AllowEmptyStrings = false, ErrorMessage = "CustomerId is required")]
            [Display(Name = "Customer Id")]
            public string VianetCustomerId { get; set; }
        }

        public class VianetBillInquiryResponseModel : ProductDetailsModel
        {
            public string Encryptioncontent { get; set; }
            public string VianetCustomerId { get; set; }
            public string CustomerName { get; set; }
            public string PaymentMessage { get; set; }
            public string BillAmount { get; set; }
            //public List<PlansModel> RenewalPlans { get; set; }
            [Display(Name = "Plan List")]
            public string RenewalPlans { get; set; }
        }
        public class PlansModel
        {
            public string PlanId { get; set; }
            public string PlanName { get; set; }
            public string PlanAmount { get; set; }
            public string PlanDescription { get; set; }
        }


        public class PrabhuPayVianetBillInquiryResponseModel
    {
            public string VianetCustomerId { get; set; }
            public string CustomerName { get; set; }
            public string PaymentMessage { get; set; }
            public string BillAmount { get; set; }
            public List<PrabhuPayPlansModel> RenewalPlans { get; set; }
            public string PlanSelect { get; set; }
        }
        public class PrabhuPayPlansModel
        {
            public string PlanId { get; set; }
            public string PlanName { get; set; }
            public string PlanAmount { get; set; }
            public string PlanDescription { get; set; }
        }


        public class VianetBillPaymentModel
        {
            public string VianetCustomerId { get; set; }
            public string PlanId { get; set; }
            public string Amount { get; set; }
            public string TransactionId { get; set; }
        }
    
}