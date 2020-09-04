using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models
{
    public class StaticDataCommon:Common
    {
        //public string TypeCode { get; set; }
        //public string DataCode { get; set; }
        //public string DataValue { get; set; }
        //public string NepValue { get; set; }


       
        public string StaticDataTypeId { get; set; }
        public string StaticDataTypeName  { get; set; }
        public string StaticDataTypeDescription  { get; set; }

        public string StaticDataId { get; set; }
        public string StaticDataValue { get; set; }
        public string StaticDataLabel { get; set; }
        public string StaticDataDescription { get; set; }
        public string AdditionalValue1 { get; set; }
        public string AdditionalValue2 { get; set; }
        public string AdditionalValue3 { get; set; }
        public string AdditionalValue4 { get; set; }
        public string IsDeleted { get; set; }
    }
}
