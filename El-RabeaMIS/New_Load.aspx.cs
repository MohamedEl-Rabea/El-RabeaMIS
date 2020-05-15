using System;
using System.Web.UI.WebControls;
using Business_Logic;

namespace El_RabeaMIS
{
    public partial class New_Load : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ID"] != null)
                {
                    LoadClass load = new LoadClass();
                    load.ID = Request.QueryString["ID"].ToString();
                    load.GetLoadByID();
                    txtClientName.Text = load.ClientName;
                    txtDriverName.Text = load.DriverName;
                    txtCarNumber.Text = load.CarNumber;
                    txtDate.Text = load.LoadDate.ToShortDateString();
                    txtEmptyLoad.Text = load.EmptyLoad > 0 ? load.EmptyLoad.ToString() : "";
                    txtEmptyTime.Text = load.EmptyTime;
                    txtFilledLoad.Text = load.FilledLoad > 0 ? load.FilledLoad.ToString() : "";
                    txtFilledTime.Text = load.FilledTime;
                    txtLoadType.Text = load.LoadType;
                    txtCost.Text = load.Cost.ToString();
                    txtNotes.Text = load.Notes;
                    CbIsPaid.Checked = load.IsPaid;
                    cbIsResponsible.Checked = load.IsResponsible;
                    ViewState["ID"] = load.ID;
                    lblEmptyTime.Text = load.EmptyTime;
                    lblFilledTime.Text = load.FilledTime;
                    if (!string.IsNullOrEmpty(load.Notes))
                    {
                        lblNotes1.Visible = lblNotesTitle.Visible = true;
                        lblNotes1.Text = load.Notes;
                    }
                    else
                    {
                        lblNotes1.Visible =lblNotesTitle.Visible = false;
                    }
                    if (load.LoadCount == null)
                    {
                        txtCount.Text = "";
                    }
                    else
                    {
                        txtCount.Text = load.LoadCount.ToString();
                    }

                    BtnSave.Visible = false;
                    if (this.PreviousPage is Old_Load)
                    {
                        ((Button)((Site)Master).BtnOldLoad).BackColor = System.Drawing.Color.White;
                        ((Button)((Site)Master).BtnOldLoad).ForeColor = System.Drawing.Color.Black;
                    }
                    else
                    {
                        ((Button)((Site)Master).BtnSearchLoads).BackColor = System.Drawing.Color.White;
                        ((Button)((Site)Master).BtnSearchLoads).ForeColor = System.Drawing.Color.Black;
                    }
                }
                else
                {
                    ((Button)((Site)Master).BtnNewLoad).BackColor = System.Drawing.Color.White;
                    ((Button)((Site)Master).BtnNewLoad).ForeColor = System.Drawing.Color.Black;
                }
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            LoadClass load = new LoadClass();
            load.ClientName = txtClientName.Text;
            load.DriverName = txtDriverName.Text;
            load.CarNumber = txtCarNumber.Text;
            load.EmptyLoad = txtEmptyLoad.Text == "" ? 0 : Convert.ToInt32(txtEmptyLoad.Text);
            load.FilledLoad = txtFilledLoad.Text == "" ? 0 : Convert.ToInt32(txtFilledLoad.Text);
            load.EmptyTime = txtEmptyTime.Text;
            load.FilledTime = txtFilledTime.Text;
            load.LoadDate = Convert.ToDateTime(txtDate.Text);
            load.LoadType = txtLoadType.Text;
            load.Notes = txtNotes.Text;
            load.Cost = txtCost.Text == "" ? 0 : Convert.ToDouble(txtCost.Text);
            load.IsPaid = CbIsPaid.Checked;
            load.IsResponsible = cbIsResponsible.Checked;
            if (!string.IsNullOrEmpty(txtCount.Text))
            {
                load.LoadCount = Convert.ToInt32(txtCount.Text);
            }
            else
            {
                load.LoadCount = null;
            }
            string m, ID;
            if (!load.Add_Load(out m, out ID))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblSaveMsg.Text = "تم بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
                // use this flag in finish click btn to get rid of adding the same load twice
                ViewState["IsSaved"] = ID;
            }
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            LoadClass load = new LoadClass();
            load.ClientName = txtClientName.Text;
            load.DriverName = txtDriverName.Text;
            load.CarNumber = txtCarNumber.Text;
            load.EmptyLoad = txtEmptyLoad.Text == "" ? 0 : Convert.ToInt32(txtEmptyLoad.Text);
            load.FilledLoad = txtFilledLoad.Text == "" ? 0 : Convert.ToInt32(txtFilledLoad.Text);
            load.EmptyTime = txtEmptyTime.Text;
            load.FilledTime = txtFilledTime.Text;
            load.LoadDate = Convert.ToDateTime(txtDate.Text);
            load.LoadType = txtLoadType.Text;
            load.Notes = txtNotes.Text;
            load.Cost = txtCost.Text == "" ? 0 : Convert.ToDouble(txtCost.Text);
            load.IsPaid = CbIsPaid.Checked;
            load.IsResponsible = cbIsResponsible.Checked;
            if (!string.IsNullOrEmpty(txtCount.Text))
            {
                load.LoadCount = Convert.ToInt32(txtCount.Text);
            }
            else
            {
                load.LoadCount = null;
            }
            string m, ID;
            bool Done = true;
            if (Request.QueryString["ID"] != null)
            {
                load.ID = ID = Request.QueryString["ID"].ToString();
                if (!load.Update_Load(out m))
                {
                    lblSaveMsg.Text = m;
                    lblSaveMsg.ForeColor = System.Drawing.Color.Red;
                    Done = false;
                }
            }
            else
            {
                // check if the current load is saved before or not 
                if (ViewState["IsSaved"] == null)
                {
                    if (!load.Add_Load(out m, out ID))
                    {
                        lblSaveMsg.Text = m;
                        lblSaveMsg.ForeColor = System.Drawing.Color.Red;
                        Done = false;
                    }
                }
                else
                {
                    ID = ViewState["IsSaved"].ToString();
                }
            }
            if (Done)
            {
                load.ID = ID;
                lblDate.Text = txtDate.Text;
                lblID.Text = ID.ToString();
                lblCarNumber.Text = txtCarNumber.Text;
                lblClientName.Text = txtClientName.Text;
                lblDriver.Text = txtDriverName.Text;
                lblLoadType.Text = txtLoadType.Text;
                lblFilledLoad.Text = txtFilledLoad.Text;
                lblEmptyLoad.Text = txtEmptyLoad.Text;
                if (!string.IsNullOrEmpty(load.Notes))
                {
                    lblNotes1.Visible =lblNotesTitle.Visible =  true;
                    lblNotes1.Text = load.Notes;
                }
                else
                {
                    lblNotes1.Visible =lblNotesTitle.Visible = false;
                }
                lblNetLoad.Text = (Convert.ToInt32(txtFilledLoad.Text) - Convert.ToInt32(txtEmptyLoad.Text)).ToString();
                if (load.LoadCount == null)
                {
                    labelCount.Visible = false;
                    lblCount.Visible = false;
                }
                else
                {
                    labelCount.Visible  = lblCount.Visible = true;
                    lblCount.Text = txtCount.Text;                    
                }
                // get time for Loads
                load.GetLoadByID();
                lblEmptyTime.Text = load.EmptyTime;
                lblFilledTime.Text = load.FilledTime;
                PanelFooter1.Visible = cbIsResponsible.Checked;
                PanelPrint.Visible = true;
                PanelLoadInfo.Visible = false;
            }
        }
    }
}