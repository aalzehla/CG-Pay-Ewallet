using cgpay.wallet.shared;
using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.StaticData
{
    public class StaticDataRepository : IStaticDataRepository
    {
        RepositoryDao dao;

        public StaticDataRepository()
        {
            dao = new RepositoryDao();
        }
        /*
        public List<StaticDataCommon> GetList(string user, string id, string Search, int Pagesize)
        {
            var list = new List<StaticDataCommon>();
            try
            {

                var sql = "EXEC proc_tblStaticData ";
                sql += " @FLAG = " + dao.FilterString(id != "0" ? "S" : "A");
                sql += ",@User = " + dao.FilterString(user);
                sql += ",@ID = " + dao.FilterString(id.ToString());
                sql += ",@Search = " + dao.FilterString(Search);
                sql += ",@Pagesize = " + dao.FilterString(Pagesize.ToString());

                var dt = dao.ExecuteDataTable(sql);
                if (null != dt)
                {
                    int sn = 1;
                    foreach (DataRow item in dt.Rows)
                    {
                        var common = new StaticDataCommon()
                        {

                            UniqueId = item["Id"].ToString(),
                            TypeCode = item["StaticCode"].ToString(),
                            DataCode = item["Code"].ToString(),
                            DataValue = item["Value"].ToString(),
                            NepValue = item["NepValue"].ToString(),
                            ActionUser = item["CreatedBy"].ToString(),

                        };
                        sn++;
                        list.Add(common);
                    }
                }
            }
            catch (Exception e)
            {

                return list;
            }

            return list;
        }*/
        public List<StaticDataCommon> GetStaticDataTypeList()
        {
            string sql = "exec [sproc_static_data_setup]";
            sql += " @flag='st'";
            var dt = dao.ExecuteDataTable(sql);
            List<StaticDataCommon> lst = new List<StaticDataCommon>();
            if(dt!=null)
            {
                foreach(DataRow item in dt.Rows)
                {
                    StaticDataCommon SDC = new StaticDataCommon
                    {
                        StaticDataTypeId = item["sdata_type_id"].ToString(),
                        StaticDataTypeName = item["static_data_name"].ToString(),
                        StaticDataTypeDescription = item["static_data_description"].ToString()

                    };
                    lst.Add(SDC);
                }
            }
            return lst;
        }
        public List<StaticDataCommon> GetStaticDataList(string staticdatatypeid)
        {
            string sql = "exec [sproc_static_data_setup]";
            sql += " @flag='sdlst'";
            sql += " ,@sdata_type_id="+dao.FilterString(staticdatatypeid);
            var dt = dao.ExecuteDataTable(sql);
            List<StaticDataCommon> lst = new List<StaticDataCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    StaticDataCommon SDC = new StaticDataCommon
                    {
                        StaticDataTypeId = item["sdata_type_id"].ToString(),
                        StaticDataId = item["static_data_row_id"].ToString(),
                        StaticDataValue = item["static_data_value"].ToString(),
                        StaticDataLabel = item["static_data_label"].ToString(),
                        IsDeleted = item["is_deleted"].ToString(),
                        StaticDataDescription = item["static_data_description"].ToString()
                    };
                    lst.Add(SDC);
                }
            }
            return lst;
        }
        public StaticDataCommon GetStaticDataById(string staticdataId,string staticdatatypeId)
        {
            string sql = "exec [sproc_static_data_setup]";
            sql += " @flag='sdid'";
            sql += " ,@sdata_type_id=" + dao.FilterString(staticdatatypeId);
            sql += " ,@sdatarowid=" + dao.FilterString(staticdataId);
            var dt = dao.ExecuteDataRow(sql);
            StaticDataCommon SDC = new StaticDataCommon();
            if(dt!=null)
            {
                SDC.StaticDataId =dt["static_data_row_id"].ToString();
                SDC.StaticDataTypeId =dt["sdata_type_id"].ToString();
                SDC.StaticDataLabel =dt["static_data_label"].ToString();
                SDC.StaticDataValue =dt["static_data_value"].ToString();
                SDC.StaticDataDescription = dt["static_data_description"].ToString();
                SDC.AdditionalValue1 = dt["additional_value1"].ToString();
                SDC.AdditionalValue2 = dt["additional_value2"].ToString();
                SDC.AdditionalValue3 = dt["additional_value3"].ToString();
                SDC.AdditionalValue4 = dt["additional_value4"].ToString();
            }
            return SDC;
        }
        public CommonDbResponse ManageStaticData(StaticDataCommon sdc)
        {
            string sql = "exec [sproc_static_data_setup]";
            sql += " @flag='"+(string.IsNullOrEmpty(sdc.StaticDataId)?"i":"u")+"'";
            sql += " ,@sdata_type_id=" + dao.FilterString(sdc.StaticDataTypeId);
            sql += " ,@sdatarowid=" + dao.FilterString(sdc.StaticDataId);
            sql += " ,@slabel=" + dao.FilterString(sdc.StaticDataLabel);
            sql += " ,@svalue=" + dao.FilterString(sdc.StaticDataValue);
            sql += " ,@sdatatype=" + dao.FilterString(sdc.StaticDataDescription);
            sql += " , @additional_value1=" + dao.FilterString(sdc.AdditionalValue1);
            sql += " , @additional_value2=" + dao.FilterString(sdc.AdditionalValue2);
            sql += " , @additional_value3=" + dao.FilterString(sdc.AdditionalValue3);
            sql += " , @additional_value4=" + dao.FilterString(sdc.AdditionalValue4);
            sql += " ,@createdby=" + dao.FilterString(sdc.ActionUser);

            return dao.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse block_unblockStaticData(StaticDataCommon SDC, string status)
        {
            string sql = "exec sproc_static_data_setup ";
            sql += "@flag='d'";
            sql += ",@status=" + dao.FilterString(status);
            sql += ",@sdatarowid=" + dao.FilterString(SDC.StaticDataId);
            sql += ",@sdata_type_id=" + dao.FilterString(SDC.StaticDataTypeId);
            sql += ",@createdby=" + dao.FilterString(SDC.ActionUser);
            return dao.ParseCommonDbResponse(sql);

        }


    }
}
