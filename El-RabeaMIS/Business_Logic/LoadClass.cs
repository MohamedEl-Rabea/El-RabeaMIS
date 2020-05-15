using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class LoadClass
    {
        public string ID { get; set; }
        public string ClientName { get; set; }
        public string DriverName { get; set; }
        public string CarNumber { get; set; }
        public string LoadType { get; set; }
        public DateTime LoadDate { get; set; }
        public int FilledLoad { get; set; }
        public int EmptyLoad { get; set; }
        public string FilledTime { get; set; }
        public string EmptyTime { get; set; }
        public double Cost { get; set; }
        public bool IsPaid { get; set; }
        public int? LoadCount { get; set; }
        public bool IsResponsible { get; set; }
        public string Notes { get; set; }


        public bool Add_Load(out string m, out string ID)
        {
            m = "";
            ID = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("NewLoad", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@DriverName", SqlDbType.NVarChar).Value = this.DriverName;
                cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = this.ClientName;
                cmd.Parameters.Add("@CarNumber", SqlDbType.NVarChar).Value = this.CarNumber;
                cmd.Parameters.Add("@LoadType", SqlDbType.NVarChar).Value = this.LoadType;
                cmd.Parameters.Add("@LoadDate", SqlDbType.Date).Value = this.LoadDate;
                cmd.Parameters.Add("@FilledTime", SqlDbType.NVarChar).Value = this.FilledTime;
                cmd.Parameters.Add("@EmptyTime", SqlDbType.NVarChar).Value = this.EmptyTime;
                cmd.Parameters.Add("@FilledLoad", SqlDbType.Int).Value = this.FilledLoad;
                cmd.Parameters.Add("@EmptyLoad", SqlDbType.Int).Value = this.EmptyLoad;
                cmd.Parameters.Add("@LoadCount", SqlDbType.Int).Value = this.LoadCount;
                cmd.Parameters.Add("@Cost", SqlDbType.SmallMoney).Value = this.Cost;
                cmd.Parameters.Add("@IsPaid", SqlDbType.Bit).Value = this.IsPaid;
                cmd.Parameters.Add("@IsResponsible", SqlDbType.Bit).Value = this.IsResponsible;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = this.Notes;
                cmd.Parameters.Add("@Load_ID", SqlDbType.BigInt);
                cmd.Parameters["@Load_ID"].Direction = ParameterDirection.Output;
                con.Open();
                cmd.ExecuteNonQuery();
                ID = cmd.Parameters["@Load_ID"].Value.ToString();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                b = false;
            }
            return b;
        }

        public bool Delete_Load(out string m)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete from tblLoad where ID = @ID", con);
                SqlParameter Param_ID = new SqlParameter("@ID", this.ID);
                cmd.Parameters.Add(Param_ID);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                b = false;
            }
            return b;
        }

        public bool Update_Load_Status(out string m)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("UpdatePayStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ID", SqlDbType.BigInt).Value = this.ID;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                b = false;                
                m = ex.Message;
            }
            return b;
        }

        public static List<LoadClass> GetLoadsByDate(DateTime LoadDate)
        {
            List<LoadClass> Loads = new List<LoadClass>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SelectLoadsByDate", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = LoadDate;
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
                load.Cost = Convert.ToDouble(rdr["Cost"]);
                load.IsPaid = Convert.ToBoolean(rdr["IsPaid"]);
                Loads.Add(load);
            }
            rdr.Close();
            con.Close();
            return Loads;
        }

        public static List<LoadClass> GetAllLoads(DateTime LoadDate)
        {
            List<LoadClass> Loads = new List<LoadClass>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SelectMonthlLoads", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@SelecetedDate", SqlDbType.Date).Value = LoadDate;
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
                load.Cost = Convert.ToDouble(rdr["Cost"]);
                load.IsPaid = Convert.ToBoolean(rdr["IsPaid"]);
                load.LoadCount = Convert.ToInt32(rdr["LoadCount"] is DBNull ? 0 : rdr["LoadCount"]);
                Loads.Add(load);
            }
            rdr.Close();
            con.Close();
            return Loads;
        }

        public static List<DateTime> GetDistinctDates()
        {
            List<DateTime> Dates = new List<DateTime>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("select distinct LoadDate from tblLoad order by LoadDate", con);
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Dates.Add(Convert.ToDateTime(rdr["LoadDate"]));
            }
            rdr.Close();
            con.Close();
            return Dates;
        }

        public void GetLoadByID()
        {
            List<LoadClass> Loads = new List<LoadClass>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SelectLoadsByID", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@ID", SqlDbType.BigInt).Value = this.ID;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                this.ID = rdr["ID"].ToString();
                this.ClientName = Convert.ToString(rdr["ClientName"]);
                this.DriverName = Convert.ToString(rdr["DriverName"]);
                this.CarNumber = Convert.ToString(rdr["CarNumber"]);
                this.LoadDate = Convert.ToDateTime(rdr["LoadDate"]);
                this.LoadType = Convert.ToString(rdr["LoadType"]);
                this.EmptyTime = Convert.ToString(rdr["EmptyTime"]);
                this.FilledTime = Convert.ToString(rdr["FilledTime"]);
                this.EmptyLoad = Convert.ToInt32(rdr["EmptyLoad"]);
                this.FilledLoad = Convert.ToInt32(rdr["FilledLoad"]);
                this.Cost = Convert.ToDouble(rdr["Cost"]);
                this.IsPaid = Convert.ToBoolean(rdr["IsPaid"]);
                this.Notes = Convert.ToString(rdr["Notes"]);
                this.IsResponsible = Convert.ToBoolean(rdr["IsResponsible"]);
                if (rdr["LoadCount"] is DBNull)
                {
                    this.LoadCount = null;
                }
                else
                {
                    this.LoadCount = Convert.ToInt32(rdr["LoadCount"]);
                }
            }
            rdr.Close();
            con.Close();
        }

        public bool Update_Load(out string m)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("UpdateLoad", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ID", SqlDbType.BigInt).Value = this.ID;
                cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = this.ClientName;
                cmd.Parameters.Add("@DriverName", SqlDbType.NVarChar).Value = this.DriverName;
                cmd.Parameters.Add("@CarNumber", SqlDbType.NVarChar).Value = this.CarNumber;
                cmd.Parameters.Add("@LoadType", SqlDbType.NVarChar).Value = this.LoadType;
                cmd.Parameters.Add("@LoadDate", SqlDbType.Date).Value = this.LoadDate;
                cmd.Parameters.Add("@FilledTime", SqlDbType.NVarChar).Value = this.FilledTime;
                cmd.Parameters.Add("@EmptyTime", SqlDbType.NVarChar).Value = this.EmptyTime;
                cmd.Parameters.Add("@FilledLoad", SqlDbType.Int).Value = this.FilledLoad;
                cmd.Parameters.Add("@EmptyLoad", SqlDbType.Int).Value = this.EmptyLoad;
                cmd.Parameters.Add("@Cost", SqlDbType.SmallMoney).Value = this.Cost;
                cmd.Parameters.Add("@IsPaid", SqlDbType.Bit).Value = this.IsPaid;
                cmd.Parameters.Add("@IsResponsible", SqlDbType.Bit).Value = this.IsResponsible;
                cmd.Parameters.Add("@LoadCount", SqlDbType.Int).Value = this.LoadCount;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = this.Notes;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                b = false;
            }
            return b;
        }
    }
}