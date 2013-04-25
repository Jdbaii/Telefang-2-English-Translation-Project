using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GfxCompressor
{
    class Program
    {
        private static byte[] input;
        private static byte[] output;
        static void Main(string[] args)
        {
            if (args.Length < 2)
            {
                Console.Write("usage: gfxcompressor input_name output_name");
                return;
            }

            input = File.ReadAllBytes(args[0]);

            output = new byte[input.Length * 3];
            int compressedLength = 0;
            int decompressedLength = input.Length;


            output[compressedLength++] = 0x4C;
            output[compressedLength++] = 0x65;

            output[compressedLength++] = (byte)(decompressedLength >> 0);
            output[compressedLength++] = (byte)(decompressedLength >> 8);
            output[compressedLength++] = (byte)(decompressedLength >> 16);
            output[compressedLength++] = (byte)(decompressedLength >> 24);

            int position = 0;
            while(position < decompressedLength)
            {
                /*output[compressedLength++] = 0xAA; //Set next four bytes to be uncompressed

                for (int i = 0; i < 4; i++)
                {
                    output[compressedLength+i+1] = input[position++];
                }*/
                int commandPosition = compressedLength++;
                int commandByte = 0;

                int i = 0;
                while(i < 4)
                {
                    int length = 0;
                    /*while (position < decompressedLength-1 && input[position] == input[position + 1])
                    {
                        position++;
                        length++;
                    }*/

                    if (position > decompressedLength - 1)
                        break;

                    //if (length == 0)
                    {
                        while ((length < 3) && ((position + length) < decompressedLength - 1) && (input[position + length] != input[position + length + 1]))
                        {
                            length++;
                        }

                        if (length == 3)
                        {
                            commandByte |= 3 << (2*i);
                            output[compressedLength++] = input[position++];
                            output[compressedLength++] = input[position++];
                            output[compressedLength++] = input[position++];
                        }
                        else
                        {
                            commandByte |= 2 << (2*i);
                            output[compressedLength++] = input[position++];
                        }
                    }
                    /*else
                    {
                        //Copy the byte first then set it to copy
                        commandByte |= 2 << (2 * i);
                        output[compressedLength++] = input[position++];
                        i++;

                        if (i > 3)
                        {
                            output[commandPosition] = (byte)commandByte;
                            commandPosition = compressedLength++;
                            commandByte = 0;
                            i = 0;

                            commandByte |= 2 << (2 * i);
                            output[compressedLength++] = input[position-1];
                            i++;

                            if (length == 1)
                                break;
                        }

                        commandByte |= 1 << (2 * i);
                        output[compressedLength++] = (byte)(((length - 2) << 2));
                    }*/
                    i++;
                }

                output[commandPosition] = (byte) commandByte;
            }

            byte[] outp = new byte[compressedLength];
            Array.Copy(output,outp,compressedLength);

            File.WriteAllBytes(args[1], outp);

        }
    }
}
