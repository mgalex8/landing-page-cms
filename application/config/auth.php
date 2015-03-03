<?php defined('SYSPATH') or die('No direct access allowed.');
 
return array(
 
    'driver'       => 'ORM',
    'hash_method'  => 'sha256',
    'hash_key'     => 'Never gonna give you up',
    'lifetime'     => 60*60*24*30, //1 month
    'session_type' => Session::$default,
    'session_key'  => 'auth_user'
 
);