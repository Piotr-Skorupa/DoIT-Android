package org.qtproject.example.activityhandler;

import android.net.Uri;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.support.v4.content.FileProvider;
import android.util.Log;
import java.io.File;
import java.io.InputStream;
import java.util.List;

public class ShareComponent
{
    private static final String TAG = "ShareComponent";

    public ShareComponent() {}

    public static void share(Context context, String path) {
        File requestFile = new File(path);
        try {
            Uri fileUri = FileProvider.getUriForFile(
                    context,
                    "org.qtproject.example.fileprovider",
                    requestFile);
            Intent intentShareFile = new Intent(Intent.ACTION_SEND);
            Log.i(TAG, "START");
            Log.i(TAG, path);
            Log.i(TAG, fileUri.getPath());
            ContentResolver contentResolver = context.getContentResolver();
            InputStream inputStream = contentResolver.openInputStream(fileUri);
            intentShareFile.setType(contentResolver.getType(fileUri));
            intentShareFile.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intentShareFile.putExtra(Intent.EXTRA_STREAM, fileUri);
            intentShareFile.putExtra(Intent.EXTRA_SUBJECT, "Lista Zadań");
            intentShareFile.putExtra(Intent.EXTRA_TEXT, "Udostępniam Ci listę zadań. Pobierz ją z załącznika i otwórz w aplikacji.");

            PackageManager packageManager = context.getPackageManager();
            List<ResolveInfo> resInfoList = packageManager.queryIntentActivities(intentShareFile, PackageManager.MATCH_DEFAULT_ONLY);
            // Loop the activity list.
            int size = resInfoList.size();
            for(int i=0;i<size;i++)
            {
                ResolveInfo resolveInfo = resInfoList.get(i);
                String packageName = resolveInfo.activityInfo.packageName;
                context.grantUriPermission(packageName, fileUri, Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            }

            context.startActivity(Intent.createChooser(intentShareFile, "Share File"));
            Log.i(TAG, "STOP");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
