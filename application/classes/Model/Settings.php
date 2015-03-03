<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Settings extends ORM {

    protected $_table_name = 'settings';
    protected $_primary_key = 'id_setting';

    public function set_setting($name, $value)
    {
        $this->where('name', '=', $name)->find();
        if ($this->pk())
        {
            $this->value = $value;
            return $this->save();
        }
        else
        {
            return FALSE;
        }
    }
}


