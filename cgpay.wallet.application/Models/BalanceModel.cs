using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Models
{
    public class BalanceModel
    {
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }
        public string BalanceId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Name is required")]
        public string Name { get; set; }
        public List<SelectListItem> NameList { get; set; }
        public string Type { get; set; }
        [Display(Name = "Mode")]
        public string TxnMode { get; set; }

        [Display(Name = "Bank Account")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Bank Name is required")]
        public string BankId { get; set; }
        [Display(Name = "Bank Name")]
        public string BankName { get; set; }
        public List<SelectListItem> BankAccountList { get; set; }
        [Display(Name = "Bank Branch")]
        public string BankBranch { get; set; }
        [Display(Name = "Account Number")]
        public string BankAcccountNo { get; set; }
        //[MaxLength(6, ErrorMessage = "Max digit exceed")]
        //[RegularExpression("^[0-9.]*$", ErrorMessage = "Only Numbers allowed")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Amount is required")]
        //[Range(minimum:10.00,maximum: 500000.00,ErrorMessage = "Minimum 10 to Maximum 500000")]
        public string Amount { get; set; }
        [Display(Name = "Previous Balance")]
        public string OldBalance { get; set; }
        [Display(Name = "Current Balance")]
        public string NewBalance { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Remarks is required")]
        public string Remarks { get; set; }
        [Display(Name = "Created By")]
        public string CreatedBy { get; set; }
        public string CreatedIp { get; set; }
        public string CreatedPlatform { get; set; }
        [Display(Name = "Created Date")]
        public string CreatedDate { get; set; }
        [Display(Name = "Created Nepali Date")]
        public string CreatedNepaliDate { get; set; }
        public string ActionUser { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string ServiceCharge { get; set; }
        public string BonusAmt { get; set; }
        public string SenderId { get; set; }
        public string RecieverId { get; set; }
        public string GrandParentId { get; set; }
        public string ParentId { get; set; }
        [Display(Name = "Parent Name")]
        public string ParentName { get; set; }
        public string Subscriber { get; set; }
        public string Action { get; set; }

    }
}