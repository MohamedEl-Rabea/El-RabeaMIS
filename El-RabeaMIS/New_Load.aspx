<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="New_Load.aspx.cs" Inherits="El_RabeaMIS.New_Load" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Script/jquery-2.1.4.js"></script>
    <script src="Script/jquery-ui.js"></script>
    <link href="CSS/jquery-ui.css" rel="stylesheet" />
    <script>
        $(document).ready(function () {
            $('#OriginSection').clone().insertAfter('#OriginSection')[0];
            $('#CopiesSelect').change(function () {
                var SelectedVal = $(this).val();
                if (SelectedVal == 3) {
                    $($('#OriginSection')[0]).clone().insertAfter('#OriginSection')[0];
                }
            });

            var DeleteImg = $('#ImgDeleteLoad');
            var LoadType;
            function ShowDeleteImg(event, ui) {
                DeleteImg.css('display', 'block');
                $(this).val(ui.item.value);
                LoadType = ui.item.value;
                return false;
            };
            function HideDeleteImg() {
                DeleteImg.css('display', 'none');
            };

            DeleteImg.hover(function () {
                $(this).css('cursor', 'pointer');
            },
                function () {
                    $(this).css('cursor', 'auto');
                })

            DeleteImg.click(function () {
                $.ajax({
                    url: 'WebServicePostData.asmx/DeleteLoad',
                    method: 'Post',
                    data: { LoadType: LoadType },
                    success: function () {
                        $('#txtLoadType').val('');
                        HideDeleteImg();
                    },
                    error: function (err) {
                        alret(err.statusText);
                    }
                });
            });

            $('#<%= txtLoadType.ClientID %>').autocomplete({
                focus: ShowDeleteImg,
                select: HideDeleteImg,
                source: function (request, response) {
                    $.ajax({
                        url: "GetTypes.asmx/GetSuggestedTypes",
                        method: "Post",
                        data: { TypedValue: request.term },
                        dataType: "json",
                        success: function (data) {
                            response(data);
                        },
                        error: function (err) {
                            alert(err.statusText);
                        }
                    });
                }
            });


            $('input[name="hideAddressCheckBox"]').click(function (element) {
                if (element.currentTarget.checked)
                    $('table tr td[data-section="address"]').css('display', 'none');
                else
                    $('table tr td[data-section="address"]').css('display', '');
            });

            hideAddressCheckBox
        });
        function GetDate() {
            var CurrentDate = new Date();
            var Day = CurrentDate.getDate();
            var Month = CurrentDate.getMonth() + 1;
            var Year = CurrentDate.getFullYear();

            document.getElementById('txtDate').value = Day + ' / ' + Month + ' / ' + Year;
            return false;
        }

        function GetTime(control_ID) {
            var CurrentDate = new Date();
            var hours = CurrentDate.getHours() < 10 ? '0' + CurrentDate.getHours() : CurrentDate.getHours();
            var minutes = CurrentDate.getMinutes() < 10 ? '0' + CurrentDate.getMinutes() : CurrentDate.getMinutes();
            if (hours == 0) {
                hours = 12;
            }
            if (hours > 12) {
                document.getElementById(control_ID).value = hours - 12 + ':' + minutes + ' م';
            }
            else {
                document.getElementById(control_ID).value = hours + ':' + minutes + ' ص';
            }
            return false;
        }

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
    <asp:Panel runat="server" ID="PanelLoadInfo">
        <h3 style="margin: 0; padding: 0">بيانات الحموله :-</h3>
        <h3 style="margin: 0; padding: 0">ــــــــــــــــــــــــ</h3>
        <section>
            <table style="border-collapse: collapse;">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="التاريــــــخ : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtDate" placeholder="تاريخ الحمولة" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="BtnGetDate" OnClientClick="return GetDate()" runat="server" Text=":" CssClass="ButtonAddStyle4" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorDate" runat="server"
                            ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="يجب اضافة تاريخ الحمولة">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="اسم العميل : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtClientName" placeholder="اسم العميل" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="رقم السيارة : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtCarNumber" placeholder="رقم السيارة" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label20" runat="server" Text="اسم السائق : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtDriverName" placeholder="اسم السائق" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtCarNumber" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="يجب اضافة رقم السيارة">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="نوع الحمولة : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtLoadType" ClientIDMode="Static" placeholder="نوع الحمولة" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                    <td>
                        <img id="ImgDeleteLoad" src="Images/Delete.png" width="16" height="16" style="display: none" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label9" runat="server" Text="العــــــــــــدد : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtCount" placeholder="قم باضافة العدد ان وجد" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label5" runat="server" Text="الوزن القائم : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtFilledLoad" placeholder="الوزن القائم بوحدة ك" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label8" runat="server" Text="الوقت : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtFilledTime" placeholder="وقت الوزن" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" CssClass="TextBoxs2"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="BtnFilledTime" OnClientClick="return GetTime('txtFilledTime')" runat="server" Text=":" CssClass="ButtonAddStyle4" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label6" runat="server" Text="الوزن الفارغ : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtEmptyLoad" placeholder="الوزن الفارغ بوحدة ك" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label7" runat="server" Text="الوقت : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtEmptyTime" placeholder="وقت الوزن" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" CssClass="TextBoxs2"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="BtnEmptyTime" OnClientClick="return GetTime('txtEmptyTime')" runat="server" Text=":" CssClass="ButtonAddStyle4" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label10" runat="server" Text="التكلفــــــــه : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtCost" placeholder="اضف التكلفة" AutoCompleteType="Disabled" runat="server" CssClass="TextBoxs"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label24" runat="server" Text="مدفوعه : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:CheckBox ID="CbIsPaid" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:CompareValidator ID="CompareValidator3" runat="server"
                            ControlToValidate="txtCost" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="يجب الكتابة بصورة صحيحه" Operator="DataTypeCheck" Type="Currency">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CompareValidator>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top">
                        <asp:Label ID="Label28" runat="server" Text="ملاحظــــــــات : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtNotes" placeholder="اضف ملاحظات ان وجد........" runat="server" TextMode="MultiLine"
                            CssClass="multiLineTxt"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <table style="border-collapse: collapse;">
                <tr>
                    <td>
                        <asp:Label ID="Label26" runat="server" Text="الفارغ على مسئولية السائق : " CssClass="Labels"></asp:Label>
                    </td>
                    <td>
                        <asp:CheckBox ID="cbIsResponsible" runat="server" />
                    </td>
                </tr>
            </table>
        </section>
        <footer style="text-align: left; width: 900px; margin-top: 20px;">
            <asp:Button ID="BtnSave" runat="server" Text="حفظ" CssClass="ButtonAddStyle" Width="75" OnClick="BtnSave_Click" />
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="ButtonAddStyle2" Width="75" OnClick="BtnFinish_Click" />
            <div style="width: 100%; text-align: center">
                <asp:Label ID="lblSaveMsg" runat="server" Font-Bold="true"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelPrint" Visible="false">
        <header style="direction: ltr; clear: both">
            <table>
                <tr>
                    <td>
                        <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="28" Height="28" OnClientClick="PrintDivContent('DivToPrint');" />
                    </td>
                    <td>
                        <select id="CopiesSelect" style="width: 50px;">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                        </select>
                        <label for="CopiesSelect">عدد النسخ</label>
                    </td>
                    <td>
                        <input type="checkbox" name="hideAddressCheckBox" />
                        <label for="hideAddressCheckBox">بدون عنوان</label>
                    </td>
                </tr>
            </table>
        </header>
        <div id="DivToPrint">
            <section class="ContactsSection" id="OriginSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px; margin-bottom: 10px; border-bottom: 1px solid black; min-height: 260px;">
                <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                    <div style="border: 1px solid black;">
                        <table style="width: 100%">
                            <tr>
                                <td style="text-align: center">
                                    <p style="font: bold 22px arial; margin: 0; padding: 0; line-height: 30px">ميزان بسكول (الحاج قطب)</p>
                                    <p style="font: bold 20px arial; margin: 0; padding: 0; line-height: 30px">الالكترونى 120 طن  -  الميزان مزود بالكاميرات</p>
                                </td>
                                <td style="text-align: center" data-section="address">
                                    <p style="font: bold 22px arial; margin: 0; padding: 0; line-height: 30px">بنى مزار - صندفا - الطريق الجديد</p>
                                    <p style="font: bold 17px arial; margin: 0; padding: 0; line-height: 30px">ت / 01220989657 - 01008539045</p>
                                </td>
                            </tr>
                        </table>
                    </div>
                </header>
                <table class="AddProductsTable" style="float: right;">
                    <tr>
                        <td>
                            <asp:Label ID="Label13" runat="server" Text="اسم العميل : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 150px">
                            <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Label12" runat="server" Text="رقم مسلسل : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblID" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Label15" runat="server" Text="رقم السيارة : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 80px">
                            <asp:Label ID="lblCarNumber" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label11" runat="server" Text="اسم السواق : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 80px">
                            <asp:Label ID="lblDriver" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Label17" runat="server" Text="نوع الحموله : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 70px">
                            <asp:Label ID="lblLoadType" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="labelCount" runat="server" Text="العدد : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblCount" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label19" runat="server" Text="التاريخ : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 70px">
                            <asp:Label ID="lblDate" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Label22" runat="server" Text="وقت القائم : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 60px">
                            <asp:Label ID="lblFilledTime" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblTime" runat="server" Text="وقت الفارغ : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td style="width: 60px">
                            <asp:Label ID="lblEmptyTime" runat="server" CssClass="lblInfo"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top">
                            <asp:Label ID="lblNotesTitle" runat="server" Text="ملاحظـــات : " CssClass="lblInfo"></asp:Label>
                        </td>
                        <td colspan="5" style="max-width: 100px;">
                            <asp:Label runat="server" ID="lblNotes1" CssClass="multiLinelbl"></asp:Label>
                        </td>
                    </tr>
                </table>
                <table style="float: left; border: 1px solid black">
                    <thead>
                        <tr style="border: 1px solid black">
                            <th></th>
                            <th style="text-align: center">ك / طن</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="border: 1px solid black">
                                <asp:Label ID="Label14" runat="server" Text=" الوزن القائم " CssClass="lblInfo11"></asp:Label>
                            </td>
                            <td style="width: 80px; text-align: center; border: 1px solid black">
                                <asp:Label ID="lblFilledLoad" runat="server" CssClass="lblInfo22"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="border: 1px solid black">
                                <asp:Label ID="Label16" runat="server" Text=" الوزن الفارغ " CssClass="lblInfo11"></asp:Label>
                            </td>
                            <td style="width: 80px; text-align: center; border: 1px solid black">
                                <asp:Label ID="lblEmptyLoad" runat="server" CssClass="lblInfo22"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="border: 1px solid black">
                                <asp:Label ID="Label18" runat="server" Text=" الوزن الصافى " CssClass="lblInfo11"></asp:Label>
                            </td>
                            <td style="width: 80px; text-align: center; border: 1px solid black">
                                <asp:Label ID="lblNetLoad" runat="server" CssClass="lblInfo22"></asp:Label>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <asp:Panel runat="server" ID="PanelFooter1" Visible="false">
                    <footer style="clear: both; width: 100%; text-align: center">
                        <p style="font: bold 14px arial; margin: 0; padding: 0">الفارغ على مسئولية السائق</p>
                    </footer>
                </asp:Panel>
            </section>
        </div>
    </asp:Panel>
</asp:Content>
