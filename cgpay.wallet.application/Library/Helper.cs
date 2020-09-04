using cgpay.wallet.shared.Models.Role;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Data;
using System.Reflection;


namespace cgpay.wallet.application.Library
{
    public static class Helper
    {
        public static string GetActions(string Control, int Id, string ViewId)
        {
            var link = "<a href='/" + Control + "/Manage/" + Id + "' ><i class='fa fa-pencil'></i></a>";
            link += " | <a href='/" + Control + "/Delete/" + Id + "'><i class='fa fa-remove'></i></a>";
            if (Control.ToLower() == "user")
            {
                link += " | <a href='#' data-toggle='modal' data-target='#AddModal' onclick='GetDetailById(" + Id + ")'><i class='fa fa-gear'></i></a>";
            }
            else if (Control.ToLower() == "role")
            {
                link += " | <a href='/" + Control + "/Role/" + Id + "'><i class='fa fa-gear'></i></a>";
            }
            return link;
        }

        public static string GetMenuList(List<RoleDetails> data)
        {
            var sb = new StringBuilder("<table class='table table-bordered'>");

            foreach (var item in data.GroupBy(x => x.menuGroup).Select(y => y.First()))
            {
                var menu = data.Where(m => m.menuGroup == item.menuGroup);
                sb.AppendLine("<tr><th style='cursor:pointer' onclick=\"CheckFunction('" + item.menuGroup.Replace(" ", "_") + item.groupPosition + "')\" rowspan='" + (menu.GroupBy(x => x.parentFunctionId).Count() + 1) + "'>" + item.ParentGroup + " --> " + item.menuGroup + "</th></tr>");
                sb.AppendLine(GetMenuList(menu));
            }

            //var menu = data.Where(m => m.menuGroup.ToLower() == "user management");
            //sb.AppendLine("<tr><th onclick=\"CheckFunction(\"User Management\")\" rowspan='" + (menu.GroupBy(x => x.parentFunctionId).Count() + 1) + "'>User Management</th></tr>");
            //sb.AppendLine(GetMenuList(menu));

            //menu = data.Where(m => m.menuGroup.ToLower() == "application log");
            //sb.AppendLine("<tr><th onclick=\"CheckFunction(\"Application Log\")\" rowspan='" + (menu.GroupBy(x => x.parentFunctionId).Count() + 1) + "'>Application Log</th></tr>");
            //sb.AppendLine(GetMenuList(menu));

            sb.AppendLine("</table>");

            return sb.ToString();
        }

        private static string GetMenuList(IEnumerable<RoleDetails> menu)
        {
            var sb = new StringBuilder("");

            foreach (var item in menu.GroupBy(x => x.parentFunctionId).Select(y => y.First()))
            {
                sb.AppendLine("<tr>");
                sb.AppendLine("<td style='cursor:pointer' onclick=\"CheckFunction('" + item.menuName.Replace(" ", "_") + item.groupPosition + "')\" ><strong>" + item.menuName + "</strong></td>");
                sb.AppendLine("<td>");
                if (menu.Where(m => m.parentFunctionId == item.parentFunctionId) != null)
                {
                    foreach (var m in menu.Where(m => m.parentFunctionId == item.parentFunctionId))
                    {
                        string chk = "";
                        if (!string.IsNullOrWhiteSpace(m.hasChecked))
                        {
                            chk = "checked='checked'";
                        }
                        sb.AppendLine("<input type='checkbox' " + chk + " id='functionRole' name='functionRole' class='" + item.menuGroup.Replace(" ", "_") + item.groupPosition + "  " + item.menuName.Replace(" ", "_") + item.groupPosition + "' value='" + m.functionId + "' />" + m.functionName);
                        sb.AppendLine("</br>");
                    }
                }
                sb.AppendLine("</td></tr>");
            }

            return sb.ToString();
        }

        public static List<T> DataTableToList<T>(this DataTable table) where T : class, new()
        {
            try
            {
                List<T> list = new List<T>();

                foreach (var row in table.AsEnumerable())
                {
                    T obj = new T();

                    foreach (var prop in obj.GetType().GetProperties())
                    {
                        try
                        {
                            PropertyInfo propertyInfo = obj.GetType().GetProperty(prop.Name);
                            propertyInfo.SetValue(obj, Convert.ChangeType(row[prop.Name], propertyInfo.PropertyType), null);
                        }
                        catch
                        {
                            continue;
                        }
                    }

                    list.Add(obj);
                }

                return list;
            }
            catch
            {
                return null;
            }
        }


    }
}