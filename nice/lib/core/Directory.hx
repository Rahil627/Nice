package nice.lib.core;

import nice.cli.Output;
import sys.FileSystem;
import sys.io.File;

/**
 * Directory manages all 
 */
class Directory
{
    public var local : String;
    public var names : Array<String>;
    public var contents : Map<String, String>;

    public function new(local : String)
    {
        this.local = local;

        if(!FileSystem.exists(this.local))
        {
            Output.error("Cannot find directory /" + this.local + ".");
            Sys.exit(1);
        }

        this.names = FileSystem.readDirectory(this.local);
        this.contents = loadFiles(this.names);
    }

    /**
     * Returns the contents of a file in the directory
     * @param name 
     * @return content
     */
    public function getFile(name : String) : String
    {
        return this.contents.get(name);
    }

    /**
     * Get the names of each of the files in the directory
     */
    public function files()
    {
        return this.contents.keys();
    }

    /**
     * Create a new directory with a given name
     * @param name 
     */
    public static function create(name : String)
    {
        FileSystem.createDirectory(name);
    }

    /*
     * Load a list of files into memory
    */
    private function loadFiles(files : Array<String>) : Map<String, String>
    {
        var fileContents = new Map();
        for(file in files)
        {
            if(FileSystem.isDirectory('$local/$file'))
            {
                fileContents.set(file, "directory");
            }
            else
            {
                fileContents.set(file, File.getContent('$local/$file'));
            }
        }

        return fileContents;
    }

}