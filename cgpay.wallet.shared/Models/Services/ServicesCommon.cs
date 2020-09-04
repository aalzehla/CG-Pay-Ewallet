using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace cgpay.wallet.shared.Models.Services
{
    
    public class ServicesCommon
    {
        public string ProductId { get; set; }
        public List<SelectListItem> TransactionTypeList { get; set; }
        public string TransactionType { get; set; }
        public List<SelectListItem> CompanyList { get; set; }
        public string Company { get; set; }
        public string ProductServiceInfo { get; set; }
        public string ProductLabel { get; set; }
        public List<SelectListItem> ProductTypeList { get; set; }
        public string ProductType { get; set; }
        public List<SelectListItem> ProductCategoryList { get; set; }
       
        public string ProductCategory { get; set; }
        public string MinDenominationAmount { get; set; }
        public string MaxDenomonationAmount { get; set; }
      
       public string ProductLogo { get; set; }

        public List<SelectListItem> PrimaryGatewayList { get; set; }
        public string PrimaryGateway { get; set; }
        public List<SelectListItem> SecondaryGatewayList { get; set; }
        public string SecondaryGateway { get; set; }
        public List<SelectListItem> StatusList { get; set; }
        public string Status { get; set; }
        public string Action { get; set; }
        public string ClientPmtUrl { get; set; }
        public string CommissionValue { get; set; }
        public string CommissionType { get; set; }
        public string CreatedIp { get; set; }
        public string ProductCode { get; set; }
        public string ProductUrl { get; set; }


    }
}
