<?php defined('SYSPATH') OR die('No direct script access.');

class I18n extends Kohana_I18n {
    
    public static function get($string, $lang = NULL)
    {
            if ( ! $lang)
            {
                    // Use the global target language
                    $lang = I18n::$lang;
            }
            $phrase = ORM::factory('I18n')->where('language','=',$lang)->and_where('i18n','=',$string)->find();
            if ($phrase->loaded())
            {                
                return $phrase->value;
            }
            else 
            {
                // Load the translation table for this language
                $table = I18n::load($lang);                
                return isset($table[$string]) ? $table[$string] : $string;
            }

            
    }
        
}