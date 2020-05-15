using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;

namespace El_RabeaMIS
{
    /// <summary>
    /// Summary description for WebServicePostData
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WebServicePostData : System.Web.Services.WebService
    {

        [WebMethod]
        public void DeleteLoad(string LoadType)
        {
            string connectionStr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(connectionStr);
            SqlCommand cmd = new SqlCommand("DisableLoad", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@LoadName", SqlDbType.NVarChar).Value = LoadType;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}
