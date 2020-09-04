using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class ClientCommissionCategoryDetailModel:Common
    {
        //public string AgentId { get; set; }

        public string CommissionDetailId { get; set; }
        public string CommissionCategoryId { get; set; }
        [Required(ErrorMessage = "Product is Required")]
        [Display(Name = "Product")]
        public string ProductId { get; set; }
        public string ProductLabel { get; set; }
        [Required(ErrorMessage = "Commission Type is Required")]
        [Display(Name = "Commission Type")]
        public string CommissionType { get; set; }
        [Required(ErrorMessage = "Commission Percent Type is Required")]
        [Display(Name = "Commission Percent Type")]
        public string CommissionPercentType { get; set; }
        [Required(ErrorMessage = "Commission Value is Required")]
        [Display(Name = "Commission Value")]
        [Range(0, float.MaxValue, ErrorMessage = "Please enter valid Number")]
        public string CommissionValue { get; set; }
        //public List<SelectListItem> CommissionTypeList { get; set; }
        //public List<SelectListItem> CommissionPercentTypeList { get; set; }
    }
}