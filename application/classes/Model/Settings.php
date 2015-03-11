<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Settings extends ORM {

    protected $_table_name = 'settings';
    protected $_primary_key = 'id';
    
    public function rules()
    {
        return array(                        
            'settings' => array(
                array('not_empty')
            ),
        );
    }
}


