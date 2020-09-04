using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Models
{
    public class GatewayProductModel : Common
    {
        public int GatewayProductId { get; set; }
        [Required]
        public string GatewayId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Product is required")]
        [Display(Name = "Product")]
        public string ProductId { get; set; }
        public string ProductLabel { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Commission Value is required")]
        [Display(Name = "Commission Value")]
        public float CommissionValue { get; set; }
        
        [Required(AllowEmptyStrings = false, ErrorMessage = "Commission Type is required")]
        [Display(Name = "Commission Type")]
        public string CommissionType { get; set; }
        public string CommissionEarned { get; set; }
        public string IsProduct { get; set; }
        public List<SelectListItem> CommissionTypeList { get; set; }
    }
}