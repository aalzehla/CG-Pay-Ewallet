using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Models
{
    public class MerchantModel:Common
    {
        public string MerchantType { get; set; }
        [Display(Name = "Merchant Id")]
        public string MerchantID { get; set; }
        public string ParentID { get; set; }
        [Display(Name = "Merchant Operation Type")]
        public string MerchantOperationType { get; set; }
        [Display(Name = "Merchant Commission Type")]
        public bool MerchantCommissionType { get; set; }
        public string MerchantStatus { get; set; }
        [Display(Name = "Merchant Name ")]
        public string MerchantName { get; set; }
        public string MerchantCode { get; set; }
        [Display(Name = "Merchant Contact Number ")]
        public string MerchantPhoneNumber { get; set; }
        [Display(Name = "Merchant Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "Mobile Number Invalid")]
        public string MerchantMobileNumber { get; set; }
        [Display(Name = "Merchant Email")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Email Format Invalid")]
        public string MerchantEmail { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant URL is required")]
        [Display(Name = "Merchant URL")]
        public string MerchantWebUrl { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant Registration Number is required")]
        [Display(Name = "Merchant Registration Number")]
        public string MerchantRegistrationNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant Pan/VAT No is required")]
        [Display(Name = "Merchant Pan/VAT No")]
        public string MerchantPanNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant Contract Date is required")]
        [Display(Name = "Merchant Contract Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string MerchantContractDate { get; set; }
        [Display(Name = "Merchant Contract Date(BS)")]
        public string MerchantContractDate_BS { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant Country is required")]
        [Display(Name = "Merchant Country")]
        public string MerchantCountry { get; set; }
        public string MerchantCountryCode { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant Province is required")]
        [Display(Name = "Merchant Province")]
        [RegularExpression(@"^[1-7]+$", ErrorMessage = "Province Invalid")]
        public string MerchantProvince { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant District is required")]
        [Display(Name = "Merchant District")]
        public string MerchantDistrict { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant VDC/Muncipality is required")]
        [Display(Name = "Merchant VDC/Muncipality")]
        public string MerchantVDC_Muncipality { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Merchant Ward No is required")]
        [Display(Name = "Merchant Ward No")]
        [RegularExpression(@"^[0-9]{1,3}$", ErrorMessage = "Ward No Invalid")]

        public string MerchantWardNo { get; set; }

        [Display(Name = "Merchant Street")]
        public string MerchantStreet { get; set; }
        [Display(Name = "Merchant Credit Limit")]
        [RegularExpression(@"^\d*\.?\d+$", ErrorMessage = "Credit Limit Invalid")]//need to improvise

        public string MerchantCreditLimit { get; set; }
        [Display(Name = "Merchant Balance")]
        [RegularExpression(@"^\d*\.?\d+$", ErrorMessage = "Merchant Balance Invalid")]
        public string MerchantBalance { get; set; }
        [Display(Name = "Merchant Logo")]
        public string MerchantLogo { get; set; }
        [Display(Name = "Merchant Registration Certificate")]
        public string MerchantRegistrationCertificate { get; set; }
        [Display(Name = "Merchant Pan Certificate")]
        public string MerchantPanCertificate { get; set; }

        //User Information
        public string UserID { get; set; }
        public string UserType { get; set; }
        public string UserStatus { get; set; }
        public string IsPrimary { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "User Name is required")]
        [Display(Name = "User Name")]
        [RegularExpression(@"[A-Za-z0-9._]{3,15}$", ErrorMessage = "Only valid for A-Z,a-z,0-9,.,_.  Length must be 3-15 letters")]

        public string UserName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
        [Display(Name = "Password")]
        [RegularExpression(@"^.*(?=.{8,16})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", ErrorMessage = "Must be 8 to 16 Length and must contain a-z,A-Z,0-9,@#$%^&+=")]

        public string Password { get; set; }
        [Display(Name = "Confirm Password")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Confirm Password is required")]
        [Compare("Password", ErrorMessage = "Password Mismatch")]
        public string ConfirmPassword { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "First Name is required")]
        [Display(Name = "First Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "First Name Invalid")]
        public string FirstName { get; set; }

        [Display(Name = "Middle Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Middle Name Invalid")]
        public string MiddleName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Last Name is required")]
        [Display(Name = "Last Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Last Name Invalid")]
        public string LastName { get; set; }
        [Display(Name = "Full Name")]
        public string FullName { get; set; }
        [Display(Name = "User Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "User Number Invalid")]
        public string UserMobileNumber { get; set; }
        [Display(Name = "User Email")]
        [RegularExpression(@"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$", ErrorMessage = "Email Id Invalid")]
        public string UserEmail { get; set; }

        //Contact person Details
        [Display(Name = "Contact Person Name ")]
        [RegularExpression(@"[A-Za-z\s_]+$", ErrorMessage = "Contact Person Name Invalid")]
        public string ContactPersonName { get; set; }
        [Display(Name = "Contact Person Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "Contact Person Number Invalid")]
        public string ContactPersonMobileNumber { get; set; }
        [Display(Name = "Contact Person ID Type")]
        public string ContactPersonIdType { get; set; }
        [Display(Name = "Contact Person ID Number")]
        public string ContactPersonIdNumber { get; set; }
        public string ContactPersonIdIssueCountry { get; set; }
        [Display(Name = "Contact Person ID Issue District")]
        public string ContactPersonIdIssueDistrict { get; set; }
        [Display(Name = "Contact Person ID Issue Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string ContactPersonIdIssueDate { get; set; }
        [Display(Name = "Contact Person ID Issue Date(BS)")]
        public string ContactPersonIdIssueDate_BS { get; set; }
        public string ContactPersonIdExpiryDate { get; set; }
        public string ContactPersonIdExpiryDate_BS { get; set; }

        public string MerchantQr { get; set; }
    }
    public class MerchantUserModel:Common
    {
        public string MerchantId { get; set; }
        public string UserId { get; set; }
        public string IsPrimary { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "User Name is required")]
        [Display(Name = "User Name")]
        [RegularExpression(@"[A-Za-z0-9._]{3,15}$", ErrorMessage = "Only valid for A-Z,a-z,0-9,.,_.  Length must be 3-15 letters")]

        public string UserName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
        [Display(Name = "Password")]
        [RegularExpression(@"^.*(?=.{8,16})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", ErrorMessage = "Must be 8 to 16 Length and must contain a-z,A-Z,0-9,@#$%^&+=")]

        public string Password { get; set; }
        [Display(Name = "Confirm Password")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Confirm Password is required")]
        [Compare("Password", ErrorMessage = "Password Mismatch")]
        public string ConfirmPassword { get; set; }
        [Display(Name = "First Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "First Name Invalid")]
        public string FirstName { get; set; }

        [Display(Name = "Middle Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Middle Name Invalid")]
        public string MiddleName { get; set; }
        [Display(Name = "Last Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Last Name Invalid")]
        public string LastName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Full Name is required")]
        [Display(Name = "Full Name")]
        [RegularExpression(@"[A-Za-z\s_]+$", ErrorMessage = "Full Name Invalid")]
        public string FullName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "User Mobile Number is required")]
        [Display(Name = "User Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "User Number Invalid")]
        public string UserMobileNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Email Id is required")]
        [Display(Name = "User Email")]
        [RegularExpression(@"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$", ErrorMessage = "Email Id Invalid")]
        public string UserEmail { get; set; }
    }
}