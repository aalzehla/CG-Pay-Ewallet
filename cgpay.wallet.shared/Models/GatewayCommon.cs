using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace cgpay.wallet.shared.Models
{
   public class GatewayCommon:Common
    {
        public string GatewayId { get; set; }
        public string GatewayName { get; set; }
        public string GatewayBalance { get; set; }
        [Required(ErrorMessage = "Gateway URL is required")]
        public string GatewayURL { get; set; }
       
        [Required(ErrorMessage = "Gateway User Name is required")]
        public string GatewayUsername { get; set; }
     
        [Required(ErrorMessage = "Gateway Password is required")]
        public string GatewayPwd { get; set; }
        public string GatewayStatus { get; set; }
        public bool IsDirectGateway { get; set; }
        public string GatewayType { get; set; }
        public string GatewayCountry { get; set; }
        public string GatewayCurrency { get; set; }
        public string GatewayAccessCode { get; set; }
        public string GatewaySecurityCode { get; set; }
        public string GatewayApitoken { get; set; }
        public string GatewayContact { get; set; }
       

        public List<SelectListItem> IsDirectGatewayList { get; set; }
        public List<SelectListItem> GatewayTypeList { get; set; }
        public List<SelectListItem> GatewayCurrencyList { get; set; }
        public List<SelectListItem> GatewayCountryList { get; set; }

    }
}
