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
            this.playPauseButton = new System.Windows.Forms.Button();
            this.songDataGrid = new System.Windows.Forms.DataGridView();
            this.playbackProgress = new System.Windows.Forms.ProgressBar();
            this.stopButton = new System.Windows.Forms.Button();
            this.repeatToggle = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.songDataGrid)).BeginInit();
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
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(647, 485);
            this.Controls.Add(this.repeatToggle);
            this.Controls.Add(this.stopButton);
            this.Controls.Add(this.playbackProgress);
            this.Controls.Add(this.songDataGrid);
            this.Controls.Add(this.playPauseButton);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            ((System.ComponentModel.ISupportInitialize)(this.songDataGrid)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button playPauseButton;
        private System.Windows.Forms.DataGridView songDataGrid;
        private System.Windows.Forms.ProgressBar playbackProgress;
        private System.Windows.Forms.Button stopButton;
        private System.Windows.Forms.CheckBox repeatToggle;
    }
}

