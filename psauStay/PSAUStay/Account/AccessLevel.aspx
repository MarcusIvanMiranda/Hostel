<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="AccessLevel.aspx.cs" Inherits="PSAUStay.Account.AccessLevel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <%-- Page Header --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-shield-lock-fill me-2" style="color: var(--psau-gold);"></i>
                        Access Levels Management
                    </h2>
                    <p class="mb-0 text-white-50">Manage user roles and access permissions</p>
                </div>
                <div class="col-auto">
                    <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                        <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <%-- Form Section --%>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white border-bottom">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-plus-circle-fill me-2" style="color: var(--psau-green);"></i>
                Add New Access Level
            </h5>
        </div>
        <div class="card-body p-4">
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">
                            <i class="bi bi-tag-fill me-1" style="color: var(--psau-gold);"></i>
                            Access Level Name
                        </label>
                        <asp:TextBox ID="txtAccessLevelName" runat="server" CssClass="form-control" placeholder="Enter access level name"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">
                            <i class="bi bi-card-text me-1" style="color: var(--psau-gold);"></i>
                            Description
                        </label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Enter description"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="d-flex gap-2">
                <asp:Button ID="btnAdd" runat="server" Text="Add Access Level" CssClass="btn btn-primary fw-bold" OnClick="btnAdd_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary fw-bold" OnClick="btnClear_Click" />
            </div>
        </div>
    </div>

    <%-- Grid Section --%>
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white border-bottom">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-list-ul me-2" style="color: var(--psau-green);"></i>
                Existing Access Levels
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="gvAccessLevels" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-hover mb-0"
                    DataKeyNames="AccessLevelID"
                    OnRowEditing="gvAccessLevels_RowEditing"
                    OnRowUpdating="gvAccessLevels_RowUpdating"
                    OnRowCancelingEdit="gvAccessLevels_RowCancelingEdit"
                    OnRowDeleting="gvAccessLevels_RowDeleting"
                    GridLines="None">

                    <HeaderStyle CssClass="table-light fw-bold text-dark" />
                    <RowStyle CssClass="align-middle" />
                    
                    <Columns>
                        <asp:BoundField DataField="AccessLevelID" HeaderText="ID" ReadOnly="True">
                            <ItemStyle Width="80px" />
                        </asp:BoundField>

                        <asp:TemplateField HeaderText="Access Level Name">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-shield-check me-2" style="color: var(--psau-green);"></i>
                                    <%# Eval("AccessLevelName") %>
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtNameEdit" runat="server" Text='<%# Bind("AccessLevelName") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <span class="text-muted">
                                    <%# Eval("Description") %>
                                </span>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDescEdit" runat="server" Text='<%# Bind("Description") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" 
                            ButtonType="Button" ControlStyle-CssClass="btn btn-sm me-1"
                            EditText="Edit" DeleteText="Delete" CancelText="Cancel" UpdateText="Update">
                            <ControlStyle CssClass="btn btn-sm me-1" />
                        </asp:CommandField>
                    </Columns>

                </asp:GridView>
            </div>
        </div>
    </div>

    <%-- Message Label --%>
    <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 fw-bold"></asp:Label>

</asp:Content>
