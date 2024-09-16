public class NFCPermissionsPlugin implements MethodCallHandler, StreamHandler, FlutterPlugin, ActivityAware {
 private static void check_nfc{
android.nfc.NfcAdapter mNfcAdapter= android.nfc.NfcAdapter.getDefaultAdapter(v.getContext());

            if (!mNfcAdapter.isEnabled()) {

                AlertDialog.Builder alertbox = new AlertDialog.Builder(v.getContext());
                alertbox.setTitle("Info");
                alertbox.setMessage(getString(R.string.msg_nfcon));
                alertbox.setPositiveButton("Turn On", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                            Intent intent = new Intent(Settings.ACTION_NFC_SETTINGS);
                            startActivity(intent);
                        } else {
                            Intent intent = new Intent(Settings.ACTION_WIRELESS_SETTINGS);
                            startActivity(intent);
                        }
                    }
                });
                alertbox.setNegativeButton("Close", new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                });
                alertbox.show();

            }} }