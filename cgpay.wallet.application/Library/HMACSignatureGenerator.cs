using System;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace cgpay.wallet.application.Library
{
    public class HMACSignatureGenerator
    {
        private const string secretKey = "1234567890";
        /// <summary>
        /// Used to Validate signature of required attributes only
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="item"></param>
        /// <returns></returns>
        internal static bool AutoValidateSignature<T>(T item, string secertKey)
        {
            Type type = item.GetType();
            PropertyInfo[] props = type.GetProperties();
            string signData = "";
            var signature = "";
            foreach (var prop in props.ToList().OrderBy(x => x.Name))
            {
                if (prop.Name.ToLower() != "signature")
                {
                    try
                    {
                        signData += prop.GetValue(item).ToString();
                    }
                    catch
                    {
                        signData += "";
                    }
                }
                else if (prop.Name.ToLower() == "signature")
                    signature = prop.GetValue(item).ToString();
            }
            if (signature != SHA512_ComputeHash(signData, secertKey))
                return false;
            else
                return true;
        }
        internal static bool ManualValidateSignature(string item, string signature)
        {
            if (signature != SHA512_ComputeHash(item, secretKey))
                return false;
            else
                return true;
        }
        internal static string SHA512_ComputeHash(string text, string secretKey)
        {
            var hash = new StringBuilder(); ;
            byte[] secretkeyBytes = Encoding.UTF8.GetBytes(secretKey);
            byte[] inputBytes = Encoding.UTF8.GetBytes(text);
            using (var hmac = new HMACSHA512(secretkeyBytes))
            {
                byte[] hashValue = hmac.ComputeHash(inputBytes);
                foreach (var theByte in hashValue)
                {
                    hash.Append(theByte.ToString("x2"));
                }
            }
            return hash.ToString();
        }
    }
}