<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="El_RabeaMIS.Inventory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Script/jquery-2.1.4.js"></script>
    <script>
        $(document).ready(function () {

            var SearchOption = '';
            var searchTd = 3;// the td in which we compare our typedtext with its text default = 3 matches o carnumber td
            $('#RdBtLstSearchOption').click(function () {
                SearchOption = $(this).find('input:checked').val();
                if (SearchOption == "ClientName") {
                    searchTd = 2;
                    $('#txtSearch').val('').attr('placeholder', 'اسم العميل للبحث . . . . .');
                }
                else {
                    searchTd = 3;
                    $('#txtSearch').val('').attr('placeholder', 'رقم السيارة للبحث . . . . .');
                }
            });

            // allow search on gridview
            var MyGridRows = $('#GridViewDayLoads tr:has(td)');
            $('#txtSearch').keyup(function () {
                var TypedValue = $(this).val().toLowerCase();
                if (TypedValue == '') {
                    MyGridRows.show();
                }
                else {
                    $('#GridViewDayLoads tr:has(td)').each(function () {
                        var TdValue = $(this).find('td:eq(' + searchTd + ')').text().toLowerCase();
                        if (TdValue.indexOf(TypedValue) > -1) {
                            $(this).show();
                        }
                        else {
                            $(this).hide();
                        }
                    });
                }
            });

            var Rows = $('#<%= GridViewDayLoads.ClientID%> tr:has(td)');
            var NetValue = 0;

            Rows.each(function () {
                var CurrentRow = $(this);
                var LoadID = $(this).find('td:eq(0)').text();
                var IsPaidCell = $(this).find('td:eq(6)');
                var BackColorRow, BackColorCell;
                var IsPaidValue = IsPaidCell.text();
                var LoadCost = parseFloat($(this).find('td:eq(5)').text());
                IsPaidCell.hover(function () {
                    IsPaidCell.css('cursor', 'pointer');
                    BackColor = CurrentRow.css('background-color');
                    BackColorCell = IsPaidCell.css('background-color');
                    CurrentRow.css('background-color', '#ffd800');
                    IsPaidCell.css('background-color', '#ffd800');
                }, function () {
                    CurrentRow.css('background-color', BackColor);
                    IsPaidCell.css('background-color', BackColorCell);
                });

                if (IsPaidValue == 'False') {
                    IsPaidCell.text('باقى');
                }
                else {
                    IsPaidCell.text('');
                    IsPaidCell.css('background-color', '#1abc9c');
                    NetValue += LoadCost;
                }

                IsPaidCell.click(function () {
                    // if the cell is paid do unpaid proces and vic versa
                    $.ajax({
                        url: "Inventory.aspx/UpdatePayStatus",
                        method: "Post",
                        data: '{ LoadID:' + JSON.stringify(LoadID) + '}',
                        contentType: 'application/json;charset:utf-8',
                        dataType: "json",
                        success: function (data) {
                            //change the pay status and change the back-color depend on it
                            if (data.d == "Done") {
                                if (IsPaidCell.text() == "باقى") {
                                    IsPaidCell.text('');
                                    IsPaidCell.css('background-color', '#1abc9c');
                                    BackColorCell = IsPaidCell.css('background-color');
                                    NetValue += LoadCost;
                                }
                                else {
                                    IsPaidCell.text('باقى');
                                    IsPaidCell.css('background-color', 'white');
                                    BackColorCell = IsPaidCell.css('background-color');
                                    NetValue -= LoadCost;
                                }
                                $('#<%= lblNetValue.ClientID%>').text(NetValue);
                            }
                        },
                        error: function (Err) {
                            alert(Err.status);
                        }
                    });
                });
            });

            $('#<%= lblNetValue.ClientID%>').text(NetValue);
        });

        function PrintDivContent(divId) {
            var printContent = document.getElementById(divId);
            var WinPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            WinPrint.document.write('<html><head><title></title>');
            WinPrint.document.write('<link rel="stylesheet" href="CSS/Prices_List_Style_Sheet.css" type="text/css" />');
            WinPrint.document.write('</head><body >');
            WinPrint.document.write(printContent.innerHTML);
            WinPrint.document.write('</body></html>');
            WinPrint.document.close();
            function show() {
                if (WinPrint.document.readyState === "complete") {
                    WinPrint.focus();
                    WinPrint.print();
                    WinPrint.close();
                } else {
                    setTimeout(show, 100);
                }
            };
            show();

            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="placeHolderContentDiv" runat="server">
    <header style="text-align: right">
        <table style="border-collapse: collapse;">
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="التاريــــــخ : " CssClass="Labels"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtDate" placeholder="تاريخ الكشف" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" CssClass="TextBoxs"></asp:TextBox>
                </td>
                <td>
                    <asp:Button ID="BtnGetInventory" runat="server" Text="بحــــــث" CssClass="ButtonAddStyle4" OnClick="BtnGetInventory_Click" />
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorDate" runat="server"
                        ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="يجب اضافة تاريخ الحمولة">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="يجب اضافة تاريخ الحمولة بشكل صحيح"
                        Operator="DataTypeCheck" Type="Date">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
                </td>
            </tr>
        </table>
    </header>
    <header style="text-align: left">
        <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="28" Height="28" OnClientClick="PrintDivContent('DivToPrint');" />
    </header>
    <section class="Search_Section">
        <asp:RadioButtonList ID="RdBtLstSearchOption" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="SearchOptions">
            <asp:ListItem Text="رقم السيارة" Value="CarNumber" Selected="True" />
            <asp:ListItem Text="اسم العميل" Value="ClientName" />
        </asp:RadioButtonList>
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClientClick="return false" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="رقم السيارة للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <div id="DivToPrint">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; min-height: 900px; padding: 10px; margin-bottom: 10px; border-bottom: 1px solid black; height: 220px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black; text-align: center">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">ميزان بسكول (الحاج قطب)</p>
                    <p style="font: bold 13px arial; margin: 0; padding: 0">الالكترونى 120 طن</p>
                    <p style="font: bold 13px arial; margin: 0; padding: 0">بنى مزار - صندفا- الطريق الجديد</p>
                    <p style="font: bold 13px arial; margin: 0; padding: 0">ت / 01220989657 - 01008539045</p>
                </div>
            </header>
            <header style="margin: auto; margin-bottom: 10px; width: 200px;">
                <div style="border: 1px solid black; text-align: center">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">كشف حساب</p>
                </div>
            </header>
            <header>
                <table>
                    <tr>
                        <td>
                            <asp:Label ID="Label33" runat="server" Text=" صافى الحساب :" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblNetValue" runat="server" CssClass="lblInfo2"></asp:Label>
                        </td>
                    </tr>
                </table>
            </header>
            <asp:Panel runat="server" CssClass="ContainerPanel">
                <asp:GridView runat="server" ID="GridViewDayLoads" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="GridStyle">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="م" />
                        <asp:BoundField DataField="LoadDate" HeaderText="التاريخ" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" />
                        <asp:BoundField DataField="CarNumber" HeaderText="رقم السيارة" />
                        <asp:BoundField DataField="LoadType" HeaderText="نوع الحمولة" />
                        <asp:BoundField DataField="Cost" HeaderText="التكلفه" />
                        <asp:BoundField DataField="IsPaid" HeaderText="مدفوعه" />
                    </Columns>
                    <HeaderStyle CssClass="headerStyle2" />
                    <EmptyDataRowStyle CssClass="EmptyStyle" />
                    <RowStyle CssClass="Row_Style" />
                </asp:GridView>
            </asp:Panel>
        </section>
    </div>
</asp:Content>
