<?php

defined('SYSPATH') OR die('No direct script access.');

abstract class Log_Writer extends Kohana_Log_Writer
{

    public function format_message(array $message, $format = "time --- level: body in   file:line")
    {
        $message['time']  = Date::formatted_time('@' . $message['time'], Log_Writer::$timestamp, Log_Writer::$timezone, TRUE);
        $message['level'] = $this->_log_levels[$message['level']];

        $string = strtr($format, array_filter($message, 'is_scalar'));

        if( isset($message['additional']['exception']) )
        {
            $message['body']  = $message['additional']['exception']->getTraceAsString();
            $message['level'] = $this->_log_levels[Log_Writer::$strace_level];

            $string .= PHP_EOL . strtr($format, array_filter($message, 'is_scalar'));
        }

        return $string;
    }
}
