using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Models
{
    public class ServicesModel
    {

        public String ProductId { get; set; }
        public List<SelectListItem> TransactionTypeList { get; set; }


        [Required(AllowEmptyStrings = false, ErrorMessage = "Transaction Type is required")]
        [Display(Name = "Transaction Type")]
        public string TransactionType { get; set; }
        public List<SelectListItem> CompanyList { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Company is required")]

        public string Company { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Product info is required")]
        [Display(Name = "Product Information")]
        public string ProductServiceInfo { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Product Label is required")]
        [Display(Name = "Product Label")]
        public string ProductLabel { get; set; }
        public List<SelectListItem> ProductTypeList { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Product Type is required")]
        [Display(Name = "Product Type")]
        public string ProductType { get; set; }
        public List<SelectListItem> ProductCategoryList { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Product Category is required")]
        [Display(Name = "Product Category")]
        public string ProductCategory { get; set; }
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Minimum Detonation Amount is required")]
        [Display(Name = "Minimum Denomination Amount")]
        public string MinDenominationAmount { get; set; }
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Maximum Detonation Amount is required")]
        [Display(Name = "Maximum Denomination Amount")]
        public string MaxDenomonationAmount { get; set; }
        public string ProductLogo { get; set; }
        public List<SelectListItem> PrimaryGatewayList { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Primary Gateway is required")]
        [Display(Name = "Primary Gateway")]
        public string PrimaryGateway { get; set; }
        public List<SelectListItem> SecondaryGatewayList { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Secondary Gateway is required")]
        [Display(Name = "Secondary Gateway")]
        public string SecondaryGateway { get; set; }

        public List<SelectListItem> StatusList { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Status is required")]
        public string Status { get; set; }
        public string Action { get; set; }
        public string ClientPmtUrl { get; set; }
        public string CommissionValue { get; set; }
        public string CommissionType { get; set; }
        [Display(Name = "Product Code")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Product Code is required")]
        public string ProductCode { get; set; }
        [Display(Name = "Product Url")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Product Url")]
        public string ProductUrl { get; set; }

    }
}