using cgpay.wallet.shared.Models;
using direct.gateway.selection.domain;
using direct.gateway.selection.domain.abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Common
{
    public class CommonRepository:ICommonRepository
    {
        RepositoryDao dao;
        public CommonRepository()
        {
            dao = new RepositoryDao();
        }
        public Dictionary<string, string> sproc_get_dropdown_list(string flag, string extra1 = "")
        {
            string sql = "sproc_get_dropdown_list";
            sql += " @flag=" + dao.FilterString(flag);
            sql += ", @search_field1=" + dao.FilterString(extra1);
            Dictionary<string, string> dict = dao.ParseSqlToDictionary(sql);
            return dict;
        }
        public Dictionary<string,string> sproc_get_product_denomination(string flag,string extra1="",string extra2="")
        {
            string sql = "sproc_get_product_denomination";
            sql += " @flag=" + dao.FilterString(flag);
            sql += " ,@extra1=" + dao.FilterString(extra1);
            sql += " ,@extra2=" + dao.FilterString(extra2);
            Dictionary<string, string> dict = dao.ParseSqlToDictionary(sql);
            return dict;
        }
        public Dictionary<string, string> Denomination(string ProductId, Dictionary<string, string> dictionary)
        {
            CommonDbResponse response = new CommonDbResponse();

            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            var fresponse = factory.GetDropdownValues(ProductId, dictionary);
            var dropdownlist = new Dictionary<string, string>();

            if (fresponse.Code == "000" && fresponse.Count >= 1)
            {
                var dropdown = fresponse.Dropdownitems;
                foreach (var items in dropdown)
                {

                    dropdownlist.Add(items.Text, items.Value);

                }

            }
            
            return dropdownlist;
        }
    }
}
