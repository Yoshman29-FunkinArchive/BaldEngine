package;

import flixel.util.FlxSave;
import flixel.util.FlxColor;

/**
 * Class containing all of the game's configuration.
 */
class GameConfig {
    /**
        MOD INFO
    **/
    public static final modName:String = "Quantum Engine";
    public static final saveName:String = "QuantumEngine";
    public static final defaultLang:String = "en-US";

    /**
        MENUS
    **/
    public static final defaultSongColor:FlxColor = 0xFF9271FD;
    public static final defaultFont:String = "fonts/vcr";

    /**
        DISCORD
    **/
    public static final discordClientID:String = "814588678700924999"; // base FNF client ID
    public static final discordLogoKey:String = "icon";

    /**
        ENGINE - DO NOT TOUCH FOR SYNCHRONISATION BETWEEN MODS
    **/
    public static final funkinVersion:Array<Int> = [0, 2, 7, 1];
    public static final engineVersion:Array<Int> = [0, 1, 0];
    public static final engineSettingsSaveName:String = "QuantumEngineSettings";
    public static final engineSettingsSavePath:String = "YoshiCrafter29/QuantumEngine";
    public static final engineName:String = "Quantum Engine";
}