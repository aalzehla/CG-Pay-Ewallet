using System.Collections.Generic;

namespace admin.onepg.api.Models
{
    public class CommonResponse
    {
        public CommonResponse()
        {
            errors = new List<Errors>();
        }
     
        public string code { get; set; }

        public string message { get; set; }
 
        public List<Errors> errors { get; set; }

        public object data { get; set; }

    }
    public class Errors
    {
        public string error_code { get; set; }
        public string error_message { get; set; }
    }
}