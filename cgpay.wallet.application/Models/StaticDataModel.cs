using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class StaticDataModel:Common
    {

        public string StaticDataTypeId { get; set; }
        public string StaticDataTypeName { get; set; }
        public string StaticDataTypeDescription { get; set; }

        public string StaticDataId { get; set; }
        [Display(Name = "Static Data Value")]
        public string StaticDataValue { get; set; }
        [Display(Name = "Static Data Label")]
        public string StaticDataLabel { get; set; }
        [Display(Name = "Static Data Description")]
        public string StaticDataDescription { get; set; }
        [Display(Name = "Additional Value1")]
        public string AdditionalValue1 { get; set; }
        [Display(Name = "Additional Value2")]
        public string AdditionalValue2 { get; set; }
        [Display(Name = "Additional Value3")]
        public string AdditionalValue3 { get; set; }
        [Display(Name = "Additional Value4")]
        public string AdditionalValue4 { get; set; }
        public string IsDeleted { get; set; }
    }
}