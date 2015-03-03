<?php

defined('SYSPATH') or die('No direct script access.');

class Model_I18n extends ORM
{
    protected $_table_name  = 'i18n';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array(                        
            'language' => array(
                array('not_empty')
            ),
            'i18n' => array(
                array('not_empty')
            ),    
            'value' => array(
                array('not_empty')
            ),
        );
    }
    
}