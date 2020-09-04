using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class GatewayBalanceModel:Common
    {
        [Display(Name = "Gateway ID")]
        
        public string Gatewayid { get; set; }
        [Display(Name = "Gateway Name")]
        
        public string GatewayName { get; set; }

        public string GatewayStatus { get; set; }
        [Display(Name = "Avaliable Balance")]        
        public decimal AvaliableBalance { get; set; }
        [Display(Name = "Gateway Currency")]
       
        public string GatewayCurrency { get; set; }
        [Display(Name = "Amount")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Amount is required")]
        public float BalanceToBeAdd { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Remark is required")]
        public string Remarks { get; set; }
    }
}