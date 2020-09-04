using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;

namespace cgpay.wallet.application.Library
{
    public static class CommonFunctions
    {

        public static string SingnatureGenerator<T>(T item)
        {
            Type type = item.GetType();
            PropertyInfo[] props = type.GetProperties();
            var signature = "";
            foreach (var prop in props.ToList().OrderBy(x => x.Name))
            {

                try
                {
                    //if (!prop.Name.Equals("Signature"))
                    signature += prop.GetValue(item).ToString();
                }
                catch
                {
                    signature += "";
                }

            }
            return signature;
        }


        public static string SerializeObjectToJSON(this object obj)
        {
            string serializedObject = string.Empty;
            serializedObject = JsonConvert.SerializeObject(obj);
            return serializedObject;
        }

        public static string Getwayurl()
        {
            if (ConfigurationManager.AppSettings["phase"] != null && ConfigurationManager.AppSettings["phase"].ToLower() == "local")
                return "http://localhost:61236/payment/index";
            if (ConfigurationManager.AppSettings["phase"] != null && ConfigurationManager.AppSettings["phase"].ToLower() == "development")
                return "http://202.79.47.32:8092/payment/index";
            if (ConfigurationManager.AppSettings["phase"] != null && ConfigurationManager.AppSettings["phase"].ToLower() == "uat")
                return "https://gatewaysandbox.nepalpayment.com/payment/index";
            return "https://gateway.nepalpayment.com/payment/index";
        }
    }
}