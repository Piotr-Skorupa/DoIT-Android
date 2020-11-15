package org.qtproject.example.activityhandler;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.provider.MediaStore.Files;
import android.util.Log;
import java.io.File;

public class FilePathResolver
{
    private static final String TAG = "FilePathResolver";

    public FilePathResolver() {}

    public static void resolve(Context context, String path) {
        String fileName="unknown";
        File file = new File(path);
        Uri uri = Uri.fromFile(new File(path));
        Uri filePathUri = uri;
        if (uri.getScheme().toString().compareTo("content")==0)
        {
            Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);
            if (cursor.moveToFirst())
            {
                int column_index = cursor.getColumnIndexOrThrow("_data");
                Log.i(TAG, cursor.getString(column_index));
                filePathUri = Uri.parse(cursor.getString(column_index));
                fileName = filePathUri.getLastPathSegment().toString();
            }
        }
        else if (uri.getScheme().compareTo("file")==0)
        {
            fileName = filePathUri.getLastPathSegment().toString();
        }
        else
        {
            fileName = fileName+"_"+filePathUri.getLastPathSegment();
        }

        Log.i(TAG, "FILE PATH: " + fileName);
        Log.i(TAG, "REAL ?: " + getURIPath(context, uri));
    }

    private static String getURIPath(Context context, Uri uriValue)
    {
        String[] mediaStoreProjection = { MediaStore.Images.Media.DATA };
        Cursor cursor = context.getContentResolver().query(uriValue, mediaStoreProjection, null, null, null);
        if (cursor != null)
        {
            int colIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            String colIndexString=cursor.getString(colIndex);
            cursor.close();
            return colIndexString;
        }
        return "null";
    }
}