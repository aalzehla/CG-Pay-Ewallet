using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.business.StaticData
{
    public interface IStaticDataBusiness
    {
        //System.Collections.Generic.List<shared.Models.StaticDataCommon> GetList(string User, string Id, string Search, int Pagesize);
        List<StaticDataCommon> GetStaticDataTypeList();
        List<StaticDataCommon> GetStaticDataList(string staticdatatypeid);
        StaticDataCommon GetStaticDataById(string staticdataId, string staticdatatypeId);
        CommonDbResponse ManageStaticData(StaticDataCommon sdc);
        CommonDbResponse block_unblockStaticData(StaticDataCommon SDC, string status);
    }
}