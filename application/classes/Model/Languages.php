<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Languages extends ORM {

    protected $_table_name = 'languages';
    protected $_primary_key = 'id';
    
    public function rules()
    {
        return array(                        
            'title' => array(
                array('not_empty')
            ),
            'i18n' => array(
                array('not_empty')
            ),
            'lang' => array(
                array('not_empty')
            ),
        );
    }
}


