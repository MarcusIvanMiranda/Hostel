using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class InvoiceReport : DevExpress.XtraReports.UI.XtraReport {

    private DevExpress.XtraReports.UI.TopMarginBand topMarginBand1;
    private DevExpress.XtraReports.UI.DetailBand detailBand1;
    private DevExpress.XtraReports.UI.BottomMarginBand bottomMarginBand1;
    private DevExpress.XtraReports.UI.ReportHeaderBand ReportHeader;
    private DevExpress.XtraReports.UI.XRLabel xrLabel2;
    private DevExpress.XtraReports.UI.XRLabel xrLabel1;
    private DevExpress.XtraReports.UI.XRLine xrLine1;
    public DevExpress.XtraReports.UI.XRLabel HotelDescriptionLabel;
    private DevExpress.XtraReports.UI.XRLabel xrLabel15;
    public DevExpress.XtraReports.UI.XRLabel TotalPriceLabel;
    private DevExpress.XtraReports.UI.XRLabel xrLabel13;
    public DevExpress.XtraReports.UI.XRTable PriceTable;
    private DevExpress.XtraReports.UI.XRTableRow xrTableRow1;
    private DevExpress.XtraReports.UI.XRTableCell xrTableCell1;
    private DevExpress.XtraReports.UI.XRTableCell xrTableCell3;
    private DevExpress.XtraReports.UI.XRLine xrLine3;
    public DevExpress.XtraReports.UI.XRLabel CheckOutLabel;
    private DevExpress.XtraReports.UI.XRLabel xrLabel11;
    public DevExpress.XtraReports.UI.XRLabel CheckInLabel;
    private DevExpress.XtraReports.UI.XRLabel xrLabel9;
    public DevExpress.XtraReports.UI.XRLabel HotelAddressLabel;
    public DevExpress.XtraReports.UI.XRLabel HotelNameLabel2;
    public DevExpress.XtraReports.UI.XRPictureBox HotelSmallImagePictureBox;
    private DevExpress.XtraReports.UI.XRLine xrLine2;
    private DevExpress.XtraReports.UI.XRLabel xrLabel6;
    public DevExpress.XtraReports.UI.XRPictureBox HotelLargeImagePictureBox;
    public DevExpress.XtraReports.UI.XRLabel HotelAddressLine2Label;
    public DevExpress.XtraReports.UI.XRLabel HotelAddressLine1Label;
    public DevExpress.XtraReports.UI.XRLabel HotelNameLabel1;
    private DevExpress.XtraReports.UI.ReportFooterBand ReportFooter;
    private DevExpress.XtraReports.UI.XRPictureBox xrPictureBox4;
    private DevExpress.XtraReports.UI.XRLine xrLine4;
    private DevExpress.XtraReports.UI.XRLabel xrLabel17;
    public DevExpress.XtraReports.UI.XRPictureBox RatingPictureBox;
    private DevExpress.XtraReports.UI.XRPictureBox xrPictureBox1;
    public InvoiceReport() {
        InitializeComponent();
    }
    private void InitializeComponent() {
            System.Resources.ResourceManager resources = global::Resources.InvoiceReport.ResourceManager;
            this.topMarginBand1 = new DevExpress.XtraReports.UI.TopMarginBand();
            this.detailBand1 = new DevExpress.XtraReports.UI.DetailBand();
            this.RatingPictureBox = new DevExpress.XtraReports.UI.XRPictureBox();
            this.HotelDescriptionLabel = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel15 = new DevExpress.XtraReports.UI.XRLabel();
            this.TotalPriceLabel = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel13 = new DevExpress.XtraReports.UI.XRLabel();
            this.PriceTable = new DevExpress.XtraReports.UI.XRTable();
            this.xrTableRow1 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell1 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell3 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrLine3 = new DevExpress.XtraReports.UI.XRLine();
            this.CheckOutLabel = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel11 = new DevExpress.XtraReports.UI.XRLabel();
            this.CheckInLabel = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel9 = new DevExpress.XtraReports.UI.XRLabel();
            this.HotelAddressLabel = new DevExpress.XtraReports.UI.XRLabel();
            this.HotelNameLabel2 = new DevExpress.XtraReports.UI.XRLabel();
            this.HotelSmallImagePictureBox = new DevExpress.XtraReports.UI.XRPictureBox();
            this.xrLine2 = new DevExpress.XtraReports.UI.XRLine();
            this.xrLabel6 = new DevExpress.XtraReports.UI.XRLabel();
            this.HotelLargeImagePictureBox = new DevExpress.XtraReports.UI.XRPictureBox();
            this.HotelAddressLine2Label = new DevExpress.XtraReports.UI.XRLabel();
            this.HotelAddressLine1Label = new DevExpress.XtraReports.UI.XRLabel();
            this.HotelNameLabel1 = new DevExpress.XtraReports.UI.XRLabel();
            this.bottomMarginBand1 = new DevExpress.XtraReports.UI.BottomMarginBand();
            this.ReportHeader = new DevExpress.XtraReports.UI.ReportHeaderBand();
            this.xrLabel2 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel1 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrPictureBox1 = new DevExpress.XtraReports.UI.XRPictureBox();
            this.xrLine1 = new DevExpress.XtraReports.UI.XRLine();
            this.ReportFooter = new DevExpress.XtraReports.UI.ReportFooterBand();
            this.xrPictureBox4 = new DevExpress.XtraReports.UI.XRPictureBox();
            this.xrLine4 = new DevExpress.XtraReports.UI.XRLine();
            this.xrLabel17 = new DevExpress.XtraReports.UI.XRLabel();
            ((System.ComponentModel.ISupportInitialize)(this.PriceTable)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
            // 
            // topMarginBand1
            // 
            this.topMarginBand1.HeightF = 53.04166F;
            this.topMarginBand1.Name = "topMarginBand1";
            // 
            // detailBand1
            // 
            this.detailBand1.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.RatingPictureBox,
            this.HotelDescriptionLabel,
            this.xrLabel15,
            this.TotalPriceLabel,
            this.xrLabel13,
            this.PriceTable,
            this.xrLine3,
            this.CheckOutLabel,
            this.xrLabel11,
            this.CheckInLabel,
            this.xrLabel9,
            this.HotelAddressLabel,
            this.HotelNameLabel2,
            this.HotelSmallImagePictureBox,
            this.xrLine2,
            this.xrLabel6,
            this.HotelLargeImagePictureBox,
            this.HotelAddressLine2Label,
            this.HotelAddressLine1Label,
            this.HotelNameLabel1});
            this.detailBand1.HeightF = 614.5417F;
            this.detailBand1.Name = "detailBand1";
            // 
            // RatingPictureBox
            // 
            this.RatingPictureBox.Image = ((System.Drawing.Image)(resources.GetObject("RatingPictureBox.Image")));
            this.RatingPictureBox.LocationFloat = new DevExpress.Utils.PointFloat(195F, 0F);
            this.RatingPictureBox.Name = "RatingPictureBox";
            this.RatingPictureBox.SizeF = new System.Drawing.SizeF(180.2084F, 37.7917F);
            // 
            // HotelDescriptionLabel
            // 
            this.HotelDescriptionLabel.AutoWidth = true;
            this.HotelDescriptionLabel.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.HotelDescriptionLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(52)))), ((int)(((byte)(52)))));
            this.HotelDescriptionLabel.LocationFloat = new DevExpress.Utils.PointFloat(6.357829E-05F, 514.9167F);
            this.HotelDescriptionLabel.Multiline = true;
            this.HotelDescriptionLabel.Name = "HotelDescriptionLabel";
            this.HotelDescriptionLabel.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.HotelDescriptionLabel.SizeF = new System.Drawing.SizeF(750.9998F, 69.875F);
            this.HotelDescriptionLabel.StylePriority.UseFont = false;
            this.HotelDescriptionLabel.StylePriority.UseForeColor = false;
            this.HotelDescriptionLabel.Text = "HotelDescriptionLabel";
            // 
            // xrLabel15
            // 
            this.xrLabel15.Font = new System.Drawing.Font("Segoe UI", 13.5F);
            this.xrLabel15.LocationFloat = new DevExpress.Utils.PointFloat(6.357829E-05F, 485F);
            this.xrLabel15.Name = "xrLabel15";
            this.xrLabel15.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel15.SizeF = new System.Drawing.SizeF(100F, 23F);
            this.xrLabel15.StylePriority.UseFont = false;
            this.xrLabel15.Text = "Description";
            // 
            // TotalPriceLabel
            // 
            this.TotalPriceLabel.Font = new System.Drawing.Font("Segoe UI", 18F);
            this.TotalPriceLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(52)))), ((int)(((byte)(52)))));
            this.TotalPriceLabel.LocationFloat = new DevExpress.Utils.PointFloat(624.1669F, 325.6667F);
            this.TotalPriceLabel.Name = "TotalPriceLabel";
            this.TotalPriceLabel.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.TotalPriceLabel.SizeF = new System.Drawing.SizeF(126.8336F, 36.5416F);
            this.TotalPriceLabel.StylePriority.UseFont = false;
            this.TotalPriceLabel.StylePriority.UseForeColor = false;
            this.TotalPriceLabel.StylePriority.UsePadding = false;
            this.TotalPriceLabel.StylePriority.UseTextAlignment = false;
            this.TotalPriceLabel.Text = "$1000.00";
            this.TotalPriceLabel.TextAlignment = DevExpress.XtraPrinting.TextAlignment.BottomRight;
            // 
            // xrLabel13
            // 
            this.xrLabel13.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.xrLabel13.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.xrLabel13.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 325.6667F);
            this.xrLabel13.Name = "xrLabel13";
            this.xrLabel13.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 2, 0, 3, 100F);
            this.xrLabel13.SizeF = new System.Drawing.SizeF(150.4168F, 36.54166F);
            this.xrLabel13.StylePriority.UseFont = false;
            this.xrLabel13.StylePriority.UseForeColor = false;
            this.xrLabel13.StylePriority.UsePadding = false;
            this.xrLabel13.StylePriority.UseTextAlignment = false;
            this.xrLabel13.Text = "TOTAL";
            this.xrLabel13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.BottomLeft;
            // 
            // PriceTable
            // 
            this.PriceTable.BorderColor = System.Drawing.Color.Transparent;
            this.PriceTable.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.PriceTable.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.PriceTable.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 300.6667F);
            this.PriceTable.Name = "PriceTable";
            this.PriceTable.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.xrTableRow1});
            this.PriceTable.SizeF = new System.Drawing.SizeF(277.2503F, 25F);
            this.PriceTable.StylePriority.UseBorderColor = false;
            this.PriceTable.StylePriority.UseFont = false;
            this.PriceTable.StylePriority.UseForeColor = false;
            // 
            // xrTableRow1
            // 
            this.xrTableRow1.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell1,
            this.xrTableCell3});
            this.xrTableRow1.Name = "xrTableRow1";
            this.xrTableRow1.Weight = 1D;
            // 
            // xrTableCell1
            // 
            this.xrTableCell1.Name = "xrTableCell1";
            this.xrTableCell1.Text = "xrTableCell1";
            this.xrTableCell1.Weight = 2.3621389289424295D;
            // 
            // xrTableCell3
            // 
            this.xrTableCell3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(52)))), ((int)(((byte)(52)))));
            this.xrTableCell3.Name = "xrTableCell3";
            this.xrTableCell3.StylePriority.UseForeColor = false;
            this.xrTableCell3.StylePriority.UseTextAlignment = false;
            this.xrTableCell3.Text = "$323.22";
            this.xrTableCell3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight;
            this.xrTableCell3.Weight = 1.1866659014754952D;
            // 
            // xrLine3
            // 
            this.xrLine3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.xrLine3.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 277.6667F);
            this.xrLine3.Name = "xrLine3";
            this.xrLine3.SizeF = new System.Drawing.SizeF(277.2503F, 23F);
            this.xrLine3.StylePriority.UseForeColor = false;
            // 
            // CheckOutLabel
            // 
            this.CheckOutLabel.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.CheckOutLabel.LocationFloat = new DevExpress.Utils.PointFloat(577.0834F, 246.7084F);
            this.CheckOutLabel.Name = "CheckOutLabel";
            this.CheckOutLabel.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.CheckOutLabel.SizeF = new System.Drawing.SizeF(100F, 23F);
            this.CheckOutLabel.StylePriority.UseFont = false;
            this.CheckOutLabel.Text = "03/20/2014";
            // 
            // xrLabel11
            // 
            this.xrLabel11.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.xrLabel11.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.xrLabel11.LocationFloat = new DevExpress.Utils.PointFloat(577.0833F, 223.7083F);
            this.xrLabel11.Name = "xrLabel11";
            this.xrLabel11.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel11.SizeF = new System.Drawing.SizeF(100F, 23.00002F);
            this.xrLabel11.StylePriority.UseFont = false;
            this.xrLabel11.StylePriority.UseForeColor = false;
            this.xrLabel11.Text = "Check out";
            // 
            // CheckInLabel
            // 
            this.CheckInLabel.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.CheckInLabel.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 246.7084F);
            this.CheckInLabel.Name = "CheckInLabel";
            this.CheckInLabel.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 2, 0, 0, 100F);
            this.CheckInLabel.SizeF = new System.Drawing.SizeF(100F, 23F);
            this.CheckInLabel.StylePriority.UseFont = false;
            this.CheckInLabel.StylePriority.UsePadding = false;
            this.CheckInLabel.Text = "03/20/2014";
            // 
            // xrLabel9
            // 
            this.xrLabel9.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.xrLabel9.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.xrLabel9.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 223.7083F);
            this.xrLabel9.Name = "xrLabel9";
            this.xrLabel9.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 2, 0, 0, 100F);
            this.xrLabel9.SizeF = new System.Drawing.SizeF(100F, 23.00002F);
            this.xrLabel9.StylePriority.UseFont = false;
            this.xrLabel9.StylePriority.UseForeColor = false;
            this.xrLabel9.StylePriority.UsePadding = false;
            this.xrLabel9.Text = "Check in";
            // 
            // HotelAddressLabel
            // 
            this.HotelAddressLabel.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.HotelAddressLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.HotelAddressLabel.LocationFloat = new DevExpress.Utils.PointFloat(554.1667F, 166.2916F);
            this.HotelAddressLabel.Multiline = true;
            this.HotelAddressLabel.Name = "HotelAddressLabel";
            this.HotelAddressLabel.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.HotelAddressLabel.SizeF = new System.Drawing.SizeF(196.8333F, 22.99998F);
            this.HotelAddressLabel.StylePriority.UseFont = false;
            this.HotelAddressLabel.StylePriority.UseForeColor = false;
            this.HotelAddressLabel.StylePriority.UsePadding = false;
            this.HotelAddressLabel.Text = "Hollywood Hotel / The Hotel";
            // 
            // HotelNameLabel2
            // 
            this.HotelNameLabel2.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.HotelNameLabel2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(52)))), ((int)(((byte)(52)))));
            this.HotelNameLabel2.LocationFloat = new DevExpress.Utils.PointFloat(554.1666F, 143.2916F);
            this.HotelNameLabel2.Multiline = true;
            this.HotelNameLabel2.Name = "HotelNameLabel2";
            this.HotelNameLabel2.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.HotelNameLabel2.SizeF = new System.Drawing.SizeF(196.8334F, 23F);
            this.HotelNameLabel2.StylePriority.UseFont = false;
            this.HotelNameLabel2.StylePriority.UseForeColor = false;
            this.HotelNameLabel2.StylePriority.UsePadding = false;
            this.HotelNameLabel2.Text = "Hollywood Hotel / The Hotel";
            // 
            // HotelSmallImagePictureBox
            // 
            this.HotelSmallImagePictureBox.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(200)))), ((int)(((byte)(199)))), ((int)(((byte)(199)))));
            this.HotelSmallImagePictureBox.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.HotelSmallImagePictureBox.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 143.2916F);
            this.HotelSmallImagePictureBox.Name = "HotelSmallImagePictureBox";
            this.HotelSmallImagePictureBox.Padding = new DevExpress.XtraPrinting.PaddingInfo(4, 4, 4, 4, 100F);
            this.HotelSmallImagePictureBox.SizeF = new System.Drawing.SizeF(69.99997F, 70F);
            this.HotelSmallImagePictureBox.Sizing = DevExpress.XtraPrinting.ImageSizeMode.StretchImage;
            this.HotelSmallImagePictureBox.StylePriority.UseBorderColor = false;
            this.HotelSmallImagePictureBox.StylePriority.UseBorders = false;
            this.HotelSmallImagePictureBox.StylePriority.UsePadding = false;
            // 
            // xrLine2
            // 
            this.xrLine2.BorderWidth = 1F;
            this.xrLine2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.xrLine2.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 113F);
            this.xrLine2.Name = "xrLine2";
            this.xrLine2.SizeF = new System.Drawing.SizeF(277.2498F, 18.83335F);
            this.xrLine2.StylePriority.UseBorderWidth = false;
            this.xrLine2.StylePriority.UseForeColor = false;
            // 
            // xrLabel6
            // 
            this.xrLabel6.Font = new System.Drawing.Font("Segoe UI", 13.5F);
            this.xrLabel6.LocationFloat = new DevExpress.Utils.PointFloat(473.7501F, 89.99999F);
            this.xrLabel6.Name = "xrLabel6";
            this.xrLabel6.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.xrLabel6.SizeF = new System.Drawing.SizeF(277.25F, 22.99998F);
            this.xrLabel6.StylePriority.UseFont = false;
            this.xrLabel6.StylePriority.UsePadding = false;
            this.xrLabel6.StylePriority.UseTextAlignment = false;
            this.xrLabel6.Text = "Your Reservation Summary";
            this.xrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
            // 
            // HotelLargeImagePictureBox
            // 
            this.HotelLargeImagePictureBox.LocationFloat = new DevExpress.Utils.PointFloat(0F, 89.99999F);
            this.HotelLargeImagePictureBox.Name = "HotelLargeImagePictureBox";
            this.HotelLargeImagePictureBox.SizeF = new System.Drawing.SizeF(445.2083F, 372.9166F);
            // 
            // HotelAddressLine2Label
            // 
            this.HotelAddressLine2Label.AutoWidth = true;
            this.HotelAddressLine2Label.Font = new System.Drawing.Font("Segoe UI", 12F);
            this.HotelAddressLine2Label.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.HotelAddressLine2Label.LocationFloat = new DevExpress.Utils.PointFloat(0F, 60.79175F);
            this.HotelAddressLine2Label.Multiline = true;
            this.HotelAddressLine2Label.Name = "HotelAddressLine2Label";
            this.HotelAddressLine2Label.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.HotelAddressLine2Label.SizeF = new System.Drawing.SizeF(250.4167F, 22.99998F);
            this.HotelAddressLine2Label.StylePriority.UseFont = false;
            this.HotelAddressLine2Label.StylePriority.UseForeColor = false;
            this.HotelAddressLine2Label.Text = "Address Line 2";
            // 
            // HotelAddressLine1Label
            // 
            this.HotelAddressLine1Label.AutoWidth = true;
            this.HotelAddressLine1Label.Font = new System.Drawing.Font("Segoe UI", 12F);
            this.HotelAddressLine1Label.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.HotelAddressLine1Label.LocationFloat = new DevExpress.Utils.PointFloat(0F, 37.79173F);
            this.HotelAddressLine1Label.Name = "HotelAddressLine1Label";
            this.HotelAddressLine1Label.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.HotelAddressLine1Label.SizeF = new System.Drawing.SizeF(250.4167F, 23F);
            this.HotelAddressLine1Label.StylePriority.UseFont = false;
            this.HotelAddressLine1Label.StylePriority.UseForeColor = false;
            this.HotelAddressLine1Label.Text = "Address Line 1";
            // 
            // HotelNameLabel1
            // 
            this.HotelNameLabel1.AutoWidth = true;
            this.HotelNameLabel1.Font = new System.Drawing.Font("Times New Roman", 18F);
            this.HotelNameLabel1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(52)))), ((int)(((byte)(52)))));
            this.HotelNameLabel1.LocationFloat = new DevExpress.Utils.PointFloat(6.357829E-05F, 4F);
            this.HotelNameLabel1.Name = "HotelNameLabel1";
            this.HotelNameLabel1.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.HotelNameLabel1.SizeF = new System.Drawing.SizeF(179.5833F, 30.29167F);
            this.HotelNameLabel1.StylePriority.UseFont = false;
            this.HotelNameLabel1.StylePriority.UseForeColor = false;
            this.HotelNameLabel1.Text = "Hollywood Hotel";
            this.HotelNameLabel1.WordWrap = false;
            // 
            // bottomMarginBand1
            // 
            this.bottomMarginBand1.HeightF = 17F;
            this.bottomMarginBand1.Name = "bottomMarginBand1";
            // 
            // ReportHeader
            // 
            this.ReportHeader.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.xrLabel2,
            this.xrLabel1,
            this.xrPictureBox1,
            this.xrLine1});
            this.ReportHeader.HeightF = 86.625F;
            this.ReportHeader.Name = "ReportHeader";
            // 
            // xrLabel2
            // 
            this.xrLabel2.Font = new System.Drawing.Font("Segoe UI", 10F);
            this.xrLabel2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.xrLabel2.LocationFloat = new DevExpress.Utils.PointFloat(215.6249F, 3F);
            this.xrLabel2.Name = "xrLabel2";
            this.xrLabel2.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel2.SizeF = new System.Drawing.SizeF(229.5834F, 19F);
            this.xrLabel2.StylePriority.UseFont = false;
            this.xrLabel2.StylePriority.UseForeColor = false;
            this.xrLabel2.Text = "ASP.NET CONTROLS AND LIBRARIES";
            // 
            // xrLabel1
            // 
            this.xrLabel1.Font = new System.Drawing.Font("Segoe UI", 10F);
            this.xrLabel1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.xrLabel1.LocationFloat = new DevExpress.Utils.PointFloat(215.6249F, 22.20832F);
            this.xrLabel1.Name = "xrLabel1";
            this.xrLabel1.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel1.SizeF = new System.Drawing.SizeF(214.5833F, 17.79167F);
            this.xrLabel1.StylePriority.UseFont = false;
            this.xrLabel1.StylePriority.UseForeColor = false;
            this.xrLabel1.Text = "POWERED BY DEVEXPRESS";
            // 
            // xrPictureBox1
            // 
            this.xrPictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("xrPictureBox1.Image")));
            this.xrPictureBox1.LocationFloat = new DevExpress.Utils.PointFloat(0F, 0F);
            this.xrPictureBox1.Name = "xrPictureBox1";
            this.xrPictureBox1.SizeF = new System.Drawing.SizeF(189.5833F, 40F);
            // 
            // xrLine1
            // 
            this.xrLine1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.xrLine1.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical;
            this.xrLine1.LocationFloat = new DevExpress.Utils.PointFloat(189.5833F, 0F);
            this.xrLine1.Name = "xrLine1";
            this.xrLine1.SizeF = new System.Drawing.SizeF(26.04164F, 39.99999F);
            this.xrLine1.StylePriority.UseForeColor = false;
            // 
            // ReportFooter
            // 
            this.ReportFooter.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.xrPictureBox4,
            this.xrLine4,
            this.xrLabel17});
            this.ReportFooter.HeightF = 77F;
            this.ReportFooter.Name = "ReportFooter";
            this.ReportFooter.PrintAtBottom = true;
            // 
            // xrPictureBox4
            // 
            this.xrPictureBox4.Image = ((System.Drawing.Image)(resources.GetObject("xrPictureBox4.Image")));
            this.xrPictureBox4.LocationFloat = new DevExpress.Utils.PointFloat(577.0833F, 33.41668F);
            this.xrPictureBox4.Name = "xrPictureBox4";
            this.xrPictureBox4.SizeF = new System.Drawing.SizeF(173.9167F, 37.58335F);
            // 
            // xrLine4
            // 
            this.xrLine4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.xrLine4.LineWidth = 2;
            this.xrLine4.LocationFloat = new DevExpress.Utils.PointFloat(0F, 0F);
            this.xrLine4.Name = "xrLine4";
            this.xrLine4.SizeF = new System.Drawing.SizeF(751.0001F, 23.00002F);
            this.xrLine4.StylePriority.UseForeColor = false;
            // 
            // xrLabel17
            // 
            this.xrLabel17.AutoWidth = true;
            this.xrLabel17.Font = new System.Drawing.Font("Segoe UI", 9.75F);
            this.xrLabel17.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(103)))), ((int)(((byte)(103)))), ((int)(((byte)(103)))));
            this.xrLabel17.LocationFloat = new DevExpress.Utils.PointFloat(6.357829E-05F, 23.00002F);
            this.xrLabel17.Name = "xrLabel17";
            this.xrLabel17.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel17.SizeF = new System.Drawing.SizeF(568.5417F, 48.00002F);
            this.xrLabel17.StylePriority.UseFont = false;
            this.xrLabel17.StylePriority.UseForeColor = false;
            this.xrLabel17.Text = "This ASP.NET web report was generated with DevExpress Reporting which is included" +
    " in DevExpress ASP.NET Subscription and supports both WebForms and MVC. ";
            // 
            // InvoiceReport
            // 
            this.Bands.AddRange(new DevExpress.XtraReports.UI.Band[] {
            this.topMarginBand1,
            this.detailBand1,
            this.bottomMarginBand1,
            this.ReportHeader,
            this.ReportFooter});
            this.Margins = new System.Drawing.Printing.Margins(50, 49, 53, 17);
            this.Version = "14.2";
            ((System.ComponentModel.ISupportInitialize)(this.PriceTable)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

    }
}
