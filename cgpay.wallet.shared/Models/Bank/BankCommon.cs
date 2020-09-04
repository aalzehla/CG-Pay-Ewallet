using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Bank
{
   public class BankCommon:Common
    {
        //Bank Id, Bank Name, Bank Account No, Bank Branch, IsActive, Created By, Craeated Date

        public string BankID { get; set; }
        [Display(Name = "Bank Name")]
        public string BankName { get; set; }
        [Display(Name ="Bank Account Number")]
        public string BankAccountNo { get; set; }
        [Display (Name ="Bank Branch")]
        public string BankBranch { get; set; }
        [Display(Name = "Bank Status")]
        public string BankStatus { get; set; }
        public string BankCreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }

    }
}
