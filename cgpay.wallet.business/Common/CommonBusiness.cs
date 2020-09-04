using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.Common;

namespace cgpay.wallet.business.Common
{
    public class CommonBusiness:ICommonBusiness
    {
        ICommonRepository _repo;
        public CommonBusiness()
        {
            _repo = new CommonRepository();
        }
        public  Dictionary<string, string> sproc_get_dropdown_list(string flag, string extra1 = "")
        {
            return _repo.sproc_get_dropdown_list(flag, extra1);
        }
        public Dictionary<string, string> sproc_get_product_denomination(string flag, string extra1 = "", string extra2 = "")
        {
            return _repo.sproc_get_product_denomination(flag, extra1, extra2);
        }
        public Dictionary<string, string> Denomination(string ProductId, Dictionary<string, string> dictionary)
        {
            return _repo.Denomination( ProductId, dictionary);
        }
    }
}
