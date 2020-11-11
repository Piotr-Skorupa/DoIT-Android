package org.qtproject.example.activityhandler;

import android.net.Uri;
import android.util.Log;
import android.content.Context;
import android.content.Intent;

public class ShareComponent
{
    private static final String TAG = "ShareComponent";

    public ShareComponent() {}

    public static void share(Context context, String path) {
        try
        {
            Intent intentShareFile = new Intent(Intent.ACTION_SEND);
            Log.i(TAG, "START");
            Log.i(TAG, path);
            intentShareFile.setType("text/txt");
            intentShareFile.putExtra(Intent.EXTRA_STREAM, Uri.parse(path));
            intentShareFile.putExtra(Intent.EXTRA_SUBJECT, "Lista Zadań");
            intentShareFile.putExtra(Intent.EXTRA_TEXT, "Udostępniam Ci listę zadań. Pobierz ją z załącznika i otwórz w aplikacji.");
            context.startActivity(Intent.createChooser(intentShareFile, "Share File"));
            Log.i(TAG, "STOP");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
