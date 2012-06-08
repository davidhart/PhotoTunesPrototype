namespace PhotoTunesDebugApp
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataVisualization.Charting.ChartArea chartArea1 = new System.Windows.Forms.DataVisualization.Charting.ChartArea();
            System.Windows.Forms.DataVisualization.Charting.Legend legend1 = new System.Windows.Forms.DataVisualization.Charting.Legend();
            this.playPauseButton = new System.Windows.Forms.Button();
            this.songDataGrid = new System.Windows.Forms.DataGridView();
            this.playbackProgress = new System.Windows.Forms.ProgressBar();
            this.stopButton = new System.Windows.Forms.Button();
            this.repeatToggle = new System.Windows.Forms.CheckBox();
            this.instrumentTextBox = new System.Windows.Forms.TextBox();
            this.loadInstrumentButton = new System.Windows.Forms.Button();
            this.drumTextBox = new System.Windows.Forms.TextBox();
            this.loadDrumTextbox = new System.Windows.Forms.Button();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.comboBox2 = new System.Windows.Forms.ComboBox();
            this.comboBox3 = new System.Windows.Forms.ComboBox();
            this.comboBox4 = new System.Windows.Forms.ComboBox();
            this.comboBox5 = new System.Windows.Forms.ComboBox();
            this.comboBox6 = new System.Windows.Forms.ComboBox();
            this.loadImageButton = new System.Windows.Forms.Button();
            this.pictureBox = new System.Windows.Forms.PictureBox();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.gridLoadButton = new System.Windows.Forms.Button();
            this.chart1 = new System.Windows.Forms.DataVisualization.Charting.Chart();
            this.checkListChart = new System.Windows.Forms.CheckedListBox();
            ((System.ComponentModel.ISupportInitialize)(this.songDataGrid)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.chart1)).BeginInit();
            this.SuspendLayout();
            // 
            // playPauseButton
            // 
            this.playPauseButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.playPauseButton.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.playPauseButton.Location = new System.Drawing.Point(12, 184);
            this.playPauseButton.Name = "playPauseButton";
            this.playPauseButton.Size = new System.Drawing.Size(60, 58);
            this.playPauseButton.TabIndex = 0;
            this.playPauseButton.Text = "Play";
            this.playPauseButton.UseVisualStyleBackColor = true;
            this.playPauseButton.Click += new System.EventHandler(this.playPauseButton_Click);
            // 
            // songDataGrid
            // 
            this.songDataGrid.AllowUserToAddRows = false;
            this.songDataGrid.AllowUserToDeleteRows = false;
            this.songDataGrid.AllowUserToResizeColumns = false;
            this.songDataGrid.AllowUserToResizeRows = false;
            this.songDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.songDataGrid.ColumnHeadersVisible = false;
            this.songDataGrid.Location = new System.Drawing.Point(12, 12);
            this.songDataGrid.Name = "songDataGrid";
            this.songDataGrid.RowHeadersVisible = false;
            this.songDataGrid.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.songDataGrid.Size = new System.Drawing.Size(561, 150);
            this.songDataGrid.TabIndex = 1;
            // 
            // playbackProgress
            // 
            this.playbackProgress.Location = new System.Drawing.Point(12, 162);
            this.playbackProgress.Name = "playbackProgress";
            this.playbackProgress.Size = new System.Drawing.Size(561, 12);
            this.playbackProgress.TabIndex = 2;
            // 
            // stopButton
            // 
            this.stopButton.Location = new System.Drawing.Point(78, 184);
            this.stopButton.Name = "stopButton";
            this.stopButton.Size = new System.Drawing.Size(60, 58);
            this.stopButton.TabIndex = 3;
            this.stopButton.Text = "Stop";
            this.stopButton.UseVisualStyleBackColor = true;
            this.stopButton.Click += new System.EventHandler(this.stopButton_Click);
            // 
            // repeatToggle
            // 
            this.repeatToggle.Appearance = System.Windows.Forms.Appearance.Button;
            this.repeatToggle.Location = new System.Drawing.Point(144, 184);
            this.repeatToggle.Name = "repeatToggle";
            this.repeatToggle.Size = new System.Drawing.Size(60, 58);
            this.repeatToggle.TabIndex = 4;
            this.repeatToggle.Text = "Repeat";
            this.repeatToggle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.repeatToggle.UseVisualStyleBackColor = true;
            this.repeatToggle.CheckedChanged += new System.EventHandler(this.repeatToggle_CheckedChanged);
            // 
            // instrumentTextBox
            // 
            this.instrumentTextBox.Location = new System.Drawing.Point(211, 184);
            this.instrumentTextBox.Name = "instrumentTextBox";
            this.instrumentTextBox.Size = new System.Drawing.Size(100, 20);
            this.instrumentTextBox.TabIndex = 5;
            this.instrumentTextBox.Text = "a.wav";
            // 
            // loadInstrumentButton
            // 
            this.loadInstrumentButton.Location = new System.Drawing.Point(211, 211);
            this.loadInstrumentButton.Name = "loadInstrumentButton";
            this.loadInstrumentButton.Size = new System.Drawing.Size(100, 23);
            this.loadInstrumentButton.TabIndex = 6;
            this.loadInstrumentButton.Text = "Load Instrument";
            this.loadInstrumentButton.UseVisualStyleBackColor = true;
            this.loadInstrumentButton.Click += new System.EventHandler(this.loadInstrumentButton_Click);
            // 
            // drumTextBox
            // 
            this.drumTextBox.Location = new System.Drawing.Point(318, 183);
            this.drumTextBox.Multiline = true;
            this.drumTextBox.Name = "drumTextBox";
            this.drumTextBox.Size = new System.Drawing.Size(100, 71);
            this.drumTextBox.TabIndex = 7;
            this.drumTextBox.Text = "ride.wav\r\nbass.wav\r\nsnare.wav\r\nsplash.wav\r\nhihat.wav";
            // 
            // loadDrumTextbox
            // 
            this.loadDrumTextbox.Location = new System.Drawing.Point(318, 261);
            this.loadDrumTextbox.Name = "loadDrumTextbox";
            this.loadDrumTextbox.Size = new System.Drawing.Size(100, 23);
            this.loadDrumTextbox.TabIndex = 8;
            this.loadDrumTextbox.Text = "Load Drums";
            this.loadDrumTextbox.UseVisualStyleBackColor = true;
            this.loadDrumTextbox.Click += new System.EventHandler(this.loadDrumTextbox_Click);
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(514, 12);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(121, 21);
            this.comboBox1.TabIndex = 9;
            // 
            // comboBox2
            // 
            this.comboBox2.FormattingEnabled = true;
            this.comboBox2.Location = new System.Drawing.Point(514, 35);
            this.comboBox2.Name = "comboBox2";
            this.comboBox2.Size = new System.Drawing.Size(121, 21);
            this.comboBox2.TabIndex = 10;
            // 
            // comboBox3
            // 
            this.comboBox3.FormattingEnabled = true;
            this.comboBox3.Location = new System.Drawing.Point(514, 58);
            this.comboBox3.Name = "comboBox3";
            this.comboBox3.Size = new System.Drawing.Size(121, 21);
            this.comboBox3.TabIndex = 11;
            // 
            // comboBox4
            // 
            this.comboBox4.FormattingEnabled = true;
            this.comboBox4.Location = new System.Drawing.Point(514, 81);
            this.comboBox4.Name = "comboBox4";
            this.comboBox4.Size = new System.Drawing.Size(121, 21);
            this.comboBox4.TabIndex = 12;
            // 
            // comboBox5
            // 
            this.comboBox5.FormattingEnabled = true;
            this.comboBox5.Location = new System.Drawing.Point(514, 104);
            this.comboBox5.Name = "comboBox5";
            this.comboBox5.Size = new System.Drawing.Size(121, 21);
            this.comboBox5.TabIndex = 13;
            // 
            // comboBox6
            // 
            this.comboBox6.FormattingEnabled = true;
            this.comboBox6.Location = new System.Drawing.Point(514, 127);
            this.comboBox6.Name = "comboBox6";
            this.comboBox6.Size = new System.Drawing.Size(121, 21);
            this.comboBox6.TabIndex = 14;
            // 
            // loadImageButton
            // 
            this.loadImageButton.Location = new System.Drawing.Point(424, 184);
            this.loadImageButton.Name = "loadImageButton";
            this.loadImageButton.Size = new System.Drawing.Size(100, 23);
            this.loadImageButton.TabIndex = 16;
            this.loadImageButton.Text = "Load Image";
            this.loadImageButton.UseVisualStyleBackColor = true;
            this.loadImageButton.Click += new System.EventHandler(this.loadImageButton_Click);
            // 
            // pictureBox
            // 
            this.pictureBox.Location = new System.Drawing.Point(424, 213);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new System.Drawing.Size(327, 162);
            this.pictureBox.TabIndex = 17;
            this.pictureBox.TabStop = false;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // gridLoadButton
            // 
            this.gridLoadButton.Location = new System.Drawing.Point(531, 184);
            this.gridLoadButton.Name = "gridLoadButton";
            this.gridLoadButton.Size = new System.Drawing.Size(104, 23);
            this.gridLoadButton.TabIndex = 18;
            this.gridLoadButton.Text = "Load Grid";
            this.gridLoadButton.UseVisualStyleBackColor = true;
            this.gridLoadButton.Click += new System.EventHandler(this.gridLoadButton_Click);
            // 
            // chart1
            // 
            chartArea1.Name = "ChartArea1";
            this.chart1.ChartAreas.Add(chartArea1);
            legend1.Name = "Legend1";
            this.chart1.Legends.Add(legend1);
            this.chart1.Location = new System.Drawing.Point(424, 381);
            this.chart1.Name = "chart1";
            this.chart1.Size = new System.Drawing.Size(327, 190);
            this.chart1.TabIndex = 19;
            this.chart1.Text = "chart1";
            // 
            // checkListChart
            // 
            this.checkListChart.FormattingEnabled = true;
            this.checkListChart.Items.AddRange(new object[] {
            "Red",
            "Green",
            "Blue",
            "Hue",
            "Sat",
            "Val"});
            this.checkListChart.Location = new System.Drawing.Point(363, 381);
            this.checkListChart.Name = "checkListChart";
            this.checkListChart.Size = new System.Drawing.Size(55, 94);
            this.checkListChart.TabIndex = 20;
            this.checkListChart.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.checkListChart_SelectedIndexValueChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(818, 637);
            this.Controls.Add(this.checkListChart);
            this.Controls.Add(this.chart1);
            this.Controls.Add(this.gridLoadButton);
            this.Controls.Add(this.pictureBox);
            this.Controls.Add(this.loadImageButton);
            this.Controls.Add(this.comboBox6);
            this.Controls.Add(this.comboBox5);
            this.Controls.Add(this.comboBox4);
            this.Controls.Add(this.comboBox3);
            this.Controls.Add(this.comboBox2);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.loadDrumTextbox);
            this.Controls.Add(this.drumTextBox);
            this.Controls.Add(this.loadInstrumentButton);
            this.Controls.Add(this.instrumentTextBox);
            this.Controls.Add(this.repeatToggle);
            this.Controls.Add(this.stopButton);
            this.Controls.Add(this.playbackProgress);
            this.Controls.Add(this.songDataGrid);
            this.Controls.Add(this.playPauseButton);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            ((System.ComponentModel.ISupportInitialize)(this.songDataGrid)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.chart1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button playPauseButton;
        private System.Windows.Forms.DataGridView songDataGrid;
        private System.Windows.Forms.ProgressBar playbackProgress;
        private System.Windows.Forms.Button stopButton;
        private System.Windows.Forms.CheckBox repeatToggle;
        private System.Windows.Forms.TextBox instrumentTextBox;
        private System.Windows.Forms.Button loadInstrumentButton;
        private System.Windows.Forms.TextBox drumTextBox;
        private System.Windows.Forms.Button loadDrumTextbox;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.ComboBox comboBox2;
        private System.Windows.Forms.ComboBox comboBox3;
        private System.Windows.Forms.ComboBox comboBox4;
        private System.Windows.Forms.ComboBox comboBox5;
        private System.Windows.Forms.ComboBox comboBox6;
        private System.Windows.Forms.Button loadImageButton;
        private System.Windows.Forms.PictureBox pictureBox;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Button gridLoadButton;
        private System.Windows.Forms.DataVisualization.Charting.Chart chart1;
        private System.Windows.Forms.CheckedListBox checkListChart;
    }
}

