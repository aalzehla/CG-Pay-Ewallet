using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.BulkUpload
{
    public class BulkUploadCommon :Common
    {
        public string DataId { get; set; }
        public string ProcessId { get; set; }
        public string DataImportSource { get; set; }
        public string DataImportStatus { get; set; }

        public string Type { get; set; }
        public string Module { get; set; }
        public string Description { get; set; }
        public string Remarks { get; set; }

    }

    public class BulkTopUpCommon : Common
    {
        public string SubscriberNumber { get; set; }
        public string Amount { get; set; }
        public string Product { get; set; }
        public string Remark { get; set; }

        //public string Code { get; set; }
        public string Message { get; set; }
    }

    public class BulkTopUpReceiptCommon : Common
    {
        public string SubscriberNumber { get; set; }
        public string Amount { get; set; }
        public string Product { get; set; }
        public string SericeCharge { get; set; }
        public string BonusAmount { get; set; }
        public string AgentCommission { get; set; }
        public string Status { get; set; }
        public string TransactionCreatedDate { get; set; }
        public string TransactionUpdatedDate { get; set; }

        public string Remark { get; set; }
    }
}
