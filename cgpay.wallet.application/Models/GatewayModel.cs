using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Models
{
    public class GatewayModel:Common
    {
        public string GatewayId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Name is required")]
        [Display(Name = "Gateway Name")]
        public string GatewayName { get; set; }
     //   [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Balance is required")]
        [Display(Name = "Gateway Balance")]
        public string GatewayBalance { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway URL is required")]
        [Display(Name = "Gateway Url")]
        [DataType(DataType.Password)]
        public string GatewayURL { get; set; }

         [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Username is required")]
        [Display(Name = "Gateway Username")]
        [DataType(DataType.Password)]
        public string GatewayUsername { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Password is required")]
        [Display(Name = "Gateway Password")]
        [DataType(DataType.Password)]
        public string GatewayPwd { get; set; }
      
        [Display(Name = "Gateway Status")]
        public string GatewayStatus { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Direct/Indirect is required")]
        [Display(Name = "Gateway Direct/Indirect")]
        public bool IsDirectGateway { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Type is required")]
        [Display(Name = "Gateway Type")]
        public string GatewayType { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Country is required")]
        [Display(Name = "Gateway Country")]
        public string GatewayCountry { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Gateway Currency is required")]
        [Display(Name = "Gateway Currency")]
        public string GatewayCurrency { get; set; }
       
        [Display(Name = "Gateway Access Code")]
        [DataType(DataType.Password)]
        public string GatewayAccessCode { get; set; }
        [Display(Name = "Gateway Security Code")]
        [DataType(DataType.Password)]
        public string GatewaySecurityCode { get; set; }
        [Display(Name = "Gateway API Token")]
        [DataType(DataType.Password)]
        public string GatewayApitoken { get; set; }
        public string GatewayContact { get; set; }
        
        public List<SelectListItem> IsDirectGatewayList { get; set; }
        public List<SelectListItem> GatewayTypeList { get; set; }
        public List<SelectListItem> GatewayCurrencyList { get; set; }
        public List<SelectListItem> GatewayCountryList { get; set; }
    }

    public class GatewayDetailModel:Common
    {
        public string GatewayId { get; set; }
        [Display(Name = "Gateway Name")]
        public string GatewayName { get; set; }
        [Display(Name = "Gateway Balance")]
        public string GatewayBalance { get; set; }
        [Display(Name = "Gateway Url")]
        [DataType(DataType.Password)]
        public string GatewayURL { get; set; }

        [Display(Name = "Gateway Username")]
        [DataType(DataType.Password)]
        public string GatewayUsername { get; set; }

        [Display(Name = "Gateway Password")]
        [DataType(DataType.Password)]
        public string GatewayPwd { get; set; }

        [Display(Name = "Gateway Status")]
        public string GatewayStatus { get; set; }
        [Display(Name = "Gateway Direct/Indirect")]
        public bool IsDirectGateway { get; set; }
        [Display(Name = "Gateway Type")]
        public string GatewayType { get; set; }
        [Display(Name = "Gateway Country")]
        public string GatewayCountry { get; set; }
        [Display(Name = "Gateway Currency")]
        public string GatewayCurrency { get; set; }

        [Display(Name = "Gateway Access Code")]
        [DataType(DataType.Password)]
        public string GatewayAccessCode { get; set; }
        [Display(Name = "Gateway Security Code")]
        [DataType(DataType.Password)]
        public string GatewaySecurityCode { get; set; }
        [Display(Name = "Gateway API Token")]
        [DataType(DataType.Password)]
        public string GatewayApitoken { get; set; }
        public string GatewayContact { get; set; }
    }
}