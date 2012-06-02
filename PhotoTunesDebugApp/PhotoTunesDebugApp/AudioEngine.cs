using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using PortAudioSharp;
using LibPDBinding;

namespace PhotoTunesDebugApp
{
    class AudioEngine
    {
        static IntPtr stream;
        static int handle;

        // Keep this in static memory to stop it being garbage collected at runtime
        static PortAudio.PaStreamCallbackDelegate delagate = AudioCallback;

        static Dictionary<string, Action<float>> floatHandlers = new Dictionary<string,Action<float>>();
        static Dictionary<string, Action> bangHandlers = new Dictionary<string, Action>();

        // Audio render callback
        static PortAudio.PaStreamCallbackResult AudioCallback(
            IntPtr input,
            IntPtr output,
            uint frameCount,
            ref PortAudio.PaStreamCallbackTimeInfo timeInfo,
            PortAudio.PaStreamCallbackFlags statusFlags,
            IntPtr userData)
        {
            unsafe
            {
                LibPD.Process((int)frameCount / LibPD.BlockSize, (float*)input.ToPointer(), (float*)output.ToPointer());
            }

            return PortAudio.PaStreamCallbackResult.paContinue;
        }

        // Pd Print Hook
        static void LibPD_Print(string text)
        {
            Console.Write(text);
        }

        // Startup audio engine
        public static void Startup()
        {
            LibPD.ReInit();

            LibPD.Print += new LibPDPrint(LibPD_Print);

            LibPD.ComputeAudio(true);

            LibPD.OpenAudio(1, 2, 44100);
            handle = LibPD.OpenPatch("patch/soundsystem.pd");

            PortAudio.Pa_Initialize();
            PortAudio.Pa_OpenDefaultStream(out stream, 1, 2, (uint)PortAudio.PaSampleFormat.paFloat32,
                44100,
                256,
                delagate,
                (IntPtr)null);

            PortAudio.Pa_StartStream(stream);

            LibPD.Float += new LibPDFloat(LibPD_Float);
            LibPD.Bang += new LibPDBang(LibPD_Bang);
        }

        static void  LibPD_Bang(string recv)
        {
 	        bangHandlers[recv]();
        }

        static void LibPD_Float(string recv, float x)
        {
            floatHandlers[recv](x);
        }

        // Shutdown audio engine
        public static void Shutdown()
        {
            PortAudio.Pa_StopStream(stream);

            PortAudio.Pa_CloseStream(stream);

            PortAudio.Pa_Terminate();
        }

        public static void SendMessage(string message)
        {
            LibPD.SendBang(message);
        }

        public static void SendFloat(string message, float value)
        {
            LibPD.SendFloat(message, value);
        }

        public static void SendArray(string array, int offset, float[] source, int n)
        {
            LibPD.WriteArray(array, offset, source, n);
        }
        
        public static string PrependDollarZero(string name)
        {
            return handle.ToString() + "-" + name;
        }

        public static void SubscribeFloat(string name, Action<float> handler)
        {
            LibPD.Subscribe(name);

            floatHandlers[name] = handler;
        }

        public static void UnsubscribeFloat(string name)
        {
            LibPD.Unsubscribe(name);
        }

        public static void SubscribeBang(string name, Action handler)
        {
            LibPD.Subscribe(name);

            bangHandlers[name] = handler;
        }

        public static void UnsubscribeBang(string name)
        {
            LibPD.Unsubscribe(name);
        }
    }
}
