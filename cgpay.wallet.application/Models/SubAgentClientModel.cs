using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Models
{
    public class SubAgentClientModel:Common
    {

        public string AgentType { get; set; }
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Id is required")]
        [Display(Name = "Agent Id")]
        public string AgentID { get; set; }
        public string ParentID { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Operation Type is required")]
        [Display(Name = "Agent Operation Type")]
        public string AgentOperationType { get; set; }

        [Display(Name = "Agent Commission Type")]
        public bool AgentCommissionType { get; set; }
        public string AgentStatus { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Name  is required")]
        [Display(Name = "Agent Name ")]
        public string AgentName { get; set; }
        public string AgentPhoneNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Mobile Number is required")]
        [Display(Name = "Agent Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "Mobile Number Invalid")]
        public string AgentMobileNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Email is required")]
        [Display(Name = "Agent Email")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Email Format Invalid")]
        public string AgentEmail { get; set; }
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent URL is required")]
        [Display(Name = "Agent URL")]
        [RegularExpression(@"^?([\w-]+.)+[\w-]+(/[\w- ./?%&=])?$", ErrorMessage = "URL Format Invalid")]
        public string AgentWebUrl { get; set; }
        [Display(Name = "Agent Registration Number")]
        public string AgentRegistrationNumber { get; set; }
        [Display(Name = "Agent Pan")]
        public string AgentPanNumber { get; set; }
        [Display(Name = "Agent Contract Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string AgentContractDate { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Contract Date(BS) is required")]
        [Display(Name = "Agent Contract Date(BS)")]
        public string AgentContractDate_BS { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Country is required")]
        [Display(Name = "Agent Country")]
        public string AgentCountry { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Province is required")]
        [Display(Name = "Agent Province")]
        [RegularExpression(@"^[1-7]+$", ErrorMessage = "Province Invalid")]
        public string AgentProvince { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent District is required")]
        [Display(Name = "Agent District")]
        public string AgentDistrict { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent VDC/Muncipality is required")]
        [Display(Name = "Agent VDC/Muncipality")]
        public string AgentVDC_Muncipality { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Ward No is required")]
        [Display(Name = "Agent Ward No")]
        [RegularExpression(@"^[0-9]{1,3}$", ErrorMessage = "Ward No Invalid")]
        public string AgentWardNo { get; set; }
        [Display(Name = "Agent Street")]
        public string AgentStreet { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Credit Limit is required")]
        [Display(Name = "Agent Credit Limit")]
        [Range(-1, float.MaxValue, ErrorMessage = "Credit Limit Invalid")]
        //[RegularExpression(@"^\-\d*\.?\d+$", ErrorMessage = "Credit Limit Invalid")]//need to improvise

        public string AgentCreditLimit { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Balance is required")]
        [Display(Name = "Agent Balance")]
        [RegularExpression(@"^\d*\.?\d+$", ErrorMessage = "Agent Balance Invalid")]
        public string AgentBalance { get; set; }
        [Display(Name = "Agent Logo")]
        public string AgentLogo { get; set; }
        // [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Registration Certificate is required")]
        [Display(Name = "Agent Registration Certificate")]
        public string AgentRegistrationCertificate { get; set; }
        //   [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Pan Certificate is required")]
        [Display(Name = "Agent Pan Certificate")]
        public string AgentPanCertificate { get; set; }

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
        [Compare("Password", ErrorMessage = "Password Mismatch")]
        public string ConfirmPassword { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "First Name is required")]
        [Display(Name = "First Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "First Name Invalid")]
        public string FirstName { get; set; }

        [Display(Name = "Middle Name")]
        [RegularExpression(@"^[a-zA-Z\s_]+$", ErrorMessage = "Middle Name Invalid")]
        public string MiddleName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Last Name is required")]
        [Display(Name = "Last Name")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Last Name Invalid")]
        public string LastName { get; set; }
        [Display(Name = "Full Name")]
        public string FullName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "User Mobile Number is required")]
        [Display(Name = "User Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "User Number Invalid")]
        public string UserMobileNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Email Id is required")]
        [Display(Name = "Email Id ")]
        [RegularExpression(@"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$", ErrorMessage = "Email Id Invalid")]
        public string UserEmail { get; set; }

    }
}