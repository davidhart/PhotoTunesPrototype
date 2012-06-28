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

        static float step1 = 0.05f;
        static float step2 = 0.10f;
        static float step3 = 0.15f;
        static float step4 = 0.20f;

        bool playing;
        bool repeat;
        int playbackProgressValue;
        playbackMode mode = 0;

        public enum playbackMode{
            rock,
            dance,
            atebit
            }

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
            dataGridView1.Columns.Clear();
            dataGridView1.RowHeadersVisible = false;

            for (int x = 0; x < songLength; ++x)
            {
                songDataGrid.Columns.Add(x.ToString(), x.ToString());
                songDataGrid.Columns[x].Width = 40;
                dataGridView1.Columns.Add(x.ToString(), x.ToString());
                dataGridView1.Columns[x].Width = 673 / songLength;
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
        public void SetupTrack(int instruments, int length, float[] melody, DrumsWrap drums)
        {
            numInstruments = instruments;
            songLength = length;


            float[] data = new float[numInstruments * songLength];

                for (int i = 0; i < songLength; ++i)
                {
                    data[i] = drums.bassNotes[i];
                    data[i + songLength] = drums.hihatNotes[i];
                    data[i + songLength * 2] = drums.rideNotes[i];
                    data[i + songLength * 3] = drums.snareNotes[i];
                    data[i + songLength * 4] = drums.splashNotes[i];
                    data[i + songLength * 5] = melody[i];
                }
            


            songDataGrid.Columns.Clear();
            songDataGrid.Rows.Clear();
            songDataGrid.AllowUserToAddRows = false;
            dataGridView1.Columns.Clear();
            dataGridView1.RowHeadersVisible = false;

            for (int x = 0; x < songLength; ++x)
            {
                songDataGrid.Columns.Add(x.ToString(), x.ToString());
                songDataGrid.Columns[x].Width = 40;
                dataGridView1.Columns.Add(x.ToString(), x.ToString());
                dataGridView1.Columns[x].Width = 673 / songLength;
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
                imageprop = new ImageProperties();
                imageprop.init(imageVanilla);
                filteredimageprop = new ImageProperties();
                filteredimageprop.init(imageFiltered);
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


            updateChart();
            float[] sliceAvArray = new float[songLength];
            float[] filteredSliceAvArray = new float[songLength];
            float[] ModifiedSliceAvArray = new float[songLength];
            bool[] rests = new bool[songLength];
            DrumsWrap drums = new DrumsWrap();
            drums.bassNotes = new float[songLength];
            drums.hihatNotes = new float[songLength];
            drums.rideNotes = new float[songLength];
            drums.snareNotes = new float[songLength];
            drums.splashNotes = new float[songLength];
            float[] melodyNotes = new float[songLength];

            int prevSliceNumber = 0;
            for (int i = 1; i < songLength+1; i++)
            {
                int sliceBack;
                int sliceNum = (int)(((i / (float)(songLength) * (imageprop.getNumSlices() - 1))));
                ImageSlice slice = imageprop.getSlice(sliceNum);
                ImageSlice filteredSlice = filteredimageprop.getSlice(sliceNum);
                

                    sliceBack = (int)(((i / (float)(songLength)) * (imageprop.getNumSlices()) - prevSliceNumber)) - 1;
                    ////sliceBack = (int)((i * songLength) / (imageprop.getNumSlices() - prevSliceNumber) - 1);
                    Console.WriteLine("from slice" + (sliceNum - sliceBack) + "to" +  sliceNum);
                    float sliceAv = 0;
                    float filteredSliceAv = 0;
                    int numOfLoops = 0;

                    for (int j = i; (j - i) < sliceBack; j++)
                    {
                        int sliceIndex = (int)(((i / (float)(songLength)) * (imageprop.getNumSlices() - 1)) - j);
                        slice = imageprop.getSlice(sliceIndex);
                        filteredSlice = filteredimageprop.getSlice(sliceIndex);
                        sliceAv += slice.getAverageVal();
                        filteredSliceAv += filteredSlice.getAverageVal();
                        numOfLoops++;
                    }
                    sliceAv /= numOfLoops;
                    filteredSliceAv /= numOfLoops;
                    i--;// to adjust for array
                    sliceAvArray[i] = sliceAv;
                    filteredSliceAvArray[i] = filteredSliceAv;

                    if (filteredSliceAvArray[i] > filteredimageprop.getAverageVal())
                    {
                        rests[i] = false;
                    }
                    else
                    {
                        rests[i] = true;
                    }



                prevSliceNumber = sliceNum;
                                                const float bassVolume = 0.6f;
            const float hihatVolume = 0.6f;
            const float rideVolume = 0.6f;
            const float snareVolume = 0.6f;
            const float splashVolume = 0.6f;

            const float bassVariation = 0.5f;
            const float hihatVariation = 0.5f;
            const float rideVariation = 0.5f;
            const float snareVariation = 0.5f;
            const float splashVariation = 0.5f;

           float change = (slice.getAverageSat() - imageprop.getAverageSat());
           float splash = Math.Abs(change) > ((imageprop.getDeviationSat())*10) ? 1.0f : 0.0f;
           
           switch (mode)
           {
               case playbackMode.rock:
                   drums.bassNotes[i] = i % 4 == 0 ? 1.0f : 0.0f;
                   //drums.hihatNotes[i] = [slice getAverageVal] < 60? 1.0f : 0.0f;
                   drums.hihatNotes[i] = 1;
                   drums.rideNotes[i] = 1 - drums.hihatNotes[i];
                   drums.snareNotes[i] = i % 4 == 2 ? 1.0f : 0.0f;
                   drums.splashNotes[i] = splash;
                   break;

               case playbackMode.dance:
                   drums.bassNotes[i] = i % 2 == 0 ? 1.0f : 0.0f;
                   drums.hihatNotes[i] = i % 2 == 1 ? 1.0f : 0.0f;
                   drums.rideNotes[i] = 0.0f;
                   drums.snareNotes[i] = splash;
                   drums.splashNotes[i] = i % 4 == 3 ? 1.0f : 0.0f;
                   break;

               default:
                   break;
           }
    


        
        
        
        if (drums.bassNotes[i] > 0)
            drums.bassNotes[i] += - bassVariation / 2 - bassVariation * slice.getAverageRed() / 255.0f;
        
        if (drums.hihatNotes[i] > 0)
            drums.hihatNotes[i] += - hihatVariation / 2 + hihatVariation * slice.getAverageGreen() / 255.0f;
        
        if (drums.rideNotes[i] > 0)
            drums.rideNotes[i] += - rideVariation / 2 - rideVariation * slice.getAverageBlue() / 255.0f;
        
        if (drums.snareNotes[i] > 0)
            drums.snareNotes[i] += - rideVariation / 2 - snareVariation * slice.getAverageRed() / 255.0f;
        
        if (drums.splashNotes[i] > 0)
            drums.splashNotes[i] += - splashVariation / 2 - splashVariation * slice.getAverageGreen() / 255.0f;
          
        
        drums.bassNotes[i] *= bassVolume;
        drums.hihatNotes[i] *= hihatVolume;
        drums.rideNotes[i] *= rideVolume;
        drums.snareNotes[i] *= snareVolume;
        drums.splashNotes[i] *= splashVolume;
        i++;//readjust for array
            }
            //Gets Highest and lowest slices and maps to a range of 0 - 1
            float lowSlice = 0;
            float highSlice = 0;
            for (int j = 0; j < songLength; j++)
            {

                if (sliceAvArray[j] < lowSlice || j == 0)
                {
                    lowSlice = (float)sliceAvArray[j];

                }
                if (sliceAvArray[j] > highSlice || j == 0)
                {
                    highSlice = (float)sliceAvArray[j];
                }

            }
            for (int i = 0; i < songLength; i++)
            {
                sliceAvArray[i] = (sliceAvArray[i] - lowSlice) / (highSlice - lowSlice);
            }

            ModifiedSliceAvArray[0] = 0.5f;
            for (int i = 0; i < songLength-1;/*!-1 may be bug in obj c code*/ i++)
            {

                float step = sliceAvArray[i + 1] - sliceAvArray[i];

                if (step > 0)
                {
                    if (Math.Abs(step) < 0.01)
                    {
                        ModifiedSliceAvArray[i + 1] = step1 + ModifiedSliceAvArray[i];

                    }
                    else if (Math.Abs(step) < 0.05)
                    {
                        ModifiedSliceAvArray[i + 1] = step2 + ModifiedSliceAvArray[i];

                    }
                    else if (Math.Abs(step) < 0.1)
                    {


                        ModifiedSliceAvArray[i + 1] = step3 + ModifiedSliceAvArray[i];

                    }
                    else
                    {
                        ModifiedSliceAvArray[i + 1] = step4 + ModifiedSliceAvArray[i];


                    }
                    if (ModifiedSliceAvArray[i + 1] > 1.0 && i > 0)
                    {

                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];

                    }
                    else if (ModifiedSliceAvArray[i + 1] > 1.0)
                    {
                        ModifiedSliceAvArray[i + 1] = step1;
                    }
                    if (ModifiedSliceAvArray[i + 1] < 0.0 && i > 0)
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];

                    }
                    else if (ModifiedSliceAvArray[i + 1] < 0.0)
                    {
                        ModifiedSliceAvArray[i + 1] = step1;
                    }
                }
                else
                {
                    if (Math.Abs(step) < 0.01)
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i];

                    }
                    else if (Math.Abs(step) < 0.05)
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i] - step2;

                    }
                    else if (Math.Abs(step) < 0.1)
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i] - step3;

                    }
                    else
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i] - step4;
                    }

                    if (ModifiedSliceAvArray[i + 1] > 1.0 && i > 0)
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];

                    }
                    else if (ModifiedSliceAvArray[i + 1] > 1.0)
                    {
                        ModifiedSliceAvArray[i + 1] = step1;
                    }
                    if (ModifiedSliceAvArray[i + 1] < 0.0 && i > 0)
                    {
                        ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];
                    }
                    else if (ModifiedSliceAvArray[i + 1] < 0.0)
                    {
                        ModifiedSliceAvArray[i + 1] = step1;
                    }
                }
                

            }
            for (int i = 0; i < songLength; i++)
            {
                //C Scale
                float[] scale = { 0.5f, 0.56122f, 0.6299f, 0.6674f, 0.7491f, 0.8408f, 0.9438f, 1.0f, 1.1124f, 1.2600f, 1.3348f, 1.4983f, 1.684f, 1.8877f };
                if (!rests[i])
                {
                    melodyNotes[i] = getNote(scale, scale.Length, ModifiedSliceAvArray[i]);
                }
                else
                {
                    melodyNotes[i] = 0;
                }
            }
            SetupTrack(6, songLength, melodyNotes, drums);
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
        private float getNote(float[] scale, int size, float locationOnScale)
        {   
            int index = (int)(locationOnScale * (size - 1) + 0.5f);
            return scale[index];
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
            if (pictureBox.Image != null)
            {
                songLength = trackBarLength.Value;
                updateSongNotes();
            }
            else
            {
                SetupTrack(6, trackBarLength.Value);
            }
        }

        private void trackBarTempo_Scroll(object sender, EventArgs e)
        {
            float tempo = 60000.0f / (((float)trackBarTempo.Value / 1000) * 400.0f + 60.0f);
            AudioEngine.SendFloat(AudioEngine.PrependDollarZero("tempo"), tempo);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            mode = playbackMode.rock;
            updateSongNotes();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            mode = playbackMode.dance;
            updateSongNotes();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            mode = playbackMode.atebit;
            updateSongNotes();
        }

    }
}
