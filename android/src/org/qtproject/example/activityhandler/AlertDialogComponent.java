package org.qtproject.example.activityhandler;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;

public class AlertDialogComponent
{
    private static final String TAG = "AlertDialogComponent";

    public AlertDialogComponent() {}

    public static void show(Context context, String message) {
        new AlertDialog.Builder(context)
        .setTitle("Uwaga!")
        .setMessage(message)
        .setCancelable(false)
        .setPositiveButton("ok", null).show();
    }
}