using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Windows.Forms.DataVisualization.Charting;

namespace PhotoTunesDebugApp
{
    public partial class Form1 : Form
    {
        Image imageVanilla;
        Image imageFiltered;

        bool playing;
        bool repeat;
        int playbackProgressValue;

        int songLength;
        int numInstruments;

        Color defaultColor;
        Color playbackColor;

        ImageProperties imageprop = new ImageProperties();
        ImageProperties filteredimageprop = new ImageProperties();

        public Form1()
        {
            defaultColor = Color.FromKnownColor(KnownColor.White);
            playbackColor = Color.FromKnownColor(KnownColor.Yellow);

            playing = false;
            repeat = false;
            playbackProgressValue = 0;

            InitializeComponent();

            AudioEngine.Startup();

            AudioEngine.SubscribeFloat(AudioEngine.PrependDollarZero("notifyProgress"), OnProgressFloat);
            AudioEngine.SubscribeBang("stopPlayback", OnStopBang);

            SetupTrack(6, 8);

            trackBarLength.TickStyle = TickStyle.None;
            trackBarTempo.TickStyle = TickStyle.None;
        }

        public void OnProgressFloat(float value)
        {
            this.BeginInvoke(new Action<float>(OnProgress), new object[] { value });
        }

        public void OnProgress(float value)
        {
            playbackProgress.Value = (int)value;
            playbackProgressValue = (int)value;
            ColourPlaybackColumn();
        }

        public void ColourPlaybackColumn()
        {
            for (int i = 0; i < songLength; i++)
            {
                for (int j = 0; j < numInstruments; j++)
                {
                    songDataGrid.Rows[j].Cells[i].Style.BackColor = defaultColor;
                }
            }

            for (int j = 0; j < numInstruments; j++)
            {
                songDataGrid.Rows[j].Cells[playbackProgressValue].Style.BackColor = playbackColor;
            }
        }

        public void OnStopBang()
        {
            this.BeginInvoke(new Action(OnStop));
        }

        public void OnStop()
        {
            SetPlaying(false);
        }

        public void SetupTrack(int instruments, int length)
        {
            numInstruments = instruments;
            songLength = length;

            float[] data = new float[numInstruments * songLength];

            for (int i = 0; i < songLength; ++i)
            {
                data[i] = i % 8 == 0 ? 1 : 0;
                data[i + songLength] = i % 8 == 4 ? 1 : 0;
                data[i + songLength * 2] = i % 4 == 1 ? 1 : 0;
                data[i + songLength * 3] = i % 4 == 2 ? 1 : 0;
                data[i + songLength * 4] = i % 4 == 3 ? 1 : 0;
                data[i + songLength * 5] = i * 2 / (float)songLength;
            }

            songDataGrid.Columns.Clear();
            songDataGrid.Rows.Clear();
            songDataGrid.AllowUserToAddRows = false;

            for (int x = 0; x < songLength; ++x)
            {
                songDataGrid.Columns.Add(x.ToString(), x.ToString());
                songDataGrid.Columns[x].Width = 40;
            }

            for (int y = 0; y < numInstruments; y++)
            {
                songDataGrid.Rows.Add();

                for (int x = 0; x < songLength; x++)
                {
                   songDataGrid.Rows[y].Cells[x].Value = data[y * songLength + x];
                }
            }

            AudioEngine.SendFloat(AudioEngine.PrependDollarZero("numInstruments"), (float)numInstruments);

            playbackProgress.Maximum = (int)songLength - 1;
            AudioEngine.SendFloat(AudioEngine.PrependDollarZero("length"), (float)songLength);

            AudioEngine.SendArray("pattern", 0, data, data.Length); 
        }

        private void updateGrid()
        {
            float[] data = new float[numInstruments * songLength];

            for (int i = 0; i < numInstruments; i++)
            {
                for (int j = 0; j < songLength; j++)
                {
                    data[(i * songLength) + j] = float.Parse(songDataGrid.Rows[i].Cells[j].Value.ToString());
                }
            }
        
            AudioEngine.SendArray("pattern", 0, data, data.Length); 
        }

        private void playPauseButton_Click(object sender, EventArgs e)
        {
            if (!playing)
            {
                AudioEngine.SendMessage("startPlayback");
                SetPlaying(true);
            }
            else
            {
                AudioEngine.SendMessage("pausePlayback");
                SetPlaying(false);
            }
        }

        private void stopButton_Click(object sender, EventArgs e)
        {
            AudioEngine.SendMessage("stopPlayback");
            SetPlaying(false);
        }

        private void repeatToggle_CheckedChanged(object sender, EventArgs e)
        {
            repeat = repeatToggle.Checked;

            AudioEngine.SendFloat(AudioEngine.PrependDollarZero("loopPlayback"), repeat ? 1.0f : 0.0f);
        }

        private void SetPlaying(bool playing)
        {
            this.playing = playing;

            if (playing)
                playPauseButton.Text = "Pause";
            else
                playPauseButton.Text = "Play";
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            AudioEngine.Shutdown();
        }

        private void loadInstrumentButton_Click(object sender, EventArgs e)
        {
            AudioEngine.LoadInstrument(5, instrumentTextBox.Text);
        }

        private void loadDrumTextbox_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < drumTextBox.Lines.Length; i++)
            {
                AudioEngine.LoadInstrument(i, drumTextBox.Lines[i]);
            }
        }

        private void loadImageButton_Click(object sender, EventArgs e)
        {
            DialogResult result = openFileDialog1.ShowDialog();

            if (result == DialogResult.OK)
            {
                Image image = Image.FromFile(openFileDialog1.FileName);
                imageVanilla = ImageFilter.Downsample(image, 320); // TODO: downsample
                imageFiltered = ImageFilter.SobelFilter(imageVanilla);

                pictureBox.Image = imageVanilla;
                pictureBox.SizeMode = PictureBoxSizeMode.StretchImage;
                updateSongNotes();
            }
        }

        private void gridLoadButton_Click(object sender, EventArgs e)
        {
            updateGrid();
            pictureBox.Image = null;
        }

        private void updateSongNotes()
        {
            //ImageSlice slice = new ImageSlice();

            //slice.init(image, 4);

            imageprop.init(imageVanilla);
            filteredimageprop.init(imageFiltered);

            updateChart();
        }

        private void updateChart()
        {
            string[] seriesArray = { "Red", "Green", "Blue", "Hue", "Sat", "Val", "filtered val" };
            Color[] colourArray = { Color.Red, Color.Green, Color.Blue, Color.Purple, Color.Orange, Color.Black, Color.HotPink };
            float[,] pointArray = new float[imageprop.getNumSlices(), seriesArray.Length];

            this.chart1.Series.Clear();

            this.chart1.ChartAreas[0].AxisY.Maximum = 255;
            this.chart1.ChartAreas[0].AxisX.Maximum = imageprop.getNumSlices();

            this.chart1.ChartAreas[0].AxisX.Enabled = AxisEnabled.False;
            this.chart1.ChartAreas[0].AxisY.Enabled = AxisEnabled.False;

            this.chart1.Legends[0].Enabled = false;

            for (int j = 0; j < imageprop.getNumSlices(); j++)
            {
                pointArray[j, 0] = imageprop.getSlice(j).getAverageRed();
                pointArray[j, 1] = imageprop.getSlice(j).getAverageGreen();
                pointArray[j, 2] = imageprop.getSlice(j).getAverageBlue();
                pointArray[j, 3] = imageprop.getSlice(j).getAverageHue();
                pointArray[j, 4] = imageprop.getSlice(j).getAverageSat();
                pointArray[j, 5] = imageprop.getSlice(j).getAverageVal();
                pointArray[j, 6] = filteredimageprop.getSlice(j).getAverageVal();
            }

            for (int i = 0; i < seriesArray.Length; i++)
            {
                Series series = this.chart1.Series.Add(seriesArray[i]);

                series.ChartType = SeriesChartType.Line;
                series.Color = colourArray[i];

                for (int j = 0; j < imageprop.getNumSlices(); j++)
                {
                    series.Points.Add(pointArray[j, i]);
                }

                chart1.Series[i].Enabled = isSeriesEnabled(i);
                chart1.Series[i].LegendText = "";
            }
        }

        private bool isSeriesEnabled(int index)
        {
            return checkListChart.GetItemCheckState(index) == CheckState.Checked;
        }

        private void checkListChart_SelectedIndexValueChanged(object sender, ItemCheckEventArgs e)
        {
            chart1.Series[e.Index].Enabled = e.NewValue == CheckState.Checked;
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            AudioEngine.SetInstrumentMode(0, comboBox1.SelectedIndex);
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            AudioEngine.SetInstrumentMode(1, comboBox1.SelectedIndex);
        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            AudioEngine.SetInstrumentMode(2, comboBox3.SelectedIndex);
        }

        private void comboBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            AudioEngine.SetInstrumentMode(3, comboBox4.SelectedIndex);
        }

        private void comboBox5_SelectedIndexChanged(object sender, EventArgs e)
        {
            AudioEngine.SetInstrumentMode(4, comboBox5.SelectedIndex);
        }

        private void comboBox6_SelectedIndexChanged(object sender, EventArgs e)
        {
            AudioEngine.SetInstrumentMode(5, comboBox6.SelectedIndex);
        }

        private void pictureBox_Click(object sender, EventArgs e)
        {
            if (pictureBox.Image == imageVanilla)
                pictureBox.Image = imageFiltered;
            else
                pictureBox.Image = imageVanilla;
        }

        private void trackBarLength_Scroll(object sender, EventArgs e)
        {
            AudioEngine.SendMessage("stopPlayback");
            SetPlaying(false);
            SetupTrack(6, trackBarLength.Value);
        }

        private void trackBarTempo_Scroll(object sender, EventArgs e)
        {
            float tempo = 60000.0f / (((float)trackBarTempo.Value / 1000) * 400.0f + 60.0f);
            AudioEngine.SendFloat(AudioEngine.PrependDollarZero("tempo"), tempo);
        }
    }
}
