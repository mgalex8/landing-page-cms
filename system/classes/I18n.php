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

function i18n($i18n, $phrase, array $values = NULL, $lang = 'en-us')
{
    if ($lang !== I18n::$lang)
    {
            // The message and target languages are different
            // Get the translation for this message
            $string = __($phrase);
    }

    return empty($values) ? $string : strtr($string, $values);
}