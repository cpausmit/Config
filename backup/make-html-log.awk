# Read a listing of backup tar archives and log files and write
# the same information as an HTML file.
#
# Sample input line:
#XX-BU_BASE-XX/complete/paus/paus04152.tgz/1049077464/Sun Mar 30 20:24:24 2003
# The input lines should be sorted by user name and in reverse order by field 6 (here
# equal to 1049077464). Field delimiter is "/".
#
# Field definitions:
# 1: Null.
# 2: "backup".
# 3: "complete", "incremental", or "log".
# 4: User name.
# 5: Name of tar archive or of compressed log file.
# 6: File ctime in seconds since beginning of epoch.
# 7: File ctime in conventional format.

# Fill three arrays with data from the input file. Keyed by user name.
#   complete: Concatentation of complete backup file names + dates.
#   incremental: Concatentation of incremental backup file names + dates.
#   logs: Concatentation of log file names + dates.
# The array users contains all user names and ordusers all user names indexed by order of arrival.

{ if (!($4 in users)) {users[$4] = 1; ordusers[nu++] = $4}
  if ($3 == "complete")    {complete[$4]    = complete[$4]    "<tr><td>" $5 "</td><td>" $7 "</td></tr>\n"}
  if ($3 == "incremental") {incremental[$4] = incremental[$4] "<tr><td>" $5 "</td><td>" $7 "</td></tr>\n"}
  if ($3 == "log")         {logs[$4]        = logs[$4]        "<tr><td>" $5 "</td><td>" $7 "</td></tr>\n"}
}

END {
  # Emit HTML preamble.
  print "<html>"
  print "<head>"
  print "<meta http-equiv=\"content-type\"" " content=\"text/html; charset=ISO-8859-15\">"
  print "<title>Backups available</title>"
  print "</head>"
  print "<body style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 204);\">"
  print "<h1>Home directory backups and log files: XX-BU_BASE-XX</h1>"
  print "<h3>Last updated <!--#flastmod file=\"index.shtml\" --><h3>"

  # Emit links to users.
  for (i = 0; i < nu; ++i) {
    print "<a href=\"#" ordusers[i] "\">" ordusers[i] "</a>&nbsp;&nbsp;"
  }

  # Emit tables with an anchor+headline before each set.
  for (i = 0; i < nu; ++i) {
    print "<br><br>"
    print "<center><h2 style=\"text-decoration: underline; color: rgb(255, 102, 102);\"><a name=\"" ordusers[i] "\">" ordusers[i] "</a></h2></center>"

    print "<h3 style=\"color: rgb(51, 102, 255);\">Complete backups in XX-BU_BASE-XX/complete/" ordusers[i] "</h3>"
    print "<table cellpadding=\"2\" cellspacing=\"2\" border=\"1\" style=\"text-align: left; width: 100%;\">"
    print "<tbody>"
    print complete[ordusers[i]]
    print "</tbody>"
    print "</table>"

    print "<h3 style=\"color: rgb(51, 102, 255);\">Incremental backups in XX-BU_BASE-XX/incremental/" ordusers[i] "</h3>"
    print "<table cellpadding=\"2\" cellspacing=\"2\" border=\"1\" style=\"text-align: left; width: 100%;\">"
    print "<tbody>"
    print incremental[ordusers[i]]
    print "</tbody>"
    print "</table>"

    print "<h3 style=\"color: rgb(51, 102, 255);\">Log files in XX-BU_BASE-XX/log/" ordusers[i] "</h3>"
    print "<table cellpadding=\"2\" cellspacing=\"2\" border=\"1\" style=\"text-align: left; width: 100%;\">"
    print "<tbody>"
    print logs[ordusers[i]]
    print "</tbody>"
    print "</table>"
  }

  # Emit HTML postamble.
  print "<br>";
  print "</body>";
  print "</html>";
}
