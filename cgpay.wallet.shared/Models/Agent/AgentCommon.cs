using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Agent
{
    public class AgentCommon:Common
    {
        public string AgentType { get; set; }
        public string AgentID { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Operation Type is required")]
        [Display(Name = " Operation Type")]
        public string AgentOperationType { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Name is required")]
        [Display(Name = "Agent Name")]
        public string AgentName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Contact Number is required")]
        [Display(Name = "Agent Phone Number")]
        public string AgentPhoneNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Email is required")]
        [Display(Name = "Agent Email")]
        public string AgentEmail { get; set; }

        [Display(Name = "Agent Web URL")]
        public string AgentWebUrl { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Registration Number is required")]
        [Display(Name = "Agent Registration Number")]
        public string AgentRegistrationNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Pan Number is required")]
        [Display(Name = "Agent Pan Number")]
        public string AgentPanNo { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Contratc Date is required")]
        [Display(Name = "Agent Contratct Date")]
        public DateTime AgentContractDate { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Address is required")]
        [Display(Name = "Agent Address")]
        public string AgentAddress { get; set; }
        public string AgentLatitude { get; set; }
        public string AgentLongitude { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Credit Limit is required")]
        [Display(Name = " Agent Credit Limit")]
        public float AgentCreditLimit { get; set; }

      //  [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Balance is required")]
        [Display(Name = "Agent Balance")]
        public float AgentBalance { get; set; }

       // [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Logo is required")]
        [Display(Name = "Agent Logo")]
        public float AgentLogo { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Agent Registration Certificate is required")]
        [Display(Name = "Agent Registration Certificate")]
        public float AgentRegistrationCertificate { get; set; }

       // [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Pan Certificate is required")]
        [Display(Name = "Agent Pan Certificate")]
        public float AgentPanCertificate { get; set; }
        //items needed to be added for individual document

        //User Information

        [Display(Name = "User ID")]
        public string UserId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Username is required")]
        [Display(Name = "User Name")]
        public string UserName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Confirm Password is required")]
        [Display(Name = "Confirm Password")]
        [Compare("Password", ErrorMessage = "Password Mismatch")]
        public string ConfirmPassword { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Firstname is required")]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }
        public string MiddleName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Lastname is required")]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "DOB in AD is required")]
        [Display(Name = "D.O.B in AD")]
        public string DOB_AD { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "DOB in BS is required")]
        [Display(Name = "D.O.B in BS")]
        public string DOB_BS { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Gender is required")]
        [Display(Name = "Gender")]
        public string Gender { get; set; }
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

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent VDC/Mucipality is required")]
        [Display(Name = "Permanent VDC/Municipality")]
        public string PermanentVDC_Muncipality { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Ward Number is required")]
        [Display(Name = "Permanent Ward Number")]
        public string PermanentWardNo { get; set; }
        //public string PermanentTole { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Country is required")]
        [Display(Name = "Temporary Country")]
        public string TemporaryCountry { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Province is required")]
        [Display(Name = "Temporary Province")]
        public string TemporaryProvince { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary District is required")]
        [Display(Name = "Temporary District")]
        public string TemporaryDistrict { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary VDC/Municipality is required")]
        [Display(Name = "Temporary VDC/Municipality")]
        public string TemporaryVDC_Muncipality { get; set; }


        [Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Ward Number is required")]
        [Display(Name = "Temporary Ward Number")]
        public string TemporaryWardNo { get; set; }
        //public string TemporaryTole { get; set; }

        //Contact Person Detail

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Name is required")]
        [Display(Name = "Contact Name")]
        public string ContactPersonName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Address is required")]
        [Display(Name = "Contact Address")]
        public string ContactPersonAddress { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person Number is required")]
        [Display(Name = "Contact Number")]
        public string ContactPersonNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Type is required")]
        [Display(Name = "Contact ID Type")]
        public string ContactPersonIDtype { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Number is required")]
        [Display(Name = "Contact ID Number")]
        public string ContactPersonIDNumber { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Issue Date is required")]
        [Display(Name = "Contact ID Issue Date")]
        public string ContactPersonIDIssueDate { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Expiry Date is required")]
        [Display(Name = "Contact ID Expiry Date")]
        public string ContactPersonIDExpiryDate { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Contact Person ID Issue District is required")]
        [Display(Name = "Contact ID Issue District")]
        public string ContactPersonIDIssueDistrict { get; set; }










    }
}
