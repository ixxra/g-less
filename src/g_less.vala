class MainWindow : Gtk.Window
{
    Gtk.SourceBuffer tb;
    
    construct {
        var sv = new Gtk.SourceView();
        sv.set_show_line_numbers(true);
        sv.set_editable(false);
        sv.wrap_mode = Gtk.WrapMode.WORD_CHAR;

        tb = sv.get_buffer() as Gtk.SourceBuffer;
        tb.set_highlight_syntax(true);

        var scroll = new Gtk.ScrolledWindow(null, null);
        scroll.add(sv);

        this.add(scroll);
    }

    public void set_text_from_file(string fname) 
    {    
        string cont;

        try {
            if (FileUtils.get_contents(fname,out cont)) {
                tb.set_text(cont);

            }
    
        } catch (FileError e){
            var dialog = new Gtk.MessageDialog(this, 
                Gtk.DialogFlags.MODAL, 
                Gtk.MessageType.ERROR,
                Gtk.ButtonsType.CLOSE,
                "Error reading file: " + e.message
            );

            dialog.response.connect(() => {
                dialog.destroy();
            });            

            dialog.show();
            warning("Error reading file: %s", e.message);
        }
        
        var lm = Gtk.SourceLanguageManager.get_default();
        tb.set_language(lm.guess_language(fname, null));
    }
}


void print_usage()
{
    print("USAGE: g-less <file>\n");
}


void main(string[] args)
{
    Gtk.init(ref args);

    var mw = new MainWindow();
    mw.resize(500, 600);

    if (args.length == 1){
        print_usage();
        return;
    }

    var fname = args[1];


    if (FileUtils.test(fname, FileTest.IS_DIR)){
        var dialog = new Gtk.MessageDialog(null, 
            Gtk.DialogFlags.MODAL, 
            Gtk.MessageType.ERROR,
            Gtk.ButtonsType.CLOSE,
            fname + " is a directory"
        );
        
        dialog.response.connect(() => {
            Gtk.main_quit();
        });

        dialog.show();

    } else if (!FileUtils.test(fname, FileTest.EXISTS)){
        var dialog = new Gtk.MessageDialog(null, 
            Gtk.DialogFlags.MODAL, 
            Gtk.MessageType.ERROR,
            Gtk.ButtonsType.CLOSE,
            fname + " doesn't exist"
        );
        
        dialog.response.connect(() => {
            Gtk.main_quit();
        });

        dialog.show();

    } else {   
        mw.set_text_from_file(fname);
        mw.destroy.connect(Gtk.main_quit);
        mw.set_title(Path.get_basename(fname));

        mw.show_all();
    }

    Gtk.main();
}
