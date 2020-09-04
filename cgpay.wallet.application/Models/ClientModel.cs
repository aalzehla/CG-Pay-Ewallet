using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class ClientModel
    {
        public string ClientId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Mobile Number is required")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
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
        public string Ctrl { get; set; }
    }
   

    public class MobileTopUpModel
    {
        public string ClientId { get; set; }
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
        public string Ctrl { get; set; }
    }

    public class NTPre : MobileTopUpModel
    {
        //[RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        [RegularExpression(@"^((984)|(986))([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
    public class NTPost : MobileTopUpModel
    {
        [RegularExpression(@"^(985)([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
    public class NTCdmaPre : MobileTopUpModel
    {
        //[RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        [RegularExpression(@"^((974)|(976))([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
    public class NTCdmaPost : MobileTopUpModel
    {
        //[RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        [RegularExpression(@"^((975))([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
    public class Ncell : MobileTopUpModel
    {
        [RegularExpression(@"^((980)|(981)|(982))([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
    public class SmartCell : MobileTopUpModel
    {
        [RegularExpression(@"^((961)|(962)|(988))([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
    public class UTL : MobileTopUpModel
    {
        //[RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        [RegularExpression(@"^((972))([0-9]{7})$", ErrorMessage = "Invalid mobile number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
    }
}