using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using Business_Logic;

namespace El_RabeaMIS
{
    /// <summary>
    /// Summary description for GetLoadsDatsService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class GetLoadsDatsService : System.Web.Services.WebService
    {
        [WebMethod]
        public void GetData(int Year)
        {
            List<LoadClass> Loads = new List<LoadClass>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SelectLoadsBYear", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Year", SqlDbType.Int).Value = Year;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                LoadClass load = new LoadClass();
                load.ID = rdr["ID"].ToString();
                load.ClientName = Convert.ToString(rdr["ClientName"]);
                load.CarNumber = Convert.ToString(rdr["CarNumber"]);
                load.DriverName = Convert.ToString(rdr["DriverName"]);
                load.LoadDate = Convert.ToDateTime(rdr["LoadDate"]);
                load.LoadType = Convert.ToString(rdr["LoadType"]);
                load.EmptyTime = Convert.ToString(rdr["EmptyTime"]);
                load.FilledTime = Convert.ToString(rdr["FilledTime"]);
                load.EmptyLoad = Convert.ToInt32(rdr["EmptyLoad"]);
                load.FilledLoad = Convert.ToInt32(rdr["FilledLoad"]);
                load.Cost = Convert.ToDouble(rdr["Cost"]);
                load.LoadCount = Convert.ToInt32(rdr["LoadCount"] is DBNull ? 0 : rdr["LoadCount"]);
                load.IsPaid = Convert.ToBoolean(rdr["IsPaid"]);
                Loads.Add(load);
            }
            rdr.Close();
            con.Close();
            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = Int32.MaxValue;
            Context.Response.Write(js.Serialize(Loads));
        }

        [WebMethod]
        public void GetDataByMonth(int Year, int Month)
        {
            List<LoadClass> Loads = new List<LoadClass>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SelectLoadsBYearAndMonth", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Year", SqlDbType.Int).Value = Year;
            cmd.Parameters.Add("@Month", SqlDbType.Int).Value = Month;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                LoadClass load = new LoadClass();
                load.ID = rdr["ID"].ToString();
                load.ClientName = Convert.ToString(rdr["ClientName"]);
                load.DriverName = Convert.ToString(rdr["DriverName"]);
                load.CarNumber = Convert.ToString(rdr["CarNumber"]);
                load.LoadDate = Convert.ToDateTime(rdr["LoadDate"]);
                load.LoadType = Convert.ToString(rdr["LoadType"]);
                load.EmptyTime = Convert.ToString(rdr["EmptyTime"]);
                load.FilledTime = Convert.ToString(rdr["FilledTime"]);
                load.EmptyLoad = Convert.ToInt32(rdr["EmptyLoad"]);
                load.FilledLoad = Convert.ToInt32(rdr["FilledLoad"]);
                load.LoadCount = Convert.ToInt32(rdr["LoadCount"] is DBNull ? 0 : rdr["LoadCount"]);
                load.Cost = Convert.ToDouble(rdr["Cost"]);
                load.IsPaid = Convert.ToBoolean(rdr["IsPaid"]);
                Loads.Add(load);
            }
            rdr.Close();
            con.Close();
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Write(js.Serialize(Loads));
        }
    }
}
