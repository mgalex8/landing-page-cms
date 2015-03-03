<?php

/**
 * Set or get cookie with name COOKIE_NAME.
 *
 * If GET-param "action" set to "get" COOKIE_NAME value will be returned in js-callback.
 * Also new COOKIE_NAME value will be setted.
 *
 */

const COOKIE_NAME = 'aatExpanded';

$action = isset($_GET['action']) ? $_GET['action'] : '';
if($action === 'get')
{
    $isExpanded = isset($_COOKIE[COOKIE_NAME]) ? $_COOKIE[COOKIE_NAME] : 'true';
    die('getIsExpandedFromCookie(' . $isExpanded . ')');
}

$isExpanded = isset($_GET['is_expanded']) ? $_GET['is_expanded'] : false;
header('P3P: CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"');
Setcookie(COOKIE_NAME, $isExpanded, time() + 3600 * 24 * 365, '/', '.' . $_SERVER['HTTP_HOST']);