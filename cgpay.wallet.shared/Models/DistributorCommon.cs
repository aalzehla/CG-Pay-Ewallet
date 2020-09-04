using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using CompareAttribute = System.ComponentModel.DataAnnotations.CompareAttribute;

namespace cgpay.wallet.shared.Models
{
    public class DistributorCommon : Common
    {
        public string AgentType { get; set; }
        public string AgentID { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Operation Type is required")]
        [Display(Name = "Operation Type")]
        public string AgentOperationType { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Transaction Type is required")]
        [Display(Name = "Auto Commission")]
        public bool isautocommission { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Name is required")]
        [Display(Name = "Agent Name")]
        public string AgentName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Mobile Number is required")]
        [Display(Name = "Mobile Number")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "Mobile Number Invalid")]
        public string AgentMobileNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = " Agent Email is required")]
        [Display(Name = " Email")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Email Format Invalid")]
        public string AgentEmail { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "A is required")]
        [Display(Name = "Web URL")]
        public string AgentWebUrl { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Registration Number is required")]
        [Display(Name = " Registration Number")]
        public string AgentRegistrationNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Pan Number is required")]
        [Display(Name = " Pan Number")]
        public string AgentPanNo { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Contract Date is required")]
        [Display(Name = " Contract Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string AgentContractDate { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Address is required")]
        [Display(Name = "Address")]
        public string AgentAddress { get; set; }

        [Display(Name = "Latitude")]
        public string AgentLatitude { get; set; }
        
        [Display(Name = "Longitude")]
        public string AgentLongitude { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Credit Limit is required")]
        [Display(Name = "Credit Limit")]
        public float AgentCreditLimit { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Balance is required")]
        [Display(Name = " Balance")]
        public float AgentBalance { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Logo is required")]
        [Display(Name = " Logo")]
        public string AgentLogo { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Registration Cretificate is required")]
        [Display(Name = " Registration Certificate")]
        public string AgentRegistrationCertificate { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Pan Cretificate is required")]
        [Display(Name = " Pan Certificate")]
        public string AgentPanCertificate { get; set; }


        //User Information
        [Display(Name = " User ID")]
        public string UserId { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "User Name is required")]
        [Display(Name = "User Name")]
        public string UserName { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "User Fullname is required")]
        [Display(Name = "User Full Name")]
        public string UserFullName { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "User Email is required")]
        [Display(Name = "User Email")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Email Format Invalid")]
        public string UserEmail { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "User Mobile Number is required")]
        [Display(Name = "User Mobile Number")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "Mobile Number Not Valid")]
        public string UserMobileNo { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "User Type is required")]
        [Display(Name = "User Type")]
        public string UserType { get; set; }//manager user

        //[Required(AllowEmptyStrings = false, ErrorMessage = "User Type ID is required")]
        [Display(Name = "User Type ID")]
        public string UserTypeId { get; set; }//manager user

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
        [Display(Name = "Password")]
        public string Password { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Confirm Password is required")]
        [Display(Name = "Confirm Password")]
        [Compare("Password", ErrorMessage = "Password Mismatch")]
        public string ConfirmPassword { get; set; }

        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets Allowed")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "First Name is required")]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets Allowed")]        
        [Display(Name = "Middle Name")]
        public string MiddleName { get; set; }

        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets Allowed")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Last Name is required")]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Date of Birth is required")]
        [Display(Name = "Date of Birth (AD)")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string DOB_AD { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Date of Birth is required")]
        [Display(Name = "Date of Birth (BS)")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string DOB_BS { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Gender is required")]
        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Occupation is required")]
        [Display(Name = "Occupation")]
        public string Occupation { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Nationality is required")]
        [Display(Name = "Nationality")]
        public string Nationality { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Country is required")]
        [Display(Name = "Permanent Country")]
        public string PermanentCountry { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Province is required")]
        [Display(Name = "Permanent Province")]
        public string PermanentProvince { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent District is required")]
        [Display(Name = "Permanent District")]
        public string PermanentDistrict { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent VDC/Muncipality is required")]
        [Display(Name = "Permanent VDC/Muncipality")]
        public string PermanentVDC_Muncipality { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Ward No is required")]
        [Display(Name = "Permanent Ward No")]
        public string PermanentWardNo { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Street is required")]
        [Display(Name = "Permanent Street")]
        public string PermanentStreet { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Country is required")]
        [Display(Name = "Temporary Country ")]
        public string TemporaryCountry { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Province is required")]
        [Display(Name = "Temporary Provience ")]
        public string TemporaryProvince { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary District is required")]
        [Display(Name = "Temporary District ")]
        public string TemporaryDistrict { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary VDC/Muncipality is required")]
        [Display(Name = "Temporary VDC/Muncipality ")]
        public string TemporaryVDC_Muncipality { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Ward No is required")]
        [Display(Name = "Temporary Ward No ")]
        public string TemporaryWardNo { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Street is required")]
        [Display(Name = "Temporary Street ")]
        public string TemporaryStreet { get; set; }

        //Contact Person Detail
        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Name is required")]
        [Display(Name = "Contact  Name")]
        public string ContactPersonName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Address is required")]
        [Display(Name = "Contact  Address")]
        public string ContactPersonAddress { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Mobile Number is required")]
        [Display(Name = "Contact  Mobile Number")]
        public string ContactPersonNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Type is required")]
        [Display(Name = "Contact  ID Type")]
        public string ContactPersonIDtype { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Number is required")]
        [Display(Name = "Contact  ID Number")]
        public string ContactPersonIDNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Issue Date (AD) is required")]
        [Display(Name = "Contact  Issue Date (AD)")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string ContactPersonIDIssueDate { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Issue Date (BS) is required")]
        [Display(Name = "Contact  Issue Date (BS)")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string ContactPersonIDIssueDate_BS { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Expiry Date AD is required")]
        [Display(Name = "Contact  Expiry Date (AD)")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string ContactPersonIDExpiryDate { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Expiry Date (BS) is required")]
        [Display(Name = "Contact  Expiry Date (BS)")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string ContactPersonIDExpiryDate_BS { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Issue District is required")]
        [Display(Name = "Contact  ID Issue District")]
        public string ContactPersonIDIssueDistrict { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Issue Country is required")]
        [Display(Name = "Contact  ID Issue Country")]
        public string ContactPersonIDIssueCountry { get; set; }

        public string kycstatus { get; set; }
        public string AgentStatus { get; set; }
        public string isPrimary { get; set; }
        public string UserStatus { get; set; }

    }
}
