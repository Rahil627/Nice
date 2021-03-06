package nice.lib.util;

import sys.FileSystem;
import sys.io.File;

import yaml.Yaml;
import yaml.Parser;

import nice.cli.Output;
import nice.lib.core.Post;
import nice.lib.util.Platform;

typedef ConfigData = {
    var paths: {
        var assets : String;
        var posts : String;
        var pages : String;
        var layouts : String;
        var output : String;
        var themes: String;
        var plugins: String;
    }

    var sort: {
        var posts: String;
        var pages: String;
    }
    
    var variables: {};

    var url : String;
    var platform: String;
    var theme: String;
}

/*
    Manages the config.yaml file and helps load properties
*/
class ConfigFile
{
    private var _path : String;
    private var _content : String;
    private var _data : ConfigData;

    public function new(path : String)
    {
        this._path = path;

        if(FileSystem.exists(path))
        {
            this._content = File.getContent(path);
        }
        else
        {
            this._content = "";

            Output.error("Cannot find config.yaml!");
            Sys.exit(1);
        }

        if(this._content.length != 0)
        {
            #if sys
                this._data = Yaml.read(path, Parser.options().useObjects());
            #else 
                var fileData = File.getContent(path);
                this._data = Yaml.parse(fileData);
            #end
        }
        else
        {
            this._data = null;
        }
    }

    public function getUrl() : String
    {
        if(_data == null || _data.url == null) return "/";
        else return _data.url;
    }

    public function getVariables() : Dynamic
    {
        if (_data == null || _data.variables == null) return {};
        else return _data.variables;
    }

    public function getTheme() : String
    {
        if(_data == null || _data.theme == null) return "default";
        else return _data.theme;
    }

    public function getOutputPath() : String
    {
        if(_data == null || _data.paths == null || _data.paths.output == null) return "_public";
        return _data.paths.output;
    }

    public function getPostsPath(): String
    {
        if(_data == null || _data.paths == null || _data.paths.posts == null) return "_posts";
        return _data.paths.posts;
    }

    public function getPagesPath(): String
    {
        if(_data == null || _data.paths == null || _data.paths.pages == null) return "_pages";
        return _data.paths.pages;
    }

    public function getLayoutsPath(): String
    {
        if(_data == null || _data.paths == null || _data.paths.layouts == null) return "_layouts";
        return _data.paths.layouts;
    }

    public function getAssetsPath(): String
    {
        if(_data == null || _data.paths == null || _data.paths.assets == null) return "_assets";
        return _data.paths.assets;
    }

    public function getThemesPath(): String
    {
        if(_data == null || _data.paths == null || _data.paths.themes == null) return "_themes";
        return _data.paths.themes;
    }

    public function getPluginsPath(): String
    {
        if(_data == null || _data.paths == null || _data.paths.plugins == null) return "_plugins";
        return _data.paths.plugins;
    }

    public function getPlatform(): String
    {
        if(_data == null || _data.platform == null) return Platform.DEFAULT;
        else if(_data.platform == "github pages") return Platform.GITHUB_PAGES;
        else return Platform.DEFAULT;
    }

    public function getSortPages() : String
    {
        if(_data == null || _data.sort == null || _data.sort.pages == null) return "none";
        else return _data.sort.pages;
    }

    public function getSortPosts() : String
    {
        if(_data == null || _data.sort == null || _data.sort.posts == null) return "none";
        else return _data.sort.posts;
    }
}