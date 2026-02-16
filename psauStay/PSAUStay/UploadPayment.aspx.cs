using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PSAUStay.Helpers;

namespace PSAUStay
{
    public partial class UploadPayment : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];
            if (string.IsNullOrEmpty(token) || !ValidateToken(token))
            {
                pnlUpload.Visible = false;
                pnlExpired.Visible = true;
            }
            else
            {
                pnlUpload.Visible = true;
                pnlExpired.Visible = false;
            }
        }

        private bool ValidateToken(string token)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = @"SELECT ExpirationDate FROM RoomPaymentUploads 
                                   WHERE Token=@Token";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Token", token);
                        con.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                DateTime expiry = Convert.ToDateTime(dr["ExpirationDate"]);
                                DateTime now = DateTime.Now;
                                
                                // Debug logging
                                System.Diagnostics.Debug.WriteLine($"Token: {token}");
                                System.Diagnostics.Debug.WriteLine($"Expiry: {expiry}");
                                System.Diagnostics.Debug.WriteLine($"Now: {now}");
                                System.Diagnostics.Debug.WriteLine($"Valid: {expiry >= now}");
                                
                                if (expiry >= now)
                                {
                                    return true;
                                }
                                else
                                {
                                    System.Diagnostics.Debug.WriteLine("Token expired");
                                }
                            }
                            else
                            {
                                System.Diagnostics.Debug.WriteLine("Token not found");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ValidateToken Error: " + ex.Message);
            }

            return false;
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];
            
            // Validate token before allowing upload
            if (string.IsNullOrEmpty(token) || !ValidateToken(token))
            {
                lblMessage.Text = "Invalid or expired token. Upload not allowed.";
                pnlUpload.Visible = false;
                pnlExpired.Visible = true;
                return;
            }
            
            if (!fuPaymentProof.HasFile)
            {
                lblMessage.Text = "Please select a file to upload.";
                return;
            }

            try
            {
                string uploadFolder = Server.MapPath("~/Uploads/OnlinePayments/");
                if (!Directory.Exists(uploadFolder))
                    Directory.CreateDirectory(uploadFolder);

                string fileName = Path.GetFileName(fuPaymentProof.FileName);
                string physicalPath = Path.Combine(uploadFolder, fileName);
                fuPaymentProof.SaveAs(physicalPath);

                string virtualPath = "~/Uploads/OnlinePayments/" + fileName;

                // Update database
                string bookingRef = "";
                string customerEmail = "";
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = @"UPDATE RoomPaymentUploads 
                           SET FileName=@FileName, FilePath=@FilePath, UploadedAt=GETDATE()
                           WHERE Token=@Token";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@FileName", fileName);
                        cmd.Parameters.AddWithValue("@FilePath", virtualPath); // <-- store virtual path
                        cmd.Parameters.AddWithValue("@Token", token);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }

                    // Get booking details for email notification
                    string getDetailsSql = @"SELECT BookingRef, Email FROM RoomPaymentUploads WHERE Token=@Token";
                    using (SqlCommand getCmd = new SqlCommand(getDetailsSql, con))
                    {
                        getCmd.Parameters.AddWithValue("@Token", token);
                        using (SqlDataReader reader = getCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                bookingRef = reader["BookingRef"].ToString();
                                customerEmail = reader["Email"].ToString();
                            }
                        }
                    }
                }

                // Send email notification with attachment to admin
                SendPaymentNotificationEmail(bookingRef, customerEmail, fileName, physicalPath);

                pnlUpload.Visible = false;
                lblMessage.CssClass = "text-success";
                lblMessage.Text = "✅ Payment proof uploaded successfully. Thank you!";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "⚠ An error occurred: " + ex.Message;
            }
        }

        private void SendPaymentNotificationEmail(string bookingRef, string customerEmail, string fileName, string filePath)
        {
            try
            {
                string adminEmail = ConfigurationManager.AppSettings["AdminEmail"] ?? "kenardducut05@gmail.com";
                
                string smtpUser = ConfigurationManager.AppSettings["SmtpUser"];
                string smtpPass = ConfigurationManager.AppSettings["SmtpPass"];

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(smtpUser, "PSAU Stay System");
                mail.To.Add(adminEmail);
                mail.Subject = $"Payment Proof Uploaded - Booking #{bookingRef}";

                string body = $@"
                    <div style='font-family: Arial, sans-serif; color: #333;'>
                        <h2 style='color: #198754;'>Payment Proof Received!</h2>
                        <p>A customer has uploaded payment proof for their booking.</p>
                        
                        <div style='background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0;'>
                            <p><strong>Booking Reference:</strong> #{bookingRef}</p>
                            <p><strong>Customer Email:</strong> {customerEmail}</p>
                            <p><strong>File Name:</strong> {fileName}</p>
                            <p><strong>Upload Time:</strong> {DateTime.Now:yyyy-MM-dd HH:mm:ss}</p>
                        </div>

                        <p>Please review the attached payment proof and update the booking status accordingly.</p>
                        
                        <p>You can manage bookings in the admin panel.</p>
                        
                        <p>Thank you,<br><strong>PSAU Stay System</strong></p>
                    </div>";

                mail.Body = body;
                mail.IsBodyHtml = true;

                // Add the uploaded file as attachment
                if (File.Exists(filePath))
                {
                    Attachment attachment = new Attachment(filePath);
                    mail.Attachments.Add(attachment);
                }

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.Credentials = new NetworkCredential(smtpUser, smtpPass);

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                // Log error but don't show to user (upload was successful)
                System.Diagnostics.Debug.WriteLine("Email notification failed: " + ex.Message);
            }
        }

    }
}