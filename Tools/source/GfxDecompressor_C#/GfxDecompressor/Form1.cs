using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using GfxDecompressor.GBA;
using Nintenlord.GBA;

namespace GfxDecompressor
{
    public partial class Form1 : Form
    {
        private GBAROM ROM;
        private Color[] PALfilePalette;
        private Color[] GrayScalePalette;
        private Color[] WhiteToBlackPalette;
        private Color[] CurPalette;
        private byte[] rawGraphics; //raw tileset graphics
        private byte[] findPattern;
        private Bitmap mapBitmap;
        private Graphics mapGraphics;
        private List<GraphicsData> datas;

        public Form1()
        {
            InitializeComponent();
        }

        /// <summary>
        ///
        /// </summary>
        /// <param name="path"></param>
        /// 

        public static byte[] StringToByteArray(String hex)
        {
            int NumberChars = hex.Length;
            byte[] bytes = new byte[NumberChars / 2];
            for (int i = 0; i < NumberChars; i += 2)
                bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
            return bytes;
        }

        public static string ByteArrayToString(byte[] ba)
        {
            if (ba.Length == 0) return "";
            string hex = BitConverter.ToString(ba);
            return hex.Replace("-", "");
        }

        public static int IndexOf(byte[] arrayToSearchThrough, byte[] patternToFind)
        {
            if (patternToFind.Length > arrayToSearchThrough.Length)
                return -1;
            for (int i = 0; i < arrayToSearchThrough.Length - patternToFind.Length; i++)
            {
                bool found = true;
                for (int j = 0; j < patternToFind.Length; j++)
                {
                    if (arrayToSearchThrough[i + j] != patternToFind[j])
                    {
                        found = false;
                        break;
                    }
                }
                if (found)
                {
                    return i;
                }
            }
            return -1;
        }

        public int find(byte[] pattern, int start = -1)
        {
            if (start == -1) start = Convert.ToInt32(numericUpDown1.Value);
            int index;
            if (findPattern.Length == 0)
            {
                MessageBox.Show("Pattern to find is blank.");
                return -2;
            }
            progressBar1.Maximum = datas.Count - 1;
            for (int i = start; i < datas.Count; i++)
            {
                numericUpDown1.Value = i;
                progressBar1.Value = i;
                progressBar1.Refresh();
                if (rawGraphics == null || rawGraphics.Length == 0)
                {
                    //MessageBox.Show("Graphic at index " + numericUpDown1.Value.ToString() + " is blank.");
                }
                else
                {
                    index = IndexOf(rawGraphics, findPattern);
                    if (index >= 0)
                    {
                        progressBar1.Value = progressBar1.Maximum;
                        progressBar1.Refresh();
                        return i;
                    }
                }
            }
            return -1;
        }

        public void SaveBitmap(string path)
        {
            ImageFormat im;
            switch (Path.GetExtension(path).ToUpper())
            {
                case ".PNG":
                    im = ImageFormat.Png;
                    break;
                case ".BMP":
                    im = ImageFormat.Bmp;
                    break;
                case ".GIF":
                    im = ImageFormat.Gif;
                    break;
                default:
                    MessageBox.Show("Wrong image format.");
                    return;
            }
            mapBitmap.Save(path, im);
        }

        /// <summary>
        ///
        /// </summary>
        /// <param name="path"></param>
        public void LoadPalFile(string path)
        {
            BinaryReader br = new BinaryReader(File.OpenRead(path));
            br.BaseStream.Position = 0x18;
            byte[] data = new byte[br.BaseStream.Length - br.BaseStream.Position];
            data = br.ReadBytes(data.Length);
            br.Close();

            PALfilePalette = new Color[data.Length / 4];
            for (int i = 0; i < data.Length; i += 4)
            {
                PALfilePalette[i / 4] = Color.FromArgb(data[i], data[i + 1], data[i + 2]);
            }
        }

        public void LoadRawPalFile(int offset)
        {
            byte[] rawPal = ROM.GetData(offset, 0x1FF);

            PALfilePalette = new Color[0x100];

            Color[] temp = GBAGraphics.toPalette(rawPal, 0, 0x100);
            temp.CopyTo(PALfilePalette, 0x00);

            for (int i = 0; i < 0x100; i += 16)
            {
                PALfilePalette[i] = Color.Transparent;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sizeMultible"></param>
        public void Scan(int sizeMultible)
        {
            int[] results = ROM.ScanForMalias2CompressedData(0, ROM.Length, 0x8000, 4, sizeMultible);
            foreach (var item in results)
            {
                var data = new GraphicsData();
                data.Offset = item;
                data.Compressed = true;
                data.PaletteOffset = 0;
                data.PaletteCompressed = false;
                datas.Add(data);
            }
            numericUpDown1.Maximum = datas.Count;
        }

        public void UpdateGraphics()
        {
            rawGraphics = ROM.DecompressMalias2CompressedData(datas[(int) numericUpDown1.Value].Offset);
            byte[] graphics = rawGraphics;
            if (graphics == null) return;

            int width = Convert.ToInt32(numericUpDown2.Value * 8);
            int heigth = Convert.ToInt32(numericUpDown3.Value * 8);

            pictureBox1.Width = width;
            pictureBox1.Height = heigth;

            GraphicsMode mode = checkBox1.Checked? GraphicsMode.Tile4bit : GraphicsMode.Tile8bit;
            int bitsPerPixel = GBAGraphics.BitsPerPixel(mode);

            int length = Math.Min(bitsPerPixel * width * heigth / 8, graphics.Length);
            Color[] palette;
            int PaletteIndex = 0;
            switch (mode)
            {
                case GraphicsMode.Tile4bit:
                    palette = new Color[CurPalette.Length - PaletteIndex * 16];
                    for (int i = 0; i < palette.Length; i++)
                        palette[i] = CurPalette[i + 16 * PaletteIndex];
                    break;
                default:
                    palette = CurPalette;
                    break;
            }

            /*if (paletteForm.PALfilePalette)
            {
                switch (mode)
                {
                    case GraphicsMode.Tile4bit:
                        palette = new Color[colorForm.Palette.Length - paletteForm.PaletteIndex * 16];
                        for (int i = 0; i < palette.Length; i++)
                            palette[i] = PALfilePalette[i + 16 * paletteForm.PaletteIndex];
                        break;
                    default:
                        palette = PALfilePalette;
                        break;
                }
            }*/

            int empty;
            Bitmap bitmap = GBAGraphics.ToBitmap(graphics, length, 0, palette, width, mode, out empty);
            pictureBox1.Image = bitmap;
            pictureBox1.Refresh();
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            OpenFileDialog open = new OpenFileDialog();
            open.Title = "Open the ROM to edit.";
            open.Filter = "GBA ROMs|*.gba|Binary files|*.bin|All files|*";
            open.Multiselect = false;
            open.CheckFileExists = true;
            open.CheckPathExists = true;
            open.ShowDialog();
            if (open.FileNames.Length > 0)
            {
                ROM.OpenROM(open.FileName);

                for (int x = 0; x < 0x10; x++)
                {
                    for (int y = 0; y < 0x10; y++)
                    {
                        int value = x*0x10 + y;
                        int value2 = ((0x10 - x)*0x10 + (0x10 - y)) & 0xFF;

                        GrayScalePalette[x + y*0x10] = Color.FromArgb(value, value, value);

                        WhiteToBlackPalette[x + y*0x10] = Color.FromArgb(value2, value2, value2);
                    }
                }

                CurPalette = WhiteToBlackPalette;

                Scan(0x20);
                numericUpDown1_ValueChanged(sender, e);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            ROM = new GBAROM();
            datas = new List<GraphicsData>(2048);

            GrayScalePalette = new Color[0x100];
            WhiteToBlackPalette = new Color[0x100];
        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {
            if (numericUpDown1.Value >= datas.Count) numericUpDown1.Value = datas.Count - 1;
            label4.Text = String.Format("Offset: {0:X8}", datas[(int) numericUpDown1.Value].Offset);
            label5.Text = numericUpDown1.Value.ToString() + " / " + (numericUpDown1.Maximum-1).ToString();
            label4.Refresh();
            label5.Refresh();
            UpdateGraphics();
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            CurPalette = checkBox2.Checked ? GrayScalePalette : WhiteToBlackPalette;
            UpdateGraphics();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            SaveFileDialog save = new SaveFileDialog();
            save.Title = "Save the decompressed output to a file.";
            save.Filter = "Binary files|*.bin|All files|*";
            save.ShowDialog();
            if (save.FileNames.Length > 0)
            {
                File.WriteAllBytes(save.FileName, rawGraphics);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string value = "";
            if (findPattern != null && findPattern.Length > 0) value = ByteArrayToString(findPattern);
            if (InputBox.Show("Find", "Enter hex string to search for:", ref value) == DialogResult.OK)
            {
                try
                {
                    findPattern = StringToByteArray(value);
                    int result = find(findPattern, 0);
                    if (result == -1) MessageBox.Show("No results.");
                    else
                    {
                        DialogResult dialogResult = MessageBox.Show("Result found at index " + result.ToString() + " (offset: " + datas[result].Offset + ")\r\nDo you want to search for pointers to this graphic now?", "Result found", MessageBoxButtons.YesNo);
                        if (dialogResult == DialogResult.Yes) button4_Click(null, null);
                    }
                }
                catch (ArgumentException)
                {
                    MessageBox.Show("Invalid hex string");
                }
                catch (FormatException)
                {
                    MessageBox.Show("Invalid hex string");
                }
                catch (OverflowException)
                {
                    MessageBox.Show("Invalid hex string");
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (findPattern == null || findPattern.Length == 0) MessageBox.Show("Nothing to find. Use Find before Next.");
            else
            {
                int result = find(findPattern,Convert.ToInt32(numericUpDown1.Value) + 1);
                if (result == -1) MessageBox.Show("No results.");
                else
                {
                    DialogResult dialogResult = MessageBox.Show("Result found at index " + result.ToString() + " (offset: " + datas[result].Offset + ")\r\nDo you want to search for pointers to this graphic now?", "Result found", MessageBoxButtons.YesNo);
                    if (dialogResult == DialogResult.Yes) button4_Click(null, null);
                }
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            String str = "";
            int[] pointers = ROM.SearchForPointer(datas[(int)numericUpDown1.Value].Offset);
            if (pointers.Length == 0) MessageBox.Show("No pointers found.");
            else
            {
                foreach(int cur in pointers) {
                    String curstr = cur.ToString("X");
                    str = str + "0x8" + (new String('0', curstr.Length - 6)) + curstr + "\r\n";
                }
                DialogResult dialogResult = MessageBox.Show("Pointers found. Do you want to copy these to the clipboard?\r\n\r\n" + str, "Pointers found", MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes) Clipboard.SetText(str);
            }
        }
    }
}
