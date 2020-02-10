package com.plugin.flutter.zsdk;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.RectF;
import android.graphics.pdf.PdfRenderer;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import org.vudroid.core.DecodeServiceBase;
import org.vudroid.core.codec.CodecPage;
import org.vudroid.pdfdroid.codec.PdfContext;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class PdfUtils
{
    public static List<ImageData> getImagesFromPdf(Context context, String filePath, int width, int height, Orientation orientation, boolean writeToFile) throws Exception
    {
        List<ImageData> list = new ArrayList<>();

        DecodeServiceBase decodeService = new DecodeServiceBase(new PdfContext());
        decodeService.setContentResolver(context.getContentResolver());

        // a bit long running
        decodeService.open(Uri.fromFile(new File(filePath)));

        int pageCount = decodeService.getPageCount();
        for (int i = 0; i < pageCount; i++) {
            CodecPage page = decodeService.getPage(i);
            RectF rectF = new RectF(0, 0, 1, 1);

            // Long running
            Bitmap bitmap = page.renderBitmap(width, height, rectF);
            Matrix matrix = new Matrix();
            matrix.postRotate(orientation == Orientation.LANDSCAPE ? 90 : 0);
            Bitmap rotatedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);

            File outputFile = new File(context.getExternalCacheDir(), "/pages/"+"page-"+i+".jpg");
            if(writeToFile){
                outputFile.getParentFile().mkdirs();
                outputFile.createNewFile();
                FileOutputStream outputStream = new FileOutputStream(outputFile);

                // a bit long running
                rotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);

                outputStream.close();
            }
            list.add(new ImageData(outputFile.getAbsolutePath(), rotatedBitmap, 0, 0, 0, 0));
        }
        return list;
    }

    public static List<ImageData> getImagesFromPdfRenderer(Context context, String filePath, int width, int height, Orientation orientation, boolean writeToFile) throws Exception
    {
        final ParcelFileDescriptor pfdPdf = context.getContentResolver()
                .openFileDescriptor(Uri.fromFile(new File(filePath)), "r");

        List<ImageData> list = new ArrayList<>();
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            if(pfdPdf == null) return list;
            PdfRenderer pdf = new PdfRenderer(pfdPdf);
            for(int i = 0; i < pdf.getPageCount(); ++i) {
                PdfRenderer.Page page = pdf.openPage(i);
                Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
                bitmap.eraseColor(Color.WHITE);
                page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_PRINT);
                page.close();

                Matrix matrix = new Matrix();
                matrix.postRotate(orientation == Orientation.LANDSCAPE ? 90 : 0);
                Bitmap rotatedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);

                File outputFile = new File(context.getExternalCacheDir(), "/pages/"+"page-"+i+".jpg");
                if(writeToFile){
                    outputFile.getParentFile().mkdirs();
                    outputFile.createNewFile();
                    FileOutputStream outputStream = new FileOutputStream(outputFile);

                    // a bit long running
                    rotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);

                    outputStream.close();
                }
                list.add(new ImageData(outputFile.getAbsolutePath(), rotatedBitmap, 0, 0, 0, 0));
            }
            pdf.close();
        }
        return list;
    }

    /** Returns the printWidth of the pdf page in inches for scaling later
     * PdfRenderer is only available for devices running Android Lollipop or newer
     */
    public static Integer getPageWidth(Context context, String filePath) throws IOException
    {
        final ParcelFileDescriptor pfdPdf = context.getContentResolver()
                .openFileDescriptor(Uri.parse("file://" + filePath), "r");
        if(pfdPdf == null) return 0;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            PdfRenderer pdf = new PdfRenderer(pfdPdf);
            PdfRenderer.Page page = pdf.openPage(0);
            int pixWidth = page.getWidth();
            return pixWidth / 72;
        }
        return 0;
    }
}
