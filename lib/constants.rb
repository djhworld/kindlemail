VALID_FILE_TYPES = { 
".doc" => "Microsoft Word", 
".rtf" => "Rich Text Format", 
".jpeg" => "JPEG image file",
".jpg" => "JPEG image file",
".gif" => "GIF image file",
".png" => "PNG image file",
".bmp" => "BMP image file",
".html" => "Hypertext Markup Language", 
".htm" => "HyperText Markup Language", 
".txt" => "Text files", 
".mobi" => "Mobile ebooks",
".prc" => "Mobile ebooks",
".pdf" => "Portable Document Format (experimental)" }
SEE_HELP = "\nUse the -h flag for usage details"
USER_DIR = "~/.kindlemail"
STORAGE_DIR = USER_DIR + "/.storage"
EMAIL_CONF_FILE = File.expand_path(USER_DIR + "/.email_conf")
USER_CONF_FILE = File.expand_path(USER_DIR + "/.kindlemail")
VERSION = "0.2.0"
VERSION_STRING = "kindlemail #{VERSION} (January 2011). https://github.com/djhworld/kindlemail"
FILE_STORE = File.expand_path(STORAGE_DIR + "/sent_files.history")

