<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="PSAUStay.Account.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <div class="container-fluid py-4">
        <%-- Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-people-fill me-2" style="color: var(--psau-gold);"></i>
                            Manage Users
                        </h2>
                        <p class="mb-0 text-white-50">Create and manage user accounts and permissions (<%= DateTime.Now.ToString("MMM dd, yyyy") %>)</p>
                    </div>
                    <div class="col-auto">
                        <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold me-2">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                        <asp:Button ID="btnAddUser" runat="server" Text="➕ Add User" CssClass="btn btn-light shadow-sm fw-bold"
                            OnClick="btnAddUser_Click" data-bs-toggle="modal" data-bs-target="#userModal" />
                    </div>
                </div>
            </div>
        </div>

        <%-- Search Filter --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row align-items-end g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-uppercase text-muted">Search Users</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0" placeholder="Search name, email, or role..."></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-success px-4 fw-bold" OnClick="btnSearch_Click" />
                        <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary px-3" OnClick="btnClear_Click">Clear</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <%-- Grid Section --%>
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" GridLines="None" 
                    OnRowCommand="gvUsers_RowCommand" EmptyDataText="No users found matching your search.">
                    <Columns>
                        <asp:TemplateField HeaderText="User">
                            <ItemTemplate>
                                <div class="fw-bold"><%# Eval("FullName") %></div>
                                <small class="text-muted">ID: <%# Eval("UserId") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Contact">
                            <ItemTemplate>
                                <div><i class="bi bi-envelope text-muted me-1"></i><%# Eval("Email") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>
                                <span class="badge bg-primary"><%# Eval("AccessLevelName") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnEdit" runat="server" Text="Edit"
                                    CommandName="EditUser" CommandArgument='<%# Eval("UserId") %>'
                                    CssClass="btn btn-outline-primary btn-sm me-1" data-bs-toggle="modal" data-bs-target="#userModal" />

                                <asp:Button ID="btnDelete" runat="server" Text="Delete"
                                    CommandName="DeleteUser" CommandArgument='<%# Eval("UserId") %>'
                                    CssClass="btn btn-outline-danger btn-sm" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="bg-light text-muted small text-uppercase" />
                </asp:GridView>
            </div>
        </div>

        <!-- Bootstrap Modal for Add/Edit User -->
        <div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="userModalLabel">
                            <asp:Label ID="lblModalTitle" runat="server" Text="Add User"></asp:Label>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Role</label>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnSave" runat="server" Text="Save User" CssClass="btn btn-success px-4 fw-bold"
                            OnClick="btnSave_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary px-4"
                            OnClick="btnCancel_Click" data-bs-dismiss="modal" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Hidden field to store modal visibility state -->
        <asp:HiddenField ID="hfModalVisible" runat="server" Value="false" />
    </div>

    <script type="text/javascript">
        // Show modal if hidden field is set to true
        document.addEventListener('DOMContentLoaded', function() {
            var modalVisible = document.getElementById('<%= hfModalVisible.ClientID %>').value;
            if (modalVisible === 'true') {
                var userModal = new bootstrap.Modal(document.getElementById('userModal'));
                userModal.show();
            }
        });

        // Handle modal close events
        document.getElementById('userModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('<%= hfModalVisible.ClientID %>').value = 'false';
        });
    </script>
</asp:Content>
