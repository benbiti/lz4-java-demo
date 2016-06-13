/**
 * Simple lz4 jna test.
 */

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;

import java.util.Arrays;


public class lz4_util {

    public interface lz4 extends Library {

        lz4 INSTANCE = (lz4) Native.loadLibrary("liblz4.dylib", lz4.class);
        int LZ4_compress(byte source[], byte dest[], int isize);
        int LZ4_uncompress(byte source[], byte dest[], int osize);
        int LZ4_compress_limitedOutput(byte source[], byte dest[], int isize, int maxOutputSize);
        int LZ4_uncompress_unknownOutputSize (byte source[], byte dest[], int isize, int maxOutputSize);
    }


    public static void main(String[] args) {

        try {
            System.out.println("...compressd...");

            String strcomp = "hell. growingio";

            byte comp[] = new byte[400];
            int comlengh = lz4.INSTANCE.LZ4_compress_limitedOutput(strcomp.getBytes(), comp, strcomp.getBytes().length, 400);

            String compStr = new String(comp, 0, comlengh);
            System.out.println(compStr);
            byte decomp[] = new byte[400];
            int decomlength = lz4.INSTANCE.LZ4_uncompress_unknownOutputSize(Arrays.copyOf(comp, comlengh), decomp, comlengh, 200);
            if (decomlength > 0)
                System.out.println(new String(decomp,0, decomlength));
            System.out.println("...decompressd...");
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}

