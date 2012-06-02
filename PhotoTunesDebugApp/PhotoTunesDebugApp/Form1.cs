using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;



namespace PhotoTunesDebugApp
{
    public partial class Form1 : Form
    {
        bool playing;
        bool repeat;
        int playbackProgressValue;

        int songLength;
        int numInstruments;

        Color defaultColor;
        Color playbackColor;

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

            SetupTrack();
        }

        public void OnProgressFloat(float value)
        {
            this.Invoke(new Action<float>(OnProgress), new object[] { value });
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
            this.Invoke(new Action(OnStop));
        }

        public void OnStop()
        {
            SetPlaying(false);
        }

        public void SetupTrack()
        {
            numInstruments = 6;
            songLength = 8;

            float[] data = new float[numInstruments * songLength];

            for (int i = 0; i < songLength; ++i)
            {
                data[i] = i % 8 == 0 ? 1 : 0;
                data[i + songLength] = i % 8 == 4 ? 1 : 0;
                data[i + songLength * 2] = i % 4 == 1 ? 1 : 0;
                data[i + songLength * 3] = i % 4 == 2 ? 1 : 0;
                data[i + songLength * 4] = i % 4 == 3 ? 1 : 0;
                data[i + songLength * 5] = -200 + i * 100;
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

    }
}
