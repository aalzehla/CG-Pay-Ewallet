using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models
{
    public class ChartDataCommon
    {
        public IList<ChartData> ChartDataList;
    }

    public class ChartData
    {
        public string Label { get; set; }
        public string Value { get; set; }
        public string Type { get; set; }
    }
    //public class NotificationCommon {
    //    public string Id { get; set; }
    //    public string Subject { get; set; }
    //    public string CreatedDate { get; set; }
    //    public string Notification { get; set; }
    //    public string ReadStatus { get; set; }
    //    public string Type { get; set; }
        

    //}
}
