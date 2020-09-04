using cgpay.wallet.shared;
using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.repository.StaticData
{
    public interface IStaticDataRepository
    {
        //List<StaticDataCommon> GetList(string user, string id, string Search, int Pagesize);
        List<StaticDataCommon> GetStaticDataTypeList();
        List<StaticDataCommon> GetStaticDataList(string staticdatatypeid);
        StaticDataCommon GetStaticDataById(string staticdataId, string staticdatatypeId);
        CommonDbResponse ManageStaticData(StaticDataCommon sdc);
        CommonDbResponse block_unblockStaticData(StaticDataCommon SDC, string status);
    }
}