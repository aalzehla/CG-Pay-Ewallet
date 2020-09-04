using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Common
{
    public interface ICommonBusiness
    {
        Dictionary<string, string> sproc_get_dropdown_list(string flag,string extra1="");
        Dictionary<string, string> sproc_get_product_denomination(string flag, string extra1 = "", string extra2 = "");
        Dictionary<string, string> Denomination(string ProductId, Dictionary<string, string> dictionary);
    }
}
