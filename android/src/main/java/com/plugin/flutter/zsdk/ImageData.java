package com.plugin.flutter.zsdk;

import android.graphics.Bitmap;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class ImageData {
    final String path;
    final Bitmap bitmap;
    final int pxWidth;
    final int pxHeight;
    final int inWidth;
    final int inHeight;

    public ImageData(String path, Bitmap bitmap, int pxWidth, int pxHeight, int inWidth, int inHeight)
    {
        this.path = path;
        this.bitmap = bitmap;
        this.pxWidth = pxWidth;
        this.pxHeight = pxHeight;
        this.inWidth = inWidth;
        this.inHeight = inHeight;
    }
}
