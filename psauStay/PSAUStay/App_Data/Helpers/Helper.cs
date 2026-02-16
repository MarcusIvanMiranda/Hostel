using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Mail;
using System.Web.Http;

namespace PSAUStay.Helpers
{
    public static class EmailHelper
    {
        public static void Send(string toEmail, string subject, string body, bool isHtml = true)
        {
            string smtpUser = ConfigurationManager.AppSettings["SmtpUser"];
            string smtpPass = ConfigurationManager.AppSettings["SmtpPass"];

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(smtpUser, "PSAU Stay");
            mail.To.Add(toEmail);
            mail.Subject = subject;
            mail.Body = body;
            mail.IsBodyHtml = isHtml;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.Credentials = new NetworkCredential(smtpUser, smtpPass);

            smtp.Send(mail);
        }
    }
}