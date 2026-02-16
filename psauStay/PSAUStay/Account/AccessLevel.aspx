<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="AccessLevel.aspx.cs" Inherits="PSAUStay.Account.AccessLevel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">

    <div class="page-title-area mb-4">
        <h3>Access Levels Management</h3>
    </div>

    <div class="card shadow-sm p-4" style="max-width: 700px;">

        <div class="mb-3">
            <label class="form-label fw-bold">Access Level Name</label>
            <asp:TextBox ID="txtAccessLevelName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-3">
            <label class="form-label fw-bold">Description</label>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="d-flex justify-content-between mb-4">
            <asp:Button ID="btnAdd" runat="server" Text="Add Access Level" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
        </div>

        <asp:GridView ID="gvAccessLevels" runat="server" AutoGenerateColumns="False"
            CssClass="table table-bordered table-striped"
            DataKeyNames="AccessLevelID"
            OnRowEditing="gvAccessLevels_RowEditing"
            OnRowUpdating="gvAccessLevels_RowUpdating"
            OnRowCancelingEdit="gvAccessLevels_RowCancelingEdit"
            OnRowDeleting="gvAccessLevels_RowDeleting">

            <Columns>
                
                <asp:BoundField DataField="AccessLevelID" HeaderText="ID" ReadOnly="True" />

                
                <asp:TemplateField HeaderText="Access Level Name">
                    <ItemTemplate>
                        <%# Eval("AccessLevelName") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtNameEdit" runat="server" Text='<%# Bind("AccessLevelName") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                
                <asp:TemplateField HeaderText="Description">
                    <ItemTemplate>
                        <%# Eval("Description") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtDescEdit" runat="server" Text='<%# Bind("Description") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
            </Columns>

        </asp:GridView>


        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 fw-bold"></asp:Label>

    </div>
</asp:Content>
