using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.AppVersionControl;

namespace cgpay.wallet.repository.AppVersionControl
{
    public class AppVersionControlRepository:IAppVersionControlRepository
    {
        RepositoryDao dao;
        public AppVersionControlRepository()
        {
            dao = new RepositoryDao();
        }
        public List<AppVersionControlCommon> GetAppVersionList()
        {
            string sql = "exec sproc_app_version_control ";
                sql += " @flag='s'";
            var dt = dao.ExecuteDataTable(sql);
            var list = new List<AppVersionControlCommon>();
            if(dt!=null)
            {
                foreach(DataRow item in dt.Rows )
                {
                    AppVersionControlCommon common = new AppVersionControlCommon()
                    {
                        VersionId=item["vid"].ToString(),
                        AppVersion=item["app_version"].ToString(),
                        AppPlatform=item["app_platform"].ToString(),
                        IsMajorUpdate=item["is_major_update"].ToString(),
                        IsMinorUpdate=item["is_minor_update"].ToString(),           
                        CreatedBy=item["created_by"].ToString()           

                    };
                    list.Add(common);
                }
            }
            return list;
        }
        public CommonDbResponse ManageAppVersion(AppVersionControlCommon AVC)
        {
            string sql = "exec sproc_app_version_control ";
            sql += " @flag='i'";
            sql += " ,@app_platform="+dao.FilterString(AVC.AppPlatform);
            sql += " ,@app_version=" + dao.FilterString(AVC.AppVersion);
            sql += " ,@is_major_update=" + dao.FilterString(AVC.IsMajorUpdate);
            sql += " ,@is_minor_update=" + dao.FilterString(AVC.IsMinorUpdate);
            sql += " ,@app_update_info=" + dao.FilterString(AVC.AppUpdateInfo);
            sql += " ,@ipAddress=" + dao.FilterString(AVC.IpAddress);
            sql += " ,@Action_user=" + dao.FilterString(AVC.ActionUser);
            return dao.ParseCommonDbResponse(sql);
        }
    }
}
