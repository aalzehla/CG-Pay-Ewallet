using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Models;
using cgpay.wallet.shared.Models;
using Newtonsoft.Json;

namespace cgpay.wallet.application.Library
{
    public static class ApplicationUtilities
    {
        public static List<T> BindList<T>(this DataTable dt)
        {
            var fields = typeof(T).GetProperties().ToList();
            List<T> lst = new List<T>();
            foreach (DataRow dr in dt.Rows)
            {
                var ob = Activator.CreateInstance<T>();

                foreach (var fieldInfo in fields)
                {
                    foreach (DataColumn dc in dt.Columns)
                    {
                        if (fieldInfo.Name == dc.ColumnName)
                        {
                            Type type = fieldInfo.PropertyType;
                            if (!System.DBNull.Value.Equals(dr[dc.ColumnName]) && dr[dc.ColumnName] != null)
                            {
                                object value = GetValue(dr[dc.ColumnName], type);
                                fieldInfo.SetValue(ob, value);
                            }
                            break;
                        }
                    }
                }
                lst.Add(ob);
            }

            return lst;
        }
        public static T BindItem<T>(this DataRow dr)
        {
            var fields = typeof(T).GetProperties().ToList();
            T item = default(T);
            var ob = Activator.CreateInstance<T>();

            foreach (var fieldInfo in fields)
            {
                foreach (DataColumn dc in dr.Table.Columns)
                {
                    if (fieldInfo.Name == dc.ColumnName)
                    {
                        Type type = fieldInfo.PropertyType;
                        if (!System.DBNull.Value.Equals(dr[dc.ColumnName]) && dr[dc.ColumnName] != null)
                        {
                            object value = GetValue(dr[dc.ColumnName], type);
                            fieldInfo.SetValue(ob, value);
                        }
                        break;
                    }
                }
            }
            item = ob;
            return item;
        }
        static object GetValue(object ob, Type targetType)
        {
            if (targetType == null)
            {
                return null;
            }
            else if (targetType == typeof(String))
            {
                return ob + "";
            }
            else if (targetType == typeof(int))
            {
                int i = 0;
                int.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(short))
            {
                short i = 0;
                short.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(long))
            {
                long i = 0;
                long.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(ushort))
            {
                ushort i = 0;
                ushort.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(uint))
            {
                uint i = 0;
                uint.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(ulong))
            {
                ulong i = 0;
                ulong.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(double))
            {
                double i = 0;
                double.TryParse(ob + "", out i);
                return i;
            }
            else if (targetType == typeof(DateTime))
            {
                return ob.ToDateTime();
            }
            else if (targetType == typeof(bool))
            {
                return ob.ToBool();
            }
            else if (targetType == typeof(decimal))
            {
                return ob.ToDecimal();
            }
            else if (targetType == typeof(float))
            {
                return ob.ToFloat();
            }
            else if (targetType == typeof(byte) || targetType == typeof(byte[]))
            {
                return Encoding.UTF8.GetString(ob.ToByteArray());
            }
            ////else if (targetType == typeof(sbyte))
            ////{
            ////}
            else
            {
                return ob;
            }
        }
        public static DateTime? ToDateTime(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(DateTime))
            {
                return Convert.ToDateTime(value);
            }
            return null;
        }
        public static Int32? ToInt32(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(Int32))
            {
                return Int32.Parse(value.ToString());
            }
            return null;
        }
        public static Int16? ToInt16(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(Int16))
            {
                return Int16.Parse(value.ToString());
            }
            return null;
        }
        public static string ObjToString(this object value)
        {
            return value == null ? "" : value.ToString();
        }
        public static Int64? ToInt64(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(Int64))
            {
                return Int64.Parse(value.ToString());
            }
            return null;
        }
        public static bool? ToBool(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(bool))
            {
                return Convert.ToBoolean(value);
            }
            else if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(string))
            {
                if (value.ToString().ToLower() == "y" || value.ToString() == "1" || value.ToString() == "enable" ||
                    value.ToString() == "active" || value.ToString() == "enabled")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            return null;
        }
        public static decimal? ToDecimal(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(decimal))
            {
                return decimal.Parse(value.ToString());
            }
            return null;
        }
        public static float? ToFloat(this object value)
        {
            if (value != null && !System.DBNull.Value.Equals(value) && value.GetType() == typeof(float))
            {
                return float.Parse(value.ToString());
            }
            return null;
        }
        public static object ToObject(this object value)
        {
            return value;
        }
        public static byte[] ToBytes(this string value)
        {
            return Encoding.UTF8.GetBytes(value);
        }
        public static byte ToByte(this object value)
        {
            return Convert.ToByte(value);
        }
        public static byte[] ToByteArray(this object obj)
        {
            BinaryFormatter bf = new BinaryFormatter();
            using (var ms = new MemoryStream())
            {
                bf.Serialize(ms, obj);
                return ms.ToArray();
            }
        }
        public static object GetDataRow(this DataRow row, string ColumnName)
        {
            if (row != null)
            {
                return null;
            }
            if (row.Table.Columns.Contains(ColumnName))
            {
                return row[ColumnName];
            }
            return null;
        }
        public static string GenerateUrl(string url = "")
        {
            if (string.IsNullOrEmpty(url))
                url = "~/";
            return System.Web.VirtualPathUtility.ToAbsolute(url);
        }
        public static bool CheckPageRights(string functionid)
        {
            return true;
        }
        public static string AddSpaceBeforeCapitalLetter(string item)
        {
            if (string.IsNullOrEmpty(item))
                return "";
            return string.Concat(item.Select(x => Char.IsUpper(x) ? " " + x : x.ToString())).TrimStart(' ');
        }
        public static string GenerateBreadcum(string ControllerName, string PageName = "", string AddFunctionId = "", Dictionary<string, string> urlParameters = null, string ControllerDisplayName = null)
        {
            string AddFunctionPagePath = "";
            string AddFunctionPage = "";
            if (!string.IsNullOrEmpty(AddFunctionId))
            {
                if (ControllerName == "User" && PageName == "Index")
                {
                    AddFunctionPagePath = "/User/ManageAdminUser";
                    AddFunctionPage = "Add User";
                }
                else if (ControllerName == "ApiUser")
                {
                    if (PageName == "Index")
                    {
                        AddFunctionPagePath = "/ApiUser/Manage";
                        AddFunctionPage = "Add Api User Profile";
                    }
                    else if (PageName == "UsersList")
                    {
                        AddFunctionPagePath = "/ApiUser/ManageApiUser";
                        AddFunctionPage = "Add Api User";
                    }
                }
                else if (ControllerName == "Role" && PageName == "Index")
                {
                    AddFunctionPagePath = "/Admin/Role/Manage";
                    AddFunctionPage = "Add Role";
                }
                else if (ControllerName == "ApiFunction" && PageName == "Index")
                {
                    AddFunctionPagePath = "/ApiFunction/Manage";
                    AddFunctionPage = "Add Api Function";
                }

                if (AddFunctionPagePath != "" && urlParameters != null)
                {
                    var urlQuery = string.Join("&",
                        urlParameters.Select(kvp =>
                        string.Format("{0}={1}", kvp.Key, HttpUtility.UrlEncode(kvp.Value))));
                    AddFunctionPagePath += "?" + urlQuery;
                }
            }
            string breadcum = "<div class='page-header page-header-light'> " +
    "<div class='page-header-content header-elements-md-inline'> " +
        "<div class='page-title d-flex'> " +
            "<h4><i class='icon-arrow-left52 mr-2' onclick='window.history.back();'></i> <span class='font-weight-semibold'>" + (ControllerDisplayName ?? AddSpaceBeforeCapitalLetter(ControllerName)) + "</span> - " + (PageName == "Index" ? "View " + AddSpaceBeforeCapitalLetter(ControllerName) : PageName) + "</h4> " +
            "<a href='#' class='header-elements-toggle text-default d-md-none'><i class='icon-more'></i></a> " +
        "</div> " +

    "</div> " +
    "<div class='breadcrumb-line breadcrumb-line-light header-elements-md-inline'> " +
        "<div class='d-flex'> " +
            "<div class='breadcrumb'> " +
                "<a href='" + GenerateUrl() + "' class='breadcrumb-item'><i class='icon-home2 mr-2'></i> Home</a> " +
                "<a href='" + GenerateUrl("~/" + ControllerName) + "' class='breadcrumb-item'>" + (ControllerDisplayName ?? AddSpaceBeforeCapitalLetter(ControllerName)) + "</a> " +
                "<span class='breadcrumb-item active'>" + (PageName == "Index" ? "View " + AddSpaceBeforeCapitalLetter(ControllerName) : PageName) + "</span> " +
            "</div> " +
             "<a href='#' class='header-elements-toggle text-default d-md-none'><i class='icon-more'></i></a> " +
        "</div> " +
        "<div class='header-elements d-none'> " +
            "<div class='breadcrumb justify-content-center'> " +

                "<div class='breadcrumb-elements-item p-0'> " +

                     (String.IsNullOrEmpty(AddFunctionId) == false && HasPageRight(AddFunctionPagePath) ? "<a class='btn btn-primary' href='" + GenerateUrl(AddFunctionPagePath) + "'>" +
                     (String.IsNullOrEmpty(AddFunctionPage) ? "Add " + AddSpaceBeforeCapitalLetter(ControllerName) : AddSpaceBeforeCapitalLetter(AddFunctionPage)) + "<i class='icon-plus-circle2 ml-2'></i>" + "</a>" : "") +
                "</div> " +
            "</div> " +
        "</div> " +
    "</div> " +
"</div> ";
            return breadcum;
        }
        public static bool HasPageRight(string pagePath = "")
        {
            HttpContext context = HttpContext.Current;
            if (String.IsNullOrEmpty(pagePath))
            {
                var controllerName = string.Empty;
                var actionName = string.Empty;
                var areaName = string.Empty;
                var routeValues = context.Request.RequestContext.RouteData.Values;
                if (routeValues != null)
                {
                    if (routeValues.ContainsKey("area"))
                    {
                        areaName = routeValues["area"].ToString();
                    }
                    if (routeValues.ContainsKey("action"))
                    {
                        actionName = routeValues["action"].ToString();
                    }
                    if (routeValues.ContainsKey("controller"))
                    {
                        controllerName = routeValues["controller"].ToString();
                    }
                    var functions = context.Session["functions"] as List<string>;

                    if (!functions.Contains((areaName + "/" + controllerName + "/" + actionName).ToUpper()))
                    {
                        return false;
                    }
                }
            }
            else
            {
                pagePath = pagePath.Replace("~/", "");
                pagePath = pagePath.Contains("?") ? pagePath.Split('?')[0] : pagePath;
                var functions = (context.Session["functions"] as List<string>).ConvertAll(x => x.ToUpper());
                if (functions != null)
                    if (!functions.Contains(pagePath.ToUpper()))
                    {
                        return false;
                    }
            }
            return true;
        }
        public static void SetMessageInSession(this CommonDbResponse dbResponse)
        {
            if (HttpContext.Current.Session != null)
            {
                if (HttpContext.Current.Session["ResponseDbMessage"] != null)
                    HttpContext.Current.Session["ResponseDbMessage"] = dbResponse;
                else
                    HttpContext.Current.Session.Add("ResponseDbMessage", dbResponse);
            }
        }
        public static void SetMessageInTempData(this CommonDbResponse dbResponse, System.Web.Mvc.Controller controller, string ActionName = "")
        {
            if (controller.TempData.ContainsKey("ResponseDbMessage"))
                controller.TempData["ResponseDbMessage"] = dbResponse;
            else
                controller.TempData.Add("ResponseDbMessage", dbResponse);

        }
        public static void ShowPopup(this System.Web.Mvc.Controller Cont, Int32 code, string Message)
        {
            CommonDbResponse dbresp = new CommonDbResponse();
            if (code == 0)
            {
                dbresp.Code = ResponseCode.Success;
            }
            else
                dbresp.Code = ResponseCode.Failed;
            dbresp.Message = Message;
            dbresp.SetMessageInTempData(Cont);

        }
        public static CommonDbResponse GetMessageFromTempData()
        {
            if (HttpContext.Current.Session != null)
            {
                var dbResponse = HttpContext.Current.Session["ResponseDbMessage"] as CommonDbResponse;
                HttpContext.Current.Session.Remove("ResponseDbMessage");
                if (dbResponse == null)
                    return new CommonDbResponse();
                return dbResponse;
            }
            return new CommonDbResponse();
        }
        public static CommonDbResponse GetMessageFromSession()
        {
            if (HttpContext.Current.Session != null)
            {
                var dbResponse = HttpContext.Current.Session["ResponseDbMessage"] as CommonDbResponse;
                HttpContext.Current.Session.Remove("ResponseDbMessage");
                if (dbResponse == null)
                    return new CommonDbResponse();
                return dbResponse;
            }
            return new CommonDbResponse();
        }
        public static String GetIP(HttpContext context = null)
        {
            if (context == null)
                context = HttpContext.Current;
            String ip =
                context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (string.IsNullOrEmpty(ip))
            {
                ip = context.Request.ServerVariables["REMOTE_ADDR"];
            }

            return ip;
        }
        public static void LogRequest()
        {
            string requestBody = "";
            HttpContext context = HttpContext.Current;
            using (StreamReader reader = new StreamReader(context.Request.InputStream))
            {
                try
                {
                    context.Request.InputStream.Position = 0;
                    requestBody = reader.ReadToEnd();
                }
                catch (Exception ex)
                {
                    requestBody = string.Empty;
                    ////log errors
                }
                finally
                {
                    context.Request.InputStream.Position = 0;
                }
            }
            string requestUrl = context.Request.RawUrl;

        }
        public static object GetSessionValue(this System.Web.SessionState.HttpSessionState Session, string SessionKey)
        {
            if (Session != null)
            {
                if (Session[SessionKey] != null)
                {
                    return Session[SessionKey];
                }
            }
            return "";
        }
        public static T GetSessionValue<T>(this System.Web.SessionState.HttpSessionState Session, string SessionKey)
        {
            T t = default(T);
            if (Session != null)
            {
                if (Session[SessionKey] != null)
                {
                    t = (T)Session[SessionKey];
                }
            }
            return t;
        }
        public static object GetSessionValue(string SessionKey)
        {
            HttpContext context = HttpContext.Current;
            if (context != null)
            {
                var Session = context.Session;
                if (Session != null)
                {
                    if (Session[SessionKey] != null)
                    {
                        return Session[SessionKey];
                    }
                }
            }
            return "";
        }
        public static T GetSessionValue<T>(string SessionKey)
        {
            HttpContext context = HttpContext.Current;
            T t = default(T);
            if (context != null)
            {
                var Session = context.Session;
                if (Session != null)
                {
                    if (Session[SessionKey] != null)
                    {
                        t = (T)Session[SessionKey];
                    }
                }
            }
            return t;
        }

        public static string EncryptParameter(this string textToEncrypt)
        {
            StringCipher cipher = new StringCipher(GetSessionValue<string>("SessionGuid"));
            try
            {
                if (String.IsNullOrEmpty(textToEncrypt))
                    return "";
                var encoded = cipher.Encrypt(textToEncrypt);
                var replacedString = encoded.Replace("/", "41235asf421").Replace("+", "947421asf42514af").Replace("=", "77tt4yh788qqw");
                return replacedString;
            }
            catch
            {
                return "";
            }
        }
        public static string DecryptParameter(this string textToDecrypt)
        {
            StringCipher cipher = new StringCipher(GetSessionValue<string>("SessionGuid"));
            try
            {
                var replacedString = textToDecrypt.Replace("41235asf421", "/").Replace("947421asf42514af", "+").Replace("77tt4yh788qqw", "=");
                return cipher.Decrypt(replacedString);
            }
            catch
            {
                return "";
            }
        }

        public static string EncryptParameterForQr(this string textToEncrypt)
        {
            StringCipher cipher = new StringCipher("qrimageencryptorprivatekey");
            try
            {
                if (String.IsNullOrEmpty(textToEncrypt))
                    return "";
                var encoded = cipher.Encrypt(textToEncrypt);
                var replacedString = encoded.Replace("/", "41235asf421").Replace("+", "947421asf42514af").Replace("=", "77tt4yh788qqw");
                return replacedString;
            }
            catch
            {
                return "";
            }
        }
        public static string DecryptParameterForQr(this string textToDecrypt)
        {
            StringCipher cipher = new StringCipher("qrimageencryptorprivatekey");
            try
            {
                var replacedString = textToDecrypt.Replace("41235asf421", "/").Replace("947421asf42514af", "+").Replace("77tt4yh788qqw", "=");
                return cipher.Decrypt(replacedString);
            }
            catch
            {
                return "";
            }
        }

        public static List<SelectListItem> SetDDLValue(Dictionary<string, string> dictionary, string selectedVal, string defLabel = "", bool isTextAsValue = false)
        {
            List<SelectListItem> items = new List<SelectListItem>();
            if (!string.IsNullOrWhiteSpace(defLabel))
            {
                items.Add(new SelectListItem { Text = defLabel, Value = "", Disabled = true });
            }
            if (dictionary.Count > 0)
            {

                foreach (var item in dictionary)
                {
                    string Value = item.Key;
                    string Name = item.Value;
                    if (isTextAsValue)
                        Value = Name;

                    if (Value == selectedVal)
                    {
                        items.Add(new SelectListItem { Text = Name, Value = Value, Selected = true });
                    }
                    else
                    {
                        items.Add(new SelectListItem { Text = Name, Value = Value });
                    }
                }
            }
            return items;
        }
        public static List<SelectListItem> SetDDLValueWithOpt(List<Tuple<string, string, string>> dictionary, string selectedVal, string defLabel = "", bool isTextAsValue = false)
        {
            Dictionary<string, Dictionary<string, string>> tc = new Dictionary<string, Dictionary<string, string>>();
            string group_name = string.Empty;
            if (dictionary.Count > 0)
            {
                foreach (var item in dictionary)
                {
                    group_name = item.Item3;
                    if (tc.ContainsKey(group_name))
                    {
                        var dict = tc[group_name];
                        dict.Add(item.Item1, item.Item2);
                        tc[group_name] = dict;
                    }
                    else
                    {
                        var dict = new Dictionary<string, string>();
                        dict.Add(item.Item1, item.Item2);
                        tc.Add(group_name, dict);
                    }
                }
            }
            List<SelectListItem> items = new List<SelectListItem>();
            if (!string.IsNullOrWhiteSpace(defLabel))
            {
                items.Add(new SelectListItem { Text = defLabel, Value = "" });
            }
            if (tc.Count > 0)
            {

                foreach (var item in tc)
                {
                    SelectListGroup group = new SelectListGroup();
                    group.Name = item.Key;
                    foreach (var piece in item.Value)
                    {
                        string Value = piece.Key;
                        string Name = piece.Value;
                        if (isTextAsValue)
                            Value = Name;

                        if (Value == selectedVal)
                        {
                            items.Add(new SelectListItem { Text = Name, Value = Value, Group = group, Selected = true });
                        }
                        else
                        {
                            items.Add(new SelectListItem { Text = Name, Value = Value, Group = group, });
                        }
                    }
                }
            }
            return items;
        }
        public static List<SelectListItem> SetDDLValueMultiSelectWithGroup(List<Tuple<string, string, string, bool>> dictionary)
        {
            Dictionary<string, List<Tuple<string, string, bool>>> tc = new Dictionary<string, List<Tuple<string, string, bool>>>();
            string group_name = string.Empty;
            if (dictionary.Count > 0)
            {
                foreach (var item in dictionary)
                {
                    group_name = item.Item3;
                    if (tc.ContainsKey(group_name))
                    {
                        var dict = tc[group_name];
                        dict.Add(new Tuple<string, string, bool>(item.Item1, item.Item2, item.Item4));
                        tc[group_name] = dict;
                    }
                    else
                    {
                        ////var dict = new Dictionary<string, List<Tuple<string, string, bool>>>();
                        List<Tuple<string, string, bool>> lst = new List<Tuple<string, string, bool>>();
                        lst.Add(new Tuple<string, string, bool>(item.Item1, item.Item2, item.Item4));
                        ////dict.Add(item.Item1, lst);
                        tc.Add(group_name, lst);
                    }
                }
            }
            List<SelectListItem> items = new List<SelectListItem>();

            if (tc.Count > 0)
            {

                foreach (var item in tc)
                {
                    SelectListGroup group = new SelectListGroup();
                    group.Name = item.Key;
                    foreach (var piece in item.Value)
                    {
                        string Value = piece.Item1;
                        string Name = piece.Item2;

                        if (piece.Item3)
                        {
                            items.Add(new SelectListItem { Text = Name, Value = Value, Group = group, Selected = true });
                        }
                        else
                        {
                            items.Add(new SelectListItem { Text = Name, Value = Value, Group = group, });
                        }
                    }
                }
            }
            return items;
        }
        public static T MapObject<T>(this object item)
        {
            T sr = default(T);
            if (item != null)
            {
                var obj = Newtonsoft.Json.JsonConvert.SerializeObject(item);
                sr = JsonConvert.DeserializeObject<T>(obj);
            }
            return sr;
        }
        public static List<T> MapObjects<T>(this object item)
        {
            List<T> sr = default(List<T>);
            if (item != null)
            {
                var obj = Newtonsoft.Json.JsonConvert.SerializeObject(item);
                sr = JsonConvert.DeserializeObject<List<T>>(obj);
            }
            return sr;
        }

        public static T SerializeJSON<T>(this string jsonString)
        {
            T modelType = default(T);
            modelType = JsonConvert.DeserializeObject<T>(jsonString);
            return modelType;

        }

        public static string FormBuilder(string BankCode, string FormMethod, string configUrl, Dictionary<String, string> BankFormParams)
        {
            StringBuilder sb = new StringBuilder();


            sb.Append("<html>");
            sb.AppendFormat("<script src=" + "\"" + "/Scripts/jquery-1.11.1.min.js" + "\"" + " type=" + "\"" + "text/javascript" + "\"" + "></script>");
            sb.AppendFormat("<script src=" + "\"" + "/Scripts/blockUI.js" + "\"" + " type=" + "\"" + "text/javascript" + "\"" + "></script>");
            sb.AppendFormat("<script type=" + "\"" + "text/javascript" + "\"" + ">");
            sb.Append("$(document).ready(function () {$.blockUI({css: { border: 'none',padding: '15px',backgroundColor: '#000','-webkit-border-radius': '10px','-moz-border-radius': '10px',opacity: .5,color: '#fff'}})});");
            sb.Append("</script>");


            sb.AppendFormat(@"<body onload='document.forms[" + "\"" + BankCode + "\"" + "].submit()'>");
            sb.AppendFormat("<form name='" + BankCode + "' action='" + configUrl + "' method='" + FormMethod + "' >");


            foreach (string key in BankFormParams.Keys)
            {
                System.Web.HttpContext.Current.Response.Write(string.Format("", key, BankFormParams[key]));
                sb.AppendFormat("<input type='hidden'" + " name='" + key + "' value='" + BankFormParams[key] + "'>");
            }

            //bankFormParams += "" + key + "=" + BankFormParams[key] + (i < BankFormParams.Keys.Count ? "&" : "");
            sb.Append("</form>");
            sb.Append("</body>");
            sb.Append("</html>");
            return sb.ToString();
        }
        public static string GetAppConfigValue(string keyname)
        {
            if (ConfigurationManager.AppSettings[keyname] != null)
            {
                return ConfigurationManager.AppSettings[keyname].ToString();
            }
            return string.Empty;
        }
    }
}