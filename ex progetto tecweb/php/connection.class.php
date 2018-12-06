<?php

class connection {
    private static $DB_NAME='guglielm_hotel';
    private static $DB_HOST='localhost';
    private static $DB_USER='root';
    private static $DB_PWD='';

    static function QueryWrite($query) {
        $connection = new mysqli(self::$DB_HOST,self::$DB_USER,self::$DB_PWD,self::$DB_NAME);
        mysqli_set_charset($connection, "utf8");
        $result = $connection->query($query);
        if($result)
            return true;
        else
            return false;
    }
    
    static function QueryRead($query) {
        $connection = new mysqli(self::$DB_HOST,self::$DB_USER,self::$DB_PWD,self::$DB_NAME);
        mysqli_set_charset($connection, "utf8");
        $result = $connection->query($query); 
        return $result;
    }
}
?>