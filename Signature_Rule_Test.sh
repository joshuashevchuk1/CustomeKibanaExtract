OPENGL_Error_var="$(grep 'OPENGL_DL   ERROR' MOST_RECENT_LOG)"
echo "$OPENGL_Error_var"
#
OutOfMemoryError_var="$(grep 'Memory thresholds were broken too much. Rebooting' MOST_RECENT_LOG)"
echo "$OutOfMemoryError_var"
#
eXtremeDBError_var="$(grep -e 'eXtremeDB' -e 'error' MOST_RECENT_LOG)"
echo "$eXtremeDBError_var"
#
DISKIOReadError_var="$(grep 'kernel: ata1.00: exception Emask 0x0 SAct 0x0' MOST_RECENT_LOG)"
echo "$DISKIOReadError_var"
#
MCOFATAL_var="$(grep 'MCOFATAL' MOST_RECENT_LOG)"
echo "$MCOFATAL_var"
#
DiskDown_var="$(grep 'DISK DOWN' MOST_RECENT_LOG)"
echo "$DiskDown_var"
