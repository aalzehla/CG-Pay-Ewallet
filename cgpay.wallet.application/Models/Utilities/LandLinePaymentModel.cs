using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.Utilities
{
    public class LandLinePaymentModel
    {
        public string ClientId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "LandLine Number is required")]
        [Display(Name = "LandLine Number")]
        public string LandLineNo { get; set; }
        public string TxtTypeId { get; set; }
        public string TxtType { get; set; }
        public string CompanyId { get; set; }
        public string Company { get; set; }
        public string ProductId { get; set; }
        public string ProductTypeId { get; set; }
        public string ProductType { get; set; }
        public string ProductLabel { get; set; }
        public string ProductLogo { get; set; }
        public string ProductServiceInfo { get; set; }
        public string ProductCategory { get; set; }
        public string SubscriberRegex { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Amount is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
        public string MinAmount { get; set; }
        public string MaxAmount { get; set; }
        public string PrimaryGateway { get; set; }
        public string SecondaryGateway { get; set; }
        public string Status { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string CreatedNepaliDate { get; set; }
        public string CreatedIp { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDate { get; set; }
        public string UpdatedNepaliDate { get; set; }
        public string UpdatedIp { get; set; }
        public string CommissionValue { get; set; }
        public string CommissionType { get; set; }
        public string TxnLimitMax { get; set; }
        public string TxnDailyLimitMax { get; set; }
        public string TxnMonthlyLimitMax { get; set; }
        public string TxnDailyRemainingLimit { get; set; }
        public string TxnMonthlyRemainingLimit { get; set; }
        [Display(Name = "Have a Card?")]
        public string CardNo { get; set; }
        [Display(Name = "Amount of Card")]
        public string CardAmount { get; set; }
    }

    public class LandLineNumberValidation
    {
        public string Code { get; set; }
        public string Message { get; set; }
        public string ProductLogo { get; set; }
        public string MinAmount { get; set; }
        public string MaxAmount { get; set; }
        public string ProductId { get; set; }
        public string ProductLabel { get; set; }
        public string CommissionValue { get; set; }
        public string CommissionType { get; set; }
        public string ServiceCode { get; set; }
        public string CompanyCode { get; set; }
    }
}